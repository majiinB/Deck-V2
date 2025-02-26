import 'package:deck/pages/flashcard/add_deck.dart';
import 'package:deck/pages/flashcard/view_deck.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/widget_method.dart';
// import 'package:google_fonts/google_fonts.dart';
import '../../backend/models/card.dart';
import '../../backend/models/deck.dart';
import '../misc/custom widgets/buttons/custom_buttons.dart';
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
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        /*appBar: const DeckBar(
          title: 'Add Flash Card',
          color: DeckColors.white,
          fontSize: 24,
        ),*/
        body: _isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Image(
                  image: AssetImage('assets/images/AddDeck_Header.png'),
                  fit: BoxFit.cover,
                ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(padding: EdgeInsets.only(top: 10, bottom: 20),
                    child: Text(
                      'Add A New FlashCard To The Deck',
                      style: TextStyle(
                        fontFamily: 'Fraiche',
                        color: DeckColors.primaryColor,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const Text(
                    'Simply fill in the text fields below to add flash card on your deck.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontFamily: 'Nunito-Regular',
                      fontSize: 16,
                      color: DeckColors.white,
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
                        showConfirmationDialog(
                          context,
                          "Add Flash Card",
                          "Are you sure you want to add this flash card on your deck?",
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
                                      showInformationDialog(context, "Card Added Successfully", "You can now view this card in you deck");
                                    }
                                  } else {
                                    //Navigator.of(context).pop(); // Close the confirmation dialog
                                    await Future.delayed(const Duration(milliseconds: 300)); // Ensure the dialog is fully closed
                                    setState(() => _isLoading = false);
                                    showInformationDialog(
                                        context,
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
                                  showInformationDialog(
                                      context,
                                      "An error occured" ,
                                      "An unknown error occured. Please try again.");
                                }
                              },
                              () {
                            // when user clicks no
                            // add logic here
                              },
                        );
                      },
                      buttonText: 'Save Changes',
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
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: BuildButton(
                      onPressed: () {
                        print(
                            "cancel button clicked");
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
          ]),
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
