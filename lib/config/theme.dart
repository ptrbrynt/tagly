import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Seed: deep burgundy — the classic barbershop stage curtain / quartet vest
const _seed = Color(0xFF8B1F3F);

ThemeData get lightTheme => ThemeData.light(useMaterial3: true).applyTheme();
ThemeData get darkTheme => ThemeData.dark(useMaterial3: true).applyTheme();

extension TaglyTheme on ThemeData {
  ThemeData applyTheme() {
    final cs = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
    );
    final text = _buildTextTheme(textTheme);
    return copyWith(
      colorScheme: cs,
      textTheme: text,
      appBarTheme: AppBarTheme(
        titleSpacing: 12,
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
        scrolledUnderElevation: 2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      chipTheme: const ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      searchBarTheme: const SearchBarThemeData(
        elevation: WidgetStatePropertyAll(0),
      ),
    );
  }
}

TextTheme _buildTextTheme(TextTheme base) {
  // Playfair Display for display/headline — classic, elegant serif with character
  // Lato for titles, body, labels — warm, friendly, highly readable
  final serif = GoogleFonts.playfairDisplayTextTheme(base);
  final sans = GoogleFonts.latoTextTheme(base);
  return sans.copyWith(
    displayLarge: serif.displayLarge?.copyWith(fontWeight: .w600),
    displayMedium: serif.displayMedium?.copyWith(fontWeight: .w600),
    displaySmall: serif.displaySmall?.copyWith(fontWeight: .w600),
    headlineLarge: serif.headlineLarge?.copyWith(fontWeight: .w600),
    headlineMedium: serif.headlineMedium?.copyWith(fontWeight: .w600),
    headlineSmall: serif.headlineSmall?.copyWith(fontWeight: .w600),
  );
}
