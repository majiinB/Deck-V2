import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deck/backend/auth/auth_service.dart';
import 'package:deck/backend/task/task_provider.dart';
import 'package:deck/backend/task/task_service.dart';
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:deck/pages/task/task.dart';
import 'package:provider/provider.dart';

import '../../backend/auth/auth_utils.dart';
import '../../backend/models/task.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;
  const EditTaskPage({super.key, required this.task});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class StatusResult {
  final bool isDone;
  final bool isActive;

  StatusResult(this.isDone, this.isActive);
}

class _EditTaskPageState extends State<EditTaskPage> {
  bool isLoading = false;
  //initial values
  late String _selectedPriority;
  late int _selectedStatus;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _dateController;
  @override
  void initState() {
    super.initState();

    _dateController =
        TextEditingController(text: widget.task.deadline.toIso8601String().split("T")[0]);
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description.toString());
    _selectedPriority = widget.task.priority;
    _selectedStatus = determineStatusIndex();
  }

  int determineStatusIndex(){
    if(!widget.task.getIsDone && !widget.task.getIsActive) {
      return 0;
    } else if(!widget.task.getIsDone && widget.task.getIsActive) {return 1;}
      else {return 2;}
  }

  StatusResult checkStatus() {
    switch (_selectedStatus) {
      case 0:
        return StatusResult(false, false); // Not active, not completed
      case 1:
        return StatusResult(false, true);   // Active and completed
      case 2:
        return StatusResult(true, false);   // Not active, but completed
      default:
        return StatusResult(false, false);  // Default case
    }
  }

  Future<DateTime?> _getDeadline() async {
    final db = FirebaseFirestore.instance;
    var querySnapshot = await db.collection('tasks').where('user_id', isEqualTo: AuthService().getCurrentUser()?.uid).get();
    if(querySnapshot.docs.isNotEmpty){
      var deadline = querySnapshot.docs.first['end_date'];
      return deadline.toDate();
    }
    return null;
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDate: widget.task.deadline, //selected date ni user
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
      // appBar: const DeckBar(
      //   title: 'Edit Task',
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
                          Text('Edit a task',
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
                              fontFamily: 'Nunito',
                              color: DeckColors.primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
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
                              'Due Date',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                color: DeckColors.primaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            )
                        ),
                        BuildTextBox(
                          hintText: "Enter Due Date",
                          onTap: () => _selectDate(context), // Pass context to _selectDate method
                          controller: _dateController,
                          isReadOnly: true,
                          rightIcon: Icons.calendar_today_outlined,
                        ),
                        const Padding(
                            padding: EdgeInsets.only(top: 20,bottom: 10),
                            child:
                            Text(
                              'Description',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                color: DeckColors.primaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            )
                        ),
                        BuildTextBox(
                          hintText: "Enter Task Description",
                          showPassword: false,
                          controller: _descriptionController,
                          isMultiLine: true,
                        ),
                        const Padding(
                            padding: EdgeInsets.only(top: 20,bottom: 10),
                            child:
                            Text(
                              'Priority',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                color: DeckColors.primaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            )
                        ),
                        RadioButtonGroup(
                          buttonLabels: const ['High', 'Medium', 'Low'],
                          buttonColors: const [Colors.red, Colors.yellow, Colors.blue],
                          isClickable: true,
                          initialSelectedIndex: TaskProvider.getPriorityIndex(_selectedPriority),
                          onChange: (label, index) {
                            _selectedPriority = label;
                          },
                        ),
                        const Padding(
                            padding: EdgeInsets.only(top: 20,bottom: 10),
                            child:
                            Text(
                              'Task Status',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                color: DeckColors.primaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            )
                        ),
                        RadioButtonGroup(
                          buttonLabels: const ['To Do', 'Active', 'Done'],
                          buttonColors: const [ Colors.blue,  Colors.blue, Colors.blue],
                          isClickable: true,
                          initialSelectedIndex: _selectedStatus,
                          onChange: (label, index) {
                            _selectedStatus = index;
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
                              borderColor: Colors.transparent,
                              onPressed: () {
                                showConfirmationDialog(
                                    context,
                                    "Save Task Information",
                                    "Are you sure you want to change this task's information?",
                                        () async{
                                      setState(() => isLoading = true);
                                      if(_dateController.text.isEmpty || _titleController.text.isEmpty || _descriptionController.text.isEmpty){
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fill all the text fields before saving!')));
                                        setState(() => isLoading = false);
                                        return;
                                      }

                                      DateTime date = DateTime.parse(_dateController.text).add(const Duration(hours: 23, minutes: 59, seconds: 59));
                                      DateTime? storedDeadline = await _getDeadline();
                                      if(storedDeadline != date) {
                                        if (date.isBefore(DateTime.now())) {
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You cannot set the deadline in the past!')));
                                          setState(() => isLoading = false);
                                          return;
                                        }
                                      }
                                      setState(() => isLoading = false);
                                      StatusResult status = checkStatus();
                                      Provider.of<TaskProvider>(context, listen: false).editTask(widget.task, {
                                        'title': _titleController.text,
                                        'description': _descriptionController.text,
                                        'priority': _selectedPriority,
                                        'is_done': status.isDone,
                                        'is_active': status.isActive,
                                        'end_date': Timestamp.fromDate(DateTime.parse(_dateController.text).add(const Duration(hours: 23, minutes: 59, seconds: 59))),
                                      }).then((_) {
                                        Navigator.pop(context, TaskService().getTaskById(widget.task.uid));
                                      });
                                    }, (){}
                                );
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => TaskPage()),
                                // );
                              }),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child:
                          BuildButton(
                            buttonText: "Cancel",
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            radius: 10,
                            backgroundColor:  Colors.transparent,
                            textColor: DeckColors.white,
                            size: 16,
                            fontSize: 16,
                            borderWidth: 2,
                            borderColor: DeckColors.white,
                            onPressed: () {
                              print("Cancel button clicked");
                              Navigator.pop(context);
                            },
                          ),

                        ),
                      ],
                    ),
                  ),
                ]
            ),
          )
        // child: SingleChildScrollView(
        //   // Add a SingleChildScrollView here
        //   child: Column(
        //     children: [
        //       const Divider(
        //         color: DeckColors.white,
        //         thickness: 2,
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(top: 20),
        //         child: BuildTextBox(
        //           hintText: "Enter Task Title",
        //           showPassword: false,
        //           controller: _titleController, //initial title
        //         ),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(top: 20),
        //         child: BuildTextBox(
        //           hintText: "Enter Deadline",
        //           onTap: () => _selectDate(
        //               context), // Pass context to _selectDate method
        //           controller: _dateController,
        //           isReadOnly: true,
        //           rightIcon: Icons.calendar_today_outlined,
        //         ),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(top: 20),
        //         child: BuildTextBox(
        //           hintText: "Enter Task Description",
        //           showPassword: false,
        //           controller: _descriptionController,
        //           isMultiLine: true,
        //
        //         ),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(top: 20),
        //         child: BuildButton(
        //             buttonText: "Save",
        //             height: 50,
        //             width: MediaQuery.of(context).size.width,
        //             radius: 10,
        //             backgroundColor: DeckColors.primaryColor,
        //             textColor: DeckColors.white,
        //             size: 16,
        //             fontSize: 16,
        //             borderWidth: 0,
        //             borderColor: Colors.transparent,
        //             onPressed: () {
        //               showConfirmationDialog(
        //                   context,
        //                   "Save Task Information",
        //                   "Are you sure you want to change this task's information?",
        //                       () async{
        //                     if(_dateController.text.isEmpty || _titleController.text.isEmpty || _descriptionController.text.isEmpty){
        //                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fill all the text fields before saving!')));
        //                       return;
        //                     }
        //
        //                     DateTime date = DateTime.parse(_dateController.text).add(const Duration(hours: 23, minutes: 59, seconds: 59));
        //                     DateTime? storedDeadline = await _getDeadline();
        //                     if(storedDeadline != date) {
        //                       if (date.isBefore(DateTime.now())) {
        //                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You cannot set the deadline in the past!')));
        //                         return;
        //                       }
        //                     }
        //
        //                     Provider.of<TaskProvider>(context, listen: false).editTask(widget.task, {
        //                       'title': _titleController.text,
        //                       'description': _descriptionController.text,
        //                       'deadline': DateTime.parse(_dateController.text).add(const Duration(hours: 23, minutes: 59, seconds: 59)),
        //                     }).then((_) {
        //                       Navigator.pop(context, TaskService().getTaskById(widget.task.uid));
        //                     });
        //                   }, (){}
        //               );
        //               // Navigator.push(
        //               //   context,
        //               //   MaterialPageRoute(builder: (context) => TaskPage()),
        //               // );
        //             }),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(top: 20),
        //         child: BuildButton(
        //           buttonText: "Cancel",
        //           height: 50,
        //           width: MediaQuery.of(context).size.width,
        //           radius: 10,
        //           backgroundColor: DeckColors.white,
        //           textColor: DeckColors.primaryColor,
        //           size: 16,
        //           fontSize: 16,
        //           borderWidth: 0,
        //           borderColor: Colors.transparent,
        //           onPressed: () {
        //             print("Cancel button clicked");
        //             Navigator.pop(context);
        //           },
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}