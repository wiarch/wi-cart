import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'category_style.dart';

/// Bottom sheet grid of list icons. Returns the chosen key, or null on dismiss.
Future<String?> showIconPicker(BuildContext context, {String? current}) {
  return showModalBottomSheet<String>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Icono de la lista',
              style: Theme.of(ctx).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final k in CategoryStyle.featuredIconKeys)
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => Navigator.pop(ctx, k),
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: k == current
                            ? AppTheme.sage.withValues(alpha: 0.3)
                            : AppTheme.ink700,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(CategoryStyle.iconFor(k),
                          color: AppTheme.mint),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
