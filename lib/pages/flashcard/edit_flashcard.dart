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
    _descriptionOrAnswerController = TextEditingController(text: widget.card.answer.toString());
    _questionOrTermController = TextEditingController(text: widget.card.question.toString());

    ///add listeners to track changes
    _descriptionOrAnswerController.addListener(_onTextChanged);
    _questionOrTermController.addListener(_onTextChanged);
  }

  ///This method is used to compare the current text in the controllers to the original values
  void _onTextChanged() {
    setState(() {
      hasUnsavedChanges = _descriptionOrAnswerController.text.trim() != widget.card.answer.toString().trim() ||
          _questionOrTermController.text.trim() != widget.card.question.toString().trim();
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
            return ShowConfirmationDialog(
              title: 'Are you sure you want to go back?',
              text: 'If you go back now, all unsaved progress will be lost.',
              onConfirm: () {
                Navigator.of(context).pop();
              },
              onCancel: () {

              },
            );
          },
        );

        if (shouldPop == true) {
          Navigator.of(context).pop(); //allow exit
        }
      },
      child: SafeArea(
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
          /*appBar: DeckBar(
            title: 'Manage Flash Card',
            color: DeckColors.white,
            fontSize: 24,
            icon: DeckIcons.pencil,
            iconColor: Colors.white,
            onPressed: () {
              // Unfocus the text fields
              FocusScope.of(context).unfocus();
      
              // Hide the keyboard
              SystemChannels.textInput.invokeMethod('TextInput.hide');
              setState(() {
                buttonsEnabled = !buttonsEnabled;
              });
            },
          ),*/
          body: _isLoading ? const Center(child: CircularProgressIndicator()) :
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                'Edit A Flashcard',
                                style: TextStyle(
                                  fontFamily: 'Fraiche',
                                  color: DeckColors.primaryColor,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
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
                                      showConfirmationDialog(
                                        context,
                                        "Save Changes",
                                        "Are you sure you want to save changes you made on this flash card?",
                                            () async {
                                          try {
                                            if (_questionOrTermController.text.trim().isEmpty) {
                                              await Future.delayed(const Duration(milliseconds: 300));
                                              showInformationDialog(context, "Input Error", "This flash card requires a term/question");
                                              return;
                                            }
                                            if (_descriptionOrAnswerController.text.trim().isEmpty) {
                                              await Future.delayed(const Duration(milliseconds: 300));
                                              showInformationDialog(context, "Input Error", "This flash card requires a description/answer");
                                              return;
                                            }
                                            if (widget.card.question.toString().trim() != _questionOrTermController.text.toString().trim()) {
                                              setState(() => _isLoading = true);
                                              await widget.card.updateQuestion(
                                                _questionOrTermController.text.toString().trim(),
                                                widget.deck.deckId,
                                              );
                                            }
                                            if (widget.card.answer.toString() != _descriptionOrAnswerController.text.toString()) {
                                              setState(() => _isLoading = true);
                                              await widget.card.updateAnswer(
                                                _descriptionOrAnswerController.text.toString().trim(),
                                                widget.deck.deckId,
                                              );
                                            }
                                            await Future.delayed(const Duration(milliseconds: 300));
                                            setState(() => _isLoading = false);
                                            showInformationDialog(context, "Changed flash card information!", "Successfully changed flash card information.");
                                            setState(() {
                                              buttonsEnabled = !buttonsEnabled;
                                            });
                                          } catch (e) {
                                            print('Error saving changes $e');
                                            setState(() => _isLoading = false);
                                            showInformationDialog(context, "Unknown Error Occurred",
                                                'An unknown error has occurred while editing flash card. Please try again.');
                                          }
                                        },
                                          () {
                                        },
                                      );
                                    }
                                        : () {}, // Enable button when user clicks the pencil icon
                                    buttonText: 'Save Flash Card',
                                    height: 50.0,
                                    width: MediaQuery.of(context).size.width,
                                    backgroundColor: DeckColors.primaryColor,
                                    textColor: DeckColors.white,
                                    radius: 10.0,
                                    fontSize: 16,
                                    borderWidth: 0,
                                    borderColor: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: BuildButton(
                                onPressed: () {
      
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
                    ],
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
      ),
    );
  }
}
