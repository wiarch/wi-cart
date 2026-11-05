import 'package:flutter_test/flutter_test.dart';
import 'package:wicart_mobile/utils/quantity_math.dart';

void main() {
  test('500 g at \$10/kg = \$5', () {
    expect(lineTotal(qty: 500, unitAbbr: 'g', unitPrice: 10), closeTo(5, 1e-9));
  });

  test('1 kg at \$10/kg = \$10', () {
    expect(lineTotal(qty: 1, unitAbbr: 'kg', unitPrice: 10), closeTo(10, 1e-9));
  });

  test('ml priced per litre', () {
    expect(lineTotal(qty: 250, unitAbbr: 'ml', unitPrice: 4), closeTo(1, 1e-9));
  });

  test('count units multiply directly', () {
    expect(lineTotal(qty: 3, unitAbbr: 'un', unitPrice: 2), 6);
    expect(lineTotal(qty: 2, unitAbbr: null, unitPrice: 1.5), 3);
  });

  test('price base labels', () {
    expect(basePriceLabel('g'), 'kg');
    expect(basePriceLabel('kg'), 'kg');
    expect(basePriceLabel('ml'), 'lt');
    expect(basePriceLabel('lb'), 'lb');
    expect(basePriceLabel('un'), 'un');
  });
}
