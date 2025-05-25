import 'dart:io';
import 'package:deck/backend/flashcard/flashcard_service.dart';
import 'package:deck/pages/flashcard/flashcard.dart';
import 'package:deck/pages/flashcard/view_deck.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/custom%20widgets/appbar/auth_bar.dart';
import 'package:deck/pages/misc/custom%20widgets/appbar/learn_mode_bar.dart';
import 'package:deck/pages/misc/custom%20widgets/buttons/custom_buttons.dart';
import 'package:deck/pages/misc/custom%20widgets/functions/tab_bar.dart';
import 'package:deck/pages/misc/custom%20widgets/textboxes/textboxes.dart';
import 'package:deck/pages/misc/custom%20widgets/tiles/container_of_flashcard.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../misc/custom widgets/progressbar/progress_bar.dart';

class QuizResults extends StatefulWidget {
  final List<Map<String, dynamic>> result;
  final int score;
  final String deckId;
  final String quizType;
  const QuizResults({super.key, required this.result, required this.score, required this.deckId, required this.quizType});

  @override
  _QuizResultsState createState() => _QuizResultsState();
}

class _QuizResultsState extends State<QuizResults> {
  final TextEditingController _searchController = TextEditingController();
  int overallItems = 0;
  int correctItems = 0;
  int incorrectItems = 0;
  double progress = 0.0;
  List<Map<String, dynamic>> correctAnswers = [];
  List<Map<String, dynamic>> wrongAnswers = [];

  @override
  void initState() {
    super.initState();
    overallItems = widget.result.length;
    correctItems = widget.score;
    incorrectItems = overallItems - correctItems;
    progress = widget.result.isNotEmpty ? widget.score / widget.result.length : 0.0;

    // Separate the correct and wrong answers
    for (var result in widget.result) {
      if (result['isCorrect']) {
        correctAnswers.add(result);
      } else {
        wrongAnswers.add(result);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _logQuizAttempt();
    });
  }

  Future<void> _logQuizAttempt() async {
    try {
      FlashcardService flashcardService = new FlashcardService();
      await flashcardService.logQuizAttempt(
        deckId: widget.deckId,
        attemptedAt: DateTime.now(),
        quizType: widget.quizType.toString(),
        score: widget.score,
        totalQuestions: overallItems,
        correctQuestionIds: correctAnswers
            .map((r) => r['questionId'] as String)
            .toList(),
        incorrectQuestionIds: wrongAnswers
            .map((r) => r['questionId'] as String)
            .toList(),
      );
      print('Quiz attempt logged successfully');
    } catch (e) {
      print('Failed to log quiz attempt: $e');
      // optionally show a SnackBar or silently ignore
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DeckColors.backgroundColor,
      appBar: LearnModeBar(
        title: 'Quiz Results',
        color: DeckColors.primaryColor,
        fontSize: 24,
        onButtonPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
        buttonText: 'Finish Quiz',
        buttonIcon: Icons.done_all,
        buttonColor: DeckColors.accentColor,
        borderButtonColor: DeckColors.accentColor,
      ),
      body: SingleChildScrollView(
        child:
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
              child: Column(
                children: [
                  ///START OF OVERALL SCORE
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Container(
                      width: double.infinity,
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
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Score',
                                  style: TextStyle(
                                    fontFamily: 'Fraiche',
                                    fontSize: 24,
                                    color: DeckColors.primaryColor,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${widget.score}/${widget.result.length}',
                                  style: const TextStyle(
                                    fontFamily: 'Fraiche',
                                    fontSize: 24,
                                    color: DeckColors.primaryColor,
                                  ),
                                )
                              ],
                            ),
                            ///P R O G R E S S  B A R
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: ProgressBar(
                                progress: progress,
                                progressColor: DeckColors.deckYellow,
                                height: 20.0,
                              ),
                            ),
                            /// ----- end progress bar ----------
                          ],
                        ),
                      ),
                    ),
                  ),
                  ///END of overall score container
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    child: Row(
                      children: [
                        ///Container for number of correct items
                        Expanded(
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: DeckColors.white,
                              image: const DecorationImage(
                                image: AssetImage('assets/images/Deck-Correct.png'),
                                fit: BoxFit.cover,
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
                              padding: const EdgeInsets.all(10.0),
                              child: Stack(
                                children: [
                                  const Positioned(
                                    top: 15,
                                    right: 20,
                                    child: Text(
                                      'Correct',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: DeckColors.primaryColor,
                                          fontFamily: 'Fraiche'),
                                    ),
                                  ),
                                  Positioned(
                                    top: 25,
                                    right: 30,
                                    child: Text(
                                      '$correctItems',
                                      style: const TextStyle(
                                          fontSize: 40,
                                          color: DeckColors.primaryColor,
                                          fontFamily: 'Fraiche'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ///---- end of number of correct items ----
                        const SizedBox(width: 8),

                        ///Container number of incorrect items
                        Expanded(
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: DeckColors.white,
                              image: const DecorationImage(
                                image: AssetImage('assets/images/Deck-Incorrect.png'),
                                fit: BoxFit.cover,
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
                              padding: const EdgeInsets.all(10.0),
                              child: Stack(
                                children: [
                                  const Positioned(
                                    top: 15,
                                    right: 20,
                                    child: Text(
                                      'Incorrect',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: DeckColors.deckRed,
                                          fontFamily: 'Fraiche'),
                                    ),
                                  ),
                                  Positioned(
                                    top: 25,
                                    right: 30,
                                    child: Text(
                                      '$incorrectItems',
                                      style: const TextStyle(
                                          fontSize: 40,
                                          color: DeckColors.deckRed,
                                          fontFamily: 'Fraiche'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ///---- end of number of incorrect items ----
                      ],
                    ),
                  ),


                  ///START OF TAB BAR
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .6,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                      child: BuildTabBar(
                        titles: ['Correct', 'Incorrect'],
                        length: 2,
                        tabContent: [
                          ///
                          /// ------------------------- START OF TAB 'CORRECT' CONTENT ----------------------------
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0,),
                              child: ListView.builder(
                                itemCount: correctAnswers.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0, right: 4.0),
                                    child: BuildContainerOfFlashCards(
                                      enableSwipeToRetrieve: false,
                                      titleOfFlashCard: 'Question No. ${correctAnswers[index]['questionIndex']}',
                                      contentOfFlashCard: correctAnswers[index]['question'],
                                      rightIcon: Icon(Icons.check),
                                      rightIconColor: Colors.green.shade700,
                                      iconOnPressed: () {
                                        // Define your onPressed logic here
                                      },
                                      showStar: false,
                                      showIcon: true,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          ///
                          /// ------------------------- END OF TAB 'CORRECT' CONTENT ----------------------------

                          ///
                          /// ------------------------- START OF TAB 'INCORRECT' CONTENT ----------------------------
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: ListView.builder(
                                itemCount: wrongAnswers.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                                    child: BuildContainerOfFlashCards(
                                      enableSwipeToRetrieve: false,
                                      titleOfFlashCard: 'Question No. ${wrongAnswers[index]['questionIndex']}',
                                      contentOfFlashCard: wrongAnswers[index]['question'],
                                      rightIcon: Icon(Icons.close_rounded),
                                      rightIconColor: DeckColors.deckRed,
                                      iconOnPressed: () {
                                        // Define your onPressed logic here
                                      },
                                      showStar: false,
                                      showIcon: true,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  /// ------------------------- END OF TAB 'INCORRECT' CONTENT ---------------------------
                ],
              ),
            ),
      ),
    );
  }
}