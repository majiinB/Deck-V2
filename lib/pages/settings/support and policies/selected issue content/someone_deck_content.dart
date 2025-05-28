import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/custom%20widgets/textboxes/textboxes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../misc/custom widgets/buttons/radio_button.dart';
import '../../../misc/custom widgets/dialogs/confirmation_dialog.dart';

class SomeoneDeckContent extends StatefulWidget {
  final TextEditingController controller; // Accept controller via constructor

  const SomeoneDeckContent({super.key, required this.controller});

  String getTextValue() {
    return controller.text;
  }
  @override
  _SomeoneDeckContentState createState() => _SomeoneDeckContentState();
}
class _SomeoneDeckContentState extends State<SomeoneDeckContent> {
  String getTextValue() {
    return widget.controller.text;
  }

  ///handles behavior of the radio buttons in the 'Reason for reporting this content' section
  int selectedDeckRadio = -1;

  void deckRadioButtonSelected(int index) {
    setState(() {
      selectedDeckRadio = index;
    });
    if (selectedDeckRadio == 0) {
      print('You selected 1st option');
    }
    else if (selectedDeckRadio == 1) {
      print('You selected 2nd option');
    }
    else if (selectedDeckRadio == 2) {
      print('You selected 3rd option');
    }
    else if (selectedDeckRadio == 3) {
      print('You selected 4th option');
    }
    else if (selectedDeckRadio == 4) {
      print('You selected 5th option');
    }
    else if (selectedDeckRadio == 5) {
      print('You selected 6th option');
    }
    else if (selectedDeckRadio == 6) {
      print('You selected 7th option');
    }
    else if (selectedDeckRadio == 7) {
      print('You selected 8th option');
    }
    else {
      print('Please choose among the options!');
    }
  }
  ///--- E N D -----

  bool _hasUnsavedChanges() {
    return widget.controller.text.isNotEmpty;
  }



  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didpop) async {
        if (didpop) {
          return;
        }

        // Show the dialog only if a radio button is selected
        if (selectedDeckRadio != -1 || _hasUnsavedChanges()) { //TODO FIX THIS (status: FIXED!!!)
          final shouldPop = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return CustomConfirmDialog(
                title: 'Are you sure you want to go back?',
                message: 'If you go back now, you will lose all your progress',
                imagePath: 'assets/images/Deck-Dialogue4.png',
                button1: 'Go Back',
                button2: 'Cancel',
                onConfirm: () {
                  Navigator.of(context).pop(true); //Return true to allow pop
                },
                onCancel: () {
                  Navigator.of(context).pop(false); //Return false to prevent pop
                },
              );
            },
          );

          //If the user confirmed, pop the current route
          if (shouldPop != null && shouldPop) {
            Navigator.of(context).pop(true);
          }
        } else {
          //No unsaved changes, allow pop without confirmation
          Navigator.of(context).pop(true);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'Why are you reporting this content?',
                style: TextStyle(
                  fontFamily: 'Fraiche',
                  fontSize: 24,
                  color: DeckColors.primaryColor,
                ),
              ),
            ),

            ///Radio buttons for 'Reporting this content' section
            Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: BuildRadioButton(
                  numberOfButtons: 8,
                  buttonLabels: const [
                    'Graphic Violence',
                    'Sexually explicit content',
                    'Political partiality',
                    'Abuse, hate speech, or discrimination',
                    'Regulated Content',
                    'Deceptive or misleading',
                    'Intellectual property infringement',
                    'Something Else'
                  ],
                  buttonSubtexts: const [
                    'Violent or triggering content or promotion of violence or self harm.',
                    'Sexually explicit content, objectification or sexualisation, '
                        'non-consensual intimate imagery.',
                    'Content that favors or disfavours a particular political stance.',
                    'Abuse or exploitation, including child sexual abuse material. '
                        'Harassment, prejudice, stereotypes, degradation, or insensitivity '
                        'including on the basis of culture, race, gender, etc.',
                    'Promotion of weapons, dangerous goods, or drug usage.',
                    'Scams, fraud, phishing, or other harmful misinformation.',
                    'Content that infringes copyright, trademark or other rights.',
                    '' //null because there is no subtext for the 8th option
                  ],
                  textStyle:
                  const TextStyle(
                    fontFamily: 'Fraiche',
                    fontSize: 24,
                    color: DeckColors.primaryColor,
                  ),
                  subtextStyle:
                  const TextStyle(
                    fontFamily: 'Nunito-Regular',
                    fontSize: 16,
                    color: DeckColors.primaryColor,
                  ),
                  activeColor: DeckColors.primaryColor,
                  inactiveColor: DeckColors.primaryColor,
                  onButtonSelected: deckRadioButtonSelected,
                ),
            ),
            ///--- E N D ------

            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'Give us additional details about your report',
                style: TextStyle(
                  fontFamily: 'Fraiche',
                  fontSize: 24,
                  color: DeckColors.primaryColor,
                ),
              ),
            ),
            ///Textbox for user to provide additional details about the report
             Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
              child: BuildTextBox(
                hintText: 'Enter additional details',
                isMultiLine: true,
                controller: widget.controller,
              ),
            )
            ///---- E N D -----
          ],
        ),
      ),
    );
  }
}
