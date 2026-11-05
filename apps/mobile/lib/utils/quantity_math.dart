// Pure quantity/price helpers. Prices are stored per base unit:
// kg for g/kg, lt for ml/lts, lb for lb, unit for count units.

/// Multiplier that converts a quantity in [abbr] to its base unit.
double baseFactor(String? abbr) => switch (abbr) {
      'g' => 0.001,
      'ml' => 0.001,
      _ => 1.0,
    };

/// Label of the base unit the price refers to (e.g. "kg" for g/kg).
String basePriceLabel(String? abbr) => switch (abbr) {
      'g' || 'kg' => 'kg',
      'ml' || 'lts' || 'l' => 'lt',
      'lb' => 'lb',
      _ => 'un',
    };

/// Line total. 500 g at $10/kg → 500 × 0.001 × 10 = 5.
double lineTotal({
  required double qty,
  required String? unitAbbr,
  required double unitPrice,
}) =>
    qty * baseFactor(unitAbbr) * unitPrice;
