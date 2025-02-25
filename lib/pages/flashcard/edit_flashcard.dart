import 'package:deck/backend/flashcard/flashcard_utils.dart';
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../backend/models/deck.dart';
import '../../backend/models/card.dart';
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
  late final TextEditingController _descriptionOrAnswerController;
  late final TextEditingController _questionOrTermController;

  @override
  void initState() {
    super.initState();
    _descriptionOrAnswerController = TextEditingController(text: widget.card.answer.toString());
    _questionOrTermController = TextEditingController(text: widget.card.question.toString());
  }

  @override
  void dispose() {
    _descriptionOrAnswerController.dispose();
    _questionOrTermController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
        body: _isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Image(
                image: AssetImage('assets/images/AddDeck_Header.png'),
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: IconButton(
                    icon: const Icon(
                        DeckIcons.pencil,
                        color: DeckColors.white,
                        size: 24),
                  onPressed: () {
                    // Unfocus the text fields
                    FocusScope.of(context).unfocus();

                    // Hide the keyboard
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    setState(() {
                      buttonsEnabled = !buttonsEnabled;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
                    Text(
                      'Click the pencil icon above to enable editing of the text fields below.',
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        color: DeckColors.white,
                      ),
                    ),
                    /*Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
                        color: DeckColors.white,
                        height: 2,
                      ),
                    ),*/
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        'Title',
                        style: GoogleFonts.nunito(
                          color: DeckColors.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
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
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        'Description',
                        style: GoogleFonts.nunito(
                          color: DeckColors.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
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
                          print("cancel button clicked");
                          Navigator.pop(context);
                        },
                        buttonText: 'Cancel',
                        height: 50.0,
                        width: MediaQuery.of(context).size.width,
                        backgroundColor: DeckColors.white,
                        textColor: DeckColors.primaryColor,
                        radius: 10.0,
                        fontSize: 16,
                        borderWidth: 0,
                        borderColor: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
