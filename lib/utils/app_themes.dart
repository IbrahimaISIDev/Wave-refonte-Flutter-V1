import 'package:flutter/material.dart';

class AppTheme {
  // Couleurs principales
  static const _primaryColor = Colors.deepPurple;
  static final _secondaryColor = Colors.purpleAccent.shade200;
  static final _backgroundColor = Colors.grey[100]!;
  static final _errorColor = Colors.red.shade400;

  // Configuration du ColorScheme
  static ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: _primaryColor,
    brightness: Brightness.light,
    primary: _primaryColor,
    secondary: _secondaryColor,
    surface: Colors.white,
    // ignore: deprecated_member_use
    background: _backgroundColor,
    error: _errorColor,
  );

  // Configuration du TextTheme
  static TextTheme textTheme = TextTheme(
    headlineLarge: TextStyle(
      color: _primaryColor.shade900,
      fontWeight: FontWeight.w600,
      fontSize: 32,
    ),
    headlineMedium: TextStyle(
      color: _primaryColor.shade800,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: Colors.grey.shade800,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(color: Colors.grey.shade700),
    bodySmall: TextStyle(color: Colors.grey.shade600),
  );

  // Configuration du DatePickerTheme
  static DatePickerThemeData datePickerTheme = DatePickerThemeData(
    backgroundColor: Colors.white,
    headerBackgroundColor: _primaryColor,
    headerForegroundColor: Colors.white,
    surfaceTintColor: _primaryColor.shade50,
    dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return _primaryColor;
      }
      return null;
    }),
    dayForegroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.white;
      }
      return _primaryColor.shade900;
    }),
    yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return _primaryColor;
      }
      return null;
    }),
    yearForegroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.white;
      }
      return _primaryColor.shade900;
    }),
  );

  // Configuration du InputDecorationTheme
  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: Colors.white.withOpacity(0.85),
    border: _buildBorder(),
    enabledBorder: _buildBorder(
      borderSide: BorderSide(color: _primaryColor.shade100),
    ),
    focusedBorder: _buildBorder(
      borderSide: BorderSide(color: _primaryColor.shade300, width: 1),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
  );

  // Configuration du ElevatedButtonTheme
  static ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: _primaryColor.shade900,
      backgroundColor: Colors.purpleAccent.shade100,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),
  );

  // Configuration du TextButtonTheme
  static TextButtonThemeData textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: _primaryColor.shade900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
  );

  // Configuration du IconTheme
  static IconThemeData iconTheme = IconThemeData(
    color: _primaryColor.shade700,
  );

  // Méthode utilitaire pour construire les bordures
  static OutlineInputBorder _buildBorder({BorderSide? borderSide}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: borderSide ?? BorderSide.none,
    );
  }

  // Méthode pour obtenir le ThemeData complet
  static ThemeData getThemeData() {
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      fontFamily: 'Poppins',
      textTheme: textTheme,
      datePickerTheme: datePickerTheme,
      inputDecorationTheme: inputDecorationTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      textButtonTheme: textButtonTheme,
      iconTheme: iconTheme,
    );
  }
}