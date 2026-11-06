import 'dart:async';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../../services/backup_service.dart';
import '../widgets/confirm_dialog.dart';

/// Export and restore, embedded in Configuración.
class BackupSection extends StatefulWidget {
  const BackupSection({super.key});

  @override
  State<BackupSection> createState() => _BackupSectionState();
}

class _BackupSectionState extends State<BackupSection> {
  List<Store> _stores = [];
  List<ShoppingList> _lists = [];
  var _loading = true;
  var _busy = false;
  var _wired = false;
  var _includeStore = false;
  String? _storeId;
  final _listIds = <String>{};
  var _allProducts = false;
  var _allCategories = false;
  StreamSubscription<List<Store>>? _storesSub;
  StreamSubscription<List<ShoppingList>>? _listsSub;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_wired) return;
    _wired = true;
    final db = AppScope.of(context).repo.db;
    _storesSub = (db.select(db.stores)..where((t) => t.deletedAt.isNull()))
        .watch()
        .listen((rows) {
      if (!mounted) return;
      setState(() {
        _stores = rows;
        _loading = false;
      });
    }, onError: (_) {
      if (mounted) setState(() => _loading = false);
    });
    _listsSub =
        (db.select(db.shoppingLists)..where((t) => t.deletedAt.isNull()))
            .watch()
            .listen((rows) {
      if (!mounted) return;
      setState(() {
        _lists = rows;
        _loading = false;
      });
    }, onError: (_) {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  void dispose() {
    _storesSub?.cancel();
    _listsSub?.cancel();
    super.dispose();
  }

  bool get _canExport =>
      (_includeStore && _storeId != null) ||
      _listIds.isNotEmpty ||
      _allProducts ||
      _allCategories;

  String _stamp() {
    final n = DateTime.now();
    String two(int v) => v.toString().padLeft(2, '0');
    return 'wi-cart-${n.year}-${two(n.month)}-${two(n.day)}';
  }

  String _withExt(String name, String ext) {
    var clean = name.trim().replaceAll(RegExp(r'[\\/:*?"<>|]'), '-');
    if (clean.isEmpty) clean = _stamp();
    if (clean.toLowerCase().endsWith('.$ext')) return clean;
    final base = clean.replaceAll(RegExp(r'\.[A-Za-z0-9]+$'), '');
    return '$base.$ext';
  }

  Future<String?> _askName(String suggested) async {
    final ctrl = TextEditingController(text: suggested);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AppAlertDialog(
        title: 'Nombre del archivo',
        confirmLabel: 'Exportar',
        onCancel: () => Navigator.pop(ctx, false),
        onConfirm: () => Navigator.pop(ctx, true),
        child: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Archivo'),
        ),
      ),
    );
    final name = ctrl.text.trim();
    ctrl.dispose();
    if (ok != true || name.isEmpty) return null;
    return name;
  }

  Future<File> _save(String name, Uint8List bytes) async {
    final root = await getApplicationDocumentsDirectory();
    final dir = Directory('${root.path}/backups');
    await dir.create(recursive: true);
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Future<void> _share(File file, String name, String mime) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: mime, name: name)],
        subject: name,
        fileNameOverrides: [name],
      ),
    );
  }

  Future<Map<String, dynamic>> _selectionDoc() {
    return BackupService(AppScope.of(context).repo).build(
      storeId: _includeStore ? _storeId : null,
      listIds: _listIds,
      allProducts: _allProducts,
      allCategories: _allCategories,
    );
  }

  Future<void> _exportWiCart() async {
    if (_busy) return;
    final name = await _askName('${_stamp()}.wicart');
    if (name == null || !mounted) return;
    final repo = AppScope.of(context).repo;
    setState(() => _busy = true);
    try {
      final doc = await BackupService(repo).build(full: true);
      final bytes = await compute(encodeBackupJson, doc);
      final file = await _save(_withExt(name, 'wicart'), bytes);
      await _share(file, file.uri.pathSegments.last, 'application/json');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo exportar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _exportOther() async {
    if (!_canExport || _busy) return;
    final kind = await showDialog<String>(
      context: context,
      builder: (ctx) => AppAlertDialog(
        title: 'Formato',
        confirmLabel: 'Cerrar',
        onCancel: () => Navigator.pop(ctx),
        onConfirm: () => Navigator.pop(ctx),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('JSON'),
              onTap: () => Navigator.pop(ctx, 'json'),
            ),
            ListTile(
              title: const Text('Texto'),
              onTap: () => Navigator.pop(ctx, 'txt'),
            ),
            ListTile(
              title: const Text('Excel'),
              onTap: () => Navigator.pop(ctx, 'xls'),
            ),
          ],
        ),
      ),
    );
    if (kind == null || !mounted) return;
    final ext = kind;
    final name = await _askName('${_stamp()}.$ext');
    if (name == null || !mounted) return;
    setState(() => _busy = true);
    try {
      final doc = await _selectionDoc();
      final Uint8List bytes;
      final String mime;
      if (kind == 'txt') {
        bytes = await compute(encodeBackupText, doc);
        mime = 'text/plain';
      } else if (kind == 'xls') {
        bytes = await compute(encodeBackupExcel, doc);
        mime = 'application/vnd.ms-excel';
      } else {
        bytes = await compute(encodeBackupJson, doc);
        mime = 'application/json';
      }
      final file = await _save(_withExt(name, ext), bytes);
      await _share(file, file.uri.pathSegments.last, mime);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo exportar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<List<File>> _localFiles(String ext) async {
    final root = await getApplicationDocumentsDirectory();
    final dir = Directory('${root.path}/backups');
    if (!await dir.exists()) return [];
    final out = <File>[];
    await for (final entity in dir.list()) {
      if (entity is File && entity.path.toLowerCase().endsWith('.$ext')) {
        out.add(entity);
      }
    }
    out.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
    return out;
  }

  Future<void> _restore() async {
    if (_busy) return;
    final kind = await showDialog<String>(
      context: context,
      builder: (ctx) => AppAlertDialog(
        title: 'Tipo de respaldo',
        confirmLabel: 'Cerrar',
        onCancel: () => Navigator.pop(ctx),
        onConfirm: () => Navigator.pop(ctx),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('wi-cart'),
              subtitle: const Text('Busca los archivos guardados en el celular'),
              onTap: () => Navigator.pop(ctx, 'wicart'),
            ),
            ListTile(
              title: const Text('JSON'),
              onTap: () => Navigator.pop(ctx, 'json'),
            ),
            ListTile(
              title: const Text('Texto'),
              onTap: () => Navigator.pop(ctx, 'txt'),
            ),
            ListTile(
              title: const Text('Excel'),
              onTap: () => Navigator.pop(ctx, 'xls'),
            ),
          ],
        ),
      ),
    );
    if (kind == null || !mounted) return;

    String? path;
    if (kind == 'wicart') {
      final files = await _localFiles('wicart');
      if (!mounted) return;
      final picked = await showDialog<String>(
        context: context,
        builder: (ctx) => AppAlertDialog(
          title: 'Respaldos wi-cart',
          confirmLabel: 'Buscar archivo',
          onCancel: () => Navigator.pop(ctx),
          onConfirm: () => Navigator.pop(ctx, 'browse'),
          child: SizedBox(
            height: 240,
            child: files.isEmpty
                ? const Text('No hay respaldos wi-cart en el celular.')
                : ListView(
                    children: [
                      for (final file in files)
                        ListTile(
                          title: Text(file.uri.pathSegments.last),
                          onTap: () => Navigator.pop(ctx, file.path),
                        ),
                    ],
                  ),
          ),
        ),
      );
      if (picked == null || !mounted) return;
      path = picked == 'browse' ? null : picked;
    }
    if (path == null) {
      final groups = switch (kind) {
        'txt' => const [
            XTypeGroup(label: 'Texto', extensions: ['txt'], mimeTypes: ['text/plain']),
          ],
        'xls' => const [
            XTypeGroup(
              label: 'Excel',
              extensions: ['xls', 'xlsx'],
              mimeTypes: ['application/vnd.ms-excel'],
            ),
          ],
        'json' => const [
            XTypeGroup(
              label: 'JSON',
              extensions: ['json'],
              mimeTypes: ['application/json'],
            ),
          ],
        _ => const [
            XTypeGroup(
              label: 'wi-cart',
              extensions: ['wicart', 'json'],
              mimeTypes: ['application/json'],
            ),
          ],
      };
      final file = await openFile(acceptedTypeGroups: groups);
      if (file == null || !mounted) return;
      path = file.path;
    }

    final scope = AppScope.of(context);
    final bytes = await File(path).readAsBytes();
    if (!mounted) return;
    setState(() => _busy = true);
    try {
      final int n;
      if (kind == 'txt' || kind == 'xls') {
        final lists = kind == 'txt'
            ? await compute(decodeBackupText, bytes)
            : await compute(decodeBackupExcel, bytes);
        n = await BackupService(scope.repo).importPlain(lists);
      } else {
        final doc = await compute(decodeBackupJson, bytes);
        n = await BackupService(scope.repo).restore(doc);
      }
      unawaited(scope.sync.syncNow());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Respaldo restaurado ($n registros)')),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo restaurar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Respaldo', style: Theme.of(context).textTheme.titleMedium),
        if (_busy)
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: LinearProgressIndicator(),
          ),
        const SizedBox(height: 8),
        Text(
          'Elige qué incluir. Puedes combinar las opciones.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Una tienda completa'),
          subtitle: const Text('La tienda, sus listas y sus productos'),
          value: _includeStore,
          onChanged: _busy
              ? null
              : (v) => setState(() => _includeStore = v ?? false),
        ),
        if (_includeStore)
          DropdownButtonFormField<String>(
            initialValue:
                _stores.any((s) => s.id == _storeId) ? _storeId : null,
            decoration: const InputDecoration(labelText: 'Tienda'),
            items: [
              for (final s in _stores)
                DropdownMenuItem(value: s.id, child: Text(s.name)),
            ],
            onChanged: (v) => setState(() => _storeId = v),
          ),
        const Divider(),
        Text('Listas específicas',
            style: Theme.of(context).textTheme.titleSmall),
        if (_loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: LinearProgressIndicator(),
          )
        else if (_lists.isEmpty)
          Text('Sin listas', style: Theme.of(context).textTheme.bodySmall)
        else
          for (final l in _lists)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l.name),
              value: _listIds.contains(l.id),
              onChanged: _busy
                  ? null
                  : (v) => setState(() {
                        if (v ?? false) {
                          _listIds.add(l.id);
                        } else {
                          _listIds.remove(l.id);
                        }
                      }),
            ),
        const Divider(),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Todos los productos'),
          value: _allProducts,
          onChanged: _busy
              ? null
              : (v) => setState(() => _allProducts = v ?? false),
        ),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Todas las categorías'),
          value: _allCategories,
          onChanged: _busy
              ? null
              : (v) => setState(() => _allCategories = v ?? false),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _busy ? null : _exportWiCart,
          child: const Text('Exportar como wi-cart'),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: _canExport && !_busy ? _exportOther : null,
          child: const Text('Exportar respaldo'),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: _busy ? null : _restore,
          child: const Text('Restaurar respaldo'),
        ),
      ],
    );
  }
}
