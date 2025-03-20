import 'package:deck/backend/auth/auth_service.dart';
import 'package:deck/backend/flashcard/flashcard_service.dart';
import 'package:deck/backend/flashcard/flashcard_utils.dart';
import 'package:deck/backend/models/card.dart';
import 'package:deck/pages/flashcard/add_flashcard.dart';
import 'package:deck/pages/flashcard/edit_flashcard.dart';
import 'package:deck/pages/flashcard/play_my_deck.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/widget_method.dart';
// import 'package:google_fonts/google_fonts.dart';

import '../../backend/models/deck.dart';
import '../misc/custom widgets/appbar/auth_bar.dart';
import '../misc/custom widgets/buttons/custom_buttons.dart';
import '../misc/custom widgets/buttons/floating_action_button.dart';
import '../misc/custom widgets/dialogs/confirmation_dialog.dart';
import '../misc/custom widgets/dialogs/learn_mode_dialog.dart';
import '../misc/custom widgets/functions/if_collection_empty.dart';
import '../misc/custom widgets/functions/tab_bar.dart';
import '../misc/custom widgets/images/cover_image.dart';
import '../misc/custom widgets/textboxes/textboxes.dart';
import '../misc/custom widgets/tiles/container_of_flashcard.dart';

class ViewDeckPage extends StatefulWidget {
  final Deck deck;
  const ViewDeckPage({super.key, required this.deck});

  @override
  _ViewDeckPageState createState() => _ViewDeckPageState();
}

class _ViewDeckPageState extends State<ViewDeckPage> {
  String coverPhoto = "no_photo";
  String username = '';
  String description = '';
  List<Cards> _cardsCollection = [];
  List<Cards> _starredCardCollection = [];
  List<Cards> _filteredCardsCollection = [];
  List<Cards> _filteredStarredCardCollection = [];
  int numberOfCards = 0;
  final TextEditingController _searchController = TextEditingController();
  User? currentUser;

  @override
  void initState() {
    super.initState();
    _initDeckCards();
    _searchController.addListener(_filterFlashcards);
    _getCurrentUser();
  }

  void _initDeckCards() async {
    List<Cards> cards = await widget.deck.getCard();
    List<Cards> starredCards = [];
    for (var card in cards) {
      if (card.isStarred) {
        starredCards.add(card);
      }
    }
    setState(() {
      _cardsCollection = cards;
      FlashcardUtils().sortByQuestion(_cardsCollection);
      _starredCardCollection = starredCards;
      FlashcardUtils().sortByQuestion(_starredCardCollection);
      _filteredCardsCollection = List.from(cards);
      FlashcardUtils().sortByQuestion(_filteredCardsCollection);
      _filteredStarredCardCollection = List.from(starredCards);
      FlashcardUtils().sortByQuestion(_filteredStarredCardCollection);

      // Update numberOfCards
      numberOfCards = _cardsCollection.length;
    });
  }

  void _filterFlashcards() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCardsCollection = _cardsCollection
          .where((card) =>
              card.question.toLowerCase().contains(query) ||
              card.answer.toLowerCase().contains(query))
          .toList();

      _filteredStarredCardCollection = _starredCardCollection
          .where((card) =>
              card.question.toLowerCase().contains(query) ||
              card.answer.toLowerCase().contains(query))
          .toList();
      FlashcardUtils().sortByQuestion(_filteredCardsCollection);
      FlashcardUtils().sortByQuestion(_filteredStarredCardCollection);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  ///Retrieve the currently signed-in user from Firebase Authentication
  void _getCurrentUser() {
    setState(() {
      currentUser = FirebaseAuth.instance.currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    double topPadding =
        (_cardsCollection.isNotEmpty || _starredCardCollection.isNotEmpty)
            ? 20.0
            : 40.0;

    return SafeArea(
      child: Scaffold(
        backgroundColor: DeckColors.backgroundColor,
        appBar: const AuthBar(
          automaticallyImplyLeading: true,
          title: 'View Deck',
          color: DeckColors.primaryColor,
          fontSize: 24,
        ),
        /*floatingActionButton: DeckFAB(
          text: "Add FlashCard",
          fontSize: 12,
          icon: Icons.add,
          foregroundColor: DeckColors.primaryColor,
          backgroundColor: DeckColors.gray,
          onPressed: () async {
            final newCard = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddFlashcardPage(
                        deck: widget.deck,
                      )),
            );
            if (newCard != null) {
              setState(() {
                _cardsCollection.add(newCard);
                if (newCard.isStarred) {
                  _starredCardCollection.add(newCard);
                }
                _filterFlashcards();
                numberOfCards = _cardsCollection.length;
              });
            }
          },
        ),*/
        body: SingleChildScrollView(
          //padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    child: BuildCoverImage(
                      // Conditionally pass CoverPhotofile based on coverPhoto value
                      imageUrl: widget.deck.coverPhoto ?? "no_image",
                      borderRadiusContainer: 0,
                      borderRadiusImage: 0,
                      isHeader: true,
                    ),
                  ),
                  /*Container(
                    height: 150,
                    width: double.infinity,
                    child: const Image(
                      image: AssetImage('assets/images/Deck-Branding1.png'),
                      fit: BoxFit.cover,
                    ),
                  ),*/
                  //For fading effect on the bottom, refer at figma if confused
                  Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        DeckColors.backgroundColor.withOpacity(0.3),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.85, 1.0],
                    )),
                  )
                ],
              ),
              /*Text(
                  widget.deck.title.toString(),
                  overflow: TextOverflow.visible,
                  style: const TextStyle(
                    fontFamily: 'Fraiche',
                    color: DeckColors.primaryColor,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),*/
              Padding(
                padding: const EdgeInsets.only(
                    top: 15, left: 20, right: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///Start of deck title, made by who and description
                    Text(
                      widget.deck.title.toString(),
                      overflow: TextOverflow.visible,
                      style: const TextStyle(
                        fontFamily: 'Fraiche',
                        color: DeckColors.primaryColor,
                        fontSize: 32,
                      ),
                    ),
                    Text(
                      'By: $username',
                      overflow: TextOverflow.visible,
                      style: const TextStyle(
                        fontFamily: 'Nunito-Bold',
                        color: DeckColors.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '$description',
                      overflow: TextOverflow.visible,
                      style: const TextStyle(
                        fontFamily: 'Nunito-Regular',
                        color: DeckColors.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    ///-------E N D ----------
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Text(
                            '$numberOfCards cards',
                            overflow: TextOverflow.visible,
                            style: const TextStyle(
                              fontFamily: 'Nunito-Regular',
                              fontSize: 16,
                              color: DeckColors.primaryColor,
                            ),
                          ),
                          Spacer(),
                          ///this is used sana to check if the currently signed-in user's UID matches the deck owner's UID
                          //if (currentUser?.uid == widget.deck.ownerUid)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: BuildButton(
                                onPressed: () async {
                                  final newCard = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddFlashcardPage(
                                              deck: widget.deck,
                                            )),
                                  );
                                  if (newCard != null) {
                                    setState(() {
                                      _cardsCollection.add(newCard);
                                      if (newCard.isStarred) {
                                        _starredCardCollection.add(newCard);
                                      }
                                      _filterFlashcards();
                                      numberOfCards = _cardsCollection.length;
                                    });
                                  }
                                },
                                buttonText: 'Add',
                                icon: Icons.add,
                                paddingIconText: 3,
                                iconColor: DeckColors.primaryColor,
                                height: 35,
                                width: 110,
                                radius: 20,
                                backgroundColor: DeckColors.deckYellow,
                                textColor: DeckColors.primaryColor,
                                fontSize: 16,
                                borderWidth: 1,
                                borderColor: DeckColors.primaryColor),
                          ),
                          BuildButton(
                            onPressed: (){
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) => const LearnModeDialog(
                                ),
                              );
                            },
                            /*onPressed: () async {
                              var cards = await widget.deck.getCard();
                              var starredCards = [];
                              var noStarCard = [];
                              var joinedCards = [];

                              for (int i = 0; i < cards.length; i++) {
                                if (cards[i].isStarred) {
                                  starredCards.add(cards[i]);
                                } else {
                                  noStarCard.add(cards[i]);
                                }
                              }

                              FlashcardUtils _flashcardUtils = FlashcardUtils();

                              // Shuffle cards
                              if (starredCards.isNotEmpty)
                                _flashcardUtils.shuffleList(starredCards);
                              if (noStarCard.isNotEmpty)
                                _flashcardUtils.shuffleList(noStarCard);

                              joinedCards = starredCards + noStarCard;

                              if (joinedCards.isNotEmpty) {
                                AuthService _authService = AuthService();
                                User? user = _authService.getCurrentUser();
                                if (user != null) {
                                  try {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PlayMyDeckPage(
                                            cards: joinedCards,
                                            deck: widget.deck,
                                          )),
                                    );

                                    FlashcardService _flashCardService =
                                    FlashcardService();
                                    await _flashCardService.addDeckLogRecord(
                                        deckId: widget.deck.deckId.toString(),
                                        title: widget.deck.title.toString(),
                                        userId: user.uid.toString(),
                                        visitedAt: DateTime.now());
                                    FlashcardUtils.updateLatestReview.value = true;
                                  } catch (e) {
                                    print('View Deck Error: $e');

                                    ///display error
                                    showInformationDialog(
                                        context,
                                        "Error viewing deck",
                                        "A problem occured while trying to view deck. Please try again.");
                                  }
                                }
                              } else {
                                ///display error
                                showInformationDialog(context, "Error viewing deck",
                                    "The deck has no card please add a card first before playing.");
                              }
                            },*/
                            buttonText: 'Learn',
                            height: 35,
                            width: 110,
                            radius: 20,
                            backgroundColor: DeckColors.primaryColor,
                            textColor: DeckColors.white,
                            fontSize: 16,
                            borderWidth: 1,
                            borderColor: DeckColors.primaryColor,
                            icon: Icons.play_arrow_rounded,
                            paddingIconText: 3,
                            iconColor: DeckColors.white,
                          ),
                        ],
                      ),
                    ),
                    if (_cardsCollection.isNotEmpty ||
                        _starredCardCollection.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: BuildTextBox(
                          controller: _searchController,
                          hintText: 'Search Flashcard',
                          showPassword: false,
                          rightIcon: Icons.search,
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(top: topPadding),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .6,
                        child: BuildTabBar(
                          titles: ['All', 'Starred'],
                          length: 2,
                          tabContent: [
                            ///
                            ///
                            /// ------------------------- START OF TAB 'ALL' CONTENT ----------------------------

                            if (_cardsCollection.isEmpty)
                              IfCollectionEmpty(
                                ifCollectionEmptyText:
                                    'No Flashcard(s) Available',
                                ifCollectionEmptyHeight:
                                    MediaQuery.of(context).size.height * 0.3,
                              )
                            else if (_cardsCollection.isNotEmpty &&
                                _filteredCardsCollection.isEmpty)
                              IfCollectionEmpty(
                                ifCollectionEmptyText: 'No Results Found',
                                ifCollectionEmptySubText:
                                    'Try adjusting your search to \nfind what your looking for.',
                                ifCollectionEmptyHeight:
                                    MediaQuery.of(context).size.height * 0.4,
                              )
                            else
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          _filteredCardsCollection.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6.0),
                                          child: BuildContainerOfFlashCards(
                                            titleOfFlashCard:
                                                _filteredCardsCollection[index]
                                                    .question,
                                            contentOfFlashCard:
                                                _filteredCardsCollection[index]
                                                    .answer,
                                            onDelete: () {
                                              /*Cards removedCard =
                                                  _filteredCardsCollection[
                                                      index];
                                              final String deletedTitle =
                                                  removedCard.question;
                                              setState(() {
                                                _filteredCardsCollection
                                                    .removeAt(index);
                                                _cardsCollection.removeWhere(
                                                    (card) =>
                                                        card.cardId ==
                                                        removedCard.cardId);
                                                _filteredStarredCardCollection
                                                    .removeWhere((card) =>
                                                        card.cardId ==
                                                        removedCard.cardId);
                                                _starredCardCollection
                                                    .removeWhere((card) =>
                                                        card.cardId ==
                                                        removedCard.cardId);
                                                numberOfCards =
                                                    _cardsCollection.length;
                                              });
                                              showConfirmationDialog(
                                                context,
                                                "Delete Item",
                                                "Are you sure you want to delete '$deletedTitle'?",
                                                () async {
                                                  try {
                                                    await removedCard
                                                        .updateDeleteStatus(
                                                            true,
                                                            widget.deck.deckId);
                                                  } catch (e) {
                                                    print(
                                                        'View Deck Error: $e');
                                                    showInformationDialog(
                                                        context,
                                                        'Card Deletion Unsuccessful',
                                                        'An error occurred during the deletion process please try again');
                                                    setState(() {
                                                      _cardsCollection
                                                          .add(removedCard);
                                                      FlashcardUtils()
                                                          .sortByQuestion(
                                                              _cardsCollection);
                                                      _filteredCardsCollection
                                                          .add(removedCard);
                                                      FlashcardUtils()
                                                          .sortByQuestion(
                                                              _filteredCardsCollection);
                                                      if (removedCard
                                                          .isStarred) {
                                                        _filteredStarredCardCollection
                                                            .add(removedCard);
                                                        FlashcardUtils()
                                                            .sortByQuestion(
                                                                _filteredStarredCardCollection);
                                                        _starredCardCollection
                                                            .add(removedCard);
                                                        FlashcardUtils()
                                                            .sortByQuestion(
                                                                _starredCardCollection);
                                                      }
                                                      numberOfCards =
                                                          _cardsCollection
                                                              .length;
                                                    });
                                                  }
                                                },
                                                () {
                                                  setState(() {
                                                    _cardsCollection
                                                        .add(removedCard);
                                                    FlashcardUtils()
                                                        .sortByQuestion(
                                                            _cardsCollection);
                                                    _filteredCardsCollection
                                                        .add(removedCard);
                                                    FlashcardUtils().sortByQuestion(
                                                        _filteredCardsCollection);
                                                    if (removedCard.isStarred) {
                                                      _filteredStarredCardCollection
                                                          .add(removedCard);
                                                      FlashcardUtils()
                                                          .sortByQuestion(
                                                              _filteredStarredCardCollection);
                                                      _starredCardCollection
                                                          .add(removedCard);
                                                      FlashcardUtils()
                                                          .sortByQuestion(
                                                              _starredCardCollection);
                                                    }
                                                    numberOfCards =
                                                        _cardsCollection.length;
                                                  });
                                                },
                                              );*/
                                            },
                                            enableSwipeToRetrieve: false,
                                            onTap: () {
                                              print("Clicked");
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditFlashcardPage(
                                                          deck: widget.deck,
                                                          card:
                                                              _filteredCardsCollection[
                                                                  index],
                                                        )),
                                              );
                                            },
                                            isStarShaded:
                                                _filteredCardsCollection[index]
                                                    .isStarred,
                                            onStarShaded: () {
                                              setState(() {
                                                try {
                                                  _filteredCardsCollection[
                                                          index]
                                                      .updateStarredStatus(true,
                                                          widget.deck.deckId);
                                                  _starredCardCollection.add(
                                                      _filteredCardsCollection[
                                                          index]);
                                                  _filteredStarredCardCollection
                                                      .add(
                                                          _filteredCardsCollection[
                                                              index]);
                                                  _filteredCardsCollection[
                                                          index]
                                                      .isStarred = true;
                                                } catch (e) {
                                                  print(
                                                      'star shaded error: $e');
                                                }
                                              });
                                            },
                                            onStarUnshaded: () {
                                              setState(() {
                                                try {
                                                  _filteredCardsCollection[
                                                          index]
                                                      .updateStarredStatus(
                                                          false,
                                                          widget.deck.deckId);
                                                  _starredCardCollection
                                                      .removeWhere((card) =>
                                                          card.cardId ==
                                                          _filteredCardsCollection[
                                                                  index]
                                                              .cardId);
                                                  _filteredStarredCardCollection
                                                      .removeWhere((card) =>
                                                          card.cardId ==
                                                          _filteredCardsCollection[
                                                                  index]
                                                              .cardId);
                                                  _filteredCardsCollection[
                                                          index]
                                                      .isStarred = false;
                                                } catch (e) {
                                                  print(
                                                      'star unshaded error: $e');
                                                }
                                              });
                                            },
                                            trashOnPressed: () {
                                              print("Recognized");
                                              Cards removedCard =
                                              _filteredCardsCollection[
                                              index];
                                              final String deletedTitle =
                                                  removedCard.question;
                                              setState(() {
                                                _filteredCardsCollection
                                                    .removeAt(index);
                                                _cardsCollection.removeWhere(
                                                        (card) =>
                                                    card.cardId ==
                                                        removedCard.cardId);
                                                _filteredStarredCardCollection
                                                    .removeWhere((card) =>
                                                card.cardId ==
                                                    removedCard.cardId);
                                                _starredCardCollection
                                                    .removeWhere((card) =>
                                                card.cardId ==
                                                    removedCard.cardId);
                                                numberOfCards =
                                                    _cardsCollection.length;
                                              });
                                              showConfirmationDialog(
                                                context,
                                                "Delete Item",
                                                "Are you sure you want to delete '$deletedTitle'?",
                                                    () async {
                                                  try {
                                                    await removedCard
                                                        .updateDeleteStatus(
                                                        true,
                                                        widget.deck.deckId);
                                                  } catch (e) {
                                                    print(
                                                        'View Deck Error: $e');
                                                    showInformationDialog(
                                                        context,
                                                        'Card Deletion Unsuccessful',
                                                        'An error occurred during the deletion process please try again');
                                                    setState(() {
                                                      _cardsCollection
                                                          .add(removedCard);
                                                      FlashcardUtils()
                                                          .sortByQuestion(
                                                          _cardsCollection);
                                                      _filteredCardsCollection
                                                          .add(removedCard);
                                                      FlashcardUtils()
                                                          .sortByQuestion(
                                                          _filteredCardsCollection);
                                                      if (removedCard
                                                          .isStarred) {
                                                        _filteredStarredCardCollection
                                                            .add(removedCard);
                                                        FlashcardUtils()
                                                            .sortByQuestion(
                                                            _filteredStarredCardCollection);
                                                        _starredCardCollection
                                                            .add(removedCard);
                                                        FlashcardUtils()
                                                            .sortByQuestion(
                                                            _starredCardCollection);
                                                      }
                                                      numberOfCards =
                                                          _cardsCollection
                                                              .length;
                                                    });
                                                  }
                                                },
                                                    () {
                                                  setState(() {
                                                    _cardsCollection
                                                        .add(removedCard);
                                                    FlashcardUtils()
                                                        .sortByQuestion(
                                                        _cardsCollection);
                                                    _filteredCardsCollection
                                                        .add(removedCard);
                                                    FlashcardUtils().sortByQuestion(
                                                        _filteredCardsCollection);
                                                    if (removedCard.isStarred) {
                                                      _filteredStarredCardCollection
                                                          .add(removedCard);
                                                      FlashcardUtils()
                                                          .sortByQuestion(
                                                          _filteredStarredCardCollection);
                                                      _starredCardCollection
                                                          .add(removedCard);
                                                      FlashcardUtils()
                                                          .sortByQuestion(
                                                          _starredCardCollection);
                                                    }
                                                    numberOfCards =
                                                        _cardsCollection.length;
                                                  });
                                                },
                                              );

                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),

                            ///
                            ///
                            /// ------------------------- END OF TAB 'ALL' CONTENT ----------------------------

                            ///
                            ///
                            /// ------------------------- START OF TAB 'STARRED' CONTENT ----------------------------
                            if (_starredCardCollection.isEmpty)
                              IfCollectionEmpty(
                                ifCollectionEmptyText:
                                    'No Starred Flashcard(s) Available',
                                ifCollectionEmptyHeight:
                                    MediaQuery.of(context).size.height * 0.3,
                              )
                            else if (_starredCardCollection.isNotEmpty &&
                                _filteredStarredCardCollection.isEmpty)
                              IfCollectionEmpty(
                                ifCollectionEmptyText: 'No Results Found',
                                ifCollectionEmptySubText:
                                    'Try adjusting your search to \nfind what your looking for.',
                                ifCollectionEmptyHeight:
                                    MediaQuery.of(context).size.height * 0.4,
                              )
                            else
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          _filteredStarredCardCollection.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6.0),
                                          child: BuildContainerOfFlashCards(
                                            titleOfFlashCard:
                                                _filteredStarredCardCollection[
                                                        index]
                                                    .question,
                                            contentOfFlashCard:
                                                _filteredStarredCardCollection[
                                                        index]
                                                    .answer,
                                            onDelete: () {
                                              /*Cards removedCard =
                                                  _filteredStarredCardCollection[
                                                      index];
                                              final String starredDeletedTitle =
                                                  removedCard.question;
                                              setState(() {
                                                _cardsCollection.removeWhere(
                                                    (card) =>
                                                        card.cardId ==
                                                        removedCard.cardId);
                                                _filteredCardsCollection
                                                    .removeWhere((card) =>
                                                        card.cardId ==
                                                        removedCard.cardId);
                                                _filteredStarredCardCollection
                                                    .removeAt(index);
                                                _starredCardCollection
                                                    .removeWhere((card) =>
                                                        card.cardId ==
                                                        removedCard.cardId);
                                                numberOfCards =
                                                    _cardsCollection.length;
                                              });
                                              showConfirmationDialog(
                                                context,
                                                "Delete Item",
                                                "Are you sure you want to delete '$starredDeletedTitle'?",
                                                () async {
                                                  try {
                                                    await removedCard
                                                        .updateDeleteStatus(
                                                            true,
                                                            widget.deck.deckId);
                                                  } catch (e) {
                                                    print(
                                                        'View Deck Error: $e');
                                                    showInformationDialog(
                                                        context,
                                                        'Card Deletion Unsuccessful',
                                                        'An error occurred during the deletion process please try again');
                                                    setState(() {
                                                      _cardsCollection
                                                          .add(removedCard);
                                                      FlashcardUtils()
                                                          .sortByQuestion(
                                                              _cardsCollection);
                                                      _filteredCardsCollection
                                                          .add(removedCard);
                                                      FlashcardUtils()
                                                          .sortByQuestion(
                                                              _filteredCardsCollection);
                                                      _filteredStarredCardCollection
                                                          .add(removedCard);
                                                      FlashcardUtils()
                                                          .sortByQuestion(
                                                              _filteredStarredCardCollection);
                                                      _starredCardCollection
                                                          .add(removedCard);
                                                      FlashcardUtils()
                                                          .sortByQuestion(
                                                              _starredCardCollection);
                                                      numberOfCards =
                                                          _cardsCollection
                                                              .length;
                                                    });
                                                  }
                                                },
                                                () {
                                                  setState(() {
                                                    _cardsCollection
                                                        .add(removedCard);
                                                    FlashcardUtils()
                                                        .sortByQuestion(
                                                            _cardsCollection);
                                                    _filteredCardsCollection
                                                        .add(removedCard);
                                                    FlashcardUtils().sortByQuestion(
                                                        _filteredCardsCollection);
                                                    _filteredStarredCardCollection
                                                        .add(removedCard);
                                                    FlashcardUtils().sortByQuestion(
                                                        _filteredStarredCardCollection);
                                                    _starredCardCollection
                                                        .add(removedCard);
                                                    FlashcardUtils().sortByQuestion(
                                                        _starredCardCollection);
                                                    numberOfCards =
                                                        _cardsCollection.length;
                                                  });
                                                },
                                              );*/
                                            },
                                            enableSwipeToRetrieve: false,
                                            onTap: () {
                                              print("Clicked");
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditFlashcardPage(
                                                          deck: widget.deck,
                                                          card:
                                                              _filteredStarredCardCollection[
                                                                  index],
                                                        )),
                                              );
                                            },
                                            isStarShaded: true,
                                            onStarShaded: () {
                                              // No action because it's always shaded here
                                            },
                                            onStarUnshaded: () {
                                              setState(() {
                                                try {
                                                  _filteredStarredCardCollection[
                                                          index]
                                                      .updateStarredStatus(
                                                          false,
                                                          widget.deck.deckId);
                                                  _filteredStarredCardCollection[
                                                          index]
                                                      .isStarred = false;
                                                  _starredCardCollection
                                                      .removeWhere((card) =>
                                                          card.cardId ==
                                                          _filteredStarredCardCollection[
                                                                  index]
                                                              .cardId);
                                                  _filteredStarredCardCollection
                                                      .removeWhere((card) =>
                                                          card.cardId ==
                                                          _filteredStarredCardCollection[
                                                                  index]
                                                              .cardId);
                                                } catch (e) {
                                                  print(
                                                      'star unshaded error: $e');
                                                }
                                              });
                                            },
                                            trashOnPressed: () {
                                              Cards removedCard =
                                              _filteredStarredCardCollection[
                                              index];
                                              final String starredDeletedTitle =
                                                  removedCard.question;
                                              setState(() {
                                                _cardsCollection.removeWhere(
                                                        (card) =>
                                                    card.cardId ==
                                                        removedCard.cardId);
                                                _filteredCardsCollection
                                                    .removeWhere((card) =>
                                                card.cardId ==
                                                    removedCard.cardId);
                                                _filteredStarredCardCollection
                                                    .removeAt(index);
                                                _starredCardCollection
                                                    .removeWhere((card) =>
                                                card.cardId ==
                                                    removedCard.cardId);
                                                numberOfCards =
                                                    _cardsCollection.length;
                                              });
                                              showConfirmationDialog(
                                                context,
                                                "Delete Item",
                                                "Are you sure you want to delete '$starredDeletedTitle'?",
                                                    () async {
                                                  try {
                                                    await removedCard
                                                        .updateDeleteStatus(
                                                        true,
                                                        widget.deck.deckId);
                                                  } catch (e) {
                                                    print(
                                                        'View Deck Error: $e');
                                                    showInformationDialog(
                                                        context,
                                                        'Card Deletion Unsuccessful',
                                                        'An error occurred during the deletion process please try again');
                                                    setState(() {
                                                      _cardsCollection
                                                          .add(removedCard);
                                                      FlashcardUtils()
                                                          .sortByQuestion(
                                                          _cardsCollection);
                                                      _filteredCardsCollection
                                                          .add(removedCard);
                                                      FlashcardUtils()
                                                          .sortByQuestion(
                                                          _filteredCardsCollection);
                                                      _filteredStarredCardCollection
                                                          .add(removedCard);
                                                      FlashcardUtils()
                                                          .sortByQuestion(
                                                          _filteredStarredCardCollection);
                                                      _starredCardCollection
                                                          .add(removedCard);
                                                      FlashcardUtils()
                                                          .sortByQuestion(
                                                          _starredCardCollection);
                                                      numberOfCards =
                                                          _cardsCollection
                                                              .length;
                                                    });
                                                  }
                                                },
                                                    () {
                                                  setState(() {
                                                    _cardsCollection
                                                        .add(removedCard);
                                                    FlashcardUtils()
                                                        .sortByQuestion(
                                                        _cardsCollection);
                                                    _filteredCardsCollection
                                                        .add(removedCard);
                                                    FlashcardUtils().sortByQuestion(
                                                        _filteredCardsCollection);
                                                    _filteredStarredCardCollection
                                                        .add(removedCard);
                                                    FlashcardUtils().sortByQuestion(
                                                        _filteredStarredCardCollection);
                                                    _starredCardCollection
                                                        .add(removedCard);
                                                    FlashcardUtils().sortByQuestion(
                                                        _starredCardCollection);
                                                    numberOfCards =
                                                        _cardsCollection.length;
                                                  });
                                                },
                                              );
                                          },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),

        ///
        ///
        /// ------------------------- END OF TAB 'STARRED' CONTENT ----------------------------
      ),
    );
  }
}
