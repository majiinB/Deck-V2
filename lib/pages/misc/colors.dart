import 'package:flutter/material.dart';

/// DeckColors - A centralized color scheme for the Deck app.
/// This class defines static color constants used throughout the app
/// for consistency in UI design.
///

class DeckColors {
  //used for text,tiles,buttons,outline
  static const Color primaryColor = Color(0xFF12454C);
  static const Color accentColor = Color(0xFF28DF99);//mostly used for buttons
  static const Color darkgreen = Color(0xFF00945B); //mostly used for texts in home page
  static const Color softGreen = Color(0xFF99F3BD);
  static const Color white = Color(0xFFFFFFFF);
  static const Color deepgreen= Color(0xFF1C7062); //used for gradient
  static const Color deepblue= Color(0xFF2467B6); //used for gradient

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
