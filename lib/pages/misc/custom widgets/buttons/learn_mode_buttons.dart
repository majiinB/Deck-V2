import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/custom%20widgets/buttons/radio_button_group.dart';
import 'package:flutter/material.dart';

class LearnModeButton extends StatelessWidget {
  final String label;
  final String? imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const LearnModeButton({
    Key? key,
    required this.label,
    this.imagePath,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom
        (
        backgroundColor: isSelected ? DeckColors.deckBlue : DeckColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected ? DeckColors.primaryColor : DeckColors.primaryColor,
            width: 2,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Fraiche',
                fontWeight: FontWeight.bold,
                color: isSelected ? DeckColors.white : DeckColors.primaryColor,
              ),
            ),
          ),
          Image.asset(
              imagePath!,
              width: 100,
              height: 100),
        ],
      ),
    );
  }
}


