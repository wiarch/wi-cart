class ImportedLine {
  ImportedLine({
    required this.name,
    this.category,
    this.qty = 1,
    this.unitAbbr,
    this.price,
    this.note,
  });

  final String name;
  final String? category;
  final double qty;
  final String? unitAbbr;
  final double? price;
  String? note;
}

// "Nombre (1.05 kg) - $ 1.50": nombre, cantidad, unidad y precio opcional.
final _itemRe = RegExp(
    r'^(.+?)\s*\(\s*([\d.,]+)\s*([^\s()]+)\s*\)\s*(?:-\s*\$\s*([\d.,]+))?$');
// "Nombre - $ 2.60" sin cantidad: cantidad 1.
final _priceOnlyRe = RegExp(r'^(.+?)\s*-\s*\$\s*([\d.,]+)$');
final _noteRe = RegExp(r'^nota\s*:\s*(.*)$', caseSensitive: false);
final _letterRe = RegExp(r'[A-ZÁÉÍÓÚÑ]');

/// Parsea texto pegado. Encabezado = línea en mayúsculas sin precio ni cantidad.
/// Línea "Nota:" se asocia al producto anterior. Línea sin formato = producto qty 1.
/// shortcut: "1,000.50" (miles con coma) mal leído; producto solo en mayúsculas se toma como encabezado.
List<ImportedLine> parseListText(String text) {
  final out = <ImportedLine>[];
  String? category;
  for (final raw in text.split('\n')) {
    final line = raw.trim();
    if (line.isEmpty) continue;

    final note = _noteRe.firstMatch(line);
    if (note != null) {
      final value = note.group(1)!.trim();
      if (out.isNotEmpty && value.isNotEmpty) {
        final last = out.last;
        last.note = last.note == null ? value : '${last.note}; $value';
      }
      continue;
    }

    final item = _itemRe.firstMatch(line);
    if (item != null) {
      out.add(ImportedLine(
        name: item.group(1)!.trim(),
        category: category,
        qty: _num(item.group(2)!) ?? 1,
        unitAbbr: item.group(3)!.toLowerCase(),
        price: item.group(4) == null ? null : _num(item.group(4)!),
      ));
      continue;
    }

    final priced = _priceOnlyRe.firstMatch(line);
    if (priced != null) {
      out.add(ImportedLine(
        name: priced.group(1)!.trim(),
        category: category,
        price: _num(priced.group(2)!),
      ));
      continue;
    }

    if (!line.contains(r'$') && line == line.toUpperCase() && _letterRe.hasMatch(line)) {
      category = line;
      continue;
    }

    out.add(ImportedLine(name: line, category: category));
  }
  return out;
}

double? _num(String s) => double.tryParse(s.replaceAll(',', '.'));
