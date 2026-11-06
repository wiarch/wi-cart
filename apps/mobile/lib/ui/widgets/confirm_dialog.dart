import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Shared confirm/alert shell: title, body, full-width action, cancel beside the title.
class AppAlertDialog extends StatelessWidget {
  const AppAlertDialog({
    super.key,
    required this.title,
    this.message,
    this.child,
    required this.confirmLabel,
    this.cancelLabel = 'Cancelar',
    required this.onConfirm,
    required this.onCancel,
    this.hold = false,
  });

  final String title;
  final String? message;
  final Widget? child;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  /// Blocks [onConfirm] for 3 seconds. Used by destructive confirms.
  final bool hold;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: AppTheme.card,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 8, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.ink700,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.ink700,
                    backgroundColor: AppTheme.cream,
                    side: const BorderSide(color: AppTheme.ink700, width: 1.4),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    minimumSize: const Size(0, 36),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(cancelLabel),
                ),
              ],
            ),
            if (message != null)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  message!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.ink800,
                    height: 1.4,
                  ),
                ),
              ),
            if (child != null)
              Padding(
                padding: EdgeInsets.only(top: message == null ? 4 : 16, right: 12),
                child: child!,
              ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: hold
                  ? _CountdownButton(label: confirmLabel, onPressed: onConfirm)
                  : FilledButton(
                      onPressed: onConfirm,
                      child: Text(confirmLabel),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Title, message, and a full-width action. Cancel sits on the title row.
/// Returns true, false, or null if dismissed.
Future<bool?> showAppAlert(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Continuar',
  String cancelLabel = 'Cancelar',
  bool hold = false,
}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AppAlertDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      hold: hold,
      onCancel: () => Navigator.pop(ctx, false),
      onConfirm: () => Navigator.pop(ctx, true),
    ),
  );
}

/// Destructive confirm. The action stays blocked for 3 seconds.
Future<bool> confirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirm = 'Eliminar',
}) async {
  final ok = await showAppAlert(
    context,
    title: title,
    message: message,
    confirmLabel: confirm,
    hold: true,
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
