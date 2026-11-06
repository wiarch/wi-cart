import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../../services/backup_service.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  List<Store> _stores = [];
  List<ShoppingList> _lists = [];
  var _loading = true;
  var _busy = false;
  var _includeStore = false;
  String? _storeId;
  final _listIds = <String>{};
  var _allProducts = false;
  var _allCategories = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = AppScope.of(context).repo.db;
    final stores = await (db.select(db.stores)
          ..where((t) => t.deletedAt.isNull()))
        .get();
    final lists = await (db.select(db.shoppingLists)
          ..where((t) => t.deletedAt.isNull()))
        .get();
    if (!mounted) return;
    setState(() {
      _stores = stores;
      _lists = lists;
      _loading = false;
    });
  }

  bool get _canExport =>
      (_includeStore && _storeId != null) ||
      _listIds.isNotEmpty ||
      _allProducts ||
      _allCategories;

  Future<void> _export() async {
    if (!_canExport || _busy) return;
    final repo = AppScope.of(context).repo;
    setState(() => _busy = true);
    try {
      final doc = await BackupService(repo).build(
        storeId: _includeStore ? _storeId : null,
        listIds: _listIds,
        allProducts: _allProducts,
        allCategories: _allCategories,
      );
      final name =
          'wicart-respaldo-${DateTime.now().toIso8601String().split('T').first}.json';
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              utf8.encode(const JsonEncoder.withIndent('  ').convert(doc)),
              mimeType: 'application/json',
              name: name,
            ),
          ],
          subject: name,
          fileNameOverrides: [name],
        ),
      );
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

  Future<void> _restore() async {
    if (_busy) return;
    final scope = AppScope.of(context);
    final picked = await openFile(
      acceptedTypeGroups: const [
        XTypeGroup(
          label: 'JSON',
          extensions: ['json'],
          mimeTypes: ['application/json'],
        ),
      ],
    );
    if (picked == null || !mounted) return;
    final bytes = await picked.readAsBytes();
    if (!mounted) return;
    setState(() => _busy = true);
    try {
      final doc = jsonDecode(utf8.decode(bytes));
      if (doc is! Map) {
        throw const FormatException('JSON inválido');
      }
      final n = await BackupService(scope.repo).restore(Map<String, dynamic>.from(doc));
      await scope.sync.syncNow();
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
    return Scaffold(
      appBar: AppBar(title: const Text('Respaldo')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Elige qué incluir. Puedes combinar las opciones.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Una tienda completa'),
                  subtitle: const Text('La tienda, sus listas y sus productos'),
                  value: _includeStore,
                  onChanged: (v) => setState(() => _includeStore = v ?? false),
                ),
                if (_includeStore)
                  DropdownButtonFormField<String>(
                    initialValue: _storeId,
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
                if (_lists.isEmpty)
                  Text('Sin listas', style: Theme.of(context).textTheme.bodySmall)
                else
                  for (final l in _lists)
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l.name),
                      value: _listIds.contains(l.id),
                      onChanged: (v) => setState(() {
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
                  onChanged: (v) => setState(() => _allProducts = v ?? false),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Todas las categorías'),
                  value: _allCategories,
                  onChanged: (v) => setState(() => _allCategories = v ?? false),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _canExport && !_busy ? _export : null,
                  child: const Text('Exportar respaldo'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: _busy ? null : _restore,
                  child: const Text('Restaurar respaldo'),
                ),
              ],
            ),
    );
  }
}
