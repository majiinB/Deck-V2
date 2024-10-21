import 'package:deck/backend/models/task.dart';
import 'package:deck/backend/task/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:deck/pages/task/edit_task.dart';
import 'package:provider/provider.dart';

class ViewTaskPage extends StatefulWidget {
  final Task task;
  final bool isEditable;
  const ViewTaskPage({super.key, required this.task, required this.isEditable});

  @override
  State<ViewTaskPage> createState() => _ViewTaskPageState();
}

class _ViewTaskPageState extends State<ViewTaskPage> {
  //initial values
  late final TextEditingController _dateController;
  late Task _task;
  late String title,description,deadline;
  @override
  void initState() {
    super.initState();
    title = 'a high priority Task Title Number';
    deadline = 'March 19, 2024';
    description = 'This is a sample description of a high priority task title.';
    _task = widget.task;
    _dateController = TextEditingController(text: widget.task.deadline.toString().split(" ")[0]);
  }

  void _updateTask(Task updatedTask) {
    setState(() {
      _task = updatedTask;
      _dateController.text = _task.deadline.toString().split(" ")[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: DeckBar(
      //   title: "Task",
      //   color: DeckColors.white,
      //   fontSize: 24,
      //   icon: widget.isEditable ? Icons.edit : null,
      //   // icon: DeckIcons.pencil,
      //   iconColor: Colors.white,
      //   onPressed: () async {
      //     // Navigate to the second page
      //     final updatedTask = await Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => EditTaskPage(task: _task)),
      //     );
      //     if (updatedTask != null) {
      //       _updateTask(updatedTask);
      //       await Provider.of<TaskProvider>(context,listen: false).loadTasks();
      //     }
      //   },
      // ),

      body: SafeArea(
          top: true,
          bottom: false,
          left: true,
          right: true,
          minimum: const EdgeInsets.only(left: 20, right: 20),
          child:  SingleChildScrollView(
            child: Column(
                children: [
                  const Image(
                    image: AssetImage('assets/images/AddDeck_Header.png'),
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.list,
                        color: DeckColors.white,
                        size: 24),
                      onPressed: () {
                        //put navigator to edit taks page here
                        })
                      ,
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
                        Padding(padding: EdgeInsets.only(top: 10),
                          child:
                          Text( title, // title of task

                            style: TextStyle(
                              fontFamily: 'Fraiche',
                              color: DeckColors.primaryColor,
                              fontSize: 52,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),

                        Padding(
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
                          initialValue: description,
                          hintText: "Enter Task Description",
                          showPassword: false,
                          isMultiLine: true,
                          isReadOnly: true,
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
                          buttonLabels: ['High', 'Medium', 'Low'],
                          buttonColors: [Colors.red, Colors.yellow, Colors.blue],
                          isClickable: false,
                          initialSelectedIndex:1,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child:
                          BuildButton(
                            buttonText: "Back",
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
                              print("Back button clicked");
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
