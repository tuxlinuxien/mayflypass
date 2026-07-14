import 'package:flutter/material.dart';

abstract final class AppTheme {
  // Background
  static Color AppBackgroundColor = Color(0xFF1D1B20);
  static Color InputBackgroundColor = Color(0xFF26232C);

  // Colors
  static Color PrimaryColor = Color(0xFF6D28D9);
  static Color BrightColor = Color(0xFF8B5CF6);

  static Color DangerColor = Color(0xFFF87171);
  static Color SuccessColor = Color(0xFF4ADE80);
  static Color WarningColor = Color(0xFFFBBF24);
  static Color InfoColor = Color(0xFF60A5FA);

  // shared shape
  static BorderRadius borderRadius = BorderRadius.circular(4);
  static const double fieldHeight = 56;

  // styles
  static TextStyle labelStyle = TextStyle(
    color: Color(0xFF7c7788),
    fontFamily: 'Roboto Mono',
    fontSize: 11,
    letterSpacing: 1.2,
  );

  static TextStyle helperStyle = TextStyle(
    color: Color(0xFF948F9E),
    fontSize: 14,
  );

  static TextStyle mainTitleStyle = TextStyle(
    color: Colors.white,
    fontSize: 29,
    fontWeight: FontWeight(600),
  );

  static TextStyle helperStyleLink = helperStyle.copyWith(color: BrightColor);

  // The FlexColorScheme defined dark mode ThemeData.
  static ThemeData dark = ThemeData(
    useMaterial3: true,
    // base colors
    colorScheme: ColorScheme.fromSeed(
      seedColor: PrimaryColor,
      brightness: .dark,
      surface: AppBackgroundColor,
    ).copyWith(primary: BrightColor, error: DangerColor),
    // inputs
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      constraints: BoxConstraints(minHeight: fieldHeight),
      labelStyle: labelStyle,
      fillColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.error)) {
          return DangerColor.withValues(alpha: 0.06); // error background
        }
        if (states.contains(WidgetState.disabled)) {
          return Color(0xFF211F27);
        }
        return InputBackgroundColor; // default
      }),
      errorStyle: TextStyle(color: DangerColor),
      border: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: Color(0x0FFFFFFF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: BrightColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: Color(0x0FFFFFFF)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: DangerColor),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.04)),
      ),
    ),

    // button
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: PrimaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        minimumSize: Size.fromHeight(fieldHeight),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppBackgroundColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        side: BorderSide(color: Color(0x1affffff)),
        minimumSize: Size.fromHeight(fieldHeight),
      ),
    ),
  );
}
