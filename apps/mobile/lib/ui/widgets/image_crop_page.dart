import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../theme/app_theme.dart';

/// Square crop with a draggable/resizable frame (touch and mouse).
/// Live preview renders the exact crop at list-thumbnail size.
/// Pops with the saved PNG path, or null on cancel.
class ImageCropPage extends StatefulWidget {
  const ImageCropPage({super.key, required this.sourcePath});

  final String sourcePath;

  @override
  State<ImageCropPage> createState() => _ImageCropPageState();
}

class _ImageCropPageState extends State<ImageCropPage> {
  static const _outPx = 512;
  static const _minSide = 48.0; // image pixels
  static const _handleSize = 28.0;

  late final Future<ui.Image> _future = _load();
  ui.Image? _image;
  Rect? _crop; // image pixel space, always square
  Size _canvas = Size.zero;
  bool _saving = false;

  Future<ui.Image> _load() async {
    final stream =
        FileImage(File(widget.sourcePath)).resolve(ImageConfiguration.empty);
    final completer = Completer<ui.Image>();
    late final ImageStreamListener listener;
    listener = ImageStreamListener(
      (info, _) {
        stream.removeListener(listener);
        if (!completer.isCompleted) completer.complete(info.image);
      },
      onError: (error, stack) {
        stream.removeListener(listener);
        if (!completer.isCompleted) completer.completeError(error, stack);
      },
    );
    stream.addListener(listener);
    final img = await completer.future;
    final side = (img.width < img.height ? img.width : img.height).toDouble();
    _image = img;
    _crop = Rect.fromLTWH(
      (img.width - side) / 2,
      (img.height - side) / 2,
      side,
      side,
    );
    return img;
  }

  // BoxFit.contain geometry of the image inside the canvas.
  double get _scale {
    final img = _image!;
    final sx = _canvas.width / img.width;
    final sy = _canvas.height / img.height;
    return sx < sy ? sx : sy;
  }

  Offset get _origin {
    final img = _image!;
    final s = _scale;
    return Offset(
      (_canvas.width - img.width * s) / 2,
      (_canvas.height - img.height * s) / 2,
    );
  }

  Rect _toCanvas(Rect r) {
    final s = _scale;
    final o = _origin;
    return Rect.fromLTWH(
        o.dx + r.left * s, o.dy + r.top * s, r.width * s, r.height * s);
  }

  static double _clamp(double v, double lo, double hi) =>
      v < lo ? lo : (v > hi ? hi : v);

  void _move(Offset delta) {
    final img = _image!;
    final c = _crop!;
    final d = delta / _scale;
    final x = _clamp(c.left + d.dx, 0, img.width - c.width);
    final y = _clamp(c.top + d.dy, 0, img.height - c.height);
    setState(() => _crop = Rect.fromLTWH(x, y, c.width, c.height));
  }

  // sx/sy: direction of the dragged corner (-1 left/top, 1 right/bottom).
  void _resize(int sx, int sy, Offset delta) {
    final img = _image!;
    final c = _crop!;
    final d = delta / _scale;
    final grow = (sx * d.dx + sy * d.dy) / 2;
    final ax = sx > 0 ? c.left : c.right; // opposite (anchor) corner
    final ay = sy > 0 ? c.top : c.bottom;
    final maxW = sx > 0 ? img.width - ax : ax;
    final maxH = sy > 0 ? img.height - ay : ay;
    final side = _clamp(
        c.width + grow, _minSide, maxW < maxH ? maxW.toDouble() : maxH.toDouble());
    final x = sx > 0 ? ax : ax - side;
    final y = sy > 0 ? ay : ay - side;
    setState(() => _crop = Rect.fromLTWH(x, y, side, side));
  }

  Future<void> _confirm() async {
    final img = _image;
    final crop = _crop;
    if (img == null || crop == null || _saving) return;
    setState(() => _saving = true);

    final recorder = ui.PictureRecorder();
    Canvas(recorder).drawImageRect(
      img,
      crop,
      Rect.fromLTWH(0, 0, _outPx.toDouble(), _outPx.toDouble()),
      Paint()..filterQuality = FilterQuality.high,
    );
    final out = await recorder.endRecording().toImage(_outPx, _outPx);
    final data = await out.toByteData(format: ui.ImageByteFormat.png);
    out.dispose();

    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory(p.join(dir.path, 'product_images'));
    await folder.create(recursive: true);
    final file = File(p.join(folder.path, '${const Uuid().v4()}.png'));
    await file.writeAsBytes(data!.buffer.asUint8List());

    if (mounted) Navigator.pop(context, file.path);
  }

  Widget _handle(int sx, int sy, Rect box) {
    final cx = sx < 0 ? box.left : box.right;
    final cy = sy < 0 ? box.top : box.bottom;
    return Positioned(
      left: cx - _handleSize / 2,
      top: cy - _handleSize / 2,
      child: GestureDetector(
        onPanUpdate: (d) => _resize(sx, sy, d.delta),
        child: Container(
          width: _handleSize,
          height: _handleSize,
          decoration: BoxDecoration(
            color: AppTheme.sage,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black26),
          ),
        ),
      ),
    );
  }

  Widget _preview(ui.Image img, Rect crop) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderSubtle),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CustomPaint(
              size: const Size(48, 48),
              painter: _CropPreviewPainter(img, crop),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Vista en la lista', style: theme.textTheme.labelSmall),
                const SizedBox(height: 3),
                Text(
                  'Producto',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Text('1 un · \$1.00', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recortar imagen'),
        actions: [
          FutureBuilder<ui.Image>(
            future: _future,
            builder: (context, snap) => TextButton(
              onPressed: !snap.hasData || _saving ? null : _confirm,
              child: const Text('Listo'),
            ),
          ),
        ],
      ),
      body: FutureBuilder<ui.Image>(
        future: _future,
        builder: (context, snap) {
          if (snap.hasError) {
            return const Center(child: Text('No se pudo cargar la imagen'));
          }
          final img = snap.data;
          final crop = _crop;
          if (img == null || crop == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: LayoutBuilder(
                    builder: (context, c) {
                      _canvas = Size(c.maxWidth, c.maxHeight);
                      final box = _toCanvas(crop);
                      return Stack(
                        children: [
                          Positioned.fill(
                            child: RawImage(image: img, fit: BoxFit.contain),
                          ),
                          Positioned.fill(
                            child: IgnorePointer(
                              child: CustomPaint(painter: _DimPainter(box)),
                            ),
                          ),
                          Positioned.fromRect(
                            rect: box,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onPanUpdate: (d) => _move(d.delta),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ),
                          _handle(-1, -1, box),
                          _handle(1, -1, box),
                          _handle(-1, 1, box),
                          _handle(1, 1, box),
                        ],
                      );
                    },
                  ),
                ),
              ),
              _preview(img, crop),
            ],
          );
        },
      ),
    );
  }
}

/// Dims everything outside [hole].
class _DimPainter extends CustomPainter {
  _DimPainter(this.hole);

  final Rect hole;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path.combine(
      PathOperation.difference,
      Path()..addRect(Offset.zero & size),
      Path()..addRect(hole),
    );
    canvas.drawPath(path, Paint()..color = Colors.black54);
  }

  @override
  bool shouldRepaint(_DimPainter old) => old.hole != hole;
}

/// Draws the [src] region of [image] scaled to the painter size.
class _CropPreviewPainter extends CustomPainter {
  _CropPreviewPainter(this.image, this.src);

  final ui.Image image;
  final Rect src;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageRect(
      image,
      src,
      Offset.zero & size,
      Paint()..filterQuality = FilterQuality.medium,
    );
  }

  @override
  bool shouldRepaint(_CropPreviewPainter old) =>
      old.image != image || old.src != src;
}

/// Full-screen viewer for a saved product image. Pinch to zoom.
class ImagePreviewPage extends StatelessWidget {
  const ImagePreviewPage({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 1,
          maxScale: 5,
          child: Image.file(File(path), fit: BoxFit.contain),
        ),
      ),
    );
  }
}
