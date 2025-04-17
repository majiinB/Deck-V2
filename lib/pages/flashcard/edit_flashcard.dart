import 'package:deck/backend/flashcard/flashcard_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
// import 'package:google_fonts/google_fonts.dart';

import '../../backend/models/deck.dart';
import '../../backend/models/card.dart';
import '../misc/custom widgets/appbar/auth_bar.dart';
import '../misc/custom widgets/buttons/custom_buttons.dart';
import '../misc/custom widgets/dialogs/confirmation_dialog.dart';
import '../misc/custom widgets/dialogs/alert_dialog.dart';
import '../misc/custom widgets/textboxes/textboxes.dart';

class EditFlashcardPage extends StatefulWidget {
  final Deck deck;
  final Cards card;

  const EditFlashcardPage({
    super.key,
    required this.deck,
    required this.card,
  });

  @override
  _EditFlashcardPageState createState() => _EditFlashcardPageState();
}

class _EditFlashcardPageState extends State<EditFlashcardPage> {
  bool _isLoading = false;
  bool buttonsEnabled = false; // Flag to track button state
  bool hasUnsavedChanges = false;
  late final TextEditingController _descriptionOrAnswerController;
  late final TextEditingController _questionOrTermController;



  @override
  void initState() {
    super.initState();
    _descriptionOrAnswerController = TextEditingController(text: widget.card.definition.toString());
    _questionOrTermController = TextEditingController(text: widget.card.term.toString());

    ///add listeners to track changes
    _descriptionOrAnswerController.addListener(_onTextChanged);
    _questionOrTermController.addListener(_onTextChanged);
  }

  ///This method is used to compare the current text in the controllers to the original values
  void _onTextChanged() {
    setState(() {
      hasUnsavedChanges = _descriptionOrAnswerController.text.trim() != widget.card.definition.toString().trim() ||
          _questionOrTermController.text.trim() != widget.card.term.toString().trim();
    });
  }

  @override
  void dispose() {
    _descriptionOrAnswerController.removeListener(_onTextChanged);
    _questionOrTermController.removeListener(_onTextChanged);
    _descriptionOrAnswerController.dispose();
    _questionOrTermController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !hasUnsavedChanges,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return CustomConfirmDialog(
              title: 'Are you sure you want to go back?',
              message: 'If you go back now, you will lose all your progress',
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

        if (shouldPop == true) {
          Navigator.of(context).pop(); //allow exit
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: DeckColors.backgroundColor,
        appBar: AuthBar(
          automaticallyImplyLeading: true,
          title: 'View Flashcard',
          color: DeckColors.primaryColor,
          fontSize: 24,
          rightIcon: DeckIcons.pencil,
          onRightIconPressed: () {
            // Unfocus the text fields
            FocusScope.of(context).unfocus();

            // Hide the keyboard
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            setState(() {
              buttonsEnabled = !buttonsEnabled;
            });
          },
        ),
        body: _isLoading ? const Center(child: CircularProgressIndicator()) :
        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'View A Flashcard',
                          style: TextStyle(
                            fontFamily: 'Fraiche',
                            color: DeckColors.primaryColor,
                            fontSize: 40,
                          ),
                        ),
                      ),
                      const Text(
                        'Click the pencil icon above to enable editing of the text fields below.',
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
                          color: DeckColors.white,
                          height: 2,
                        ),
                      ),*/
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(
                          'Title',
                          style: TextStyle(
                            fontFamily: 'Nunito-Bold',
                            color: DeckColors.primaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Opacity(
                          opacity: buttonsEnabled ? 1.0 : 0.7, // Set opacity based on button state
                          child: IgnorePointer(
                            ignoring: !buttonsEnabled,
                            child: BuildTextBox(
                              hintText: 'Enter Term/Question',
                              controller: _questionOrTermController,
                            ),
                          ),
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
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Opacity(
                          opacity: buttonsEnabled ? 1.0 : 0.7, // Set opacity based on button state
                          child: IgnorePointer(
                            ignoring: !buttonsEnabled,
                            child: BuildTextBox(
                              controller: _descriptionOrAnswerController,
                              hintText: 'Enter Description/Answer',
                              isMultiLine: true,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Opacity(
                          opacity: buttonsEnabled ? 1.0 : 0.7,
                          child: IgnorePointer(
                            ignoring: !buttonsEnabled,
                            child: BuildButton(
                              onPressed: buttonsEnabled
                                  ? () {
                                showConfirmDialog(
                                  context,
                                  "assets/images/Deck-Dialogue4.png",
                                  "Save Changes?",
                                  "Are you sure you want to save changes made?",
                                  "Save",
                                      () async {
                                    try {
                                      if (_questionOrTermController.text.trim().isEmpty) {
                                        await Future.delayed(const Duration(milliseconds: 300));
                                        showAlertDialog(context, "assets/images/Deck-Dialogue1.png","Uh oh. Something went wrong","Input Error. This flash card requires a term/question. Please try again.");
                                        return;
                                      }
                                      if (_descriptionOrAnswerController.text.trim().isEmpty) {
                                        await Future.delayed(const Duration(milliseconds: 300));
                                        showAlertDialog(context, "assets/images/Deck-Dialogue1.png","Uh oh. Something went wrong","Input Error. This flash card requires a description/answer. Please try again.");
                                    return;
                                      }
                                      if (widget.card.term.toString().trim() != _questionOrTermController.text.toString().trim()) {
                                        setState(() => _isLoading = true);
                                        await widget.card.updateQuestion(
                                          _questionOrTermController.text.toString().trim(),
                                          widget.deck.deckId,
                                        );
                                      }
                                      if (widget.card.definition.toString() != _descriptionOrAnswerController.text.toString()) {
                                        setState(() => _isLoading = true);
                                        await widget.card.updateAnswer(
                                          _descriptionOrAnswerController.text.toString().trim(),
                                          widget.deck.deckId,
                                        );
                                      }
                                      await Future.delayed(const Duration(milliseconds: 300));
                                      setState(() => _isLoading = false);
                                      showAlertDialog(
                                        context,
                                        "assets/images/Deck-Dialogue3.png",
                                        "Changed flash card information!",
                                        "Successfully changed flash card information.",
                                      );
                                      setState(() {
                                        buttonsEnabled = !buttonsEnabled;
                                      });
                                    } catch (e) {
                                      print('Error saving changes $e');
                                      setState(() => _isLoading = false);
                                      showAlertDialog(
                                        context,
                                        "assets/images/Deck-Dialogue3.png",
                                        "Changed flash card information!",
                                        "Successfully changed flash card information.",
                                      );
                                    }
                                  },
                                );
                              }
                                  : () {}, // Enable button when user clicks the pencil icon
                              buttonText: 'Save Flash Card',
                              height: 50.0,
                              width: MediaQuery.of(context).size.width,
                              backgroundColor: DeckColors.accentColor,
                              textColor: DeckColors.primaryColor,
                              radius: 10.0,
                              fontSize: 16,
                              borderWidth: 2,
                              borderColor: DeckColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: BuildButton(
                          onPressed: () {
                            showDialog<bool>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return CustomConfirmDialog(
                                  title: 'Delete this flashcard?',
                                  message: 'Deleting this flashcard will permanently remove it, and it cannot be recovered',
                                  imagePath: 'assets/images/Deck-Dialogue4.png',
                                  button1: 'Delete Flashcard',
                                  button2: 'Cancel',
                                  onConfirm: () {
                                    Navigator.of(context).pop();  //Close the first dialog
                                  },
                                  onCancel: () {
                                    Navigator.of(context).pop(false); // Close the first dialog on cancel
                                  },
                                );
                              },
                            );
                            /*showConfirmDialog(
                              context, // Pass the context
                              '',
                              'Are you sure you want to delete the card?',
                              'Deleting this will lose all data permanently.',
                              'Delete',
                                  () {
                                    print("Confirm");
                              },
                            );*/
                          },
                          buttonText: 'Delete Card',
                          height: 50.0,
                          width: MediaQuery.of(context).size.width,
                          backgroundColor: DeckColors.deckRed,
                          textColor: DeckColors.primaryColor,
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
              'assets/images/Deck-Bottom-Image1.png',
              fit: BoxFit.fitWidth,
              width: MediaQuery.of(context).size.width,
            ),
          ],
        ),
      ),
    );
  }
}
