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

class RBGroupImage extends StatefulWidget {
  final List<String> buttonLabels; // List of button labels
  final List<Color> buttonColors; // List of button colors
  final bool isClickable; // whether the buttons can be clicked by user or not
  final int initialSelectedIndex;
  final List<String> buttonBackground;
  final double? fontSize;
  final Function(String label, int index)? onChange;

  const RBGroupImage({
    super.key,
    this.initialSelectedIndex = 0,
    required this.buttonLabels,
    required this.buttonColors,
    required this.buttonBackground,
    this.isClickable = true,
    this.onChange,
    this.fontSize
  })  : assert(buttonLabels.length == buttonColors.length,
  'Each button must have a corresponding color');
  //use assert statement to prevent crashes and bugs
  @override
  _RBGroupImageState createState() => _RBGroupImageState();
}

class _RBGroupImageState extends State<RBGroupImage> {
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
  void didUpdateWidget(RBGroupImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the initialSelectedIndex has changed
    if (oldWidget.initialSelectedIndex != widget.initialSelectedIndex) {
      _selectedIndex = widget.initialSelectedIndex; // Update the selected index
    }
  }

  String _getBackgroundImage (int index) {
    if (_selectedIndex == index) {
      return widget.buttonBackground[index]; // Assign color
    }
    return 'assets/images/Deck-Background7.svg'; // Default
  }

  Color _getBackgroundColor(int index) {
    if (_selectedIndex == index) {
      return widget.buttonColors[index]; // Assign color
    }
    return DeckColors.white; // Default
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.buttonLabels.length, (index) {
        return Padding(
            padding: const EdgeInsets.only(bottom: 10.0), // Space between buttons
            child: Container(
                decoration: BoxDecoration(
                    color: _getBackgroundColor(index),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: const [
                    BoxShadow(
                      color: DeckColors.deepGray,
                      blurRadius: 4,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: SvgPicture.asset(
                            _getBackgroundImage(index),
                            fit: BoxFit.cover,
                          ),
                        )
                    ),
                    BuildButton(
                      onPressed: () => _onButtonPressed(index),
                      buttonText: widget.buttonLabels[index],
                      height: 120,
                      width: double.infinity,
                      radius: 10,
                      backgroundColor: Colors.transparent,
                      textColor: DeckColors.primaryColor,
                      fontSize: widget.fontSize ?? 12,
                      borderWidth: 3,
                      borderColor: DeckColors.primaryColor,
                    ),
                  ],
                )
            )
        );
      })
    );
  }
}


