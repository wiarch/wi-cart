import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../app_scope.dart';
import '../../data/database.dart';
import '../lists/list_detail_page.dart';
import '../widgets/money_text.dart';
import '../widgets/soft_card.dart';
import '../widgets/sync_badge.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = AppScope.of(context).repo;
    final fmt = DateFormat('dd/MM/yyyy HH:mm');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
        actions: const [SyncBadge()],
      ),
      body: StreamBuilder<List<PurchaseHistory>>(
        stream: repo.watchHistory(),
        builder: (context, snap) {
          final rows = snap.data ?? [];
          if (rows.isEmpty) {
            return const Center(child: Text('Sin compras finalizadas'));
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
            itemCount: rows.length,
            itemBuilder: (context, i) {
              final h = rows[i];
              final rates = AppScope.of(context).rates;
              return SoftCard(
                onTap: () => _openTicket(context, h),
                padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            h.storeLocation?.isNotEmpty == true
                                ? h.storeLocation!
                                : 'Sin tienda',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 2),
                          ListenableBuilder(
                            listenable: rates,
                            builder: (_, __) => Text(
                              '${fmt.format(h.purchasedAt.toLocal())} · ${moneySubtitle(rates, h.total)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _openTicket(BuildContext context, PurchaseHistory h) async {
    final repo = AppScope.of(context).repo;
    final items = await repo.historyItems(h.id);
    if (!context.mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TicketPage(history: h, items: items),
      ),
    );
  }
}

class TicketPage extends StatelessWidget {
  const TicketPage({
    super.key,
    required this.history,
    required this.items,
  });

  final PurchaseHistory history;
  final List<PurchaseHistoryItem> items;

  static String _qtyLabel(double qty) {
    if (qty % 1 == 0) return qty.toStringAsFixed(0);
    return qty.toStringAsFixed(1).replaceAll('.', ',');
  }

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd/MM/yyyy HH:mm');
    final store = history.storeLocation?.isNotEmpty == true
        ? history.storeLocation!
        : 'Sin tienda';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket'),
        actions: [
          IconButton(
            tooltip: 'Imprimir / PDF',
            icon: const Icon(Icons.print_outlined),
            onPressed: () => _printPdf(context),
          ),
          IconButton(
            tooltip: 'Reutilizar',
            icon: const Icon(Icons.replay),
            onPressed: () => _reuse(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(store, style: Theme.of(context).textTheme.headlineSmall),
          Text(
            dateFmt.format(history.purchasedAt.toLocal()),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(
                  flex: 4,
                  child: Text('Artículo',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  flex: 3,
                  child: Text('Cantidad',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  flex: 2,
                  child: Text('P. unit',
                      textAlign: TextAlign.end,
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                  flex: 2,
                  child: Text('Total',
                      textAlign: TextAlign.end,
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          const Divider(),
          ...items.map((it) {
            final abbr = it.unitAbbr ?? 'un';
            final unit = it.unitPrice ?? 0;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(flex: 4, child: Text(it.name)),
                  Expanded(
                    flex: 3,
                    child: Text('${_qtyLabel(it.quantity)} $abbr',
                        textAlign: TextAlign.center),
                  ),
                  Expanded(
                    flex: 2,
                    child: MoneyText(
                      unit,
                      compact: true,
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: MoneyText(
                      it.lineTotal ?? 0,
                      compact: true,
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            );
          }),
          const Divider(thickness: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Importe total',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const Spacer(),
              MoneyText(
                history.total,
                textAlign: TextAlign.end,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _reuse(BuildContext context) async {
    final scope = AppScope.of(context);
    final list = await scope.repo.reuseHistory(history.id);
    await scope.sync.syncNow();
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ListDetailPage(listId: list.id, listName: list.name),
      ),
    );
  }

  Future<void> _printPdf(BuildContext context) async {
    final dateFmt = DateFormat('dd/MM/yyyy HH:mm');
    final store = history.storeLocation?.isNotEmpty == true
        ? history.storeLocation!
        : 'Sin tienda';
    final rates = AppScope.of(context).rates;
    String money(double usd) => moneySubtitle(rates, usd);
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(store,
                style:
                    pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
            pw.Text(dateFmt.format(history.purchasedAt.toLocal())),
            if (rates.usdToBs != null)
              pw.Text('Tasa BCV: 1 USD = ${formatBs(rates.usdToBs!)}'),
            pw.SizedBox(height: 16),
            pw.TableHelper.fromTextArray(
              headers: ['Artículo', 'Cantidad', 'P. unit', 'Total'],
              data: items.map((it) {
                final abbr = it.unitAbbr ?? 'un';
                final unit = it.unitPrice ?? 0;
                return [
                  it.name,
                  '${_qtyLabel(it.quantity)} $abbr',
                  money(unit),
                  money(it.lineTotal ?? 0),
                ];
              }).toList(),
            ),
            pw.SizedBox(height: 12),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                'Importe total: ${money(history.total)}',
                style: pw.TextStyle(
                    fontSize: 16, fontWeight: pw.FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
    await Printing.layoutPdf(onLayout: (_) async => doc.save());
  }
}
