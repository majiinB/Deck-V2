import 'package:deck/backend/models/newTask.dart';
import 'package:deck/backend/models/task.dart';
import 'package:deck/backend/task/task_provider.dart';
import 'package:deck/pages/misc/deck_icons2.dart';
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/widget_method.dart';
// import 'package:deck/pages/task/edit_task.dart';
import 'package:provider/provider.dart';

import '../misc/custom widgets/appbar/auth_bar.dart';
import '../misc/custom widgets/buttons/custom_buttons.dart';
import '../misc/custom widgets/buttons/radio_button_group.dart';
import '../misc/custom widgets/dialogs/confirmation_dialog.dart';
import '../misc/custom widgets/textboxes/textboxes.dart';

class ViewTaskPage extends StatefulWidget {
  final NewTask task;
  final bool isEditable;
  const ViewTaskPage({super.key, required this.task, required this.isEditable});

  @override
  State<ViewTaskPage> createState() => _ViewTaskPageState();
}

class _ViewTaskPageState extends State<ViewTaskPage> {
  late int _selectedStatus;
  //initial values
  late final TextEditingController _endDateController;
  late final TextEditingController _startDateController;
  late final TextEditingController _descriptionController;
  late NewTask _task;
  late String title,description,deadline;
  late int _priorityIndex;
  late bool isEditable;

  @override
  void initState() {
    super.initState();
    isEditable = false;
    _task = widget.task;
    title = widget.task.title;
    _priorityIndex = TaskProvider.getPriorityIndex(_task.priority);
    deadline = getNameDate(widget.task.endDate);
    _descriptionController = TextEditingController(text: widget.task.description.toString());
    _startDateController = TextEditingController(text: widget.task.startDate.toString().split(" ")[0]);
    _endDateController = TextEditingController(text: widget.task.doneDate.toString().split(" ")[0]);
    _selectedStatus = determineStatusIndex(widget.task);
  }

  int determineStatusIndex(NewTask task){
    if(task.status.toString().toLowerCase() == "pending") {
      return 0;
    } else if(task.status.toString().toLowerCase() == "in progress") {return 1;}
    else {return 2;}
  }

  // StatusResult checkStatus() {
  //   switch (_selectedStatus) {
  //     case 0:
  //       return StatusResult(false, false); // Not active, not completed
  //     case 1:
  //       return StatusResult(false, true);   // Active and completed
  //     case 2:
  //       return StatusResult(true, false);   // Not active, but completed
  //     default:
  //       return StatusResult(false, false);  // Default case
  //   }
  // }

  // void _updateTask(Task updatedTask) {
  //   setState(() {
  //     _task = updatedTask;
  //     title = _task.title;
  //     _priorityIndex = TaskProvider.getPriorityIndex(_task.priority);
  //     deadline = TaskProvider.getNameDate(_task.deadline);
  //     _descriptionController.text = _task.description;
  //     _startDateController.text = _task.deadline.toString().split(" ")[0];//todo
  //     _endDateController.text = _task.deadline.toString().split(" ")[0];
  //     _selectedStatus = determineStatusIndex(updatedTask);
  //   });
  // }

  String getNameDate(DateTime date){
    List<String> months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];

    String month = months[date.month - 1]; // Get the month name
    String day = date.day.toString(); // Get the day
    String year = date.year.toString(); // Get the year

    return '$month $day, $year';
  }

  Color getPriorityColor(int priority){
    Color color = DeckColors.white;
    if(priority == 0) { color = DeckColors.deckRed;}
    else if(priority == 1) { color = DeckColors.deckYellow;}
    else if(priority == 2) { color = DeckColors.deckBlue;}
    else{color = DeckColors.white;}
    return color;
  }
  String getPriorityText(int priority){
    String prio = "";
    if(priority == 0) { prio = "High";}
    else if(priority == 1) { prio = "Medium";}
    else if(priority == 2) {prio = "Low";}
    else{prio = "";}
    return prio;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AuthBar(
        title: "View task",
        automaticallyImplyLeading: true,
        color: DeckColors.primaryColor,
        fontSize: 24,
        rightIcon: isEditable ? Icons.close_rounded : Icons.edit,
        onRightIconPressed: () async {
          setState(() {
            isEditable = !isEditable;
          });
          // // Navigate to the second page
          // final updatedTask = await Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => EditTaskPage(task: _task)),
          // );
          // if (updatedTask != null) {
          //   _updateTask(updatedTask);
          //   await Provider.of<TaskProvider>(context,listen: false).loadTasks();
          // }
        },
      ),
      body: SafeArea(
          top: true,
          bottom: false,
          left: true,
          right: true,
          minimum: const EdgeInsets.only(left: 0, right: 0),
          child:  SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:40.0,right:40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(isEditable) ... {
                          const Text(
                            'View A Task',
                            style: TextStyle(
                              fontFamily: 'Nunito-Bold',
                              color: DeckColors.primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        }
                        else ... {
                          const Text(
                            'Edit Mode',
                            style: TextStyle(
                              fontFamily: 'Nunito-Bold',
                              color: DeckColors.primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        },
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Title',
                          style: TextStyle(
                            fontFamily: 'Nunito-Bold',
                            color: DeckColors.primaryColor,
                            fontSize: 16,
                          ),
                        ),
                        BuildTextBox(
                          hintText: title,
                          isReadOnly: isEditable,
                        ),
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
                        BuildTextBox(
                          hintText: deadline,
                          isReadOnly: isEditable,
                          rightIcon: Icons.calendar_today_outlined,
                        ),
                        const Text(
                          'Due Date',
                          style: TextStyle(
                            fontFamily: 'Nunito-Bold',
                            color: DeckColors.primaryColor,
                            fontSize: 16,
                          ),
                        ),
                        BuildTextBox(
                          hintText: deadline,
                          isReadOnly: true,
                          rightIcon: Icons.calendar_today_outlined,
                        ),
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontFamily: 'Nunito-Bold',
                            color: DeckColors.primaryColor,
                            fontSize: 16,
                          ),
                        ),
                        BuildTextBox(
                          controller: _descriptionController,
                          hintText: "Task Description",
                          showPassword: false,
                          isMultiLine: true,
                          isReadOnly: isEditable,
                        ),
                        if(isEditable)... {
                          const Text(

                            'Priority',
                            style: TextStyle(
                              fontFamily: 'Nunito-Bold',
                              color: DeckColors.primaryColor,
                              fontSize: 16,
                            ),
                          ),
                          RadioButtonGroup(
                          buttonLabels: const ['High', 'Medium', 'Low'],
                          buttonColors: const [DeckColors.deckRed, DeckColors.deckYellow, DeckColors.deckBlue],
                          isClickable: isEditable,
                          initialSelectedIndex: _priorityIndex,
                          onChange: (label, index) {
                            setState(() {
                              _priorityIndex = index; // Update _priorityIndex when user interacts with it
                            });
                          },
                        )}
                        else... {
                          Row(
                            children: [
                              const Text(

                                'Priority',
                                style: TextStyle(
                                  fontFamily: 'Nunito-Bold',
                                  color: DeckColors.primaryColor,
                                  fontSize: 16,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                decoration: BoxDecoration(
                                  color: getPriorityColor(_priorityIndex),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: DeckColors.primaryColor, width: 2),
                                ),
                                child: Text(
                                  getPriorityText(_priorityIndex),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: DeckColors.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          )
                        }
                        ,
                        const Text(
                          'Status',
                          style: TextStyle(
                            fontFamily: 'Nunito-Bold',
                            color: DeckColors.primaryColor,
                            fontSize: 16,
                          ),
                        ),
                        RadioButtonGroup(
                          buttonLabels: const ['Pending', 'In Progress', 'Complete'],
                          buttonColors: const [ DeckColors.primaryColor, DeckColors.primaryColor, DeckColors.primaryColor],
                          isClickable: true,
                          initialSelectedIndex: _selectedStatus,
                          onChange: (label, index) {
                            setState((){
                              _selectedStatus = index;
                            });
                          }
                        ),
                        if(isEditable)BuildButton(
                            buttonText: "Save Task",
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            radius: 10,
                            backgroundColor: DeckColors.accentColor,
                            textColor: DeckColors.primaryColor,
                            size: 16,
                            fontSize: 16,
                            borderWidth: 2,
                            borderColor: DeckColors.primaryColor,
                            onPressed: () {
                              print("Save button pressed");
                              showConfirmDialog(
                                  context,
                                  "assets/images/Deck-Dialogue4.png",
                                  "Save Task?",
                                  "",
                                  "Save",
                                      () {
                                  });
                            },
                          ),
                        BuildButton(
                          buttonText: "Delete Task",
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          radius: 10,
                          backgroundColor: DeckColors.deckRed,
                          textColor: DeckColors.primaryColor,
                          size: 16,
                          fontSize: 16,
                          borderWidth: 2,
                          borderColor: DeckColors.primaryColor,
                          onPressed: () {
                            print("delete button pressed");
                            showConfirmDialog(
                                context,
                                "assets/images/Deck-Dialogue4.png",
                                "Delete Task?",
                                "Are you sure you want to delete ?",
                                "Delete Task",
                                    () {
                                  // Provider.of<TaskProvider>(context,
                                  //     listen: false)
                                  //     .deleteTask(tasks[index].uid);
                                });
                          },
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

      // body: SafeArea(
      //   top: true,
      //   bottom: false,
      //   left: true,
      //   right: true,
      //   minimum: const EdgeInsets.only(left: 20, right: 20),
      //   child: SingleChildScrollView(
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.stretch,
      //       children: [
      //         Padding(
      //           padding: const EdgeInsets.symmetric(vertical: 20),
      //           child: Text(
      //             _task.title,
      //             style: const TextStyle(
      //               fontFamily: 'Fraiche',
      //               fontSize: 20,
      //               color: DeckColors.white,
      //             ),
      //             textAlign: TextAlign.justify,
      //           ),
      //         ),
      //         const Divider(
      //           color: DeckColors.white,
      //           thickness: 2,
      //         ),
      //         Padding(
      //           padding: const EdgeInsets.symmetric(vertical: 20),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               const Text(
      //                 "Task Deadline",
      //                 style: TextStyle(
      //                   fontFamily: 'nunito',
      //                   fontSize: 16,
      //                   color: DeckColors.white,
      //                   fontWeight: FontWeight.w900,
      //                 ),
      //               ),
      //               Text(
      //                 _task.deadline.toString().split(" ")[0],
      //                 style: const TextStyle(
      //                   fontFamily: 'nunito',
      //                   fontSize: 16,
      //                   color: DeckColors.white,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //         const Divider(
      //           color: DeckColors.white,
      //           thickness: 2,
      //         ),
      //         Padding(
      //           padding: const EdgeInsets.symmetric(vertical: 20),
      //           child: Text(
      //             _task.description,
      //             style: const TextStyle(
      //               fontFamily: 'nunito',
      //               fontSize: 16,
      //               color: DeckColors.white,
      //             ),
      //             textAlign: TextAlign.justify,
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
