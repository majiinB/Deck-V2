import 'package:deck/pages/misc/colors.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/widget_method.dart';
// import 'package:google_fonts/google_fonts.dart';
import '../../backend/models/deck.dart';
import '../misc/custom widgets/buttons/custom_buttons.dart';

class PlayMyDeckPage extends StatefulWidget {
  final List cards;
  final Deck deck;

  const PlayMyDeckPage({Key? key, required this.cards, required this.deck}) : super(key: key);

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
    return SafeArea(
      child: Scaffold(
        /*appBar: const DeckBar(
          title: 'play my deck',
          color: DeckColors.white,
          fontSize: 24,
        ),*/
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: BuildButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  buttonText: 'Stop Playing',
                  height: 35,
                  width: 170,
                  radius: 20,
                  backgroundColor: DeckColors.deckRed,
                  textColor: DeckColors.white,
                  fontSize: 16,
                  borderWidth: 1,
                  borderColor: DeckColors.accentColor,
                  icon: Icons.play_arrow_rounded,
                  paddingIconText: 3,
                  iconColor: DeckColors.white,),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 30.0),
                child: Text(
                  widget.deck.title.toString(),
                  overflow: TextOverflow.visible,
                  style: const TextStyle(
                    fontFamily: 'Fraiche',
                    color: DeckColors.primaryColor,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
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
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FlipCard(
                        front: buildFlipCard(widget.cards[index].question,
                            DeckColors.primaryColor, 'Fraiche',
                            "Tap to see answer"),
                        back: buildFlipCard(widget.cards[index].answer,
                            DeckColors.white, 'Nunito',
                            "Tap to see description"),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 40.0, top: 20.0, left: 25.0, right: 25.0),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      color: DeckColors.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: DeckColors.accentColor,
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
                          color: DeckColors.accentColor,
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
                            color: DeckColors.accentColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios_rounded),
                          color: DeckColors.accentColor,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFlipCard(String content, Color textColor, String fontFamily, String description) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: DeckColors.accentColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: DeckColors.white,
          width: 1,
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

              // BOTTOM DIVIDER OF THE FLASHCARD
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 8.0, left: 5, right: 5),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 2,
                  color: DeckColors.white,
                ),
              ),
              // Description text
              Text(
                description,
                style: const TextStyle(
                  fontFamily: 'Nunito-Regular',
                  color: DeckColors.white,
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
