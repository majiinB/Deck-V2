import 'package:deck/backend/flashcard/flashcard_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import '../misc/custom widgets/functions/loading.dart';
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
  late bool isEditable;
  late bool isOwner;
  User? currentUser;
  bool hasUnsavedChanges = false;
  late final TextEditingController _descriptionOrAnswerController;
  late final TextEditingController _questionOrTermController;



  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    isEditable = false;
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

  ///Retrieve the currently signed-in user from Firebase Authentication
  void _getCurrentUser() {
    setState(() {
      currentUser = FirebaseAuth.instance.currentUser;
      isOwner = widget.deck.userId == currentUser?.uid;
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

        if (shouldPop == true) {
          Navigator.of(context).pop(); //allow exit
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: DeckColors.backgroundColor,
        appBar: AuthBar(
          automaticallyImplyLeading: true,
          title: isEditable ? 'Edit Flashcard' : 'View Flashcard',
          color: DeckColors.primaryColor,
          fontSize: 24,
          rightIcon: isOwner
              ? (isEditable ? Icons.close_rounded : DeckIcons.pencil)
              : null,
          onRightIconPressed: isOwner
              ? () {
            setState(() {
              isEditable = !isEditable;
            });
          }
              : null,
        ),
        body: _isLoading ? const DeckLoadingDialog(
          message: "Updating your flashcard…",
        ) :
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
                      if (isEditable) ... {
                          const Text(
                            'Edit Mode',
                            style: TextStyle(
                              fontFamily: 'Fraiche',
                              color: DeckColors.primaryColor,
                              fontSize: 32,
                            ),
                          ),
                          const Text (
                            'Click the \'x\' icon above to exit edit mode.',
                            style: TextStyle(
                              fontFamily: 'Nunito-Regular',
                              color: DeckColors.primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        }
                        else ... {
                          const Text(
                            'View Flashcard',
                            style: TextStyle(
                              fontFamily: 'Fraiche',
                              color: DeckColors.primaryColor,
                              fontSize: 32,
                            ),
                          ),
                          const Text (
                            'Click the pencil icon above to edit the flashcard',
                            style: TextStyle(
                              fontFamily: 'Nunito-Regular',
                              color: DeckColors.primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        },
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
                        child: IgnorePointer(
                          ignoring: !isEditable,
                          child: BuildTextBox(
                            hintText: 'Enter Term/Question',
                            controller: _questionOrTermController,
                            isReadOnly: !isEditable,
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
                        child: IgnorePointer(
                          ignoring: !isEditable,
                          child: BuildTextBox(
                            controller: _descriptionOrAnswerController,
                            hintText: 'Enter Description/Answer',
                            isMultiLine: true,
                            isReadOnly: !isEditable,
                          ),
                        ),
                      ),
                      if(isEditable)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: BuildButton(
                          onPressed: () {
                            showConfirmDialog(
                              context,
                              "assets/images/Deck-Dialogue4.png",
                              "Save Changes?",
                              "Are you sure you want to save changes made?",
                              "Save",
                              () async {
                                Navigator.of(context).pop();
                                if (_questionOrTermController.text.trim().isEmpty) {
                                  await Future.delayed(const Duration(milliseconds: 300));
                                  showAlertDialog(context, "assets/images/Deck-Dialogue1.png",
                                      "Uh oh. Something went wrong",
                                      "Please add a term or question to continue.");
                                  return;
                                }
                                if (_descriptionOrAnswerController.text.trim().isEmpty) {
                                  await Future.delayed(const Duration(milliseconds: 300));
                                  showAlertDialog(context, "assets/images/Deck-Dialogue1.png",
                                      "Uh oh. Something went wrong",
                                      "Please add a description or answer to continue.");
                                  return;
                                }

                                if(_questionOrTermController.text.trim() == widget.card.term &&
                                  _descriptionOrAnswerController.text.trim() == widget.card.definition){
                                  showAlertDialog(context, "assets/images/Deck-Dialogue1.png",
                                      "Uh oh. Something went wrong",
                                      "At least one field needs to be changed to proceed with the update");
                                  return;
                                }
                                try {
                                  Map<String, dynamic> requestBody = {};
                                  if (widget.card.term.toString().trim() != _questionOrTermController.text.toString().trim()) {
                                    requestBody['term'] = _questionOrTermController.text.toString().trim();
                                    widget.card.term = _questionOrTermController.text.toString().trim();
                                  }
                                  if (widget.card.definition.toString() != _descriptionOrAnswerController.text.toString()) {
                                    requestBody['definition'] = _descriptionOrAnswerController.text.toString().trim();
                                    widget.card.definition = _descriptionOrAnswerController.text.toString().trim();
                                  }
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await widget.card.updateAnswer(widget.deck.deckId, requestBody);
                                  showAlertDialog(
                                    context,
                                    "assets/images/Deck-Dialogue3.png",
                                    "Changed flash card information!",
                                    "Successfully changed flash card information!",
                                  );
                                  await Future.delayed(const Duration(milliseconds: 300)); // optional small delay for UX
                                } catch (e) {
                                  setState(() => _isLoading = false);
                                  showAlertDialog(
                                    context,
                                    "assets/images/Deck-Dialogue3.png",
                                    "An Unknown Error Occurred",
                                    "An unknown error occurred preventing your flashcard to be update. Please try again later.",
                                  );
                                } finally{
                                  setState(() {
                                    isEditable = false;
                                    _isLoading = false;
                                  });
                                }
                              },
                            );
                          },
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
                      Padding(
                        padding: EdgeInsets.only(top: isEditable? 10 : 20),
                        child: BuildButton(
                          onPressed: () {
                            showDialog<bool>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return CustomConfirmDialog(
                                  title: 'Delete this flashcard?',
                                  message: 'Once deleted, this flashcard cannot be restored.',
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
