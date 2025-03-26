import 'package:deck/pages/flashcard/Quiz%20Modes/quiz_mode_identification.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/custom%20widgets/buttons/learn_mode_buttons.dart';
import 'package:deck/pages/misc/custom%20widgets/buttons/radio_button.dart';
import 'package:deck/pages/misc/custom%20widgets/buttons/radio_button_group.dart';
import 'package:deck/pages/misc/custom%20widgets/textboxes/textboxes.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:deck/pages/settings/support%20and%20policies/selected%20issue%20content/ai_generated_content.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';

import '../../../flashcard/Quiz Modes/quiz_mode_multChoice.dart';
import '../../../flashcard/play_my_deck.dart';
import '../../widget_method.dart';
import '../buttons/custom_buttons.dart';

///
///
///LearnModeDialog is a method for what learning mode does the user want to choose
class LearnModeDialog extends StatefulWidget {

  const LearnModeDialog({
    super.key,
  });

  @override
  _LearnModeDialogState createState() => _LearnModeDialogState();
}
class _LearnModeDialogState extends State<LearnModeDialog> {
  String selectedMode = 'None';
  final numberOfCards = TextEditingController();

  String quizType = "Multiple Choice";
  String cardOrientation = '';

  ///toggles to show quiz button options or study button options
  bool showQuizOptions = false;
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
        height: MediaQuery.of(context).size.height * 0.6,
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
                              imagePath: 'assets/images/Deck_Quiz.png',
                              isSelected: selectedMode == 'Quiz',
                              onTap: (){
                                setState(() {
                                  selectedMode = 'Quiz';
                                  print("Quiz Mode is Selected");
                                  showQuizOptions = true;
                                  showStudyOptions = false;

                                });
                              },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: LearnModeButton(
                            label: 'Study',
                            imagePath: 'assets/images/Deck_Study.png',
                            isSelected: selectedMode == 'Study',
                            onTap: (){
                              setState(() {
                                selectedMode = 'Study';
                                print("Study Mode is Selected");
                                showStudyOptions = true;
                                showQuizOptions = false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                const Divider(
                  color: DeckColors.primaryColor,
                  thickness: 2,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Number of Cards:',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Nunito-Bold',
                      color: DeckColors.primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: BuildTextBox(
                    hintText: 'Enter number of flashcards',
                    controller: numberOfCards,
                  ),
                ),
                const Divider(
                  color: DeckColors.primaryColor,
                  thickness: 2,
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
                        thickness: 2,
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
                            buttonLabels: ['Term', 'Definition', 'Shuffled'],
                            buttonColors: [DeckColors.deckYellow, DeckColors.deckYellow, DeckColors.deckYellow],
                            isClickable: true,
                            onChange: (label, index){
                              if (index == 0){
                                cardOrientation = "Term";
                              }
                              else if (index == 1){
                                cardOrientation = "Definition";
                              }
                              else if (index == 2){
                                cardOrientation = "Shuffled";
                              }
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
                    onPressed: (){
                        if(showQuizOptions){
                          if(quizType == "Multiple Choice"){
                            Navigator.of(context).push(
                              RouteGenerator.createRoute(const QuizMultChoice()),
                            );
                          }
                          else if(quizType == "Identification") {
                            Navigator.of(context).push(
                              RouteGenerator.createRoute(const QuizIdentification()),
                            );
                          }
                            AlertDialog(
                              title: const Text('Select a quiz type'),
                              content: const Text('Please select a quiz type before starting'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          }
                        else if (showStudyOptions){
                          if(cardOrientation.isNotEmpty){
                            print("Starting study with: $cardOrientation");
                          }
                        } else {
                          AlertDialog(
                            title: const Text('Select a card orientation'),
                            content: const Text('Please select a card orientation before starting'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
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
