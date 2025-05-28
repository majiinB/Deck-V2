import 'dart:io';

import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/custom%20widgets/buttons/custom_buttons.dart';
import 'package:deck/pages/misc/custom%20widgets/dialogs/alert_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../backend/flashcard/flashcard_service.dart';
import '../../backend/models/deck.dart';
import '../misc/custom widgets/appbar/auth_bar.dart';
import '../misc/custom widgets/buttons/icon_button.dart';
import '../misc/custom widgets/dialogs/confirmation_dialog.dart';
import '../misc/custom widgets/functions/loading.dart';
import '../misc/custom widgets/images/cover_image.dart';
import '../misc/custom widgets/textboxes/textboxes.dart';
import '../misc/custom widgets/tiles/bottom_sheet.dart';
import '../misc/deck_icons.dart';
class EditDeck extends StatefulWidget {
  final Deck deck;
  const EditDeck({super.key, required this.deck});

  @override
  _EditDeckState createState() => _EditDeckState();
}
class _EditDeckState extends State<EditDeck> {

  final TextEditingController deckTitleController = TextEditingController();
  final TextEditingController deckDescriptionController = TextEditingController();
  int wordCount = 0;

  bool _isDeckTitleChanged = false;
  bool _isDeckDescriptionChanged = false;
  bool _isCoverPhotoChanged = false;
  String originalDeckTitle = '';
  String originalDeckDescription = '';
  String? originalCoverPhoto;
  bool isLoading = false;

  String coverPhoto = "no_photo";
  ///This is used to update word count
  void updateWordCount(int count) {
    setState(() {
      wordCount = count;
    });
  }

  ///This is used to count words
  int countWords(String text) {
    if (text.trim().isEmpty) {
      return 0; //return 0 if the text is empty or only contains spaces
    }
    return text.trim().split(RegExp(r'\s+')).length;
  }

  @override
  void initState() {
    super.initState();
    // seed the controllers with the existing deck data
    deckTitleController.text       = widget.deck.title;
    deckDescriptionController.text = widget.deck.description ?? '';
    //add listener to the controllers to monitor changes made by the user in the textfields
    deckTitleController.addListener(() => _onDeckTitleChanged(deckTitleController.text));
    deckDescriptionController.addListener(() => _onDeckDescriptionChanged(deckDescriptionController.text));
  }

  ///Define the change detection methods
  void _onDeckTitleChanged(String value) {
    setState(() {
      _isDeckTitleChanged = value.trim() != widget.deck.title.trim();
    });
  }

  void _onDeckDescriptionChanged(String value) {
    setState(() {
      _isDeckDescriptionChanged = value.trim() != widget.deck.description.trim();
    });
  }

  void _updateCoverPhoto(String? newPhoto) {
    setState(() {
      coverPhoto = newPhoto ?? 'no_photo';
      _isCoverPhotoChanged = coverPhoto != originalCoverPhoto;
    });
  }

  @override
  Widget build(BuildContext context) {
    ///If changes are made, return popscope to show confirmation dialog
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
        if (_isDeckTitleChanged || _isDeckDescriptionChanged || _isCoverPhotoChanged) {
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
            Navigator.of(context).pop(true); //Allow exit
          }
        } else {
          Navigator.of(context).pop(true); //No changes, allow exit
        }
      },
      child: Scaffold(
        backgroundColor: DeckColors.backgroundColor,
        appBar: const AuthBar(
          automaticallyImplyLeading: true,
          title: 'Edit Deck',
          color: DeckColors.primaryColor,
          fontSize: 24,
        ),
        body: isLoading ? const DeckLoadingDialog(
          message: "Updating your deck…",
        ): SingleChildScrollView(
          padding: EdgeInsets.only(top: 15,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Edit A Deck',
                      style: TextStyle(
                        fontFamily: 'Fraiche',
                        fontWeight: FontWeight.bold,
                        color: DeckColors.primaryColor,
                        fontSize: 40,
                        height: 1.1,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text(
                        'Deck Title',
                        style: TextStyle(
                          fontFamily: 'Nunito-Bold',
                          color: DeckColors.primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    BuildTextBox(
                        controller: deckTitleController,
                        hintText: widget.deck.title,
                        onChanged: _onDeckTitleChanged,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Deck Cover Photo (Optional)',
                        style: TextStyle(
                          fontFamily: 'Nunito-Bold',
                          color: DeckColors.primaryColor,
                          fontSize: 16,
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
                      imageUrl: widget.deck.coverPhoto,
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
                                      color: DeckColors.white,
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
                                                  _updateCoverPhoto(file.path);
                                                  setState(() {
                                                    coverPhoto = file.path ?? 'no_photo';
                                                  });
                                                  print("Cover photo path: "+coverPhoto);
                                                } else {
                                                  // User canceled the picker
                                                }
                                              } catch (e) {
                                                print('Error: $e');
                                                showAlertDialog(
                                                    context,"assets/images/Deck-Dialogue1.png",
                                                    "Error in selecting files",
                                                    "File selection failed. Try again."
                                                );
                                              }
                                              Navigator.pop(context);
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
                                                _updateCoverPhoto(null);
                                              });
                                              print(coverPhoto);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                      ]),
                                    ),
                                  );
                                });
                          },
                          icon: DeckIcons.pencil,
                          iconColor: DeckColors.primaryColor,
                          backgroundColor: DeckColors.white,
                        )),
                  ],
                ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            'Deck Description',
                            style: TextStyle(
                              fontFamily: 'Nunito-Bold',
                              color: DeckColors.primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Spacer(),
                        Text(
                          '$wordCount word(s)',
                          style: const TextStyle(
                            fontFamily: 'Nunito-Bold',
                            color: DeckColors.primaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    BuildTextBox(
                      controller: deckDescriptionController,
                      hintText: widget.deck.description,
                      isMultiLine: true,
                      wordLimit: 201,
                      onChanged: (text) {
                        int count = countWords(text);
                        updateWordCount(count);
                      },
                    ),
                    const Text(
                      'You can enter up to 200 words only.',
                      style: TextStyle(
                        fontFamily: 'Nunito-Regular',
                        color: DeckColors.primaryColor,
                        fontSize: 12,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: BuildButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            if(!_isDeckTitleChanged && !_isDeckDescriptionChanged && coverPhoto == 'no_photo'){
                              setState(() {
                                isLoading = false;
                              });
                              showAlertDialog(
                                  context,
                                  'assets/images/Deck-Dialogue1.png',
                                  'Deck Update Error',
                                  'At least one of the deck information must be changed to update the deck'
                              );
                              return;
                            }

                            try{
                              Map<String, dynamic> requestBody = {};
                              if(_isDeckTitleChanged){
                                requestBody['deckTitle'] = deckTitleController.text;
                                widget.deck.title = deckTitleController.text;
                              }
                              if(_isDeckDescriptionChanged){
                                requestBody['deckDescription'] = deckDescriptionController.text;
                                widget.deck.description = deckTitleController.text;
                              }

                              setState(() {
                                isLoading = true;
                              });

                              if(coverPhoto != 'no_photo'){
                                FlashcardService flashcardService = FlashcardService();
                                String uploadedPhotoUrl = await flashcardService.uploadImageToFirebase(
                                    coverPhoto,
                                    widget.deck.userId.toString()
                                );
                                requestBody['coverPhoto'] = uploadedPhotoUrl;
                                widget.deck.coverPhoto = uploadedPhotoUrl;
                              }

                              await widget.deck.updateDeckInfo(requestBody);
                              showAlertDialog(
                                  context,
                                  'assets/images/Deck-Dialogue3.png',
                                  'Deck Successfully Updated',
                                  'Deck updated. Changes now visible in list.'
                              );
                            }catch(e){
                              showAlertDialog(
                                  context,
                                  'assets/images/Deck-Dialogue1.png',
                                  'Deck Update Error',
                                  'An Unknown Error Has Occurred During The Update. Please Try Again Later.'
                              );
                            }finally{
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          buttonText: 'Save Deck',
                          height: 50.0,
                          width: MediaQuery.of(context).size.width,
                          radius: 10.0,
                          fontSize: 16,
                          borderWidth: 2,
                          borderColor: DeckColors.primaryColor,
                          backgroundColor: DeckColors.accentColor,
                          textColor: DeckColors.primaryColor,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                      child: BuildButton(
                        onPressed: () async {
                          await widget.deck.updateDeleteStatus(true);
                          Navigator.of(context).pop();
                        },
                        buttonText: 'Delete Deck',
                        height: 50.0,
                        width: MediaQuery.of(context).size.width,
                        backgroundColor: DeckColors.deckRed,
                        textColor: DeckColors.white,
                        radius: 10.0,
                        fontSize: 16,
                        borderWidth: 2,
                        borderColor: DeckColors.primaryColor,),
                    )
                  ],
                ),
              ),

              Image.asset(
                'assets/images/Deck-Bottom-Image1.png',
                fit: BoxFit.fitWidth,
                width: MediaQuery.of(context).size.width,
              ),
            ],
          ),
        )
      ),
    );
  }
}