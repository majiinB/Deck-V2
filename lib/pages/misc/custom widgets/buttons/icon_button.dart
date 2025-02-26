import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';
// import '../theme/theme_provider.dart';
// import '../misc/custom widgets/buttons/custom_buttons.dart';

//icon button
class BuildIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color iconColor, backgroundColor;
  final Color? borderColor;
  final double containerWidth, borderWidth, containerHeight;

  const BuildIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.containerWidth,
    required this.containerHeight,
    this.borderColor,
    this.borderWidth = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerWidth,
      height: containerHeight,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: borderColor ?? Colors.transparent,
            width: borderWidth,
          )),
      child: IconButton(
        icon: Icon(icon, color: iconColor),
        onPressed: onPressed,
        iconSize: 20,
      ),
    );
  }
}
