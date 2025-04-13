import 'dart:io';
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
  const QuizResults({super.key});

  @override
  _QuizResultsState createState() => _QuizResultsState();
}

class _QuizResultsState extends State<QuizResults> {
  int correctItems = 2;
  int overallItems = 4;
  final TextEditingController _searchController = TextEditingController();

  //lists to store titles and content for the flashcards
  List<String> correctFlashCardTitles = ['Flashcard 1', 'Flashcard 2'];
  List<String> correctFlashCardContents = ['Content of card 1', 'Content of card 2'];

  List<String> incorrectFlashCardTitles = ['Flashcard 3', 'Flashcard 4'];
  List<String> incorrectFlashCardContents = ['Content of card 3', 'Content of card 4'];

  @override
  Widget build(BuildContext context) {
    double progress = overallItems > 0 ? correctItems / overallItems : 0.0;
    int incorrectItems = overallItems - correctItems;

    return PopScope(
      canPop: true, ///set to false to if nagawa na ung view deck page
      onPopInvoked: (didPop) {
        if (!didPop) {
          ///navigate to the View Deck Page (comment out mo lang to ar2r)
          /*Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ViewDeckPage(
                deck: deck)
            ),
          );*/
        }
      },
      child: Scaffold(
        backgroundColor: DeckColors.backgroundColor,
        appBar: const AuthBar(
          automaticallyImplyLeading: true,
          title: 'Quiz Results',
          color: DeckColors.primaryColor,
          fontSize: 24,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                child: Column(
                  children: [
                    ///START OF OVERALL SCORE
                    Container(
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
                                  '$correctItems/$overallItems',
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
                    ///END of overall score container
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                    ///search bar
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: BuildTextBox(
                        hintText: "Search your deck",
                        rightIcon: Icons.search,
                        controller: _searchController,
                      ),
                    ),

                    ///START OF TAB BAR
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .6,
                        child: BuildTabBar(
                          titles: ['Correct', 'Incorrect'],
                          length: 2,
                          tabContent: [
                            ///
                            /// ------------------------- START OF TAB 'CORRECT' CONTENT ----------------------------
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: ListView.builder(
                                itemCount: correctFlashCardTitles.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0, right: 4.0),
                                    child: BuildContainerOfFlashCards(
                                      enableSwipeToRetrieve: false,
                                      titleOfFlashCard: correctFlashCardTitles[index],
                                      contentOfFlashCard: correctFlashCardContents[index],
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
                            ///
                            /// ------------------------- END OF TAB 'CORRECT' CONTENT ----------------------------

                            ///
                            /// ------------------------- START OF TAB 'INCORRECT' CONTENT ----------------------------
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: ListView.builder(
                                itemCount: incorrectFlashCardTitles.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                                    child: BuildContainerOfFlashCards(
                                      enableSwipeToRetrieve: false,
                                      titleOfFlashCard: incorrectFlashCardTitles[index],
                                      contentOfFlashCard: incorrectFlashCardContents[index],
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
                          ],
                        ),
                      ),
                    )
                    /// ------------------------- END OF TAB 'INCORRECT' CONTENT ----------------------------
                  ],
                ),
              ),
              Image.asset(
                'assets/images/Deck-Bottom-Image1.png',
                fit: BoxFit.fitWidth,
                width: MediaQuery.of(context).size.width,
              ),
            ],
          ),
        ),
      ),
    );
  }
}