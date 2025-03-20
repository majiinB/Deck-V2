import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/custom%20widgets/buttons/custom_buttons.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';


///
///
/// LearnModeBar is an AppBar use in learning modes such as study and quiz mode
class LearnModeBar extends StatelessWidget implements PreferredSizeWidget {
  const LearnModeBar({
    super.key,
    required this.title,
    required this.color,
    required this.fontSize,
    this.automaticallyImplyLeading = false,
    required this.onButtonPressed,
  });
  final String title;
  final Color color;
  final double fontSize;
  final bool automaticallyImplyLeading;
  final VoidCallback onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(padding:
    const EdgeInsets.symmetric(horizontal: 0),
      child: AppBar(
        automaticallyImplyLeading: automaticallyImplyLeading,
        iconTheme: const IconThemeData(
          color: DeckColors.primaryColor,
        ),
        backgroundColor: DeckColors.white,
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Fraiche',
            fontSize: fontSize,
            color: color,
          ),
        ),
        centerTitle: false,
        actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: BuildButton(
                  onPressed: onButtonPressed,
                  buttonText: 'Stop Playing',
                  height: 35,
                  width: 170,
                  radius: 20,
                  backgroundColor: DeckColors.deckRed,
                  textColor: DeckColors.white,
                  fontSize: 16,
                  borderWidth: 1,
                  borderColor: DeckColors.accentColor,
                  icon: Icons.stop_rounded,
                  paddingIconText: 3,
                  iconColor: DeckColors.white,
              ),
            )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
  }