import 'dart:async';

import 'package:flutter/material.dart';

/// Confirmación con Cancelar y la acción a la misma altura.
/// La acción permanece bloqueada 3 segundos.
Future<bool> confirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirm = 'Eliminar',
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancelar'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _CountdownButton(
                label: confirm,
                onPressed: () => Navigator.pop(ctx, true),
              ),
            ),
          ],
        ),
      ],
    ),
  );
  return ok == true;
}

class _CountdownButton extends StatefulWidget {
  const _CountdownButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  State<_CountdownButton> createState() => _CountdownButtonState();
}

class _CountdownButtonState extends State<_CountdownButton> {
  int _left = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_left <= 1) {
        t.cancel();
        setState(() => _left = 0);
      } else {
        setState(() => _left -= 1);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ready = _left == 0;
    return FilledButton(
      onPressed: ready ? widget.onPressed : null,
      child: Text(
        ready ? widget.label : '${widget.label} ($_left)',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
