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
/// ------------ T E X T  B O X E S ------------------
class BuildTextBox extends StatefulWidget {
  final String? hintText, initialValue;
  final bool showPassword;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final bool isMultiLine;
  final bool isReadOnly;
  final TextEditingController? controller;
  final VoidCallback? onTap;

  const BuildTextBox({
    super.key,
    this.hintText,
    this.showPassword = false,
    this.leftIcon,
    this.rightIcon,
    this.initialValue,
    this.controller,
    this.onTap,
    this.isMultiLine = false,
    this.isReadOnly = false,
  });

  @override
  State<BuildTextBox> createState() => BuildTextBoxState();
}

class BuildTextBoxState extends State<BuildTextBox> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      readOnly: widget.isReadOnly,
      onTap: widget.onTap,
      controller: widget.controller,
      initialValue: widget.initialValue,
      style: const TextStyle(
        fontFamily: 'Nunito-Bold',
        color: DeckColors.primaryColor,
        fontSize: 16,
      ),
      maxLines: widget.isMultiLine ? null : 1,
      minLines: widget.isMultiLine ? 4 : 1,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: DeckColors.primaryColor,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: DeckColors.primaryColor, // Change to your desired color
            width: 2.0,
          ),
        ),
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          fontFamily: 'Nunito-Italic',
          fontSize: 16,
          // fontStyle: FontStyle.italic,
          color: DeckColors.primaryColor,
        ),
        filled: true,
        fillColor: DeckColors.white,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        prefixIcon: widget.leftIcon != null
            ? Icon(
            widget.leftIcon,
            color: DeckColors.primaryColor)
            : null, // Change to your desired left icon
        suffixIcon: widget.showPassword
            ? IconButton(
          icon: _obscureText
              ? const Icon(
            Icons.visibility_off,
            color: DeckColors.primaryColor,)
              : const Icon(
              Icons.visibility,
              color: DeckColors.primaryColor,),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : widget.rightIcon != null
            ? IconButton(
          icon: Icon(widget.rightIcon,
          color: DeckColors.primaryColor,
          ),
          onPressed: widget.onTap,
        )
            : null,
      ),
      obscureText: widget.showPassword ? _obscureText : false,
    );
  }
}

/// ------------------------- E N D ----------------------------
/// ------------ T E X T  B O X E S ------------------
