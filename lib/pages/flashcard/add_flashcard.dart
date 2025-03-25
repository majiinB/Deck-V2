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
import '../misc/custom widgets/textboxes/textboxes.dart';

class AddFlashcardPage extends StatefulWidget {
  Deck deck;
  AddFlashcardPage({super.key, required this.deck});

  @override
  _AddFlashcardPageState createState() => _AddFlashcardPageState();
}

class _AddFlashcardPageState extends State<AddFlashcardPage> {
  bool _isLoading = false;
  final TextEditingController _descriptionOrAnswerController = TextEditingController();
  final TextEditingController _questionOrTermController = TextEditingController();

  ///This is used to check if there are unsaved changes
  bool _hasUnsavedChanges() {
    return _descriptionOrAnswerController.text.isNotEmpty ||
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
        /*final shouldPop = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return ShowConfirmationDialog(
              title: 'Are you sure you want to go back?',
              text: 'If you go back now, you will lose all your progress',
              onConfirm: () {
                Navigator.of(context).pop(); //Return true to allow pop
              },
              onCancel: () {
                //Return false to prevent pop
              },
            );
          },
        );

        //If the user confirmed, pop the current route
        if (shouldPop == true) {
          Navigator.of(context).pop(true);
        }*/
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
        title: 'Manage Account',
        color: DeckColors.primaryColor,
        fontSize: 24,
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) :
      ///wrap whole content with column and expanded so image can always stay at the bottom
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
                        'Description',
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
                              controller: _descriptionOrAnswerController,
                              hintText: 'Enter Description',
                              isMultiLine: true
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: BuildButton(
                        onPressed: () {
                          showConfirmDialog(
                          context,
                          "assets/images/Deck_Dialogue1.png",
                          "Add Flash Card",
                          "Are you sure you want to add this flash card on your deck?",
                          "Add Flashcard",
                                () async {
                                  setState(() => _isLoading = true);
                                  try {
                                    if (_descriptionOrAnswerController.text.isNotEmpty &&
                                        _questionOrTermController.text.isNotEmpty) {
                                      Cards? card = await widget.deck.addQuestionToDeck(
                                        _questionOrTermController.text.toString(),
                                        _descriptionOrAnswerController.text.toString(),
                                      );
                                      if (card != null) {
                                        await Future.delayed(const Duration(milliseconds: 300));
                                        setState(() => _isLoading = false);
                                        Navigator.pop(context, card);
                                        showAlertDialog(context,
                                          "assets/images/Deck_Dialogue1.png",
                                          "Card Added Successfully", "You can now view this card in you deck");
                                    }
                                    } else {
                                      //Navigator.of(context).pop(); // Close the confirmation dialog
                                      await Future.delayed(const Duration(milliseconds: 300)); // Ensure the dialog is fully closed
                                      setState(() => _isLoading = false);
                                      showAlertDialog(
                                        context,"assets/images/Deck_Dialogue1.png",
                                        "Input Error",
                                        "Please fill out all of the input fields and try again.");
                               // showDialog(
                                      //   context: context,
                                      //   builder: (BuildContext context) {
                                      //     return AlertDialog(
                                      //       title: const Text('Input Error'),
                                      //       content: const Text('Please fill out all of the input fields.'),
                                      //       actions: <Widget>[
                                      //         TextButton(
                                      //           onPressed: () {
                                      //             Navigator.of(context).pop(); // Close the dialog
                                      //           },
                                      //           child: const Text(
                                      //             'Close',
                                      //             style: TextStyle(
                                      //               color: Colors.red,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     );
                                      //   },
                                      // );
                                    }
                                  } catch (e) {
                                    print('add card error: $e');
                                    setState(() => _isLoading = false);
                                    showAlertDialog(
                                      context,"assets/images/Deck_Dialogue1.png",
                                      "An error occured" ,
                                      "An unknown error occured. Please try again.");
                                  }
                                },
                          );
                        },
                        buttonText: 'Add Card',
                        height: 50.0,
                        width: MediaQuery.of(context).size.width,
                        backgroundColor: DeckColors.primaryColor,
                        textColor: DeckColors.white,
                        radius: 10.0,
                        fontSize: 16,
                        borderWidth: 2,
                        borderColor: DeckColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Image.asset(
            'assets/images/Deck-Bottom-Image.png',
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
    _descriptionOrAnswerController.dispose();
    _questionOrTermController.dispose();
    super.dispose();
  }
}
