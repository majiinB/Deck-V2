import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deck/backend/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:provider/provider.dart';
import '../../backend/task/task_provider.dart';
import '../../backend/task/task_service.dart';
import '../misc/custom widgets/buttons/custom_buttons.dart';
import '../misc/custom widgets/buttons/radio_button_group.dart';
import '../misc/custom widgets/dialogs/alert_dialog.dart';
import '../misc/custom widgets/dialogs/confirmation_dialog.dart';
import '../misc/custom widgets/textboxes/textboxes.dart';

class AddTaskFolderPage extends StatefulWidget {
  const AddTaskFolderPage({super.key});

  @override
  State<AddTaskFolderPage> createState() => _AddTaskFolderPageState();
}

class _AddTaskFolderPageState extends State<AddTaskFolderPage> {
  bool isLoading = false;
  late String _selectedPriority = "High";
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030), //edit nyo nlng toh
      initialDate: DateTime.now(),
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
      fieldHintText: 'Month/Day/Year',
      fieldLabelText: 'Date Deadline',

      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: const TextTheme(
              titleSmall: TextStyle(
                fontFamily: 'Fraiche',
                fontSize: 20,
              ),
              headlineLarge: TextStyle(
                fontFamily: 'Fraiche',
                fontSize: 40,
              ),
              labelLarge: TextStyle(
                fontFamily: 'Fraiche',
                fontSize: 20,
              ),
              bodyLarge: TextStyle(
                fontFamily: 'Nunito-Regular',
                fontSize: 16,
              ),
            ),
            colorScheme: Theme.of(context).colorScheme.copyWith(
              // Title, selected date and day selection background (dark and light mode)
              surface: DeckColors.backgroundColor,
              primary: DeckColors.primaryColor,
              // Title, selected date and month/year picker color (dark and light mode)
              onSurface: DeckColors.white,
              onPrimary: DeckColors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(
                  fontFamily: 'Fraiche',
                  fontSize: 20,
                ),
                shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: Colors.transparent,
                        width: 1,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(50)),
                padding: const EdgeInsets.symmetric(
                  vertical: 25,
                  horizontal: 20,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      _dateController.text = pickedDate
          .toString()
          .split(" ")[0]; // Update text in the controller with selected date
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const DeckBar(
      //   title: 'Add New Task',
      //   color: DeckColors.white,
      //   fontSize: 24,
      // ),
      body: SafeArea(
          top: true,
          bottom: false,
          left: true,
          right: true,
          minimum: const EdgeInsets.only(left: 20, right: 20),
          child: isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
            child: Column(
                children: [
                  const Image(
                    image: AssetImage('assets/images/AddDeck_Header.png'),
                    fit: BoxFit.cover,
                  ),
                  // const Divider(
                  //   color: DeckColors.white,
                  //   thickness: 2,
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(padding: EdgeInsets.only(top: 10),
                          child:
                          Text('Add a New task',
                            style: TextStyle(
                              fontFamily: 'Fraiche',
                              color: DeckColors.primaryColor,
                              fontSize: 52,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 20,bottom: 10),
                          child: Text(
                            'Title',
                            style: TextStyle(
                              fontFamily: 'Nunito-Bold',
                              color: DeckColors.primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        BuildTextBox(
                          controller: _titleController,
                          hintText: "Enter Task Title",
                        ),

                        const Padding(
                            padding: EdgeInsets.only(top: 20,bottom: 10),
                            child:
                            Text(
                              'Description',
                              style: TextStyle(
                                fontFamily: 'Nunito-Bold',
                                color: DeckColors.primaryColor,
                                fontSize: 16,
                              ),
                            )
                        ),
                        const Padding(
                            padding: EdgeInsets.only(top: 20,bottom: 10),
                            child:
                            Text(
                              'Priority',
                              style: TextStyle(
                                fontFamily: 'Nunito-Bold',
                                color: DeckColors.primaryColor,
                                fontSize: 16,
                              ),
                            )
                        ),
                        RadioButtonGroup(
                          buttonLabels: const ['High', 'Medium', 'Low'],
                          buttonColors: const [Colors.red, Colors.yellow, Colors.blue],
                          isClickable: true,
                          onChange: (label, index) {
                            _selectedPriority = label;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child:
                          BuildButton(
                              buttonText: "Save",
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              radius: 10,
                              backgroundColor: DeckColors.primaryColor,
                              textColor: DeckColors.white,
                              size: 16,
                              fontSize: 16,
                              borderWidth: 2,
                              borderColor: DeckColors.white,
                              onPressed: () async {
                                ///loading dialog
                                setState(() => isLoading = true);
                                await Future.delayed(const Duration(milliseconds: 300));
                                if(_dateController.text.isEmpty || _titleController.text.isEmpty || _descriptionController.text.isEmpty){
                                  /// stop loading
                                  setState(() => isLoading = false);
                                  ///display error
                                  showAlertDialog(
                                    context,
                                    "assets/images/Deck_Dialogue1.png",
                                    "Uh oh. Something went wrong.",
                                    "Error adding task! A text field is blank! Please fill all the text fields and try again.",
                                  );
                                  return;
                                }
                                print(DateTime.parse(_dateController.text));
                                print(DateTime.now());
                                if(DateTime.parse(_dateController.text).add(const Duration(hours: 23, minutes: 59, seconds: 59)).isBefore(DateTime.now())){
                                  /// stop loading
                                  setState(() => isLoading = false);
                                  ///display error
                                  showAlertDialog(
                                    context,
                                    "assets/images/Deck_Dialogue1.png",
                                    "Uh oh. Something went wrong.",
                                    "Error adding task! Past deadlines aren't allowed. Please try again.",
                                  );
                                  return;
                                }
                                Map<String, dynamic> data = {
                                  "user_id": AuthService().getCurrentUser()?.uid,
                                  "title": _titleController.text,
                                  "description" : _descriptionController.text,
                                  "priority": _selectedPriority,
                                  "is_done": false,
                                  "is_active": false,
                                  "set_date": DateTime.now(),
                                  "end_date": DateTime.parse(_dateController.text).add(const Duration(hours: 23, minutes: 59, seconds: 59)),
                                  "is_deleted": false,
                                  "done_date": DateTime.now(),
                                };
                                /// stop loading
                                if(mounted) {
                                  setState(() => isLoading = false);
                                }
                                Provider.of<TaskProvider>(context, listen: false).addTask(data);
                                Navigator.pop(context);
                              }
                          ),

                        ),
                      ],
                    ),
                  ),
                ]
            ),
          )
      ),
    );
  }
}