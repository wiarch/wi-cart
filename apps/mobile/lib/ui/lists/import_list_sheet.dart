import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../../services/list_import_parser.dart';
import '../theme/app_theme.dart';

const _newStore = '_new';

/// Modal de importación: pegar texto → revisar → elegir/crear tienda → importar.
class ImportListSheet extends StatefulWidget {
  const ImportListSheet({super.key});

  @override
  State<ImportListSheet> createState() => _ImportListSheetState();
}

class _ImportListSheetState extends State<ImportListSheet> {
  final _text = TextEditingController();
  final _storeName = TextEditingController();
  final _storeLocation = TextEditingController();
  List<ImportedLine>? _lines;
  String? _storeChoice;
  String? _error;
  bool _busy = false;
  int _done = 0;
  int _total = 0;

  @override
  void dispose() {
    _text.dispose();
    _storeName.dispose();
    _storeLocation.dispose();
    super.dispose();
  }

  void _analyze() {
    final lines = parseListText(_text.text);
    setState(() {
      _error = lines.isEmpty ? 'No se encontraron productos.' : null;
      _lines = lines.isEmpty ? null : lines;
    });
  }

  Future<void> _import(List<Store> stores) async {
    final scope = AppScope.of(context);
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final choice =
        _storeChoice ?? (stores.isEmpty ? _newStore : stores.first.id);
    setState(() {
      _busy = true;
      _error = null;
      _done = 0;
      _total = _lines?.length ?? 0;
    });
    try {
      String? storeId;
      if (choice == _newStore) {
        final name = _storeName.text.trim();
        if (name.isEmpty) throw StateError('Escribe el nombre de la tienda.');
        storeId = (await scope.repo.createStore(
          name: name,
          location: _storeLocation.text.trim(),
        ))
            .id;
      } else {
        storeId = choice;
      }

      final now = DateTime.now();
      final list = await scope.repo.createList(
        'Importada ${now.day}/${now.month}/${now.year}',
        storeId: storeId,
      );

      final categoryIds = {
        for (final c in await scope.repo.getCategories()) c.name: c.id,
      };
      final unitIds = {
        for (final u in await scope.repo.getUnits())
          if (u.abbreviation != null) u.abbreviation!.toLowerCase(): u.id,
      };

      final lines = _lines!;
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        String? categoryId;
        final category = line.category;
        if (category != null) {
          categoryId = categoryIds[category] ??=
              (await scope.repo.upsertCategory(name: category)).id;
        }
        final unitId = line.unitAbbr == null ? null : unitIds[line.unitAbbr];
        final product = await scope.repo.findProductByName(line.name) ??
            await scope.repo.upsertProduct(
              name: line.name,
              categoryId: categoryId,
              unitId: unitId,
            );
        await scope.repo.addItem(
          listId: list.id,
          name: line.name,
          productId: product.id,
          unitId: unitId,
          unitAbbr: line.unitAbbr,
          qtyPlanned: line.qty,
          unitPrice: line.price,
          notes: line.note,
        );
        if (mounted) {
          setState(() => _done = i + 1);
        }
        // Yield so the progress UI can paint between heavy writes.
        await Future<void>.delayed(Duration.zero);
      }

      navigator.pop();
      messenger.showSnackBar(
        SnackBar(content: Text('Importados ${lines.length} productos.')),
      );
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _done = 0;
          _total = 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final padding = MediaQuery.viewInsetsOf(context);
    return Padding(
      padding: EdgeInsets.only(bottom: padding.bottom),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.9,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: _lines == null ? _input() : _confirm(scope),
        ),
      ),
    );
  }

  Widget _input() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Importar lista', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Expanded(
          child: TextField(
            controller: _text,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            decoration: const InputDecoration(
              hintText: 'Pega aquí la lista',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(_error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ],
        const SizedBox(height: 12),
        FilledButton(onPressed: _analyze, child: const Text('Analizar')),
      ],
    );
  }

  Widget _confirm(AppScope scope) {
    final lines = _lines!;
    final progress = _total == 0 ? 0.0 : _done / _total;
    return StreamBuilder<List<Store>>(
      stream: scope.repo.watchStores(),
      builder: (context, snap) {
        final stores = snap.data ?? const <Store>[];
        final choice =
            _storeChoice ?? (stores.isEmpty ? _newStore : stores.first.id);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                TextButton(
                  onPressed:
                      _busy ? null : () => setState(() => _lines = null),
                  child: const Text('Editar texto'),
                ),
                const Spacer(),
                Text('${lines.length} productos'),
              ],
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 12),
                itemCount: lines.length,
                itemBuilder: (_, i) {
                  final l = lines[i];
                  final showHeader =
                      i == 0 || lines[i - 1].category != l.category;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showHeader && l.category != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 2),
                          child: Text(
                            l.category!,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(l.name),
                        subtitle: Text([
                          '${l.qty}${l.unitAbbr == null ? '' : ' ${l.unitAbbr}'}',
                          if (l.price != null) '\$ ${l.price}',
                          if (l.note != null) l.note!,
                        ].join(' · ')),
                      ),
                    ],
                  );
                },
              ),
            ),
            Material(
              color: AppTheme.card,
              elevation: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppTheme.card,
                  border: Border(
                    top: BorderSide(color: AppTheme.borderSubtle),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(0, 14, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_busy) ...[
                      Text(
                        _done == 0
                            ? 'Preparando importación…'
                            : 'Importando productos… $_done / $_total',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: _done == 0 ? null : progress,
                          minHeight: 6,
                          backgroundColor: AppTheme.sage.withValues(alpha: 0.25),
                          color: AppTheme.ink700,
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],
                    DropdownButtonFormField<String>(
                      initialValue: choice,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Tienda',
                        filled: true,
                        fillColor: AppTheme.field,
                      ),
                      items: [
                        for (final s in stores)
                          DropdownMenuItem(value: s.id, child: Text(s.name)),
                        const DropdownMenuItem(
                          value: _newStore,
                          child: Text('Nueva tienda'),
                        ),
                      ],
                      onChanged:
                          _busy ? null : (v) => setState(() => _storeChoice = v),
                    ),
                    if (choice == _newStore) ...[
                      const SizedBox(height: 10),
                      TextField(
                        controller: _storeName,
                        enabled: !_busy,
                        decoration: const InputDecoration(
                          labelText: 'Nombre de la tienda',
                          filled: true,
                          fillColor: AppTheme.field,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _storeLocation,
                        enabled: !_busy,
                        decoration: const InputDecoration(
                          labelText: 'Ubicación (opcional)',
                          filled: true,
                          fillColor: AppTheme.field,
                        ),
                      ),
                    ],
                    if (_error != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    FilledButton(
                      onPressed: _busy ? null : () => _import(stores),
                      child: _busy
                          ? const SizedBox(
                              height: 22,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppTheme.mint,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text('Importando…'),
                                ],
                              ),
                            )
                          : const Text('Importar'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
