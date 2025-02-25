import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';

///
///
/// DeckButton is the main button of Deck used for all routes
class BuildButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final double height, width, radius, fontSize, borderWidth;
  final Color backgroundColor, textColor, borderColor;
  final IconData? icon;
  final String? svg;
  final Color? iconColor;
  final double? paddingIconText, size, svgHeight;

  const BuildButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    required this.height,
    required this.width,
    required this.radius,
    required this.backgroundColor,
    required this.textColor,
    required this.fontSize,
    required this.borderWidth,
    required this.borderColor,
    this.svgHeight,
    this.size,
    this.icon,
    this.svg,
    this.iconColor,
    this.paddingIconText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: BorderSide(
              color: borderColor,
              width: borderWidth, // Add borderWidth
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Padding(
                padding: EdgeInsets.only(right: paddingIconText ?? 24.0),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: size,
                ),
              ),
            if (svg != null)
              Padding(
                padding: EdgeInsets.only(right: paddingIconText ?? 24.0),
                child: SvgPicture.asset(
                  svg!,
                  height: svgHeight,
                ),
              ),
            Text(
              buttonText,
              style: GoogleFonts.nunito(
                fontSize: fontSize,
                fontWeight: FontWeight.w900,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
