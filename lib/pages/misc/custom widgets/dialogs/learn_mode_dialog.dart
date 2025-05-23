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
    super.key, required this.deck
  });

  @override
  _LearnModeDialogState createState() => _LearnModeDialogState();
}
class _LearnModeDialogState extends State<LearnModeDialog> {
  String selectedMode = 'Quiz';
  String modeDialogue = 'Quiz Items';
  final numberOfCards = TextEditingController();

  String quizType = "Multiple Choice";
  String cardOrientation = 'Term';
  int numOfCards = 5;

  ///toggles to show quiz button options or study button options
  bool showQuizOptions = true;
  bool showStudyOptions = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: DeckColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.99,
        // height: MediaQuery.of(context).size.height * 0.6,
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
                    padding: const EdgeInsets.symmetric(vertical:  10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: LearnModeButton(
                              label: 'Quiz',
                              imagePath: 'assets/images/Deck-Quiz.png',
                              isSelected: selectedMode == 'Quiz',
                              onTap: (){
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
                            onTap: (){
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
                    controller: numberOfCards,
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
                          onChange: (label, index){
                            if (index == 0){
                              quizType = "Multiple Choice";
                            }
                            else if (index == 1){
                              quizType = "Identification";
                            }
                          },
                        )
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
                            buttonLabels: ['Term', 'Definition'],
                            buttonColors: [DeckColors.deckYellow, DeckColors.deckYellow],
                            isClickable: true,
                            onChange: (label, index){
                              setState(() {
                                if (index == 0){
                                  cardOrientation = "Term";
                                } else if (index == 1){
                                  cardOrientation = "Definition";
                                }
                              });
                            },
                          )
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
                    onPressed: () async {
                      ///If user clicks quiz
                        if(showQuizOptions){
                          if(quizType == "Multiple Choice"){
                            FlashcardAiService aiService = new FlashcardAiService();
                            Quiz? quiz = await aiService.retrieveQuizForDeck(deckId: widget.deck.deckId);
                            List<QuizQuestion>? questions = quiz!.questions;
                            await Navigator.of(context).push(
                              RouteGenerator.createRoute(QuizMultChoice(
                                deck: widget.deck,
                                questions: questions,
                              )),
                            ).then((_) {
                              Navigator.of(context).pop(); ///Close the dialog after navigating
                            });
                          }
                          else if(quizType == "Identification") {
                            List<Cards> randomizedCards = await widget.deck.getCardRandom(numOfCards);
                            print(randomizedCards);
                            await Navigator.of(context).push(
                              RouteGenerator.createRoute(QuizIdentification(
                                cards: randomizedCards,
                                deck:  widget.deck,
                              )),
                            ).then((_) {
                              Navigator.of(context).pop(); ///Close the dialog after navigating
                            });
                          }
                          }

                        ///If user clicks study (flashcard mode)
                        else if (showStudyOptions){
                          ///this choice is for term orientation
                          final raw = numberOfCards.text.trim();
                          final parsed = int.tryParse(raw);
                          if (raw.isNotEmpty && parsed != null && parsed > 0 ) {
                            numOfCards = parsed;
                          }
                          if(cardOrientation == "Term"){
                            Navigator.of(context).push(
                              RouteGenerator.createRoute(PlayMyDeckPage(
                                cards: await widget.deck.getCardRandom(numOfCards),
                                deck:  widget.deck,
                                orientation: cardOrientation,
                              )),
                            ).then((_) {
                              Navigator.of(context).pop(); ///Close the dialog after navigating
                            });
                          }
                          ///this choice is for definition orientation
                          else if (cardOrientation == "Definition"){
                            Navigator.of(context).push(
                              RouteGenerator.createRoute(PlayMyDeckPage(
                                cards: await widget.deck.getCardRandom(numOfCards),
                                deck:  widget.deck,
                                orientation: cardOrientation,
                              )),
                            ).then((_) {
                              Navigator.of(context).pop(); ///Close the dialog after navigating
                            });
                          }
                        }
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
                    onPressed: (){
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
