import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deck/backend/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:provider/provider.dart';
import '../../backend/task/task_provider.dart';
import '../../backend/task/task_service.dart';
import '../misc/custom widgets/appbar/auth_bar.dart';
import '../misc/custom widgets/buttons/custom_buttons.dart';
import '../misc/custom widgets/buttons/radio_button_group.dart';
import '../misc/custom widgets/dialogs/alert_dialog.dart';
import '../misc/custom widgets/dialogs/confirmation_dialog.dart';
import '../misc/custom widgets/textboxes/textboxes.dart';
import '../misc/deck_icons.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
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
      resizeToAvoidBottomInset: false,
      backgroundColor: DeckColors.backgroundColor,
      appBar: AuthBar(
        automaticallyImplyLeading: true,
        title: 'Add New Task',
        color: DeckColors.primaryColor,
        fontSize: 24,
        onRightIconPressed: () {
        },
      ),
      body: SafeArea(
          top: true,
          bottom: false,
          left: false,
          right: false,
          child:
          isLoading ? const Center(child: CircularProgressIndicator())
              :
          SingleChildScrollView(
            child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top:20,left: 30, right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Title',
                          style: TextStyle(
                            fontFamily: 'Nunito-Bold',
                            color: DeckColors.primaryColor,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BuildTextBox(
                          controller: _titleController,
                          hintText: "Enter Task Title",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Start Date',
                          style: TextStyle(
                            fontFamily: 'Nunito-Bold',
                            color: DeckColors.primaryColor,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BuildTextBox(
                          hintText: "Enter Start Date",
                          onTap: () => _selectDate(context), // Pass context to _selectDate method
                          controller: _dateController,
                          isReadOnly: true,
                          rightIcon: Icons.calendar_today_outlined,
                        ), //TODO create new date controller
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Due Date',
                          style: TextStyle(
                            fontFamily: 'Nunito-Bold',
                            color: DeckColors.primaryColor,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BuildTextBox(
                          hintText: "Enter Due Date",
                          onTap: () => _selectDate(context), // Pass context to _selectDate method
                          controller: _dateController,
                          isReadOnly: true,
                          rightIcon: Icons.calendar_today_outlined,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Description',
                          style: TextStyle(
                            fontFamily: 'Nunito-Bold',
                            color: DeckColors.primaryColor,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BuildTextBox(
                          hintText: "Enter Task Description",
                          showPassword: false,
                          controller: _descriptionController,
                          isMultiLine: true,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Priority',
                          style: TextStyle(
                            fontFamily: 'Nunito-Bold',
                            color: DeckColors.primaryColor,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RadioButtonGroup(
                          buttonLabels: const ['High', 'Medium', 'Low'],
                          buttonColors: const [DeckColors.deckRed, DeckColors.deckYellow,DeckColors.deckBlue],
                          isClickable: true,
                          onChange: (label, index) {
                            _selectedPriority = label;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        BuildButton(
                            buttonText: "Create Task",
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            radius: 10,
                            backgroundColor: DeckColors.accentColor,
                            textColor: DeckColors.primaryColor,
                            size: 16,
                            fontSize: 16,
                            borderWidth: 3,
                            borderColor: DeckColors.primaryColor,
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
                                  "assets/images/Deck-Dialogue1.png",
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
                                  "assets/images/Deck-Dialogue1.png",
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

                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Image(
                    image: const AssetImage('assets/images/Deck-Bottom-Image1.png'),
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),

                ]
            ),
          )

      ),
    );
  }
}