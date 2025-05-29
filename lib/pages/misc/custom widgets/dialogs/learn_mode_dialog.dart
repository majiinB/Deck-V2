import 'package:deck/backend/flashcard/flashcard_ai_service.dart';
import 'package:deck/pages/flashcard/Quiz%20Modes/quiz_mode_identification.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/custom%20widgets/buttons/learn_mode_buttons.dart';
import 'package:deck/pages/misc/custom%20widgets/buttons/radio_button_group.dart';
import 'package:deck/pages/misc/custom%20widgets/textboxes/textboxes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../../backend/models/card.dart';
import '../../../../backend/models/deck.dart';
import '../../../../backend/models/quiz.dart';
import '../../../flashcard/Quiz Modes/quiz_mode_multChoice.dart';
import '../../../flashcard/play_my_deck.dart';
import '../../widget_method.dart';
import '../buttons/custom_buttons.dart';
import 'alert_dialog.dart';

/// LearnModeDialog - A dialog that allows users to choose a learning mode.
///
/// This dialog provides two options for learning:
/// - **Quiz Mode** (Multiple Choice or Identification)
/// - **Study Mode** (Flashcards with different orientations)
///
/// The user can customize their session by selecting the number of cards
/// and the preferred quiz or study settings.
///
/// Usage:
/// showDialog(
///   context: context,
///   builder: (context) => const LearnModeDialog(),
/// );
///

class LearnModeDialog extends StatefulWidget {
  final Deck deck;
  const LearnModeDialog({
    super.key,
    required this.deck,
  });

  @override
  _LearnModeDialogState createState() => _LearnModeDialogState();
}

class _LearnModeDialogState extends State<LearnModeDialog> {
  String selectedMode = 'Quiz';
  String modeDialogue = 'Quiz Items';
  final numberOfCardsController = TextEditingController();

  String quizType = "Multiple Choice";
  String cardOrientation = 'Term';
  int numOfCards = 0;

  ///toggles to show quiz button options or study button options
  bool showQuizOptions = true;
  bool showStudyOptions = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: DeckColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.99,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Learning Mode',
                  style: TextStyle(
                    fontFamily: 'Fraiche',
                    fontSize: 24,
                    color: DeckColors.primaryColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: LearnModeButton(
                          label: 'Quiz',
                          imagePath: 'assets/images/Deck-Quiz.png',
                          isSelected: selectedMode == 'Quiz',
                          onTap: () {
                            setState(() {
                              selectedMode = 'Quiz';
                              print("Quiz Mode is Selected");
                              showQuizOptions = true;
                              showStudyOptions = false;
                              modeDialogue = 'Quiz Items';
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: LearnModeButton(
                          label: 'Study',
                          imagePath: 'assets/images/Deck-Study.png',
                          isSelected: selectedMode == 'Study',
                          onTap: () {
                            setState(() {
                              selectedMode = 'Study';
                              print("Study Mode is Selected");
                              showStudyOptions = true;
                              showQuizOptions = false;
                              modeDialogue = 'Cards';
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: DeckColors.primaryColor,
                  thickness: 3,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Number of $modeDialogue:',
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Nunito-Bold',
                      color: DeckColors.primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: BuildTextBox(
                    hintText: 'Enter number of $modeDialogue',
                    controller: numberOfCardsController,
                  ),
                ),
                const Divider(
                  color: DeckColors.primaryColor,
                  thickness: 3,
                ),

                ///
                ///
                ///If quiz option is clicked, it will show this result:
                if (showQuizOptions)
                  Column(
                    children: [
                      const Text(
                        'Question Type',
                        style: TextStyle(
                          fontFamily: 'Fraiche',
                          fontSize: 24,
                          color: DeckColors.primaryColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: RadioButtonGroup(
                          buttonLabels: const ['Multiple Choice', 'Identification'],
                          buttonColors: const [DeckColors.deckYellow, DeckColors.deckYellow],
                          isClickable: true,
                          onChange: (label, index) {
                            if (index == 0) {
                              quizType = "Multiple Choice";
                            } else if (index == 1) {
                              quizType = "Identification";
                            }
                          },
                        ),
                      ),
                      const Divider(
                        color: DeckColors.primaryColor,
                        thickness: 3,
                      ),
                    ],
                  ),
                ///---- E N D  O F  Q U I Z  O P T I O N S ---------

                ///
                ///
                ///If study option is clicked, it will show this result:
                if (showStudyOptions)
                  Column(
                    children: [
                      const Text(
                        'Card Orientation',
                        style: TextStyle(
                          fontFamily: 'Fraiche',
                          fontSize: 24,
                          color: DeckColors.primaryColor,
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Show By...',
                          style: TextStyle(
                            fontFamily: 'Nunito-Regular',
                            fontSize: 12,
                            color: DeckColors.primaryColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: RadioButtonGroup(
                          buttonLabels: const ['Term', 'Definition'],
                          buttonColors: const [DeckColors.deckYellow, DeckColors.deckYellow],
                          isClickable: true,
                          onChange: (label, index) {
                            setState(() {
                              if (index == 0) {
                                cardOrientation = "Term";
                              } else if (index == 1) {
                                cardOrientation = "Definition";
                              }
                            });
                          },
                        ),
                      ),
                      const Divider(
                        color: DeckColors.primaryColor,
                        thickness: 2,
                      ),
                    ],
                  ),
                ///---- E N D  O F  S T U D Y  O P T I O N ---------

                ///BUTTONS: start and cancel btns
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: BuildButton(
                    onPressed: () {
                      final rawNumberOfCards = numberOfCardsController.text.trim();
                      final parsedNumberOfCards = int.tryParse(rawNumberOfCards);

                      if(rawNumberOfCards.isEmpty ||
                        parsedNumberOfCards == null ||
                        (parsedNumberOfCards < 5 || parsedNumberOfCards > 50)
                      ){
                        showAlertDialog(
                            context,
                            "assets/images/Deck-Dialogue2.png",
                            "Invalid number of $modeDialogue",
                            "The number of $modeDialogue cant be less than 5 or greater than 50"
                        );
                        return;
                      }

                      final numberOfCards = (rawNumberOfCards.isNotEmpty &&
                          parsedNumberOfCards != null &&
                          parsedNumberOfCards > 0)
                          ? parsedNumberOfCards
                          : 5; // Default value if input is invalid

                      Navigator.pop(context, {
                        'mode': selectedMode,
                        'numberOfCards': numberOfCards,
                        if (selectedMode == 'Quiz') 'quizType': quizType,
                        if (selectedMode == 'Study') 'cardOrientation': cardOrientation,
                      });
                    },
                    buttonText: 'Start',
                    height: 35,
                    width: double.infinity,
                    radius: 20,
                    backgroundColor: DeckColors.primaryColor,
                    textColor: DeckColors.white,
                    fontSize: 16,
                    borderWidth: 2,
                    borderColor: DeckColors.primaryColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: BuildButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    buttonText: 'Cancel',
                    height: 35,
                    width: double.infinity,
                    radius: 20,
                    backgroundColor: DeckColors.white,
                    textColor: DeckColors.primaryColor,
                    fontSize: 16,
                    borderWidth: 2,
                    borderColor: DeckColors.primaryColor,
                  ),
                ),
                ///--- E N D  O F  B U T T O N S -----------
              ],
            ),
          ),
        ),
      ),
    );
  }
}

