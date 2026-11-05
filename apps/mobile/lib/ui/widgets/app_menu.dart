import 'package:flutter/material.dart';

import '../lists/import_list_sheet.dart';
import '../settings/settings_page.dart';

/// Overflow menu ("...") with Importar lista and Ajustes.
class AppMenuButton extends StatelessWidget {
  const AppMenuButton({super.key, this.onLogout});

  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Más opciones',
      icon: const Icon(Icons.more_vert),
      onSelected: (v) {
        if (v == 'import') {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (_) => const ImportListSheet(),
          );
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SettingsPage(onLogout: onLogout)),
        );
      },
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: 'import',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.content_paste_outlined),
            title: Text('Importar lista'),
          ),
        ),
        PopupMenuItem(
          value: 'settings',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.settings_outlined),
            title: Text('Ajustes'),
          ),
        ),
      ],
    );
  }
}
