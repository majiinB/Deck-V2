import 'dart:ffi';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:deck/backend/auth/auth_service.dart';
import 'package:deck/backend/flashcard/flashcard_service.dart';
import 'package:deck/backend/models/deck.dart';
import 'package:deck/pages/flashcard/Quiz%20Modes/quiz_mode_multChoice.dart';
import 'package:deck/pages/flashcard/add_deck.dart';
import 'package:deck/pages/flashcard/edit_deck.dart';
import 'package:deck/pages/flashcard/view_deck.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/custom%20widgets/menus/pop_up_menu.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:deck/pages/misc/deck_icons2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/widget_method.dart';
// import 'package:google_fonts/google_fonts.dart';

import '../../backend/flashcard/flashcard_utils.dart';
import '../misc/custom widgets/buttons/custom_buttons.dart';
import '../misc/custom widgets/dialogs/confirmation_dialog.dart';
import '../misc/custom widgets/functions/if_collection_empty.dart';
import '../misc/custom widgets/textboxes/textboxes.dart';
import '../misc/custom widgets/tiles/deck_tile.dart';
import '../misc/custom widgets/tiles/home_deck_tile.dart';
import '../settings/support and policies/report_a_problem.dart';

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
  int numOfCards = 0;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  bool _isSearchBoxVisible = true;

  ///This keeps track of the deck's publish status
  bool isDeckPublished = false;

  ///this is used sana to check if the currently signed-in is the owner
  bool isOwner = true;

  int correct = 0;
  int total = 0;
  String score = "";
  bool isRecentQuizPassed = true;

  @override
  void initState() {
    super.initState();
    _user = _authService.getCurrentUser();
    FlashcardUtils.updateLatestReview.addListener(_updateLatestReview);
    _initUserDecks(_user);
    _initScore();
    _searchController.addListener(_onSearchChanged);
  }

  void _initUserDecks(User? user) async {
    if (user != null) {
      String userId = user.uid;
      List<Deck> decks = await _flashcardService
          .getDecks(); // Call method to fetch decks
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
      if (_latestDeck != null) {
        print("Latest Deck: ${_latestDeck!.title}");
      }
    }
  }

  void _initScore() {
    /// Initializes the quiz score and determines if the user has passed.
    ///
    /// This function sets the `correct` and `total` scores, checks if user
    /// has passed based on whether they scored at least half of the total, and
    /// updates the `score` display accordingly.
    correct = 50; //_latestDeck.score //TODO get scores from db
    total = 100; //_latestDeck.total
    print("Initializing Score..."); // Debugging

    if(correct >= (total/2)){
      isRecentQuizPassed = true;
    }else {
      isRecentQuizPassed = false;
    }
    setState(() {
      score = "$correct/$total";
      print("Score updated: $score");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DeckColors.backgroundColor,
      body: SafeArea(
        top: true,
        bottom: false,
        left: true,
        right: true,
        child:  SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30,right: 30,top: 0.0),
                child: Row(
                  children: [
                    const Icon(
                      DeckIcons2.hat,
                      color: DeckColors.primaryColor,
                      size: 32,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.add,
                          color: DeckColors.primaryColor, size: 32),
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
                    ///F O R  F I L T E R  B U T T O N
                    PopupMenu(
                      icon: const Icon(Icons.filter_list_alt, color: DeckColors.primaryColor),
                      items: const ['My Decks', 'Saved Decks', 'All'],
                      icons: const [DeckIcons.flashcard, Icons.save, Icons.align_horizontal_left_rounded],
                      onItemSelected: (index) {
                        /// M Y  D E C K S
                        if (index == 0){

                        }
                        /// S A V E D  D E C K S
                        else if (index == 1) {

                        }
                        ///A L L
                        else if (index == 2) {

                        }
                      },
                    )

                  ],
                ),
              ),
              if (_decks.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 30,right: 30, top: 20.0),
                  child: IfCollectionEmpty(
                    hasIcon: true,
                    ifCollectionEmptyText: 'It’s lonely around here...',
                    ifCollectionEmptySubText:
                    'No Recent Decks Yet! Now’s the perfect time to get ahead. Create your own Deck now to keep learning.',
                    ifCollectionEmptyHeight: MediaQuery.of(context).size.height/3,
                  ),
                ),
              if (_decks.isEmpty)
                const Padding(
                  padding: const EdgeInsets.only(left: 30,right: 30, top: 20.0),
                  child: Text(
                      'Explore',
                      style: TextStyle(
                          fontFamily: 'Fraiche',
                          fontSize: 30,
                          color: DeckColors.primaryColor,
                          fontWeight: FontWeight.bold)
                  ),
                ),
              if (_decks.isEmpty)
                SizedBox(
                  height: 150.0,
                  child:
                  ListView.builder( //TODO Change datas here using data from db
                    scrollDirection: Axis.horizontal,
                    itemCount: 15, //_decks.length
                    itemBuilder:(context, index){
                      return Padding(
                          padding: EdgeInsets.only(left: index == 0 ? 30 : 10, right: 10) ,
                          child: HomeDeckTile(
                            titleOfDeck: 'yee',
                            ownerOfDeck: 'sample',
                            numberOfCards: 100,
                            onDelete: () {  },
                            onTap: () {  },
                          )
                      );
                    },
                  ),
                ),
              Padding(padding: EdgeInsets.symmetric( horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_latestDeck != null)
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        'Latest Review',
                        style: TextStyle(
                          fontFamily: 'Fraiche',
                          color: DeckColors.primaryColor,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  if (_latestDeck != null)
                    Container(
                      padding: EdgeInsets.all(15),
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: DeckColors.primaryColor, width: 3),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: DeckColors.deepGray,
                            blurRadius: 4,
                            offset: Offset(1, 1),
                          ),
                        ],
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFB9EDD9),
                            Color(0xFFF3FCF8),
                            DeckColors.white ,
                            Color(0xFFE7F0FF),
                            Color(0xFF84B2FF)
                          ],
                          stops: [0.1,0.3, 0.5, 0.8,1.0],
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AutoSizeText(
                                  "Continue Learning",
                                  maxLines:1,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    height:1,
                                    fontSize: 14,
                                    fontFamily: 'Fraiche',
                                    color: DeckColors.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                AutoSizeText(
                                  _latestDeck?.title ?? 'A VERY VERY VERY LONG Deck Title that will reach until the fourth line nyehe ',
                                  maxLines:4,
                                  minFontSize: 8,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    height:1,
                                    fontSize: 18,
                                    fontFamily: 'Fraiche',
                                    color: DeckColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const AutoSizeText(
                                  "You had a score of",
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(
                                    height:1,
                                    fontSize: 10,
                                    fontFamily: 'Nunito-SemiBold',
                                    color: DeckColors.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Flexible(child: AutoSizeText(
                                  score.isNotEmpty ? score : "100/100",
                                  textAlign: TextAlign.end,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    height:1,
                                    fontSize: 35,
                                    fontFamily: 'Fraiche',
                                    color: isRecentQuizPassed ? DeckColors.accentColor : DeckColors.deckRed ,
                                  ),
                                ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  child: TextButton(
                                    onPressed: () {
                                      print("Continue Learning Button Clicked");
                                      Navigator.of(context).push(
                                        RouteGenerator.createRoute(
                                            ViewDeckPage(deck: _latestDeck!)
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: DeckColors.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    ),
                                    child: const AutoSizeText("View Deck",
                                        maxLines: 1,
                                        minFontSize:8,
                                        style: TextStyle(
                                            fontFamily: 'Nunito-SemiBold',
                                            fontSize: 10,
                                            color: DeckColors.white,
                                            fontWeight: FontWeight.bold)
                                    ),
                                  ),
                                )

                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                  if (_decks.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text(
                        'Deck Library',
                        style: TextStyle(
                          fontFamily: 'Fraiche',
                          color: DeckColors.primaryColor,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  //TODO DELETE THIS SAMLPLE
                  DeckTile(
                      titleOfDeck: 'sample',
                      onDelete: () {

                      },
                      enableSwipeToRetrieve: false,
                      onTap: () {
                        print("Clicked");
                        Navigator.of(context).push(
                            RouteGenerator.createRoute(
                                ViewDeckPage(
                                    deck: Deck('A very long deck title that is more than 2 lines', 'description', 2, '_userId', '_deckId', false, true, DateTime.now(), 'assets/images/Deck-Branding1.png'))
                            )
                        );

                      },
                      numberOfCards: numOfCards,
                      ownerOfDeck: 'sample user',
                      items: isOwner?
                      [isDeckPublished ? 'Unpublish Deck' : 'Publish Deck', 'Edit Deck Info', 'Delete Deck']///Owner
                          : ['Unsave Deck', 'Report'],///Not Owner
                      icons: isOwner?
                      [isDeckPublished? Icons.undo_rounded: Icons.publish_rounded, DeckIcons.pencil, DeckIcons.trash_bin]///Owner
                          : [Icons.remove_circle, Icons.report],///Not Owner
                      ///START FOR LOGIC OF POP UP MENU BUTTON (ung three dots)
                      onItemsSelected: (index) {
                        ///If owner, show these options in the popup menu
                        if(isOwner) {
                          if (index == 0) {
                            ///Show the confirmation dialog for Publish/Unpublish
                            showDialog<bool>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return CustomConfirmDialog(
                                  title: isDeckPublished
                                      ? 'Unpublish Deck?'
                                      : 'Publish Deck?',
                                  message: isDeckPublished
                                      ? 'Are you sure you want to unpublish this deck?'
                                      : 'Are you sure you want to publish this deck?',
                                  imagePath: 'assets/images/Deck-Dialogue4.png',
                                  button1: isDeckPublished
                                      ? 'Unpublish Deck'
                                      : 'Publish Deck',
                                  button2: 'Cancel',
                                  onConfirm: () async {
                                    setState(() {
                                      isDeckPublished = !isDeckPublished;
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  onCancel: () {
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            );
                          }
                          ///E D I T  D E C K
                          else if (index == 1) {
                            Navigator.of(context).push(
                              RouteGenerator.createRoute(const EditDeck()),
                            );
                          }

                          ///D E L E T E  D E C K
                          else if (index == 2) {
                            showDialog<bool>(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return CustomConfirmDialog(
                                    title: 'Delete this deck?',
                                    message: 'Once deleted, this deck will no longer be playable. '
                                        'But do not worry, you can still retrieve it in the trash bin.',
                                    imagePath: 'assets/images/Deck-Dialogue4.png',
                                    button1: 'Delete Account',
                                    button2: 'Cancel',
                                    onConfirm: () async {
                                      Deck removedDeck = _filteredDecks[index];
                                      final String deletedTitle =
                                      removedDeck.title.toString();
                                      setState(() {
                                        _filteredDecks.removeAt(index);
                                        _decks.removeWhere(
                                                (card) =>
                                            card.deckId == removedDeck.deckId);
                                      });
                                      showConfirmDialog(
                                        context,
                                        "assets/images/Deck-Dialogue1.png",
                                        "Delete Item?",
                                        "Are you sure you want to delete '$deletedTitle'?",
                                        "Delete Item",
                                            () async {
                                          try {
                                            if (await removedDeck
                                                .updateDeleteStatus(true)) {
                                              if (_latestDeck != null) {
                                                if (_latestDeck?.deckId ==
                                                    removedDeck.deckId) {
                                                  Deck? latest = await _flashcardService
                                                      .getLatestDeckLog(
                                                      _user!.uid);
                                                  setState(() {
                                                    _latestDeck = latest;
                                                  });
                                                }
                                              }
                                            }
                                          } catch (e) {
                                            print(
                                                'Flash Card Page Deletion Error: $e');
                                            setState(() {
                                              _decks.insert(index, removedDeck);
                                            });
                                          }
                                        },
                                        onCancel: () {
                                          setState(() {
                                            _decks.insert(index, removedDeck);
                                          });
                                        },
                                      );
                                      Navigator.of(context).pop();
                                    },
                                    onCancel: () {
                                      Navigator.of(context).pop(
                                          false); // Close the first dialog on cancel
                                    },
                                  );
                                }
                            );
                          }
                        }
                        ///--------- E N D  O F  O W N E R -----------

                        ///If not owner, show these options
                        ///S A V E  D E C K
                        else {
                          if(index == 0){
                            showDialog<bool>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return CustomConfirmDialog(
                                  title:'Unsave Deck?',
                                  message: 'Are you sure you want to unsave this deck?',
                                  imagePath: 'assets/images/Deck-Dialogue4.png',
                                  button1: isDeckPublished ? 'Unsave Deck' : 'Save Deck',
                                  button2: 'Cancel',
                                  onConfirm: () async {
                                    setState(() {
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  onCancel: () {
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            );
                          }
                          ///R E P O R T  P A G E
                          else if (index == 1) {
                            setState(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ReportAProblem(sourcePage: 'FlashcardPage'),
                                ),
                              );
                            });
                          }
                        }
                        ///----- E N D  O F  N O T  O W N E R -----------
                      }
                    ///------- E N D ---------------
                  ),
                  if (_decks.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: BuildTextBox(
                        controller: _searchController,
                        hintText: 'Search Decks',
                        showPassword: false,
                        rightIcon: Icons.search,
                      ),
                    ),
                  if (_decks.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredDecks.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7.0),
                          child: DeckTile( //TODO CHANGE OWNER IF DATABASE IS OK
                              deckCoverPhotoUrl: _filteredDecks[index].coverPhoto,
                              titleOfDeck: _filteredDecks[index].title,
                              ownerOfDeck: 'sample owner',//_filteredDecks[index].owner,
                              onDelete: () {
                                /*Deck removedDeck = _filteredDecks[index];
                        final String deletedTitle =
                            removedDeck.title.toString();
                        setState(() {
                          _filteredDecks.removeAt(index);
                          _decks.removeWhere(
                              (card) => card.deckId == removedDeck.deckId);
                        });
                        showConfirmDialog(
                            context,
                            "assets/images/Deck_Dialogue1.png",
                            "Delete Item?",
                            "Are you sure you want to delete '$deletedTitle'?",
                            "Delete Item",
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
                          onCancel: () {
                            setState(() {
                              _decks.insert(index, removedDeck);
                            });
                          },
                        );*/
                              },
                              enableSwipeToRetrieve: false,
                              onTap: () {
                                print("Clicked");
                                Navigator.of(context).push(
                                  RouteGenerator.createRoute(
                                      ViewDeckPage(deck: _filteredDecks[index])),
                                );
                              },
                              numberOfCards: numOfCards,
                              items: isOwner?
                              [isDeckPublished ? 'Unpublish Deck' : 'Publish Deck', 'Edit Deck Info', 'Delete Deck']///Owner
                                  : ['Unsave Deck', 'Report'],///Not Owner

                              icons: isOwner?
                              [isDeckPublished? Icons.undo_rounded: Icons.publish_rounded, DeckIcons.pencil, DeckIcons.trash_bin]///Owner
                                  : [Icons.remove_circle, Icons.report],///Not Owner

                              ///START FOR LOGIC OF POP UP MENU BUTTON (ung three dots)
                              onItemsSelected: (index) {
                                ///If owner, show these options in the popup menu
                                if(isOwner) {
                                  if (index == 0) {
                                    ///Show the confirmation dialog for Publish/Unpublish
                                    showDialog<bool>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return CustomConfirmDialog(
                                          title: isDeckPublished
                                              ? 'Unpublish Deck?'
                                              : 'Publish Deck?',
                                          message: isDeckPublished
                                              ? 'Are you sure you want to unpublish this deck?'
                                              : 'Are you sure you want to publish this deck?',
                                          imagePath: 'assets/images/Deck-Dialogue4.png',
                                          button1: isDeckPublished
                                              ? 'Unpublish Deck'
                                              : 'Publish Deck',
                                          button2: 'Cancel',
                                          onConfirm: () async {
                                            setState(() {
                                              isDeckPublished = !isDeckPublished;
                                              Navigator.of(context).pop();
                                            });
                                          },
                                          onCancel: () {
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                    );
                                  }

                                  ///E D I T  D E C K
                                  else if (index == 1) {
                                    Navigator.of(context).push(
                                      RouteGenerator.createRoute(const EditDeck()),
                                    );
                                  }

                                  ///D E L E T E  D E C K
                                  else if (index == 2) {
                                    showDialog<bool>(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return CustomConfirmDialog(
                                            title: 'Delete this deck?',
                                            message: 'Once deleted, this deck will no longer be playable. '
                                                'But do not worry, you can still retrieve it in the trash bin.',
                                            imagePath: 'assets/images/Deck-Dialogue4.png',
                                            button1: 'Delete Account',
                                            button2: 'Cancel',
                                            onConfirm: () async {
                                              Deck removedDeck = _filteredDecks[index];
                                              final String deletedTitle =
                                              removedDeck.title.toString();
                                              setState(() {
                                                _filteredDecks.removeAt(index);
                                                _decks.removeWhere(
                                                        (card) =>
                                                    card.deckId == removedDeck.deckId);
                                              });
                                              showConfirmDialog(
                                                context,
                                                "assets/images/Deck-Dialogue1.png",
                                                "Delete Item?",
                                                "Are you sure you want to delete '$deletedTitle'?",
                                                "Delete Item",
                                                    () async {
                                                  try {
                                                    if (await removedDeck
                                                        .updateDeleteStatus(true)) {
                                                      if (_latestDeck != null) {
                                                        if (_latestDeck?.deckId ==
                                                            removedDeck.deckId) {
                                                          Deck? latest = await _flashcardService
                                                              .getLatestDeckLog(
                                                              _user!.uid);
                                                          setState(() {
                                                            _latestDeck = latest;
                                                          });
                                                        }
                                                      }
                                                    }
                                                  } catch (e) {
                                                    print(
                                                        'Flash Card Page Deletion Error: $e');
                                                    setState(() {
                                                      _decks.insert(index, removedDeck);
                                                    });
                                                  }
                                                },
                                                onCancel: () {
                                                  setState(() {
                                                    _decks.insert(index, removedDeck);
                                                  });
                                                },
                                              );
                                              Navigator.of(context).pop();
                                            },
                                            onCancel: () {
                                              Navigator.of(context).pop(
                                                  false); // Close the first dialog on cancel
                                            },
                                          );
                                        }
                                    );
                                  }
                                }
                                ///--------- E N D  O F  O W N E R -----------

                                ///If not owner, show these options
                                ///S A V E  D E C K
                                else {
                                  if(index == 0){
                                    showDialog<bool>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return CustomConfirmDialog(
                                          title:'Unsave Deck?',
                                          message: 'Are you sure you want to unsave this deck?',
                                          imagePath: 'assets/images/Deck-Dialogue4.png',
                                          button1: isDeckPublished ? 'Unsave Deck' : 'Save Deck',
                                          button2: 'Cancel',
                                          onConfirm: () async {
                                            setState(() {
                                              Navigator.of(context).pop();
                                            });
                                          },
                                          onCancel: () {
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                    );
                                  }
                                  ///R E P O R T  P A G E
                                  else if (index == 1) {
                                    setState(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const ReportAProblem(sourcePage: 'FlashcardPage'),
                                        ),
                                      );
                                    });
                                  }
                                }
                                ///----- E N D  O F  N O T  O W N E R -----------
                              }
                            ///------- E N D ---------------
                          ),
                        );
                      },
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
              ),)
            ],
          )
        ),
      )
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
