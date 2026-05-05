import 'package:flutter/material.dart';

ThemeData get lightTheme => ThemeData.light().applyTheme();

ThemeData get darkTheme => ThemeData.dark().applyTheme();

extension TaglyTheme on ThemeData {
  ThemeData applyTheme() {
    return copyWith(
      searchBarTheme: SearchBarThemeData(elevation: .all(0)),
      appBarTheme: AppBarThemeData(titleSpacing: 12),
    );
  }
}
