import 'dart:async';
import 'dart:convert';
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
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/widget_method.dart';
// import 'package:google_fonts/google_fonts.dart';

import '../../backend/custom_exceptions/api_exception.dart';
import '../../backend/flashcard/flashcard_utils.dart';
import '../misc/custom widgets/buttons/custom_buttons.dart';
import '../misc/custom widgets/dialogs/alert_dialog.dart';
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
  final ScrollController _scrollController = ScrollController();
  Deck? _latestDeck;
  List<Deck> _decks = [];
  List<Deck> _filteredDecks = [];
  late User? _user;
  int numOfCards = 0;
  String _nextPageToken = "";
  bool isFetchingMore = false;
  String filter = "MY_DECKS";
  Timer? _debounce; // Debouncer

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  bool _isSearchBoxVisible = true;

  ///this is used sana to check if the currently signed-in is the owner
  // bool isOwner = true;

  int correct = 0;
  int total = 0;
  String score = "";
  bool isRecentQuizPassed = true;

  @override
  void initState() {
    super.initState();
    _user = _authService.getCurrentUser();
    // FlashcardUtils.updateLatestReview.addListener(_updateLatestReview);
    _scrollController.addListener(_onScroll);
    _initUserDecks(_user);
    // _initScore();
    _searchController.addListener(_onSearchChanged);
  }

  void _initUserDecks(User? user) async {
    String? userId = user?.uid;

    if (user != null) {
      try{
        print("this is the result of changing filter with no search");

        var result = await _flashcardService.getDecks(filter); // Call method to fetch decks
        print(result);
        List<Deck> decks = result['decks'];
        String nextPageToken = result['nextPageToken'];
        if (!mounted) return;
        setState(() {
          _decks = decks; // Update state with fetched decks
          _filteredDecks = decks; // Initialize filtered decks
          _nextPageToken = nextPageToken;
        });
      }catch(e){
        print('Error fetching latest quiz attempt: $e');
      }

      try{
        final latestResult = await _flashcardService.getLatestQuizAttempt();
        final deckInfo = latestResult['deck'] as Map<String, dynamic>;
        final deckFromJson = Deck.fromJson(deckInfo);

        final latestAttempt = latestResult['latest_attempt'] as Map<String, dynamic>;
        final int attemptScore = latestAttempt['score'] as int;
        final int totalQuestion = latestAttempt['total_questions'] as int;

        if (!mounted) return;
        setState(() {
          _latestDeck = deckFromJson;
          correct = attemptScore;
          total = totalQuestion;
          score = "$correct/$total";
          if(correct >= (total/2)){
            isRecentQuizPassed = true;
          }else {
            isRecentQuizPassed = false;
          }
        });
      }catch(e){
        print('Error fetching latest quiz attempt: $e');
      }
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1200), () async {
      print(filter);
      _searchQuery = _searchController.text;
      List<Deck> searchedDecks = [];
      if(_searchQuery.trim().isNotEmpty){
        var result = await _flashcardService.searchDecks(_searchQuery, filter);
        print(filter);
        print("this is the result for this the query $_searchQuery");
        searchedDecks = result['decks'];
        setState(() {
          _filteredDecks = searchedDecks;
        });
      }else{
        var result = await _flashcardService.getDecks(filter); // Call method to fetch decks
        searchedDecks = result['decks'];
        String nextPageToken = result['nextPageToken'];
        setState(() {
          _decks = searchedDecks;
          _filteredDecks = _decks;
          _nextPageToken = nextPageToken;
        });
      }
    });
  }

  Future<void> _onScroll() async {
    if (_searchQuery.trim().isNotEmpty) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {

      if(isFetchingMore) return;
      if(_nextPageToken == "" || _nextPageToken.isEmpty) return;
      isFetchingMore = true;

      var result = await _flashcardService.getDecksNextPage(nextPageToken: _nextPageToken);
      List<Deck> decks = result['decks'];
      String nextPageToken = result['nextPageToken'];
      print('next page token from on scroll result: ${nextPageToken}');
      print('current next page token from on scroll ${_nextPageToken}');
      print(decks.map((deck) => deck.toString()).toList());

      if(decks.isNotEmpty){
        print("umabot dito");
        setState(() {
          _nextPageToken = nextPageToken;
          print('current next page token from on scroll being set ${_nextPageToken}');
          _decks.addAll(decks);
        });
      }else{
        setState(() {
          _nextPageToken = "";
        });
      }
      isFetchingMore = false;
    }
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
          controller: _scrollController,
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
                                      AddDeckPage(decks: _decks, userId: userId)
                              ),
                            );
                            _initUserDecks(_user);
                          } catch (e) {
                            print('error in navigating add deck $e');
                          }
                        }
                      },
                    ),
                    ///F O R  F I L T E R  B U T T O N
                    PopupMenu(
                      icon: const Icon(Icons.filter_list_alt, color: DeckColors.primaryColor),
                      items: const ['My Decks', 'Saved Decks', 'Published Decks'],
                      icons: const [DeckIcons.flashcard, Icons.save, Icons.align_horizontal_left_rounded],
                      onItemSelected: (index) {
                        String currentFilter = filter;
                        /// M Y  D E C K S
                        if (index == 0){
                          setState(() {
                            filter = "MY_DECKS";
                          });
                          if(filter == currentFilter) return;
                          _initUserDecks(_user);
                        }
                        /// S A V E D  D E C K S
                        else if (index == 1) {
                          setState(() {
                            filter = "SAVED_DECKS";
                          });
                          if(filter == currentFilter) return;
                          _initUserDecks(_user);
                        }
                        /// PUBLISHED DECKS
                        else if (index == 2) {
                          setState(() {
                            filter = "PUBLIC_DECKS";
                          });
                          if(filter == currentFilter) return;
                          _initUserDecks(_user);
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
                    'No decks yet? Now\'s the time to create one!',
                    ifCollectionEmptyHeight: MediaQuery.of(context).size.height/3,
                  ),
                ),
              // if (_decks.isEmpty)
              //   const Padding(
              //     padding: const EdgeInsets.only(left: 30,right: 30, top: 20.0),
              //     child: Text(
              //         'Explore',
              //         style: TextStyle(
              //             fontFamily: 'Fraiche',
              //             fontSize: 30,
              //             color: DeckColors.primaryColor,
              //             fontWeight: FontWeight.bold)
              //     ),
              //   ),
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

                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Continue Learning",
                                  maxLines:1,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    height:1,
                                    fontSize: 14,
                                    fontFamily: 'Nunito-Bold',
                                    color: DeckColors.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  _latestDeck?.title ?? 'A VERY VERY VERY LONG Deck Title that will reach until the fourth line nyehe ',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    height:1,
                                    fontSize: 24,
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
                                    fontSize: 14,
                                    fontFamily: 'Nunito-Bold',
                                    color: DeckColors.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Flexible(child:
                                Center(
                                  child: AutoSizeText(
                                    score.isNotEmpty ? score : "100/100",
                                    textAlign: TextAlign.center,
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
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  child: TextButton(
                                    onPressed: () {
                                      print("Continue Learning Button Clicked");
                                      Navigator.of(context).push(
                                        RouteGenerator.createRoute(
                                            ViewDeckPage(deck: _latestDeck!, filter: filter)
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
                          child: DeckTile(
                              deckCoverPhotoUrl: _filteredDecks[index].coverPhoto,
                              titleOfDeck: _filteredDecks[index].title,
                              ownerOfDeck: _filteredDecks[index].deckOwnerName,
                              numberOfCards: _filteredDecks[index].flashcardCount,
                              onDelete: () {},
                              enableSwipeToRetrieve: false,
                              onTap: () async {
                                await Navigator.of(context).push(
                                  RouteGenerator.createRoute(
                                      ViewDeckPage(deck: _filteredDecks[index], filter: filter)),
                                );
                                setState(() {
                                  _initUserDecks(_user);
                                });
                              },
                              // Checks if the user is the owner of the deck
                              items: (_filteredDecks[index].userId == _user!.uid)? [
                                // Check if the deck is private (not published)
                                _filteredDecks[index].isPrivate ? 'Publish Deck' :
                                'Unpublish Deck',
                                'Edit Deck Info',
                                'Delete Deck'
                              ] : [
                              filter == "SAVED_DECKS" ? 'Unsave Deck' : "Save Deck",
                                'Report'
                              ],
                              icons: (_filteredDecks[index].userId == _user!.uid) ? [
                                _filteredDecks[index].isPrivate! ? Icons.undo_rounded : Icons.publish_rounded,
                                DeckIcons.pencil,
                                DeckIcons.trash_bin
                              ] : [Icons.remove_circle, Icons.report],///Not Owner

                              ///START FOR LOGIC OF POP UP MENU BUTTON (ung three dots)
                              onItemsSelected: (selectedIndex) async {
                                BuildContext parentContext = context;
                                ///If owner, show these options in the popup menu
                                if(_filteredDecks[index].userId == _user!.uid) {
                                  if (selectedIndex == 0) {
                                    ///Show the confirmation dialog for Publish/Unpublish
                                    showDialog<bool>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return CustomConfirmDialog(
                                          title: _filteredDecks[index].isPrivate
                                              ? 'Publish Deck?'
                                              : 'Unpublish Deck?',
                                          message: _filteredDecks[index].isPrivate
                                              ? 'Are you sure you want to publish this deck?'
                                              : 'Are you sure you want to unpublish this deck?',
                                          imagePath: 'assets/images/Deck-Dialogue4.png',
                                          button1: _filteredDecks[index].isPrivate
                                              ? 'Publish Deck'
                                              : 'Unpublish Deck',
                                          button2: 'Cancel',
                                          onConfirm: () async {
                                            Navigator.of(context).pop(); // close confirm dialog
                                            Future(() async {
                                              // Put delay to ensure the current dialog is popped out of the stack
                                              await Future.delayed(Duration(milliseconds: 100));
                                              try {
                                                // Fire up request
                                                await _filteredDecks[index].publishOrUnpublishDeck();

                                                // Show dialog
                                                if (parentContext.mounted) {
                                                  // Conditional Message
                                                  String message = _filteredDecks[index].isPrivate ?
                                                    "Successfully made a publish request! Please wait for our moderator's approval" :
                                                    "Successfully unpublished the deck! You may now make changes to the deck.";
                                                  // Conditional Title
                                                  String title = _filteredDecks[index].isPrivate ?
                                                    'Publish request for "${_filteredDecks[index].title}" deck has been made!' :
                                                    'Successfully Unpublished "${_filteredDecks[index].title}';

                                                  //Set the decks' field to true if its was published or public (isPrivate = false) already
                                                  if(!_filteredDecks[index].isPrivate) _filteredDecks[index].isPrivate = true;

                                                  showAlertDialog(
                                                    parentContext,
                                                    "assets/images/Deck-Dialogue3.png",
                                                    title,
                                                    message,
                                                  );

                                                  setState(() {});
                                                }
                                              } catch (e) {
                                                print('Caught error: $e');
                                                String errorMessage = e is ApiException ? e.message : 'An unexpected error occurred.';
                                                if (parentContext.mounted) {
                                                  showAlertDialog(
                                                    parentContext,
                                                    "assets/images/Deck-Dialogue1.png",
                                                    "Uh Oh An Error Has Occured",
                                                    errorMessage,
                                                  );
                                                }
                                              }
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
                                  else if (selectedIndex == 1) {
                                    if(_filteredDecks[index].isPrivate){
                                      await Navigator.of(context).push(
                                        RouteGenerator.createRoute(EditDeck(deck: _filteredDecks[index])),
                                      );

                                      setState(() {
                                        _initUserDecks(_user);
                                      });
                                      return;
                                    }
                                    showAlertDialog(
                                      context,
                                      "assets/images/Deck-Dialogue1.png",
                                      "Sorry but you cannot edit an already published deck.",
                                      "Published decks are reviewed by are moderator to ensure appropriate content. Please unpublish first to edit your deck.",
                                    );
                                  }

                                  ///D E L E T E  D E C K
                                  else if (selectedIndex == 2) {
                                    showDialog<bool>(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return CustomConfirmDialog(
                                            title: 'Delete this deck?',
                                            message: 'Deleted decks move to trash and can be recovered.',
                                            imagePath: 'assets/images/Deck-Dialogue4.png',
                                            button1: 'Delete Deck',
                                            button2: 'Cancel',
                                            onConfirm: () async {
                                              await _filteredDecks[index].updateDeleteStatus(true);
                                              setState(() {
                                                _filteredDecks.removeWhere((d) => d.deckId == _filteredDecks[index].deckId);
                                              });
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
                                  if(selectedIndex == 0){
                                    showDialog<bool>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        String saveOrUnsave = (filter == "SAVED_DECKS") ? 'unsave' : 'save';
                                        return CustomConfirmDialog(
                                          title:(filter == "SAVED_DECKS") ? 'Unsave Deck?' : 'Save Deck?',
                                          message: 'Are you sure you want to $saveOrUnsave this deck?',
                                          imagePath: 'assets/images/Deck-Dialogue4.png',
                                          button1: (filter == "SAVED_DECKS") ? 'Unsave Deck' : 'Save Deck',
                                          button2: 'Cancel',
                                          onConfirm: () async {
                                            if(filter == "SAVED_DECKS"){
                                              await _filteredDecks[index].unsaveDeck();
                                              setState(() {
                                                _filteredDecks.removeWhere((d) => d.deckId == _filteredDecks[index].deckId);
                                              });
                                            }else{
                                              await _filteredDecks[index].saveDeck();
                                            }
                                            Navigator.of(context).pop();
                                          },
                                          onCancel: () {
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                    );
                                  }
                                  ///R E P O R T  P A G E
                                  else if (selectedIndex == 1) {
                                    setState(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ReportAProblem(sourcePage: 'FlashcardPage'),
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
                    Center(
                      child: IfCollectionEmpty(
                        ifCollectionEmptyText: 'No Results Found',
                        ifCollectionEmptySubText:
                        'Try adjusting your search to find it.',
                        ifCollectionEmptyHeight:
                        MediaQuery.of(context).size.height * 0.4,
                      ),
                    )
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
    // FlashcardUtils.updateLatestReview.removeListener(_updateLatestReview);
    _scrollController.removeListener(_onScroll);
    _searchController.dispose();
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }
}
