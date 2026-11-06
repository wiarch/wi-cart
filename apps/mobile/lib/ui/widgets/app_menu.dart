import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../lists/import_list_sheet.dart';
import '../settings/settings_page.dart';
import '../theme/app_theme.dart';

/// Profile avatar opens overflow menu (Ajustes, importar, …).
class AppMenuButton extends StatefulWidget {
  const AppMenuButton({super.key, this.onLogout});

  final VoidCallback? onLogout;

  @override
  State<AppMenuButton> createState() => _AppMenuButtonState();
}

class _AppMenuButtonState extends State<AppMenuButton> {
  String? _avatarUrl;
  String? _initial;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadUser());
  }

  Future<void> _loadUser() async {
    if (!mounted) return;
    final api = AppScope.of(context).api;
    final user = await api.getUser();
    if (!mounted) return;
    final name = user?['name']?.toString() ?? user?['email']?.toString() ?? '';
    setState(() {
      _avatarUrl = user?['avatar_url']?.toString();
      _initial = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?';
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Cuenta',
      offset: const Offset(0, 44),
      color: AppTheme.popover,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppTheme.borderSubtle),
      ),
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
          MaterialPageRoute(
            builder: (_) => SettingsPage(onLogout: widget.onLogout),
          ),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: CircleAvatar(
          radius: 16,
          backgroundColor: AppTheme.sage,
          foregroundImage: _avatarUrl != null && _avatarUrl!.isNotEmpty
              ? NetworkImage(_avatarUrl!)
              : null,
          child: Text(
            _initial ?? '?',
            style: const TextStyle(
              color: AppTheme.ink800,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
