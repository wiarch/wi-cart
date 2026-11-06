import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app_scope.dart';
import '../history/history_page.dart';
import '../widgets/money_text.dart';
import 'backup_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, this.onLogout});

  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    final rates = AppScope.of(context).rates;
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListenableBuilder(
        listenable: rates,
        builder: (context, _) {
          final fmt = DateFormat('dd/MM/yyyy HH:mm');
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Moneda', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                'Los precios se guardan en dólares (USD). '
                'Al abrir la app se consulta la tasa BCV para mostrar bolívares.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Tasa BCV',
                              style: Theme.of(context).textTheme.titleSmall),
                          const Spacer(),
                          if (rates.loading)
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          else
                            IconButton(
                              tooltip: 'Actualizar',
                              icon: const Icon(Icons.refresh),
                              onPressed: () => rates.refresh(),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        rates.usdToBs != null
                            ? '1 USD = ${formatBs(rates.usdToBs!)}'
                            : 'USD: sin tasa (usa Actualizar)',
                      ),
                      if (rates.showEur) ...[
                        const SizedBox(height: 4),
                        Text(
                          rates.eurToBs != null
                              ? '1 EUR = ${formatBs(rates.eurToBs!)}'
                              : 'EUR: pendiente',
                        ),
                      ],
                      if (rates.effectiveDate != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Vigencia: ${rates.effectiveDate}',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                      if (rates.fetchedAt != null)
                        Text(
                          'Consultada: ${fmt.format(rates.fetchedAt!.toLocal())}',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      if (rates.error != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Error: ${rates.error}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ],
                      const Divider(height: 24),
                      Text('Ejemplo \$10.00',
                          style: Theme.of(context).textTheme.labelMedium),
                      const SizedBox(height: 4),
                      MoneyText(10, style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Mostrar total general de la lista'),
                subtitle: const Text(
                  'Desactivado: solo el total del carrito en listas y tiendas. '
                  'Activado: también el total general.',
                ),
                value: rates.showListGrandTotal,
                onChanged: (v) => rates.setShowListGrandTotal(v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Incluir tasa Euro (BCV)'),
                subtitle: const Text(
                  'Además del dólar, muestra el equivalente en euros '
                  'usando la tasa oficial EUR/Bs.',
                ),
                value: rates.showEur,
                onChanged: (v) => rates.setShowEur(v),
              ),
              const Divider(height: 24),
              Text('Respaldo', style: Theme.of(context).textTheme.titleMedium),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.backup_outlined),
                title: const Text('Respaldo'),
                subtitle: const Text(
                  'Tienda, listas, productos o categorías',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BackupPage()),
                ),
              ),
              const Divider(height: 24),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.history),
                title: const Text('Historial de compras'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HistoryPage()),
                ),
              ),
              if (onLogout != null) ...[
                const Divider(height: 24),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.logout,
                      color: Theme.of(context).colorScheme.error),
                  title: Text('Cerrar sesión',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error)),
                  onTap: () async {
                    final scope = AppScope.of(context);
                    final nav = Navigator.of(context);
                    await scope.api.logout();
                    await scope.repo.onUserSwitch(null);
                    nav.popUntil((r) => r.isFirst);
                    onLogout!();
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
