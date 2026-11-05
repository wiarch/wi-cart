import 'package:flutter/material.dart';

/// Inline search bar. Filtering happens in the caller on every change.
class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: TextField(
        controller: controller,
        onChanged: (_) => onChanged(),
        decoration: InputDecoration(
          hintText: hint,
          isDense: true,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Limpiar',
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    controller.clear();
                    onChanged();
                  },
                ),
        ),
      ),
    );
  }
}

/// Normalized query: trimmed, lowercase. Empty = no filter.
String searchQuery(TextEditingController c) => c.text.trim().toLowerCase();

/// True when [query] is empty or any of [fields] contains it.
bool matchesQuery(String query, Iterable<String?> fields) {
  if (query.isEmpty) return true;
  return fields.any((f) => f != null && f.toLowerCase().contains(query));
}
