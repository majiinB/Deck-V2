import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';

///
///
///Dropdown Menu Test
class DropdownMenu extends StatelessWidget {
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final IconData? leftIcon;
  final Color? leftIconColor;

  const DropdownMenu({
    super.key,
    required this.items,
    this.onChanged,
    this.validator,
    this.onSaved,
    this.leftIcon,
    this.leftIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String?>(
      isExpanded: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding:
        const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        prefixIcon: leftIcon != null
            ? Icon(
          leftIcon,
          color: leftIconColor,
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Fixed radius of 10 pixels
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
      hint: const Text(
        'Select an option',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem<String?>(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ))
          .toList(),
      onChanged: onChanged,
      validator: validator,
      onSaved: onSaved,
      iconStyleData: const IconStyleData(
        icon: Icon(
          DeckIcons.dropdown,
          color: Colors.black45,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), // Fixed radius of 10 pixels
          color: Colors.grey[200],
        ),
      ),
    );
  }
}
