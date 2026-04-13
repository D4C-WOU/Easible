import 'package:flutter/material.dart';

class AppTheme {
  // Professional color palette
  static const _primaryColor = Color(0xFF1E3A5F); // Deep navy blue
  static const _primaryLight = Color(0xFF3B5998); // Lighter navy
  static const _accentColor = Color(0xFF4A90D9); // Soft blue accent
  static const _successColor = Color(0xFF2E7D32); // Professional green
  static const _errorColor = Color(0xFFC62828); // Professional red
  static const _warningColor = Color(0xFFF57C00); // Amber
  static const _surfaceColor = Color(0xFFFFFFFF);
  static const _backgroundColor = Color(0xFFF5F7FA); // Light gray-blue

  static const _textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: _primaryColor,
      letterSpacing: -0.5,
    ),
    headlineSmall: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: _primaryColor,
      letterSpacing: -0.3,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: _primaryColor,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Color(0xFF2C3E50),
    ),
    bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF4A5568), height: 1.5),
    bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF718096), height: 1.4),
    labelLarge: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
    ),
  );

  static final _elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: _primaryColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 2,
    textStyle: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
    ),
  );

  static final _inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFCBD5E0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFCBD5E0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _primaryColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _errorColor),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _errorColor, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    filled: true,
    fillColor: _surfaceColor,
  );

  static final _cardTheme = CardThemeData(
    elevation: 2,
    color: _surfaceColor,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
    clipBehavior: Clip.antiAlias,
  );

  static final _appBarTheme = AppBarTheme(
    backgroundColor: _accentColor,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
      color: Colors.white,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryColor,
      primary: _primaryColor,
      secondary: _accentColor,
      surface: _surfaceColor,
      error: _errorColor,
      brightness: Brightness.light,
    ),

    scaffoldBackgroundColor: _backgroundColor,

    textTheme: _textTheme,

    primaryColor: _primaryColor,
    hintColor: _accentColor,
    focusColor: _primaryColor,

    elevatedButtonTheme: ElevatedButtonThemeData(style: _elevatedButtonStyle),

    inputDecorationTheme: _inputDecorationTheme,

    cardTheme: _cardTheme,

    appBarTheme: _appBarTheme,

    dividerTheme: const DividerThemeData(
      color: Color(0xFFE2E8F0),
      thickness: 1,
      space: 1,
    ),

    chipTheme: ChipThemeData(
      backgroundColor: _backgroundColor,
      disabledColor: Color(0xFFE2E8F0),
      selectedColor: _primaryLight,
      secondarySelectedColor: _accentColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      labelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: _primaryColor,
      ),
      secondaryLabelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: _primaryColor,
      contentTextStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: _primaryColor,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
  );
}
