import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/custom widgets/buttons/custom_buttons.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';


///
///
/// Bottom Sheet
class BuildContentOfBottomSheet extends StatelessWidget {
  final String bottomSheetButtonText;
  final IconData bottomSheetButtonIcon;
  final VoidCallback onPressed;

  const BuildContentOfBottomSheet(
      {super.key,
        required this.bottomSheetButtonText,
        required this.bottomSheetButtonIcon,
        required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: BuildButton(
        onPressed: onPressed,
        buttonText: bottomSheetButtonText,
        height: 70.0,
        borderColor: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        backgroundColor: DeckColors.white,
        textColor: DeckColors.primaryColor,
        radius: 0.0,
        fontSize: 16,
        borderWidth: 0,
        iconColor: DeckColors.white,
        paddingIconText: 20.0,
        size: 32,
      ),
    );
  }
}

/// ------------------------ E N D -----------------------------
/// --------------- B O T T O M  S H E E T --------------------