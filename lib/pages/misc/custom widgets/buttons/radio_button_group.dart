import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/custom%20widgets/buttons/custom_buttons.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';

/// this will make the buttons act like a radio button. ir manages the state of the selected button.

class RadioButtonGroup extends StatefulWidget {
  final List<String> buttonLabels; // List of button labels
  final List<Color> buttonColors; // List of button colors
  final bool isClickable; // whether the buttons can be clicked by user or not
  final int initialSelectedIndex;
  final Function(String label, int index)? onChange;

  const RadioButtonGroup({
    super.key,
    this.initialSelectedIndex = 0,
    required this.buttonLabels,
    required this.buttonColors,
    this.isClickable = true,
    this.onChange
  })  : assert(buttonLabels.length == buttonColors.length,
  'Each button must have a corresponding color');
  //use assert statement to prevent crashes and bugs
  @override
  _RadioButtonGroupState createState() => _RadioButtonGroupState();
}

class _RadioButtonGroupState extends State<RadioButtonGroup> {
  int? _selectedIndex; // Keep track of the selected button index

  void initState() {
    super.initState();
    _selectedIndex = widget.initialSelectedIndex;
  }

  void _onButtonPressed(int index) {
    if (widget.isClickable) {
      setState(() {
        _selectedIndex = index; // Update the selected index
      });

      // Trigger the onChange callback, passing the selected label and index
      if (widget.onChange != null) {
        widget.onChange!(widget.buttonLabels[index], index);
      }
    }
  }
  @override
  void didUpdateWidget(RadioButtonGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the initialSelectedIndex has changed
    if (oldWidget.initialSelectedIndex != widget.initialSelectedIndex) {
      _selectedIndex = widget.initialSelectedIndex; // Update the selected index
    }
  }

  Color _getBackgroundColor(int index) {
    if (_selectedIndex == index) {
      return widget.buttonColors[index]; // Assign color
    }
    return Colors.transparent; // Default
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.buttonLabels.length, (index) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 5.0), // Space between buttons
            child: BuildButton(
              onPressed: () => _onButtonPressed(index),
              buttonText: widget.buttonLabels[index],
              height: 50,
              width: 120,
              radius: 10,
              backgroundColor: _getBackgroundColor(index),
              textColor: DeckColors.primaryColor,
              fontSize: 12,
              borderWidth: 2,
              borderColor: DeckColors.primaryColor,
            ),
          ),
        );
      }),
    );
  }
}


