import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../widgets/confirm_dialog.dart';

Future<void> shareListDialog(BuildContext context, String listId) {
  final api = AppScope.of(context).api;
  return _shareDialog(
    context,
    title: 'Compartir lista',
    done: (u) => 'Lista compartida con $u',
    send: (u) => api.shareList(listId: listId, username: u),
  );
}

Future<void> shareStoreDialog(BuildContext context, String storeId) {
  final api = AppScope.of(context).api;
  return _shareDialog(
    context,
    title: 'Compartir tienda',
    done: (u) => 'Tienda compartida con $u',
    send: (u) => api.shareStore(storeId: storeId, username: u),
  );
}

Future<void> _shareDialog(
  BuildContext context, {
  required String title,
  required String Function(String username) done,
  required Future<void> Function(String username) send,
}) async {
  final me = await AppScope.of(context).api.getUser();
  if (!context.mounted) return;
  final mine = me?['username']?.toString();
  final ctrl = TextEditingController();
  final username = await showDialog<String>(
    context: context,
    builder: (ctx) => AppAlertDialog(
      title: title,
      confirmLabel: 'Compartir',
      onCancel: () => Navigator.pop(ctx),
      onConfirm: () => Navigator.pop(ctx, ctrl.text),
      child: TextField(
        controller: ctrl,
        autofocus: true,
        decoration: InputDecoration(
          labelText: 'Nombre de usuario',
          hintText: 'usuario',
          helperText: mine == null ? null : 'Tu usuario: $mine',
        ),
        textInputAction: TextInputAction.done,
        onSubmitted: (v) => Navigator.pop(ctx, v),
      ),
    ),
  );
  if (username == null || username.trim().isEmpty || !context.mounted) return;

  final name = username.trim();
  try {
    await send(name);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(done(name))),
    );
  } on DioException catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_shareError(e))),
    );
  }
}

String _shareError(DioException e) {
  final data = e.response?.data;
  if (data is Map) {
    final errors = data['errors'];
    if (errors is Map && errors['username'] is List && errors['username'].isNotEmpty) {
      return errors['username'].first.toString();
    }
    final message = data['message'];
    if (message is String && message.isNotEmpty) return message;
  }
  if (e.response?.statusCode == 404) return 'Lista no encontrada';
  return 'No se pudo compartir. Revisa la conexión.';
}
