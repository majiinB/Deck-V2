import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/custom%20widgets/textboxes/textboxes.dart';
import 'package:flutter/cupertino.dart';

import '../../../misc/custom widgets/buttons/radio_button.dart';

class SomeoneDeckContent extends StatefulWidget {

  @override
  _SomeoneDeckContentState createState() => _SomeoneDeckContentState();
}
class _SomeoneDeckContentState extends State<SomeoneDeckContent> {
  final linkDeckController = TextEditingController();

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
      print('Please choose between two options!');
    }
  }
  ///--- E N D -----

  ///handles behavior of the radio buttons in the 'Content Violate Local Laws' section
  int seletedLocalLawsRadio = -1;
  void localLawRadioSelected (int index){
    setState(() {
      seletedLocalLawsRadio = index;
    });
    if (seletedLocalLawsRadio == 0) {
      print('Yes, I believe this content violate local laws');
    }
    else if (seletedLocalLawsRadio == 1){
      print('No');
    }
    else {
      print('Please choose between two options!');
    }
  }
  ///--- E N D -----
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Link of the content you\'reporting',
            style: TextStyle(
              fontFamily: 'Fraiche',
              fontSize: 24,
              color: DeckColors.primaryColor,
            ),
          ),

          ///Textbox to enter link of the deck being reported
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: BuildTextBox(
              showPassword: false,
              hintText: 'Enter link',
              controller: linkDeckController,
            ),
          ),
          ///---- E N D -----

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

          ///Radio buttons for 'Content Violate Local Laws' section
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Do you think this content violates any local laws?',
              style: TextStyle(
                fontFamily: 'Fraiche',
                fontSize: 24,
                color: DeckColors.primaryColor,
              ),
            ),
          ),
          BuildRadioButton(
            numberOfButtons: 2,
            buttonLabels: const [
              'Yes',
              'No (or I am not sure)',
            ],
            buttonSubtexts: const [
              'I believe this content violate local regulations',
              '',
            ],
            textStyle:  const TextStyle(
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
            onButtonSelected: localLawRadioSelected,
          )
          ///---- E N D -----
        ],
      ),
    );
  }
}
