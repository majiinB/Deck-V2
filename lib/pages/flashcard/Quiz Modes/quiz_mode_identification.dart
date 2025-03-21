import 'dart:io';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/custom%20widgets/appbar/learn_mode_bar.dart';
import 'package:deck/pages/misc/custom%20widgets/buttons/custom_buttons.dart';
import 'package:deck/pages/misc/custom%20widgets/textboxes/textboxes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../misc/custom widgets/dialogs/confirmation_dialog.dart';
import '../../misc/widget_method.dart';
import '../quiz_results.dart';

class QuizIdentification extends StatefulWidget {
  const QuizIdentification({super.key});

  @override
  _QuizIdentificationState createState() => _QuizIdentificationState();
}

class _QuizIdentificationState extends State<QuizIdentification> {
  String title = '';
  String question = '';
  final answerController = TextEditingController();
  int currentQuestionIndex = 0; //track the current question
  List<Map<String, String>> questions = [
    {
      'question': 'sino project manager ng group odyssey',
      'answer': 'richmond',
    },
    {
      'question': 'ano ang unang project ng group oydssey',
      'answer': 'archivary',
    },
    {
      'question': 'sino front end leader ng odyssey',
      'answer': 'pole',
    },
    {
      'question': 'ano unang pangalan ng grp odyssey',
      'answer': 'maiteam',
    },
  ];

  //initialize the first question
  @override
  void initState() {
    super.initState();
    question = questions[currentQuestionIndex]['question']!;
  }

  void handleSubmit() {
    String userAnswer = answerController.text.trim();
    var currentQuestion = questions[currentQuestionIndex];

    if (userAnswer == currentQuestion['answer']) {
      print('Correct!');
    } else {
      print('Incorrect!');
    }

    //Move to the next question
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        question = questions[currentQuestionIndex]['question']!;
        answerController.clear();
      });
    } else {
      //end of quiz, show the dialog
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context){
            return AlertDialog(
              title: const Text('Quiz Finished'),
              content: const Text('Congratulations! You have finished the quiz!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      RouteGenerator.createRoute(const QuizResults()),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          }
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DeckColors.backgroundColor,
      appBar: LearnModeBar(
        title: 'Quiz Mode',
        color: DeckColors.primaryColor,
        fontSize: 24,
        onButtonPressed: () {
          showConfirmationDialog(
              context,
              'Stop Quiz Mode?',
              'Are you sure you want to stop? You will lose all progress if you stop now.',
                  () {
                Navigator.of(context).pop();
              },
                  () {});
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
              child: Column(
                children: [
                  Text(
                    title.isNotEmpty ? title : 'A Very long deck title that is more than 2 lines',
                    overflow: TextOverflow.visible,
                    style: const TextStyle(
                      fontFamily: 'Fraiche',
                      color: DeckColors.primaryColor,
                      fontSize: 40,
                      height: 1.1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 20.0),
                    child: Container(
                      height: 550,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: DeckColors.white,
                        border: Border.all(
                          color: DeckColors.primaryColor,
                          width: 2.0,
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
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                height: 300,
                                child: Center(
                                  child: SingleChildScrollView(
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
                                borderWidth: 1,
                                borderColor: DeckColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Image.asset(
              'assets/images/Deck-Bottom-Image.png',
              fit: BoxFit.fitWidth,
              width: MediaQuery.of(context).size.width,
            ),
          ],
        ),
      ),
    );
  }
}
