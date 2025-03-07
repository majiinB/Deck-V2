import 'package:flutter/material.dart';

class DeckColors {
  //used for text,tiles,buttons,outline
  static const Color primaryColor = Color(0xFF12454C);
  static const Color accentColor = Color(0xFF28DF99);//mostly used for buttons
  static const Color darkgreen = Color(0xFF00945B); //mostly used for texts in home page
  static const Color softGreen = Color(0xFF99F3BD);
  static const Color white = Color(0xFFFFFFFF);

  //this is only used for background color
  static const Color backgroundColor = Color(0xFFDEDEDE);

  //grays often used for the tags, tabs, buttons in home page
  static const Color softGray = Color(0xFFB5BFC1);  //buttons B5BFC1
  static const Color  mutedGray= Color(0xFF97A0A1);  //tabs 97A0A1
  static const Color deepGray= Color(0xFF516265);  //tags of task 516265


  static const Color deckRed = Color(0xFFE54F3A);
  static const Color deckYellow = Color(0xFFFAC55F);
  static const Color deckBlue = Color(0xFF317EFF);
}

//i have no idea what this is for eh may theme file tayo
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Colors.blue,
  onPrimary: Color(0xFFFFFFFF),
  secondary: Color(0xFF735761),
  onSecondary: Color(0xFFFFFFFF),
  surface: Color(0xFFFFFFFF),
  onSurface: Color(0xFF000000),
  background: Color(0xFFF5F5F5),
  onBackground: Color(0xFF000000),
  error: Color(0xFFB00020),
  onError: Color(0xFFFFFFFF),
);
const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF1A1A1A),
  onPrimary: Color(0xFFFFFFFF),
  secondary: Color(0xFF735761),
  onSecondary: Color(0xFFFFFFFF),
  surface: Color(0xFF121212),
  onSurface: Color(0xFFFFFFFF),
  background: Color(0xFF1E1E1E),
  onBackground: Color(0xFFFFFFFF),
  error: Color(0xFFB00020),
  onError: Color(0xFFFFFFFF),
);
