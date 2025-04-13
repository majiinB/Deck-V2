import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deck/backend/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../backend/task/task_provider.dart';
import '../../backend/task/task_service.dart';
import '../misc/custom widgets/appbar/auth_bar.dart';
import '../misc/custom widgets/buttons/custom_buttons.dart';
import '../misc/custom widgets/buttons/radio_button_group.dart';
import '../misc/custom widgets/buttons/radio_button_group_background_image.dart';
import '../misc/custom widgets/dialogs/alert_dialog.dart';
import '../misc/custom widgets/dialogs/confirmation_dialog.dart';
import '../misc/custom widgets/textboxes/textboxes.dart';
import '../misc/deck_icons.dart';

class EditTaskFolderPage extends StatefulWidget {
  const EditTaskFolderPage({super.key});

  @override
  State<EditTaskFolderPage> createState() => _EditTaskFolderPageState();
}

class _EditTaskFolderPageState extends State<EditTaskFolderPage> {
  bool isLoading = false;
  final TextEditingController _titleController = TextEditingController();
  int selectedIndex = 3;  //TODO create a method to get the initial selected index of a folder

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: DeckColors.backgroundColor,
      appBar: AuthBar(
        automaticallyImplyLeading: true,
        title: 'Add Task Folder',
        color: DeckColors.primaryColor,
        fontSize: 24,
        onRightIconPressed: () {
        },
      ),
      body: SafeArea(
        top: true,
        bottom: false,
        left: true,
        right: true,
        child: isLoading ? const Center(child: CircularProgressIndicator()) :
        Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only( top:20,left: 30, right: 30),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Title',
                          style: TextStyle(
                              fontFamily: 'Nunito-Bold',
                              fontSize: 16,
                              color: DeckColors.primaryColor
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BuildTextBox(
                          hintText: 'Enter Folder Title',
                          showPassword: false,
                          controller: _titleController,
                        ),
                        const SizedBox(height: 20,),
                        const Text(
                          'Folder Design',
                          style: TextStyle(
                              fontFamily: 'Nunito-Bold',
                              fontSize: 16,
                              color: DeckColors.primaryColor
                          ),
                        ),

                        RBGroupImage(
                          buttonLabels: ['Cards', 'Hearts', 'Stars'],
                          initialSelectedIndex: selectedIndex,
                          buttonColors: [DeckColors.softGreen,DeckColors.deckRed,DeckColors.deckYellow],
                          buttonBackground: ['assets/images/Deck-Background9.svg','assets/images/Deck-Background7.svg','assets/images/Deck-Background8.svg'],
                        ),
                        BuildButton(
                          onPressed: () {},
                          buttonText: 'Save Task Folder',
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          radius: 10,
                          backgroundColor: DeckColors.accentColor,
                          textColor: DeckColors.primaryColor,
                          fontSize: 16,
                          borderWidth: 3,
                          borderColor: DeckColors.primaryColor,
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              Image(
                image: const AssetImage('assets/images/Deck-Bottom-Image1.png'),
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ]
        ),
      ),
    );
  }
}