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
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final int wordLimit;

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
    this.onChanged,
    this.wordLimit = 0,
  });

  @override
  State<BuildTextBox> createState() => BuildTextBoxState();
}

class BuildTextBoxState extends State<BuildTextBox> {
  bool _obscureText = true;
  bool _isReadOnly = false;

  //used to count words
  int countWords(String text) {
    return text.trim().split(RegExp(r'\s+')).length;
  }
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      readOnly: _isReadOnly,
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

      ///FOR COUNTING WORD LIMIT AND DETECTING CHANGES
      onChanged: (text) {

        //check if wordLimit must be applied on certain textboxes
        if (widget.wordLimit > 0) {
          int wordCount = countWords(text);

          //check if word count reaches or exceeds the word limit
          if (wordCount >= widget.wordLimit) {
            if (wordCount == widget.wordLimit) {
              //show dialog when word count reaches the limit
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Word Limit Reached'),
                    content: Text('You have reached the ${widget.wordLimit - 1}-word limit!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }

            //Block further input by truncating the text to the word limit
            widget.controller?.text = text.substring(0, text.lastIndexOf(" "));
            widget.controller?.selection = TextSelection.fromPosition(
              TextPosition(offset: widget.controller!.text.length),
            );

            return; //Prevent further typing
          }
        }
        //Allow to change texts if no limit or under the limit
        widget.onChanged?.call(text);
      },
      ///------ E N D -----------
      obscureText: widget.showPassword ? _obscureText : false,
    );
  }
}

/// ------------------------- E N D ----------------------------
/// ------------ T E X T  B O X E S ------------------
