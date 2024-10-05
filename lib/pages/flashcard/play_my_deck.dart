import 'package:deck/pages/misc/colors.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../backend/models/deck.dart';

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
    return Scaffold(
      appBar: const DeckBar(
        title: 'play my deck',
        color: DeckColors.white,
        fontSize: 24,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Text(
                widget.deck.title.toString(),
                style: GoogleFonts.nunito(
                  color: DeckColors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
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
                      front: buildFlipCard(widget.cards[index].question, DeckColors.white),
                      back: buildFlipCard(widget.cards[index].answer, DeckColors.primaryColor),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0, top: 40.0, left: 25.0, right: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: DeckColors.accentColor,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        color: DeckColors.white,
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
                        style: GoogleFonts.nunito(
                          color: DeckColors.primaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios_rounded),
                        color: Colors.white,
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
    );
  }

  Widget buildFlipCard(String content, Color textColor) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: DeckColors.accentColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Theme(
          data: ThemeData(
            highlightColor: DeckColors.primaryColor,
          ),
          child: Scrollbar(
            controller: controller,
            thickness: 5.0,
            radius: const Radius.circular(10.0),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Text(
                  content,
                  style: GoogleFonts.nunito(
                    color: textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
