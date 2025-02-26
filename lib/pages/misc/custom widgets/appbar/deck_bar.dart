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
/// DeckBar is an AppBar with the font Nunito (used in typical routes)
class DeckBar extends StatelessWidget implements PreferredSizeWidget {
  const DeckBar({
    super.key,
    required this.title,
    required this.color,
    required this.fontSize,
    this.onPressed,
    this.icon,
    this.iconColor,
  }); // Correct usage of super keyword

  final String title;
  final Color color;

  final double fontSize;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final IconData? icon; // Make IconData nullable

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];
    if (icon != null) {
      // Check if icon is not null
      actions.add(
        InkWell(
          onTap: onPressed,
          borderRadius:
          BorderRadius.circular(50), // Adjust the border radius as needed
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Adjust padding as needed
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
        ),
      );
      actions.add(const SizedBox(width: 10));
    }

    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Nunito-Bold',
          fontSize: fontSize,
          color: color,
        ),
      ),
      centerTitle: true,
      foregroundColor: const Color.fromARGB(255, 61, 61, 61),
      actions: actions, // Use the constructed list of actions
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}