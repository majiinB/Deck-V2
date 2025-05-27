import 'package:deck/backend/models/TaskFolder.dart';
import 'package:deck/backend/task/task_service.dart';
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/colors.dart';
import '../misc/custom widgets/appbar/auth_bar.dart';
import '../misc/custom widgets/buttons/custom_buttons.dart';
import '../misc/custom widgets/buttons/radio_button_group_background_image.dart';
import '../misc/custom widgets/textboxes/textboxes.dart';

class EditTaskFolderPage extends StatefulWidget {
  final TaskFolder taskFolder;
  const EditTaskFolderPage({super.key, required this.taskFolder});

  @override
  State<EditTaskFolderPage> createState() => _EditTaskFolderPageState();
}

class _EditTaskFolderPageState extends State<EditTaskFolderPage> {
  bool isLoading = false;
  late TextEditingController _titleController;
  int selectedIndex = 0;  //TODO create a method to get the initial selected index of a folder
  String selectedBackground = "";
  final TaskService _taskService = TaskService();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.taskFolder.title);
    selectedBackground = widget.taskFolder.background;
    getSelectedIndexForBG(selectedBackground);
  }

  void getSelectedIndexForBG (String background){
    if (background == "assets/images/Deck-Background9.svg") {
      setState(() {
        selectedIndex = 0;
      });
    }else if (background == "assets/images/Deck-Background7.svg") {
      setState(() {
        selectedIndex = 2;
      });
    }else if(background == "assets/images/Deck-Background8.svg") {
      setState(() {
        selectedIndex = 1;
      });
    }
  }

  void saveTaskFolder() async{
    final taskFolderId = widget.taskFolder.id;
    String? title = _titleController.text.toString().trim();
    String? background = selectedBackground;

    if(title == widget.taskFolder.title || title.isEmpty){
      title = null;
    }
    if(background == widget.taskFolder.title || background.isEmpty){
      background = null;
    }
    try{
      await _taskService.updateTaskFolder(
          taskFolderId: taskFolderId,
          title: title,
          background: background
      );
      Navigator.pop(context);
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: DeckColors.backgroundColor,
      appBar: AuthBar(
        automaticallyImplyLeading: true,
        title: 'Edit Task Folder',
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
                          hintText: widget.taskFolder.title,
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
                          onChange: (String label, int index){
                            setState(() {
                              switch (index) {
                                case 0:
                                  selectedBackground = 'assets/images/Deck-Background9.svg';
                                  break;
                                case 2:
                                  selectedBackground = 'assets/images/Deck-Background7.svg';
                                  break;
                                case 1:
                                  selectedBackground = 'assets/images/Deck-Background8.svg';
                                  break;
                                default:
                                  selectedBackground = 'assets/images/Deck-Background9.svg';
                              }
                            });
                          },
                        ),
                        BuildButton(
                          onPressed: () {
                            saveTaskFolder();
                          },
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