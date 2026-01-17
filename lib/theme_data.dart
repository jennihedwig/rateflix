// ignore_for_file: avoid_print
library config.globals;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme with ChangeNotifier {
  static bool isDark = false;
  static bool isSystem = false;
  static const String _themeModeKey = 'theme_mode';

  ThemeMode currentTheme() {
    if (!isSystem) {
      return isDark ? ThemeMode.dark : ThemeMode.light;
    }
    return ThemeMode.system;
  }

  void switchTheme() {
    isDark = !isDark;
    isSystem = false;
    saveTheme(currentTheme());
    notifyListeners();
  }

  void switchThemeSystemTheme(bool? newValue) {
    isSystem = newValue ?? false;
    print('isSystem @toggleSystemTheme: $isSystem');
    saveTheme(currentTheme());
    notifyListeners();
  }

  Future<void> saveTheme(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    int themeModeValue = themeMode == ThemeMode.dark
        ? 1
        : themeMode == ThemeMode.light
            ? 2
            : 0;
    await prefs.setInt(_themeModeKey, themeModeValue);
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    int? themeModeValue = prefs.getInt(_themeModeKey);
    print('ThemeModeValue: $themeModeValue');
    if (themeModeValue != null) {
      switch (themeModeValue) {
        case 1:
          isDark = true;
          isSystem = false;
          break;
        case 2:
          isDark = false;
          isSystem = false;
          break;
        default:
          isSystem = true;
          break;
      }
    }
    notifyListeners();
  }
}

class ThemeClass {
  static const _primaryColor = Color(0xFFB79978);
  static const _onPrimaryColor = Colors.white;
  static const _foregroundColor = Color(0xFFFFFFFF);
  static const _backgroundColor = Color(0xFFF2F2F7);
  static const _secondaryDarkColor = Color(0xFFFFFFFF);
  static const _secondaryLightColor = Color(0xFF000000);
  static const _errorColor = Color(0xFFBC1313);

  static final ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
        color: _backgroundColor, foregroundColor: _primaryColor),
    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(backgroundColor: _backgroundColor),
    scaffoldBackgroundColor: _backgroundColor,
    cardColor: const Color.fromARGB(255, 255, 255, 255),
    primaryColor: ThemeData.light().scaffoldBackgroundColor,
    colorScheme: const ColorScheme.light().copyWith(
      primary: _primaryColor,
      onPrimary: _onPrimaryColor,
      secondary: _secondaryLightColor,
      surface: Colors.white,
      onSurface: Colors.black,
      onSurfaceVariant: const Color.fromARGB(255, 130, 130, 130),
      error: _errorColor,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
  );

  static final ThemeData darkTheme = ThemeData(
    appBarTheme: const AppBarTheme(
        color: _primaryColor, foregroundColor: _foregroundColor),
    primaryColor: ThemeData.dark().scaffoldBackgroundColor,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: _primaryColor,
      secondary: _secondaryDarkColor,
      error: _errorColor,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
  );
}

final theme = ThemeData(
  brightness: Brightness.light,
  primaryColor: ThemeClass._primaryColor,
);

CustomTheme currentTheme = CustomTheme();
