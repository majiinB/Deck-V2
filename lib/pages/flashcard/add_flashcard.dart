import 'package:deck/pages/flashcard/add_deck.dart';
import 'package:deck/pages/flashcard/view_deck.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/widget_method.dart';
// import 'package:google_fonts/google_fonts.dart';
import '../../backend/models/card.dart';
import '../../backend/models/deck.dart';
import '../misc/custom widgets/appbar/auth_bar.dart';
import '../misc/custom widgets/buttons/custom_buttons.dart';
import '../misc/custom widgets/dialogs/alert_dialog.dart';
import '../misc/custom widgets/dialogs/confirmation_dialog.dart';
import '../misc/custom widgets/functions/loading.dart';
import '../misc/custom widgets/textboxes/textboxes.dart';

class AddFlashcardPage extends StatefulWidget {
  Deck deck;
  AddFlashcardPage({super.key, required this.deck});

  @override
  _AddFlashcardPageState createState() => _AddFlashcardPageState();
}

class _AddFlashcardPageState extends State<AddFlashcardPage> {
  bool _isLoading = false;
  final TextEditingController _definitionOrAnswerController = TextEditingController();
  final TextEditingController _questionOrTermController = TextEditingController();

  ///This is used to check if there are unsaved changes
  bool _hasUnsavedChanges() {
    return _definitionOrAnswerController.text.isNotEmpty ||
        _questionOrTermController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
      if (didPop) {
        return;
      }

      //Check for unsaved changes
      if (_hasUnsavedChanges()) {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return CustomConfirmDialog(
              title: 'Are you sure you want to go back?',
              message: 'Going back now will lose all your progress.',
              imagePath: 'assets/images/Deck-Dialogue4.png',
              button1: 'Go Back',
              button2: 'Cancel',
              onConfirm: () {
                Navigator.of(context).pop(true); //Return true to allow pop
              },
              onCancel: () {
                Navigator.of(context).pop(false); //Return false to prevent pop
              },
            );
          },
        );

        //If the user confirmed, pop the current route
        if (shouldPop == true) {
          Navigator.of(context).pop(true);
        }
      } else {
        //No unsaved changes, allow pop without confirmation
        Navigator.of(context).pop(true);
      }
    },
    child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: DeckColors.backgroundColor,
      appBar: const AuthBar(
        automaticallyImplyLeading: true,
        title: 'Add Flashcard',
        color: DeckColors.primaryColor,
        fontSize: 24,
      ),
      body: _isLoading ? const DeckLoadingDialog(
        message: "Adding the new flashcard to your deck...",
      ) :
      Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        'Add A New FlashCard To The Deck',
                        style: TextStyle(
                          fontFamily: 'Fraiche',
                          color: DeckColors.primaryColor,
                          fontSize: 40,
                          height: 1.1,
                        ),
                      ),
                    ),
                    const Text(
                      'Simply fill in the text fields below to add flash card on your deck.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontFamily: 'Nunito-Regular',
                        fontSize: 16,
                        color: DeckColors.primaryColor,
                      ),
                    ),
                    /*Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
                        color: DeckColors.primaryColor,
                        height: 1,
                      ),
                    ),*/
                    const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text(
                        'Terminology',
                        style: TextStyle(
                          fontFamily: 'Nunito-Bold',
                          color: DeckColors.primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: BuildTextBox(
                          controller: _questionOrTermController,
                          hintText: 'Enter Terminology'
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        'Definition',
                        style: TextStyle(
                          fontFamily: 'Nunito-Bold',
                          color: DeckColors.primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: BuildTextBox(
                              controller: _definitionOrAnswerController,
                              hintText: 'Enter Definition',
                              isMultiLine: true
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: BuildButton(
                        onPressed: () {
                          showConfirmDialog(
                            context,
                            "assets/images/Deck-Dialogue4.png",
                            "Add Flash Card",
                            "Add this flashcard to your deck?",
                            "Add Flashcard",
                            () async {
                              Navigator.of(context).pop();
                              setState(() => _isLoading = true);
                              try {
                                if (_definitionOrAnswerController.text.isNotEmpty &&
                                    _questionOrTermController.text.isNotEmpty) {
                                  Cards? card = await widget.deck.addFlashcardToDeck(
                                    _questionOrTermController.text.toString(),
                                    _definitionOrAnswerController.text.toString(),
                                  );
                                  if (card != null) {
                                    setState(() => _isLoading = false);
                                    Navigator.pop(context, card);
                                    showAlertDialog(context,
                                      "assets/images/Deck-Dialogue3.png",
                                      "Card Added Successfully", "You can now view this card in you deck");
                                  }
                                } else {
                                  setState(() => _isLoading = false);
                                  showAlertDialog(
                                    context,"assets/images/Deck-Dialogue1.png",
                                    "Input Error",
                                    "Please fill out all of the input fields");
                                }
                              } catch (e) {
                                print('add card error: $e');
                                setState(() => _isLoading = false);
                                showAlertDialog(
                                  context,"assets/images/Deck-Dialogue1.png",
                                  "An error occured" ,
                                  "An unknown error occured. Please try again.");
                              }
                            },
                          );
                        },
                        buttonText: 'Add Card',
                        height: 50.0,
                        width: MediaQuery.of(context).size.width,
                        backgroundColor: DeckColors.accentColor,
                        textColor: DeckColors.primaryColor,
                        radius: 10.0,
                        fontSize: 16,
                        borderWidth: 3,
                        borderColor: DeckColors.primaryColor,
                      ),
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
  @override
  void dispose() {
    _definitionOrAnswerController.dispose();
    _questionOrTermController.dispose();
    super.dispose();
  }
}
