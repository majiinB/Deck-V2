import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deck/backend/auth/auth_service.dart';
import 'package:deck/backend/models/TaskFolder.dart';
import 'package:deck/pages/task/view_task_folder.dart';
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
import '../misc/widget_method.dart';

class AddTaskFolderPage extends StatefulWidget {
  const AddTaskFolderPage({super.key});

  @override
  State<AddTaskFolderPage> createState() => _AddTaskFolderPageState();
}

class _AddTaskFolderPageState extends State<AddTaskFolderPage> {
  bool isLoading = false;
  String background = "assets/images/Deck-Background9.svg";
  final TaskService _taskService = TaskService();
  final TextEditingController _titleController = TextEditingController();


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
                          buttonColors: [DeckColors.softGreen,DeckColors.deckRed,DeckColors.deckYellow],
                          buttonBackground: ['assets/images/Deck-Background9.svg','assets/images/Deck-Background7.svg','assets/images/Deck-Background8.svg'],
                          onChange: (String label, int index){
                            setState(() {
                              switch (index) {
                                case 0:
                                  background = 'assets/images/Deck-Background9.svg';
                                  break;
                                case 1:
                                  background = 'assets/images/Deck-Background7.svg';
                                  break;
                                case 2:
                                  background = 'assets/images/Deck-Background8.svg';
                                  break;
                                default:
                                  background = 'assets/images/Deck-Background9.svg';
                              }
                            });
                          },
                        ),
                        BuildButton(
                          onPressed: () async{
                            String taskFolderTitle = _titleController.text.toString().trim();
                            DateTime timeStamp = DateTime.now();
                            setState(() {
                              isLoading = true;
                            });
                            try{
                              await _taskService.createTaskFolder(
                                  title: taskFolderTitle,
                                  background: background,
                                  timeStamp: timeStamp
                              );
                              TaskFolder newTaskFolder = TaskFolder(
                                  title: taskFolderTitle,
                                  background: background,
                                  timestamp: timeStamp,
                                  isDeleted: false
                              );
                              Navigator.of(context).pop(newTaskFolder);
                            }catch(e){
                              print(e);
                            }finally{
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          buttonText: 'Create Task Folder',
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