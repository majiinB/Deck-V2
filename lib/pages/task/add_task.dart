import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deck/backend/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:provider/provider.dart';

import '../../backend/task/task_provider.dart';
import '../../backend/task/task_service.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
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
                fontFamily: 'nunito',
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
      appBar: const DeckBar(
        title: 'Add New Task',
        color: DeckColors.white,
        fontSize: 24,
      ),
      body: SafeArea(
        top: true,
        bottom: false,
        left: true,
        right: true,
        minimum: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Divider(
                color: DeckColors.white,
                thickness: 2,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: BuildTextBox(
                  hintText: "Enter Task Title",
                  showPassword: false,
                  controller: _titleController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: BuildTextBox(
                  hintText: "Enter Deadline",
                  onTap: () => _selectDate(
                      context), // Pass context to _selectDate method
                  controller: _dateController,
                  isReadOnly: true,
                  rightIcon: Icons.calendar_today_outlined,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: BuildTextBox(
                  hintText: "Enter Task Description",
                  showPassword: false,
                  controller: _descriptionController,
                  isMultiLine: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: BuildButton(
                    buttonText: "Save",
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    radius: 10,
                    backgroundColor: DeckColors.primaryColor,
                    textColor: DeckColors.white,
                    size: 16,
                    fontSize: 16,
                    borderWidth: 0,
                    borderColor: Colors.transparent,
                    onPressed: () async {
                      ///loading dialog
                      showLoad(context);

                      if(_dateController.text.isEmpty || _titleController.text.isEmpty || _descriptionController.text.isEmpty){
                        /// stop loading
                        hideLoad(context);
                        ///display error
                        showInformationDialog(context, "Error adding task","A Text field is blank! Please fill all the text fields and try again.");
                        return;
                      }

                      print(DateTime.parse(_dateController.text));
                      print(DateTime.now());
                      if(DateTime.parse(_dateController.text).add(const Duration(hours: 23, minutes: 59, seconds: 59)).isBefore(DateTime.now())){
                        /// stop loading
                        hideLoad(context);
                        ///display error
                        showInformationDialog(context, "Error adding task"," Past deadlines aren't allowed. Please try again.");

                        return;
                      }

                      Map<String, dynamic> data = {
                        "user_id": AuthService().getCurrentUser()?.uid,
                        "title": _titleController.text,
                        "description" : _descriptionController.text,
                        "set_date": DateTime.now(),
                        "end_date": DateTime.parse(_dateController.text).add(const Duration(hours: 23, minutes: 59, seconds: 59)),
                        "is_done": false,
                        "is_deleted": false,
                        "done_date": DateTime.now(),
                      };
                      /// stop loading
                      hideLoad(context);
                      Provider.of<TaskProvider>(context, listen: false).addTask(data);
                      Navigator.pop(context);
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: BuildButton(
                  buttonText: "Cancel",
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  radius: 10,
                  backgroundColor: DeckColors.white,
                  textColor: DeckColors.primaryColor,
                  size: 16,
                  fontSize: 16,
                  borderWidth: 0,
                  borderColor: Colors.transparent,
                  onPressed: () {
                    print("Cancel button clicked");
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
