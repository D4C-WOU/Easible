import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color(0xFF0F4C81);
  static const primaryLight = Color(0xFF1E88E5);
  static const successColor = Color(0xFF2E7D32);
  static const warningColor = Color(0xFFF9A825);
  static const dangerColor = Color(0xFFD32F2F);
  static const backgroundColor = Color(0xFFF8F9FA);
  static const surfaceColor = Color(0xFFFFFFFF);
  static const mutedTextColor = Color(0xFF5F6B7A);
  static const borderColor = Color(0xFFE8EEF5);

  static const emergencyRed = Color(0xFFB71C1C);
  static const emergencyBackground = Color(0xFFFFF3F3);
  static const appNameColor = Color(0xFF0F4C81);

  static const _textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: primaryColor,
      letterSpacing: -0.5,
    ),
    headlineSmall: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: primaryColor,
      letterSpacing: -0.3,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: primaryColor,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Color(0xFF23374D),
    ),
    bodyLarge: TextStyle(fontSize: 16, color: mutedTextColor, height: 1.5),
    bodyMedium: TextStyle(fontSize: 14, color: mutedTextColor, height: 1.4),
    labelLarge: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
    ),
  );

  static final _elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 1,
    textStyle: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
    ),
  );

  static final _inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: borderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: primaryColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: dangerColor),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: dangerColor, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    filled: true,
    fillColor: surfaceColor,
  );

  static final _cardTheme = CardThemeData(
    elevation: 1,
    color: surfaceColor,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
    clipBehavior: Clip.antiAlias,
  );

  static final _appBarTheme = AppBarTheme(
    backgroundColor: surfaceColor,
    foregroundColor: primaryColor,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
      color: primaryColor,
    ),
    iconTheme: const IconThemeData(color: primaryColor),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: primaryLight,
      surface: surfaceColor,
      error: dangerColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: backgroundColor,
    textTheme: _textTheme,
    primaryColor: primaryColor,
    hintColor: primaryLight,
    focusColor: primaryColor,
    elevatedButtonTheme: ElevatedButtonThemeData(style: _elevatedButtonStyle),
    inputDecorationTheme: _inputDecorationTheme,
    cardTheme: _cardTheme,
    appBarTheme: _appBarTheme,
    dividerTheme: const DividerThemeData(
      color: borderColor,
      thickness: 1,
      space: 1,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFEEF4FB),
      disabledColor: const Color(0xFFE2E8F0),
      selectedColor: primaryLight,
      secondarySelectedColor: primaryLight,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      labelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      secondaryLabelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: primaryColor,
      contentTextStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryColor,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
  );
}
