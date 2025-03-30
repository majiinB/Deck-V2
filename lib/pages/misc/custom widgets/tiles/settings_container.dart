import 'package:deck/backend/models/deck.dart';
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

///
///
/// ----------------------- S T A R T --------------------------
/// -------------------- S E T T I N G S -----------------------

// Container for a function in settings
class BuildSettingsContainer extends StatefulWidget {
  final IconData selectedIcon;
  final IconData? alternateIcon;
  final String nameOfTheContainer;
  final String? alternateText;
  final VoidCallback? onTap;
  final bool showSwitch, showArrow;
  final Color containerColor;
  final Color selectedColor;
  final Color textColor;
  final Color toggledColor;
  final Color iconColor;
  final Color iconArrowColor;
  final Color borderColor;
  final ValueChanged<bool>? onToggleChanged;

  const BuildSettingsContainer({
    required this.selectedIcon,
    required this.nameOfTheContainer,
    this.alternateIcon,
    this.alternateText,
    this.showSwitch = false,
    this.showArrow = false,
    this.onTap,
    this.onToggleChanged,
    required this.containerColor,
    required this.selectedColor,
    required this.textColor,
    required this.toggledColor,
    super.key,
    this.iconArrowColor = DeckColors.primaryColor,
    this.iconColor = DeckColors.primaryColor,
    this.borderColor = DeckColors.primaryColor,
  });

  @override
  State<BuildSettingsContainer> createState() => BuildSettingsContainerState();
}

class BuildSettingsContainerState extends State<BuildSettingsContainer> {
  late bool _isToggled;

  @override
   void initState() {
     super.initState();
     /*final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
     _isToggled = themeProvider.isDarkMode;*/
    _isToggled = false;
   }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15.0),
      color: /*_isToggled ? widget.toggledColor : */widget.containerColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!();
          }
        },
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: widget.borderColor,
              width: 2,
            )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    _isToggled
                        ? (widget.alternateIcon ?? widget.selectedIcon)
                        : widget.selectedIcon,
                    color: _isToggled
                        ? widget.iconColor
                        : widget.selectedColor,
                    size: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      _isToggled
                          ? (widget.alternateText ?? widget.nameOfTheContainer)
                          : widget.nameOfTheContainer,
                      style: TextStyle(
                        fontFamily: 'Nunito-Bold',
                        fontSize: 16,
                        color:
                        _isToggled ? (widget.textColor) : widget.textColor,
                      ),
                    ),
                  ),
                ],
              ),
              if (widget.showSwitch)
                Switch(
                  value: _isToggled,
                  onChanged: (bool value) {
                    setState(() {
                      _isToggled = value;
                    });
                    if (widget.onToggleChanged != null) {
                      widget.onToggleChanged!(value);
                    }
                  },
                  activeColor: DeckColors.primaryColor,
                  inactiveThumbColor: Colors.white,
                ),
              if (widget.showArrow)
                 Icon(
                  Icons.arrow_right,
                  color: widget.iconArrowColor,
                  size: 32,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

///
///
///

///
///
///
///
///
///

/// ------------------------- E N D ----------------------------
/// -------------------- S E T T I N G S -----------------------
