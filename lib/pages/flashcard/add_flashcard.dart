import 'package:deck/pages/flashcard/add_deck.dart';
import 'package:deck/pages/flashcard/view_deck.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../backend/models/card.dart';
import '../../backend/models/deck.dart';

class AddFlashcardPage extends StatefulWidget {
  Deck deck;
  AddFlashcardPage({Key? key, required this.deck}) : super(key: key);

  @override
  _AddFlashcardPageState createState() => _AddFlashcardPageState();
}

class _AddFlashcardPageState extends State<AddFlashcardPage> {
  final TextEditingController _descriptionOrAnswerController = TextEditingController();
  final TextEditingController _questionOrTermController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DeckBar(
        title: 'Add Flash Card',
        color: DeckColors.white,
        fontSize: 24,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Simply fill in the text fields below to add flash card on your deck.',
            textAlign: TextAlign.justify,
            style: GoogleFonts.nunito(
              fontSize: 16,
              color: DeckColors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              color: DeckColors.white,
              height: 2,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40.0),
            child: BuildTextBox(
                controller: _questionOrTermController,
                hintText: 'Enter Term'
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: BuildTextBox(
                    controller: _descriptionOrAnswerController,
                    hintText: 'Enter Description',
                    isMultiLine: true
                ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 35),
            child: BuildButton(
              onPressed: () {
                showConfirmationDialog(
                  context,
                  "Add Flash Card",
                  "Are you sure you want to add this flash card on your deck?",
                      () async {
                        try {
                          if (_descriptionOrAnswerController.text.isNotEmpty &&
                              _questionOrTermController.text.isNotEmpty) {
                            Cards? card = await widget.deck.addQuestionToDeck(
                              _questionOrTermController.text.toString(),
                              _descriptionOrAnswerController.text.toString(),
                            );
                            if (card != null) {
                              await Future.delayed(Duration(milliseconds: 300));
                              Navigator.pop(context, card);
                              showInformationDialog(context, "Card Added Successfully", "You can now view this card in you deck");
                            }
                          } else {
                            //Navigator.of(context).pop(); // Close the confirmation dialog
                            await Future.delayed(Duration(milliseconds: 300)); // Ensure the dialog is fully closed
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
        ]),
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
