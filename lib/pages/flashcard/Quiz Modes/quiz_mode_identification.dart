import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/custom%20widgets/appbar/learn_mode_bar.dart';
import 'package:deck/pages/misc/custom%20widgets/buttons/custom_buttons.dart';
import 'package:deck/pages/misc/custom%20widgets/textboxes/textboxes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../backend/models/deck.dart';
import '../../misc/custom widgets/dialogs/alert_dialog.dart';
import '../../misc/custom widgets/dialogs/confirmation_dialog.dart';
import '../../misc/widget_method.dart';
import '../quiz_results.dart';

class QuizIdentification extends StatefulWidget {
  final List cards;
  final Deck deck;
  const QuizIdentification({
    Key? key,
    required this.cards,
    required this.deck,
  }) : super(key: key);

  @override
  _QuizIdentificationState createState() => _QuizIdentificationState();
}

class _QuizIdentificationState extends State<QuizIdentification> {
  String title = '';
  String question = '';
  final answerController = TextEditingController();
  int currentQuestionIndex = 0; //track the current question
  List<Map<String, dynamic>> results = [];
  int score = 0;


  //initialize the first question
  @override
  void initState() {
    super.initState();
    if (widget.cards.isNotEmpty) {
      question = widget.cards[currentQuestionIndex].definition;
    } else {
      question = 'No cards available.';
    }
  }

  void handleSubmit() {
    String userAnswer = answerController.text.trim();
    var currentQuestion = widget.cards[currentQuestionIndex];

    // Check if correct
    bool isCorrect = userAnswer.toLowerCase() ==
        currentQuestion.term.toString().trim().toLowerCase();

    if (isCorrect) score++;

    // Record result
    results.add({
      'questionId': currentQuestion.cardId, // assuming your card model has 'id'
      'questionIndex' : currentQuestionIndex + 1,
      'question': currentQuestion.definition,
      'correctAnswer': currentQuestion.term,
      'userAnswer': userAnswer,
      'isCorrect': isCorrect,
    });

    //Move to the next question
    if (currentQuestionIndex < widget.cards.length - 1) {
      setState(() {
        currentQuestionIndex++;
        question = widget.cards[currentQuestionIndex].definition;
        answerController.clear();
      });
    } else {
      //end of quiz, show the dialog
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context){
            return CustomAlertDialog(
              imagePath: 'assets/images/Deck-Dialogue3.png',
              title: 'Quiz Finished!',
              message: 'Congratulations, wanderer! You\'ve completed the quiz!',
              button1: 'Ok',
              onConfirm: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  RouteGenerator.createRoute(QuizResults(score: score, result: results,)),
                );
              },
            );
          }
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DeckColors.backgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: LearnModeBar(
        title: 'Quiz Mode',
        color: DeckColors.primaryColor,
        fontSize: 24,
        onButtonPressed: () {
          showConfirmDialog(
              context,
              'assets/images/Deck-Dialogue4.png',
              'Stop Quiz Mode?',
              'Stop Now? You\'ll lose all your progress',
              'Stop',
                  () {
                ///Pop twice: first, close the dialog, then navigate back to the previous page
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
          );
        },
        buttonText: 'Stop Playing',
        buttonIcon: Icons.play_arrow_rounded,
        buttonColor: DeckColors.deckRed,
        borderButtonColor: DeckColors.deckRed,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: AutoSizeText(
                  widget.deck.title,
                  overflow: TextOverflow.visible,
                  maxLines: 3,
                  style: const TextStyle(
                    fontFamily: 'Fraiche',
                    color: DeckColors.primaryColor,
                    fontSize: 40,
                    height: 1,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 15.0, right:15.0),
                child: Container(
                  height: 450,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: DeckColors.white,
                    border: Border.all(
                      color: DeckColors.primaryColor,
                      width: 3.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                question,
                                style: const TextStyle(
                                  fontFamily: 'Nunito-Regular',
                                  color: DeckColors.primaryColor,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          color: DeckColors.primaryColor,
                          thickness: 2,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Answer',
                              style: TextStyle(
                                fontFamily: 'Nunito-Bold',
                                fontSize: 16,
                                color: DeckColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: BuildTextBox(
                            hintText: 'Type Answer',
                            controller: answerController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: BuildButton(
                            onPressed: handleSubmit,
                            buttonText: 'Submit Answer',
                            height: 50.0,
                            width: MediaQuery.of(context).size.width,
                            backgroundColor: DeckColors.primaryColor,
                            textColor: DeckColors.white,
                            radius: 10.0,
                            fontSize: 16,
                            borderWidth: 3,
                            borderColor: DeckColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: DeckColors.accentColor,
                    border: Border.all(
                      color: DeckColors.primaryColor,
                      width: 3.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${currentQuestionIndex + 1}/${widget.cards.length}',
                      style: const TextStyle(
                          fontFamily: 'Fraiche',
                          fontSize: 32,
                          color: DeckColors.primaryColor),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Image.asset(
                  'assets/images/Deck-Bottom-Image1.png',
                  fit: BoxFit.fitWidth,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
