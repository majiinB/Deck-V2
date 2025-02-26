import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';

///
///
///Floating Action Button
class DeckFAB extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;
  final VoidCallback onPressed;
  final double? fontSize;

  const DeckFAB({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
    this.fontSize,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      //preferBelow: false,
      verticalOffset: -13,
      margin: const EdgeInsets.only(right: 65),
      message: text,
      textStyle: TextStyle(
          fontFamily: 'Nunito-Bold',
          fontSize: fontSize ?? 12,
          color: DeckColors.white),
      decoration: BoxDecoration(
        color: backgroundColor,
        //borderRadius: BorderRadius.circular(8.0),
      ),
      child: FloatingActionButton(
        onPressed: () => onPressed(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
          ],
        ),
      ),
    );
  }
}
