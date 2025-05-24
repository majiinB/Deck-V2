import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/custom%20widgets/appbar/learn_mode_bar.dart';
import 'package:deck/pages/misc/custom%20widgets/dialogs/confirmation_dialog.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/widget_method.dart';
// import 'package:google_fonts/google_fonts.dart';
import '../../backend/models/deck.dart';
import '../misc/custom widgets/appbar/auth_bar.dart';
import '../misc/custom widgets/buttons/custom_buttons.dart';

class PlayMyDeckPage extends StatefulWidget {
  final List cards;
  final Deck deck;
  final String orientation;

  const PlayMyDeckPage({
    Key? key,
    required this.cards,
    required this.deck,
    required this.orientation
  }) : super(key: key);

  @override
  _PlayMyDeckPageState createState() => _PlayMyDeckPageState();
}

class _PlayMyDeckPageState extends State<PlayMyDeckPage> {
  final PageController pageController = PageController();
  final ScrollController controller = ScrollController();
  int currentIndex = 0;

  @override
  void dispose() {
    pageController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DeckColors.backgroundColor,
      appBar: LearnModeBar(
        title: 'Study Mode',
        color: DeckColors.primaryColor,
        fontSize: 24,
        onButtonPressed: () {
          showConfirmDialog(
            context,
            'assets/images/Deck-Dialogue4.png',
            'Stop Study Mode?',
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
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 30.0, left: 15.0, right: 15.0),
              child: Text(
                widget.deck.title.toString(),
                overflow: TextOverflow.visible,
                style: const TextStyle(
                  fontFamily: 'Fraiche',
                  color: DeckColors.primaryColor,
                  fontSize: 40,
                  height: 1.1
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: widget.cards.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: FlipCard(
                      front: buildFlipCard(
                          (widget.orientation == "Term") ? widget.cards[index].term : widget.cards[index].definition,
                          DeckColors.primaryColor, 'Fraiche',
                          (widget.orientation == "Term") ? "Tap to see definition" : "Tap to see term"),
                      back: buildFlipCard(
                          (widget.orientation == "Term") ? widget.cards[index].definition : widget.cards[index].term,
                          DeckColors.primaryColor, 'Nunito',
                          (widget.orientation == "Term") ? "Tap to see term" : "Tap to see definition"),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 20.0, top: 10.0, left: 15.0, right: 15.0),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                    color: DeckColors.accentColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: DeckColors.primaryColor,
                      width: 2,
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        color: DeckColors.primaryColor,
                        onPressed: () {
                          if (currentIndex > 0) {
                            pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          }
                        },
                      ),
                      Text(
                        '${currentIndex + 1} / ${widget.cards.length}',
                        style: const TextStyle(
                          fontFamily: 'Fraiche',
                          color: DeckColors.primaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios_rounded),
                        color: DeckColors.primaryColor,
                        onPressed: () {
                          if (currentIndex < widget.cards.length - 1) {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
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
    );
  }

  Widget buildFlipCard(String content, Color textColor, String fontFamily, String description) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: DeckColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: DeckColors.primaryColor,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Theme(
          data: ThemeData(
            highlightColor: DeckColors.primaryColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
             //CONTENT OF THE FLASHCARD
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Text(
                        content,
                        style: fontFamily == 'Fraiche'
                            ? TextStyle(
                          fontFamily: 'Fraiche',
                          color: textColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        )
                            : TextStyle(
                          fontFamily: 'Nunito-Bold',
                          color: textColor,
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),

              /// BOTTOM DIVIDER OF THE FLASHCARD
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 8.0, left: 5, right: 5),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 2,
                  color: DeckColors.primaryColor,
                ),
              ),
              // Description text
              Text(
                description,
                style: const TextStyle(
                  fontFamily: 'Nunito-Regular',
                  color: DeckColors.primaryColor,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
