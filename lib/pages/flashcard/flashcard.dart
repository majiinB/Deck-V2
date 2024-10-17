import 'dart:ffi';

import 'package:deck/backend/auth/auth_service.dart';
import 'package:deck/backend/flashcard/flashcard_service.dart';
import 'package:deck/backend/models/deck.dart';
import 'package:deck/pages/flashcard/add_deck.dart';
import 'package:deck/pages/flashcard/view_deck.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../backend/flashcard/flashcard_utils.dart';

class FlashcardPage extends StatefulWidget {
  const FlashcardPage({super.key});

  @override
  _FlashcardPageState createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  final AuthService _authService = AuthService();
  final FlashcardService _flashcardService = FlashcardService();
  Deck? _latestDeck;
  List<Deck> _decks = [];
  List<Deck> _filteredDecks = [];
  late User? _user;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _user = _authService.getCurrentUser();
    FlashcardUtils.updateLatestReview.addListener(_updateLatestReview);
    _initUserDecks(_user);
    _searchController.addListener(_onSearchChanged);
  }

  void _initUserDecks(User? user) async {
    if (user != null) {
      String userId = user.uid;
      List<Deck> decks = await _flashcardService
          .getDecksByUserId(userId); // Call method to fetch decks
      Deck? latest = await _flashcardService.getLatestDeckLog(userId);
      if (!mounted) return;
      setState(() {
        _decks = decks; // Update state with fetched decks
        _filteredDecks = decks; // Initialize filtered decks
        _latestDeck = latest;
      });
    }
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filteredDecks = _decks
          .where((deck) =>
              deck.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    });
  }

  void _updateLatestReview() async {
    if (FlashcardUtils.updateLatestReview.value) {
      Deck? latest = await _flashcardService.getLatestDeckLog(_user!.uid);
      if (!mounted) return;
      setState(() {
        _latestDeck = latest;
      });
      _initUserDecks(_user); // This already has its own setState
      FlashcardUtils.updateLatestReview.value = false; // Reset the notifier
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: DeckFAB(
          text: "Add Deck",
          fontSize: 12,
          icon: Icons.add,
          foregroundColor: DeckColors.primaryColor,
          backgroundColor: DeckColors.gray,
          onPressed: () async {
            if (_user != null) {
              try {
                String userId = _user!.uid.toString();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddDeckPage(decks: _decks, userId: userId)),
                );
                _onSearchChanged();
              } catch (e) {
                print('error in navigating add deck $e');
              }
            }
          },
        ),
      ),
      appBar: const DeckBar(
        title: 'flash card',
        color: DeckColors.white,
        fontSize: 24,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_latestDeck != null)
              Text(
                'Latest Review',
                style: GoogleFonts.nunito(
                  color: DeckColors.primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            if (_latestDeck != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: DeckColors.gray),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _latestDeck!.title.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                          color: DeckColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: BuildButton(
                          onPressed: () {
                            print("Continue Learning Button Clicked");
                            Navigator.of(context).push(
                              RouteGenerator.createRoute(
                                  ViewDeckPage(deck: _latestDeck!)),
                            );
                          },
                          buttonText: 'Continue Learning',
                          height: 35,
                          width: 180,
                          radius: 20,
                          backgroundColor: DeckColors.primaryColor,
                          textColor: DeckColors.white,
                          fontSize: 16,
                          borderWidth: 0,
                          borderColor: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_decks.isEmpty)
              IfCollectionEmpty(
                  ifCollectionEmptyText: 'No Deck(s) Available',
                  ifCollectionEmptyHeight:
                      MediaQuery.of(context).size.height * 0.7),
            if (_decks.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  'My Decks',
                  style: GoogleFonts.nunito(
                    color: DeckColors.primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ),
            if (_decks.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: BuildTextBox(
                  controller: _searchController,
                  hintText: 'Search Decks',
                  showPassword: false,
                  rightIcon: Icons.search,
                ),
              ),
            if (_decks.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredDecks.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: BuildDeckContainer(
                        deckCoverPhotoUrl: _filteredDecks[index].coverPhoto,
                        titleOfDeck: _filteredDecks[index].title,
                        onDelete: () {
                          Deck removedDeck = _filteredDecks[index];
                          final String deletedTitle =
                              removedDeck.title.toString();
                          setState(() {
                            _filteredDecks.removeAt(index);
                            _decks.removeWhere(
                                (card) => card.deckId == removedDeck.deckId);
                          });
                          showConfirmationDialog(
                            context,
                            "Delete Item",
                            "Are you sure you want to delete '$deletedTitle'?",
                            () async {
                              try {
                                if (await removedDeck
                                    .updateDeleteStatus(true)) {
                                  if (_latestDeck != null) {
                                    if (_latestDeck?.deckId ==
                                        removedDeck.deckId) {
                                      Deck? latest = await _flashcardService
                                          .getLatestDeckLog(_user!.uid);
                                      setState(() {
                                        _latestDeck = latest;
                                      });
                                    }
                                  }
                                }
                              } catch (e) {
                                print('Flash Card Page Deletion Error: $e');
                                setState(() {
                                  _decks.insert(index, removedDeck);
                                });
                              }
                            },
                            () {
                              setState(() {
                                _decks.insert(index, removedDeck);
                              });
                            },
                          );
                        },
                        enableSwipeToRetrieve: false,
                        onTap: () {
                          print("Clicked");
                          Navigator.of(context).push(
                            RouteGenerator.createRoute(
                                ViewDeckPage(deck: _filteredDecks[index])),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            if (_decks.isNotEmpty && _filteredDecks.isEmpty)
              IfCollectionEmpty(
                ifCollectionEmptyText: 'No Results Found',
                ifCollectionEmptySubText:
                    'Try adjusting your search to \nfind what your looking for.',
                ifCollectionEmptyHeight:
                    MediaQuery.of(context).size.height * 0.4,
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    FlashcardUtils.updateLatestReview.removeListener(_updateLatestReview);
    _searchController.dispose();
    super.dispose();
  }
}
