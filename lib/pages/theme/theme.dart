import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    brightness: Brightness.light,
    primary: Colors.blue,
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF735761),
    onSecondary: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF000000),
    background: Colors.blue,
    onBackground: Color(0xFF000000),
    error: Color(0xFFB00020),
    onError: Color(0xFFFFFFFF),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    brightness: Brightness.dark,
    primary: Color(0xFF1A1A1A),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF735761),
    onSecondary: Color(0xFFFFFFFF),
    surface: Color(0xFF121212),
    onSurface: Color(0xFFFFFFFF),
    background: Color(0xFF1A1A1A),
    onBackground: Color(0xFFFFFFFF),
    error: Color(0xFFB00020),
    onError: Color(0xFFFFFFFF),
  ),
);
