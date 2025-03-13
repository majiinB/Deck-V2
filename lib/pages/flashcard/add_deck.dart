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
import 'package:google_fonts/google_fonts.dart';

import '../../backend/models/deck.dart';
import '../misc/custom widgets/buttons/custom_buttons.dart';
import '../misc/custom widgets/buttons/icon_button.dart';
import '../misc/custom widgets/dialogs/confirmation_dialog.dart';
import '../misc/custom widgets/images/cover_image.dart';
import '../misc/custom widgets/textboxes/textboxes.dart';
import '../misc/custom widgets/tiles/bottom_sheet.dart';
import '../misc/custom widgets/tiles/expansion_tile.dart';

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
  bool _isLoading = false;
  bool _isToggled = false;
  String coverPhoto = "no_photo";
  final TextEditingController _deckTitleController = TextEditingController();
  final TextEditingController _pickedFileController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _numCardsController = TextEditingController();
  final FlashcardService _flashCardService = FlashcardService();
  final FlashcardAiService _flashcardAiService = FlashcardAiService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        /*appBar: const DeckBar(
          title: 'add deck',
          color: DeckColors.white,
          fontSize: 24,
        ),*/
        body: _isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
            // padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      const Padding(padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Add A New Deck',
                          style: TextStyle(
                            fontFamily: 'Fraiche',
                            color: DeckColors.primaryColor,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          'Deck Title',
                          style: GoogleFonts.nunito(
                            color: DeckColors.primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      BuildTextBox(
                            controller: _deckTitleController,
                            hintText: 'Enter Deck Title'
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Deck Cover Photo (Optional)',
                      style: GoogleFonts.nunito(
                        color: DeckColors.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      BuildCoverImage(
                        // Conditionally pass CoverPhotofile based on coverPhoto value
                        coverPhotoFile: coverPhoto != 'no_photo' ? Image.file(File(coverPhoto)) : null,
                        borderRadiusContainer: 10,
                        borderRadiusImage: 10,
                        isHeader: false,
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
                                                  } else {
                                                    // User canceled the picker
                                                  }
                                                } catch (e) {
                                                  print('Error: $e');
                                                  showInformationDialog(
                                                      context,
                                                      "Error in selecting files",
                                                      "There was an error in selecting the file. Please try again.");
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
                  /*Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: BuildTextBox(
                        controller: _deckTitleController,
                        hintText: 'Enter Deck Title'
                    ),
                  ),*/
                  Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Text(
                            'AI Generated',
                            style: GoogleFonts.nunito(
                              color: DeckColors.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Spacer(),
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      'Use AI to generate flashcards',
                      style: GoogleFonts.nunito(
                        color: DeckColors.white,
                        fontSize: 16,
                        fontStyle: FontStyle.italic
                      ),
                    ),
                  ),
                  if (_isToggled) const CustomExpansionTile(),
                  if (_isToggled)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                      child: Text(
                        'Subject',
                        style: GoogleFonts.nunito(
                          color: DeckColors.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                      if (_isToggled)
                    BuildTextBox(hintText: 'Enter Subject (e.g. English)', controller: _subjectController,),
                  if (_isToggled)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                      child: Text(
                        'Topic',
                        style: GoogleFonts.nunito(
                          color: DeckColors.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                      if (_isToggled)
                    BuildTextBox(hintText: 'Enter A Topic (e.g. Verb)', controller: _topicController,),
                  if (_isToggled)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                      child: Text(
                        'Description',
                        style: GoogleFonts.nunito(
                          color: DeckColors.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                      if (_isToggled)
                    BuildTextBox(
                        hintText: 'Describe the flashcards you want to create. \n(e.g. Focus on Verbs.....)', isMultiLine: true, controller: _descriptionController,),
                      if (_isToggled)
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                          child: Text(
                            'Attach File',
                            style: GoogleFonts.nunito(
                              color: DeckColors.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
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
                          padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                          child: Text(
                            'Amount of Flashcards',
                            style: GoogleFonts.nunito(
                              color: DeckColors.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                  if (_isToggled)
                    BuildTextBox(hintText: 'Enter amount of flashcards to create', controller: _numCardsController),
                  Padding(
                    padding: const EdgeInsets.only(top: 35),
                    child: BuildButton(
                      onPressed: () {
                        showConfirmationDialog(context, "Generate Deck",
                            "Are you sure you want to generate deck?",
                        () async{
                          setState(() => _isLoading = true);
                          if(_isToggled){
                            // START OF AI
                            // Check if there is a title
                            if(_deckTitleController.text.trim().isEmpty && _numCardsController.text.trim().isNotEmpty){
                              await Future.delayed(const Duration(milliseconds: 300));
                              setState(() => _isLoading = false);
                              showInformationDialog(context, "Error adding Deck", "Your deck requires a title");
                              return;
                            }

                            //Check if the number of cards to be generate was given
                            if(_numCardsController.text.trim().isEmpty){
                              await Future.delayed(const Duration(milliseconds: 300));
                              setState(() => _isLoading = false);
                              showInformationDialog(context, "Error adding Deck", "The AI needs to know how many cards to generate");
                              return;
                            }else{
                              int? numberOfCards = int.tryParse(_numCardsController.text);
                              // Check if the number of cards is valid
                              if (numberOfCards == null || (numberOfCards < 0 && numberOfCards > 20)) {
                                await Future.delayed(const Duration(milliseconds: 300));
                                setState(() => _isLoading = false);
                                showInformationDialog(context,"Error adding Deck", "Please enter a valid integer ranging from 2-20");
                                return;
                              }
                            }

                            try {
                              String retrievedDeckId = "";
                              String fileName = "";

                              // Clean input of spaces eg "Hello    World" => "Hello World"
                              String deckTitle = FlashcardUtils().cleanSpaces(_deckTitleController.text.toString().trim());

                              // Check if the title of the the flashcard exists in the database
                              if(await _flashCardService.checkIfDeckWithTitleExists(
                                  widget.userId,
                                  deckTitle
                              )){
                                await Future.delayed(const Duration(milliseconds: 300));
                                setState(() => _isLoading = false);
                                showInformationDialog(context, "Title Already Exist", 'You already have a deck named $deckTitle');
                                return;
                              }

                              // Check if conditions are met before uploading file
                              if (_pickedFileController.text.toString().trim().isNotEmpty) {
                                fileName = await _flashCardService.uploadPdfFileToFirebase(_pickedFileController.text.toString().trim(), widget.userId.toString());
                              }

                              //GEMINI
                              if(fileName.isEmpty || fileName == ""){
                                try{
                                  // Default cover photo in firebase
                                  String uploadedPhotoUrl = 'https://firebasestorage.googleapis.com/v0/b/deck-f429c.appspot.com/o/deckCovers%2Fdefault%2FdeckDefault.png?alt=media&token=de6ac50d-13d0-411c-934e-fbeac5b9f6e0';

                                  if(coverPhoto != 'no_photo'){
                                    uploadedPhotoUrl = await _flashCardService.uploadImageToFirebase(coverPhoto, widget.userId.toString());
                                  }
                                  retrievedDeckId = await _flashcardAiService.sendAndRequestDataToGemini(
                                      coverPhotoRef: uploadedPhotoUrl,
                                      deckTitle: deckTitle,
                                      id: widget.userId,
                                      subject: _subjectController.text.trim(),
                                      topic: _topicController.text.trim(),
                                      addDescription: _descriptionController.text.trim(),
                                      numberOfQuestions: int.tryParse(_numCardsController.text) ?? 0
                                  );

                                }catch(e){
                                  print(e);
                                  await Future.delayed(const Duration(milliseconds: 300));
                                  setState(() => _isLoading = false);
                                  showInformationDialog(context, "Unknown Error Occurred",
                                      'An unknown error has occurred while generating your deck. Please try again.');
                                  return;
                                }
                              }else{
                                try{
                                  //Send and retrieve ai
                                  retrievedDeckId = await _flashcardAiService.sendAndRequestDataToGemini(
                                      deckTitle: deckTitle,
                                      id: widget.userId,
                                      subject: _subjectController.text.trim(),
                                      topic: _topicController.text.trim(),
                                      addDescription: _descriptionController.text.trim(),
                                      pdfFileName: fileName.toString(),
                                      pdfFileExtension: '.pdf',
                                      numberOfQuestions: int.tryParse(_numCardsController.text) ?? 0
                                  );
                                }on ApiException catch(e){
                                  setState(() => _isLoading = false);
                                  showInformationDialog(context, "Error while creating Deck!", e.message.toString());
                                  return;
                                }catch(e){
                                  print(e);
                                  await Future.delayed(const Duration(milliseconds: 300));
                                  setState(() => _isLoading = false);
                                  showInformationDialog(context, "Unknown Error Occurred",
                                      'An unknown error has occurred while generating your deck. Please try again.');
                                  return;
                                }
                              }

                              if (retrievedDeckId.isEmpty) {
                                await Future.delayed(const Duration(milliseconds: 300));
                                setState(() => _isLoading = false);
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
                                FlashcardService _flashcardService = FlashcardService();
                                // If sendData is successful, navigate to ViewDeckPage
                                if(_deckTitleController.text.isNotEmpty){

                                  Deck? newDeck = await _flashCardService.getDecksByUserIdAndDeckId(widget.userId, retrievedDeckId);
                                  print(newDeck);
                                  if(newDeck != null){

                                    Navigator.pop(context, newDeck);
                                    widget.decks.add(newDeck);

                                    setState(() => _isLoading = false);
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ViewDeckPage(deck: newDeck)),
                                    );
                                  }
                                }else{
                                  await Future.delayed(const Duration(milliseconds: 300)); // Ensure the dialog is fully closed
                                  setState(() => _isLoading = false);
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
                              setState(() => _isLoading = false);
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
                              setState(() => _isLoading = false);
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
                              setState(() => _isLoading = false);
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
                              setState(() => _isLoading = false);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ViewDeckPage(deck: newDeck)),
                              );
                            }else{
                              // Tell user if the deck is null because deck was not added
                              await Future.delayed(const Duration(milliseconds: 300));
                              setState(() => _isLoading = false);
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
                  ),
                ),
            ],
            ),
    ),
      ),
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
