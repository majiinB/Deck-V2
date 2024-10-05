import 'dart:io';

import 'package:deck/backend/custom_exceptions/api_exception.dart';
import 'package:deck/backend/flashcard/flashcard_ai_service.dart';
import 'package:deck/backend/flashcard/flashcard_service.dart';
import 'package:deck/backend/flashcard/flashcard_utils.dart';
import 'package:deck/backend/models/cardAi.dart';
import 'package:deck/pages/flashcard/view_deck.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../backend/models/deck.dart';

class AddDeckPage extends StatefulWidget {
  final List<Deck> decks;
  final String userId;
  const AddDeckPage({
    super.key,
    required this.decks,
    required this.userId
  });

  @override
  _AddDeckPageState createState() => _AddDeckPageState();
}

class _AddDeckPageState extends State<AddDeckPage> {
  bool _isToggled = false;
  String coverPhoto = "no_photo";
  final TextEditingController _deckTitleController = TextEditingController();
  final TextEditingController _pickedFileController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _numCardsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DeckBar(
        title: 'add deck',
        color: DeckColors.white,
        fontSize: 24,
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Upload Cover Photo Of Deck (optional)',
                  style: GoogleFonts.nunito(
                    color: DeckColors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Stack(
                children: [
                  BuildCoverImage(
                    // Conditionally pass CoverPhotofile based on coverPhoto value
                    CoverPhotofile: coverPhoto != 'no_photo' ? Image.file(File(coverPhoto)) : null,
                    borderRadiusContainer: 10,
                    borderRadiusImage: 10,
                  ),
                  Positioned(
                      top: 140,
                      right: 10,
                      child: BuildIconButton(
                        containerWidth: 40,
                        containerHeight: 40,
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                  ),
                                  child: Container(
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                    color: DeckColors.gray,
                                    child: Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: BuildContentOfBottomSheet(
                                          bottomSheetButtonText:
                                              'Upload Cover Photo',
                                          bottomSheetButtonIcon: Icons.image,
                                          onPressed: () async{
                                            try {
                                              FilePickerResult? result = await FilePicker.platform.pickFiles(
                                                type: FileType.custom,
                                                allowedExtensions: ['jpeg', 'jpg', 'png'],
                                              );

                                              if (result != null) {
                                                PlatformFile file = result.files.first;
                                                setState(() {
                                                  coverPhoto = file.path ?? 'no_photo';
                                                });
                                                print("Cover photo path: "+coverPhoto);
                                              } else {
                                                // User canceled the picker
                                              }
                                            } catch (e) {
                                              print('Error: $e');
                                              showInformationDialog(
                                                  context,
                                                  "Error in selecting files",
                                                  "There was an error in selecting the file. Please try again.");
                                              // showDialog(
                                              //   context: context,
                                              //   builder: (BuildContext context) {
                                              //     return AlertDialog(
                                              //       title: const Text('File Selection Error'),
                                              //       content: const Text('There was an error in selecting the file. Please try again.'),
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
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: BuildContentOfBottomSheet(
                                          bottomSheetButtonText:
                                              'Remove Cover Photo',
                                          bottomSheetButtonIcon:
                                              Icons.remove_circle,
                                          onPressed: () {
                                            print(coverPhoto);
                                            setState(() {
                                              coverPhoto = "no_photo";
                                            });
                                            print(coverPhoto);
                                          },
                                        ),
                                      ),
                                    ]),
                                  ),
                                );
                              });
                        },
                        icon: DeckIcons.pencil,
                        iconColor: DeckColors.white,
                        backgroundColor: DeckColors.accentColor,
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: BuildTextBox(
                    controller: _deckTitleController,
                    hintText: 'Enter Deck Title'
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      Text(
                        'AI Generated',
                        style: GoogleFonts.nunito(
                          color: DeckColors.white,
                          fontSize: 16,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Switch(
                          value: _isToggled,
                          onChanged: (value) {
                            setState(() {
                              _isToggled = value;
                            });
                          },
                          activeColor: DeckColors.primaryColor,
                          inactiveThumbColor: DeckColors.white,
                        ),
                      ),
                    ],
                  )),
              if (_isToggled) const CustomExpansionTile(),
              if (_isToggled)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: BuildTextBox(hintText: 'Enter Subject', controller: _subjectController,),
                ),
              if (_isToggled)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: BuildTextBox(hintText: 'Enter Topic', controller: _topicController,),
                ),
              if (_isToggled)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: BuildTextBox(
                      hintText: 'Enter Description', isMultiLine: true, controller: _descriptionController,),
                ),
              if (_isToggled)
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: BuildButton(
                        onPressed: () async{
                          try {
                            FilePickerResult? result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf'],
                            );

                            if (result != null) {
                              PlatformFile file = result.files.first;
                              _pickedFileController.text = file.path ?? '';
                            } else {
                              // User canceled the picker
                            }
                          } catch (e) {
                            print('Error: $e');
                            showInformationDialog(context, 'Error in selecting files!', 'There was an error in selecting the file. Please try again.');

                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return AlertDialog(
                            //       title: const Text('File Selection Error'),
                            //       content: const Text('There was an error in selecting the file. Please try again.'),
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

                        },
                        buttonText: 'Upload PDF',
                        height: 50,
                        width: 150,
                        radius: 10,
                        fontSize: 16,
                        borderWidth: 0,
                        borderColor: Colors.transparent,
                        backgroundColor: DeckColors.white,
                        textColor: DeckColors.gray,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                        child: IgnorePointer(
                          child: BuildTextBox(
                              hintText: 'File Name',
                              controller: _pickedFileController,
                          ),
                        ),
                    ),
                  ],
                ),
              if (_isToggled)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: BuildTextBox(hintText: 'Enter Number Of FlashCards', controller: _numCardsController),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 35),
                child: BuildButton(
                  onPressed: () {
                    showConfirmationDialog(context, "Generate Deck",
                        "Are you sure you want to generate deck?",
                    () async{
                      if(_isToggled){
                        // START OF AI
                        // Check if there is a title
                        if(_deckTitleController.text.trim().isEmpty && _numCardsController.text.trim().isNotEmpty){
                          await Future.delayed(const Duration(milliseconds: 300));
                          showInformationDialog(context, "Error adding Deck", "Your deck requires a title");
                          return;
                        }
                        //Check if the number of cards to be generate was given
                        if(_numCardsController.text.trim().isEmpty){
                          await Future.delayed(const Duration(milliseconds: 300));
                          showInformationDialog(context, "Error adding Deck", "The AI needs to know how many cards to generate");
                          return;
                        }else{
                          int? numberOfCards = int.tryParse(_numCardsController.text);
                          // Check if the number of cards is valid
                          if (numberOfCards == null || (numberOfCards < 0 && numberOfCards > 20)) {
                            await Future.delayed(const Duration(milliseconds: 300));
                            showInformationDialog(context,"Error adding Deck", "Please enter a valid integer ranging from 2-20");
                            return;
                          }
                        }

                        try {
                          // Initialize
                          FlashcardAiService _flashcardAiService = FlashcardAiService();
                          FlashcardService _flashcardService = FlashcardService();
                          List<Cardai> flashCardDataList = [];
                          String fileName = "";

                          // Clean input of spaces eg "Hello    World" => "Hello World"
                          String deckTitle = FlashcardUtils().cleanSpaces(_deckTitleController.text.toString().trim());

                          // Check if the title of the the flashcard exists in the database
                          if(await _flashcardService.checkIfDeckWithTitleExists(
                              widget.userId,
                              deckTitle
                          )){
                            await Future.delayed(const Duration(milliseconds: 300));
                            showInformationDialog(context, "Title Already Exist", 'You already have a deck named $deckTitle');
                            return;
                          }

                          // Check if conditions are met before uploading file
                          if (_pickedFileController.text.toString().trim().isNotEmpty) {
                            fileName = await _flashcardService.uploadPdfFileToFirebase(_pickedFileController.text.toString().trim(), widget.userId.toString());
                          }

                          try{
                            // sendData function
                            Map<String, dynamic> runAndThreadId = await _flashcardAiService.sendData(
                              id: widget.userId,
                              subject: _subjectController.text.trim(),
                              topic: _topicController.text.trim(),
                              addDescription: _descriptionController.text.trim(),
                              pdfFileName: fileName,
                              numberOfQuestions: int.tryParse(_numCardsController.text) ?? 0,
                            );

                            print(runAndThreadId); // For debug

                            // fetchData function
                            flashCardDataList = await _flashcardAiService.fetchData(
                              id: widget.userId,
                              runID: runAndThreadId['run_id'],
                              threadID: runAndThreadId['thread_id'],
                            );

                          }on ApiException catch(e){
                            showInformationDialog(context, "Error while creating Deck!", e.message.toString()
                            );
                            return;
                          }catch(e){
                            await Future.delayed(const Duration(milliseconds: 300));
                            showInformationDialog(context, "Unknown Error Occurred",
                                'An unknown error has occurred while generating your deck. Please try again.');
                            return;
                          }

                          if (flashCardDataList.isEmpty) {
                            await Future.delayed(const Duration(milliseconds: 300));
                            showInformationDialog(
                                context,
                                "AI Did Not Give A Response!",
                                'This usually happens if\n'
                                '1.) The subject, topic, or description given is inappropriate\n'
                                '2.) The request is not related to academics\n'
                                '3.) The uploaded file is a ppt converted to pdf\n'
                                '4.) There was a internet connection error\n'
                                '\nPlease check your input and try again' );

                          } else {
                            // If sendData is successful, navigate to ViewDeckPage
                            if(_deckTitleController.text.isNotEmpty){
                              FlashcardService _flashCardService = FlashcardService();

                              // Default cover photo in firebase
                              String uploadedPhotoUrl = 'https://firebasestorage.googleapis.com/v0/b/deck-f429c.appspot.com/o/deckCovers%2Fdefault%2FdeckDefault.png?alt=media&token=de6ac50d-13d0-411c-934e-fbeac5b9f6e0';

                              if(coverPhoto != 'no_photo'){
                                uploadedPhotoUrl = await _flashCardService.uploadImageToFirebase(coverPhoto, widget.userId.toString());
                              }

                              Deck? newDeck = await _flashCardService.addDeck(widget.userId, _deckTitleController.text.toString(), uploadedPhotoUrl);
                              if(newDeck != null){
                                //Loop through the list and transfer info from response to the deck
                                for(Cardai aiResponse in flashCardDataList){
                                  newDeck.addQuestionToDeck(
                                      aiResponse.question.toString(),
                                      aiResponse.answer.toString()
                                  );
                                }

                                Navigator.pop(context, newDeck);
                                widget.decks.add(newDeck);

                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ViewDeckPage(deck: newDeck)),
                                );
                              }
                            }else{
                              await Future.delayed(const Duration(milliseconds: 300)); // Ensure the dialog is fully closed
                              showInformationDialog(
                                  context,
                                  'Input Error',
                                  'Please fill out all of the input fields and try again.');
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
                          }
                        } catch (e) {
                          // Handle any errors that occur during sendData
                          print('Error: $e');
                          showInformationDialog(
                              context,
                              "An error occured",
                              "Please fill out all of the input fields and try again.");                        }
                        // END OF AI
                      }else{
                        // START OF NON AI
                        // Check if title is empty
                        if(_deckTitleController.text.trim().isEmpty) {
                          await Future.delayed(const Duration(milliseconds: 300));
                          showInformationDialog(context, "Error adding Deck", "Your deck requires a title");
                          return;
                        }

                        FlashcardService _flashcardService = FlashcardService();
                        // Default photo
                        String uploadedPhotoUrl = 'https://firebasestorage.googleapis.com/v0/b/deck-f429c.appspot.com/o/deckCovers%2Fdefault%2FdeckDefault.png?alt=media&token=de6ac50d-13d0-411c-934e-fbeac5b9f6e0';

                        // Clean input of spaces eg "Hello    World" => "Hello World"
                        String deckTitle = FlashcardUtils().cleanSpaces(_deckTitleController.text.toString().trim());

                        // Check if the title of the the flashcard exists in the database
                        if(await _flashcardService.checkIfDeckWithTitleExists(
                            widget.userId,
                            deckTitle
                        )){
                          await Future.delayed(const Duration(milliseconds: 300));
                          showInformationDialog(context, "Error adding Deck!", 'You already have a deck named $deckTitle');
                          return;
                        }

                        // Check if there is a given cover photo
                        if(coverPhoto != 'no_photo'){
                          uploadedPhotoUrl = await _flashcardService.uploadImageToFirebase(coverPhoto, widget.userId.toString());
                        }

                        // Add and initialize deck
                        Deck? newDeck = await _flashcardService.addDeck(widget.userId, _deckTitleController.text.toString(), uploadedPhotoUrl);

                        // Check if newDeck is not null before going to viewDeckPage
                        if(newDeck != null){
                          Navigator.pop(context, newDeck);

                          widget.decks.add(newDeck);

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ViewDeckPage(deck: newDeck)),
                          );
                        }else{
                          // Tell user if the deck is null because deck was not added
                          await Future.delayed(const Duration(milliseconds: 300));
                          showInformationDialog(context, "Error adding Deck", "Deck was not added please try again");
                          return;
                        }
                      }
                    }, () {
                      //when user clicks no
                      //add logic here
                    });
                  },
                  buttonText: 'Generate Deck',
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
                padding: EdgeInsets.only(top: 10),
                child: BuildButton(
                  onPressed: () {
                    print(
                        "cancel button clicked"); //line to test if working ung onPressedLogic XD
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
          )),
    );
  }
  @override
  void dispose() {
    _deckTitleController.dispose();
    _pickedFileController.dispose();
    _subjectController.dispose();
    _topicController.dispose();
    _descriptionController.dispose();
    _numCardsController.dispose();
    super.dispose();
  }
}
