import 'package:deck/backend/flashcard/flashcard_utils.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../backend/auth/auth_service.dart';
import '../../backend/flashcard/flashcard_service.dart';
import '../../backend/models/deck.dart';
import '../misc/custom widgets/appbar/auth_bar.dart';
import '../misc/custom widgets/buttons/custom_buttons.dart';
import '../misc/custom widgets/dialogs/confirmation_dialog.dart';
import '../misc/custom widgets/functions/if_collection_empty.dart';
import '../misc/custom widgets/textboxes/textboxes.dart';
import '../misc/custom widgets/tiles/deck_list.dart';

class RecentlyDeletedPage extends StatefulWidget {
  const RecentlyDeletedPage({super.key});

  @override
  State<RecentlyDeletedPage> createState() => RecentlyDeletedPageState();
}

class RecentlyDeletedPageState extends State<RecentlyDeletedPage> {
  final AuthService _authService = AuthService();
  final FlashcardService _flashcardService = FlashcardService();
  List<Deck> _decks = [];
  List<Deck> _filteredDecks = [];
  Map<String, int> _deckCardCount = {};
  late User? _user;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _nextPageToken = "";
  List<String> get allDeckIds => _decks.map((d) => d.deckId).toList();

  @override
  void initState() {
    super.initState();
    _user = _authService.getCurrentUser();
    _initUserDecks(_user);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _initUserDecks(User? user) async {
    if (user != null) {
      String userId = user.uid;
      var result = await _flashcardService.getDeletedDecksByUserId(); // Call method to fetch decks
      List<Deck> decks = result['decks'];
      String nextPageToken = result['nextPageToken'];

      Map<String, int> deckCardCount = {};
      for (Deck deck in decks) {
        int count = await deck.getCardCount();
        deckCardCount[deck.deckId] = count;
      }
      setState(() {
        _decks = decks;
        _filteredDecks = decks;
        _deckCardCount = deckCardCount;
        _nextPageToken = nextPageToken;
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

  void _deleteDeck(List<String> deckIds) async {
    await _flashcardService.deleteDeck(deckIds);
    setState(() {
      // Keep only decks whose ID is NOT in the deckIds list
      _decks = _decks.where((d) => !deckIds.contains(d.deckId)).toList();
      _onSearchChanged();
    });
  }

  void _retrieveDeck(Deck deck) async {
    final success = await deck.updateDeleteStatus(false);
    if(!success) return;

    setState(() {
      _decks.removeWhere((d) => d.deckId == deck.deckId);
      _filteredDecks.removeWhere((d) => d.deckId == deck.deckId);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DeckColors.backgroundColor,
      appBar: const AuthBar(
        automaticallyImplyLeading: true,
        title: 'Recently Deleted',
        color: DeckColors.primaryColor,
        fontSize: 24,
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(top: 30, left: 20, right: 15, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_filteredDecks.isNotEmpty)
            BuildTextBox(
              hintText: 'Search Decks',
              controller: _searchController,
              showPassword: false,
              leftIcon: Icons.search,
            ),
            if (_filteredDecks.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: BuildButton(
                      onPressed: () {
                        showConfirmDialog(
                          context,
                          "assets/images/Deck-Dialogue4.png",
                          "Retrieve All Items?",
                          "Are you sure you want to retrieve all items? Once retrieved, they will return to the deck page.",
                          "Retrieve All",
                          () {
                            for (final id in allDeckIds) {
                              final deck = _decks.firstWhere((d) => d.deckId == id);
                              _retrieveDeck(deck);
                            }
                            Navigator.of(context).pop();
                          },
                        );
                      },
                      buttonText: 'Retrieve All',
                      height: 50.0,
                      width: double.infinity,
                      backgroundColor: DeckColors.primaryColor,
                      textColor: DeckColors.white,
                      radius: 10.0,
                      borderColor: DeckColors.primaryColor,
                      fontSize: 16,
                      borderWidth: 0,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 7.0),
                      child: BuildButton(
                        onPressed: _decks.isEmpty ? () {}: () {
                          showConfirmDialog(
                            context,
                            "assets/images/Deck-Dialogue4.png",
                            "Delete All Items?",
                            "Are you sure you want to delete all items? Once deleted, they cannot be retrieved. Proceed with caution.",
                            "Delete All",
                                ()  {
                                  final idsToRemove = allDeckIds;
                                  _deleteDeck(idsToRemove);
                                  Navigator.of(context).pop();
                                },
                          );
                        },
                        buttonText: 'Delete All',
                        height: 50.0,
                        width: double.infinity,
                        backgroundColor: Colors.red,
                        textColor: DeckColors.white,
                        radius: 10.0,
                        borderColor: DeckColors.deckRed,
                        fontSize: 16,
                        borderWidth: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_filteredDecks.isEmpty)
              IfCollectionEmpty(
                  ifCollectionEmptyText: 'A clean mind starts with a clean trash',
                  ifCollectionEmptySubText: 'Deleted Decks are kept in the trash bin until you delete them permanently.',
                  ifCollectionEmptyHeight:
                      MediaQuery.of(context).size.height * 0.7),
            if (_filteredDecks.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredDecks.length,
                  itemBuilder: (context, ItemIndex) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: DeckList(
                        deckImageUrl:
                            _filteredDecks[ItemIndex].coverPhoto.toString(),
                        titleText: _filteredDecks[ItemIndex].title.toString(),
                        numberText:
                            "${_deckCardCount[_filteredDecks[ItemIndex].deckId]} Card(s)",
                        onDelete: () {
                          /*String deletedTitle =
                              _filteredDecks[index].title.toString();
                          Deck removedDeck = _filteredDecks[index];
                          showConfirmDialog(
                            context,
                            "assets/images/Deck_Dialogue1.png",
                            "Delete Item",
                            "Are you sure you want to delete '$deletedTitle'?",
                            "Delete Item",
                            () async {
                              await _deleteDeck(
                                  removedDeck, _decks.indexOf(removedDeck));
                            },
                          );*/
                        },
                        onRetrieve: () {
                          /*final String retrievedTitle =
                              _filteredDecks[index].title.toString();
                          Deck retrievedDeck = _filteredDecks[index];
                          showConfirmDialog(
                            context,
                            "assets/images/Deck_Dialogue1.png",
                            "Retrieve Item",
                            "Are you sure you want to retrieve '$retrievedTitle'?",
                            "Retrieve",
                            () async {
                              await _retrieveDeck(
                                  retrievedDeck, _decks.indexOf(retrievedDeck));
                            },
                          );*/
                        },
                        items: const ['Retrieve Deck', 'Delete Deck'],
                        icons: const [Icons.restore, DeckIcons.trash_bin],
                        onItemsSelected: (index) {
                          /// R E T R I E V E  I T E M
                          if(index == 0){
                            Deck retrievedDeck = _filteredDecks[index];
                            showConfirmDialog(
                              context,
                              "assets/images/Deck-Dialogue1.png",
                              "Retrieve Item",
                              "Are you sure you want to retrieve this deck?",
                              "Retrieve",
                                  ()  {
                                    _retrieveDeck(retrievedDeck);
                                    Navigator.of(context).pop();
                                  },
                            );
                          }
                          ///----- E N D  O F  R E T R I E V E  I T E M -----------

                          ///D E L E T E  I T E M
                          else if (index == 1){
                            List<String> removedDeckId = [_filteredDecks[ItemIndex].deckId];
                            showConfirmDialog(
                              context,
                              "assets/images/Deck-Dialogue1.png",
                              "Delete Item",
                              "Are you sure you want to delete this deck",
                              "Delete Item",
                                  ()  {
                                    _deleteDeck(removedDeckId);
                                    Navigator.of(context).pop();
                                  },
                            );
                          }
                          ///----- E N D  O F  D E L E T E  I T E M -----------
                        },
                        enableSwipeToRetrieve: true,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
