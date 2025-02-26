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
///Checkbox Widget
class DeckBox extends StatefulWidget {
  bool isChecked = false;
  DeckBox({super.key});

  @override
  State<DeckBox> createState() => DeckBoxState();
}

class DeckBoxState extends State<DeckBox> {
  bool isChecked() {
    return widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MSHCheckbox(
        size: 24,
        value: widget.isChecked,
        colorConfig: MSHColorConfig.fromCheckedUncheckedDisabled(
          checkedColor: DeckColors.primaryColor,
        ),
        style: MSHCheckboxStyle.stroke,
        onChanged: (selected) {
          setState(() {
            widget.isChecked = selected;
          });
        },
      ),
    );
  }
}

/// ------------------------ E N D -----------------------------
/// ------------------- C H E C K B O X ------------------------