import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Light-first forest palette.
/// Hex source: #DAF1DE #8EB69B #235347 #163832
class AppTheme {
  AppTheme._();

  // Raw palette
  static const ink950 = Color(0xFF163832);
  static const ink900 = Color(0xFF163832);
  static const ink800 = Color(0xFF163832);
  static const ink700 = Color(0xFF235347);
  static const sage = Color(0xFF8EB69B);
  static const mint = Color(0xFFDAF1DE);

  // Semantic aliases
  static const bg = mint;
  static const surface = mint;
  static const card = mint;
  static const popover = mint;
  static const field = mint;
  static const seed = ink700; // primary
  static const textPrimary = ink700;
  static const textSecondary = ink800;
  static const accent = ink700;
  static const borderSubtle = Color(0x738EB69B); // sage @ ~45%
  static const radius = 16.0;

  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: ink800.withValues(alpha: 0.12),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ];

  static BoxDecoration cardDecoration({Color? color}) => BoxDecoration(
        color: color ?? card,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderSubtle),
        boxShadow: softShadow,
      );

  /// Canonical theme for this palette (light surfaces).
  static ThemeData dark() => light();

  static ThemeData light() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: ink700,
      onPrimary: mint,
      primaryContainer: sage,
      onPrimaryContainer: ink800,
      secondary: sage,
      onSecondary: ink800,
      secondaryContainer: sage,
      onSecondaryContainer: ink800,
      tertiary: sage,
      onTertiary: ink800,
      error: Color(0xFFBA1A1A),
      onError: Color(0xFFFFFFFF),
      surface: mint,
      onSurface: ink700,
      onSurfaceVariant: ink800,
      outline: sage,
      outlineVariant: borderSubtle,
      shadow: ink800,
      scrim: ink800,
      inverseSurface: ink800,
      onInverseSurface: mint,
      inversePrimary: sage,
      surfaceTint: ink700,
    );

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      canvasColor: bg,
      cardColor: card,
      dividerColor: borderSubtle,
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: shape,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        clipBehavior: Clip.antiAlias,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        foregroundColor: ink700,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          color: ink700,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
        iconTheme: IconThemeData(color: ink700),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: ink700,
        foregroundColor: mint,
        elevation: 4,
        focusElevation: 6,
        highlightElevation: 6,
        shape: CircleBorder(),
      ),
      bottomAppBarTheme: const BottomAppBarThemeData(
        color: surface,
        elevation: 12,
        shadowColor: Color(0x1F163832),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        elevation: 0,
        height: 68,
        indicatorColor: sage.withValues(alpha: 0.35),
        iconTheme: WidgetStateProperty.resolveWith((s) {
          final selected = s.contains(WidgetState.selected);
          return IconThemeData(color: selected ? ink700 : sage);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((s) {
          final selected = s.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? ink700 : sage,
          );
        }),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: card,
        shape: shape,
        elevation: 0,
        shadowColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        titleTextStyle: const TextStyle(
          color: ink700,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: const TextStyle(
          color: ink800,
          fontSize: 14,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: card,
        modalBackgroundColor: card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        showDragHandle: true,
        dragHandleColor: sage,
        dragHandleSize: Size(40, 4),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: field,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: ink700, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: const TextStyle(color: ink800),
        hintStyle: TextStyle(color: ink800.withValues(alpha: 0.65)),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: field,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: ink700,
          foregroundColor: mint,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ink700,
          side: const BorderSide(color: borderSubtle),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ink700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) return ink700;
          return Colors.transparent;
        }),
        checkColor: const WidgetStatePropertyAll(mint),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        side: const BorderSide(color: sage, width: 1.5),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: const BorderSide(color: borderSubtle),
        backgroundColor: mint,
        selectedColor: sage.withValues(alpha: 0.35),
        labelStyle: const TextStyle(color: ink700),
        secondaryLabelStyle: const TextStyle(color: ink700),
        showCheckmark: false,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: sage,
        textColor: ink700,
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      ),
      dividerTheme: const DividerThemeData(
        color: borderSubtle,
        space: 1,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: popover,
        textStyle: const TextStyle(color: ink700),
        shape: shape,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ink800,
        contentTextStyle: const TextStyle(color: mint),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: ink700,
        circularTrackColor: sage,
      ),
      iconTheme: const IconThemeData(color: sage),
      primaryIconTheme: const IconThemeData(color: ink700),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: ink700, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: ink700, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: ink700, fontWeight: FontWeight.w700),
        bodyLarge: TextStyle(color: ink700),
        bodyMedium: TextStyle(color: ink700),
        bodySmall: TextStyle(color: ink800),
        labelLarge: TextStyle(color: ink700),
        labelMedium: TextStyle(color: ink800),
        labelSmall: TextStyle(color: ink800),
      ),
    );
  }
}
