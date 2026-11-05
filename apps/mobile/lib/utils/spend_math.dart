import '../data/database.dart';
import 'quantity_math.dart';

/// Value of one list item: planned qty, or bought qty when in cart.
double itemCost(ListItem i) {
  final qty =
      i.status == 'in_cart' ? (i.qtyBought ?? i.qtyPlanned) : i.qtyPlanned;
  return lineTotal(qty: qty, unitAbbr: i.unitAbbr, unitPrice: i.unitPrice ?? 0);
}

/// Spend keyed by category id (null = sin categoría).
Map<String?, double> spendByCategory(
  Iterable<ListItem> items,
  Map<String, Product> products,
) {
  final out = <String?, double>{};
  for (final i in items) {
    final catId =
        i.productId == null ? null : products[i.productId]?.categoryId;
    out[catId] = (out[catId] ?? 0) + itemCost(i);
  }
  return out;
}

/// (total, cart) for a set of list items. Cart = items with status in_cart.
(double, double) listTotals(Iterable<ListItem> items) {
  var total = 0.0;
  var cart = 0.0;
  for (final i in items) {
    final c = itemCost(i);
    total += c;
    if (i.status == 'in_cart') cart += c;
  }
  return (total, cart);
}
