import 'package:deck/pages/misc/colors.dart';
import 'package:flutter/material.dart';
import 'package:msh_checkbox/msh_checkbox.dart';


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
