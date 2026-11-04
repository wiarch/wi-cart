import 'package:flutter/material.dart';

/// Shared category icon keys + color parsing for list headers and CRUD.
class CategoryStyle {
  CategoryStyle._();

  /// Curated grid for category picker (clean, not 40+ chips).
  static const List<String> featuredIconKeys = [
    'eco',
    'grocery',
    'dairy',
    'clean',
    'meat',
    'bakery',
    'drinks',
    'frozen',
    'fruit',
    'fish',
    'snack',
    'pets',
    'home',
    'health',
    'baby',
    'category',
  ];

  static const Map<String, IconData> icons = {
    'eco': Icons.eco_outlined,
    'grocery': Icons.shopping_basket_outlined,
    'cart': Icons.shopping_cart_outlined,
    'dairy': Icons.water_drop_outlined,
    'milk': Icons.local_cafe_outlined,
    'clean': Icons.cleaning_services_outlined,
    'soap': Icons.soap_outlined,
    'meat': Icons.set_meal_outlined,
    'restaurant': Icons.restaurant_outlined,
    'bakery': Icons.bakery_dining_outlined,
    'cake': Icons.cake_outlined,
    'drinks': Icons.local_drink_outlined,
    'wine': Icons.wine_bar_outlined,
    'coffee': Icons.coffee_outlined,
    'frozen': Icons.ac_unit_outlined,
    'ice': Icons.icecream_outlined,
    'pets': Icons.pets_outlined,
    'home': Icons.home_outlined,
    'kitchen': Icons.kitchen_outlined,
    'fridge': Icons.kitchen,
    'fruit': Icons.apple,
    'veggie': Icons.grass_outlined,
    'fish': Icons.set_meal,
    'egg': Icons.egg_outlined,
    'bread': Icons.breakfast_dining_outlined,
    'pizza': Icons.local_pizza_outlined,
    'fastfood': Icons.fastfood_outlined,
    'snack': Icons.cookie_outlined,
    'candy': Icons.cake,
    'health': Icons.health_and_safety_outlined,
    'pharmacy': Icons.local_pharmacy_outlined,
    'baby': Icons.child_care_outlined,
    'clothes': Icons.checkroom_outlined,
    'tools': Icons.build_outlined,
    'electronics': Icons.devices_outlined,
    'office': Icons.work_outline,
    'garden': Icons.yard_outlined,
    'car': Icons.directions_car_outlined,
    'sport': Icons.fitness_center_outlined,
    'beauty': Icons.spa_outlined,
    'book': Icons.menu_book_outlined,
    'gift': Icons.card_giftcard_outlined,
    'star': Icons.star_outline,
    'heart': Icons.favorite_outline,
    'tag': Icons.local_offer_outlined,
    'box': Icons.inventory_2_outlined,
    'category': Icons.category_outlined,
  };

  static IconData iconFor(String? key) {
    if (key == null || key.isEmpty) return Icons.category_outlined;
    return icons[key] ?? Icons.category_outlined;
  }

  static Color? parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    var v = hex.replaceAll('#', '').trim();
    if (v.length == 3) {
      v = '${v[0]}${v[0]}${v[1]}${v[1]}${v[2]}${v[2]}';
    }
    if (v.length == 6) v = 'FF$v';
    if (v.length != 8) return null;
    final n = int.tryParse(v, radix: 16);
    return n == null ? null : Color(n);
  }

  /// Normalize to `#RRGGBB` or null if invalid.
  static String? normalizeHex(String? input) {
    final c = parseColor(input);
    if (c == null) return null;
    final rgb = c.toARGB32() & 0xFFFFFF;
    return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  static String hexFromColor(Color c) {
    final rgb = c.toARGB32() & 0xFFFFFF;
    return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  static const List<String> presetColors = [
    '#2E7D32',
    '#43A047',
    '#F9A825',
    '#FF8F00',
    '#EF6C00',
    '#C62828',
    '#AD1457',
    '#6A1B9A',
    '#4527A0',
    '#1565C0',
    '#0277BD',
    '#00838F',
    '#00695C',
    '#558B2F',
    '#5D4037',
    '#455A64',
    '#212121',
    '#F4511E',
  ];
}
