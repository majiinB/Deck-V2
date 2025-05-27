import 'package:deck/backend/models/newTask.dart';
import 'package:deck/backend/models/task.dart';
import 'package:deck/backend/task/task_provider.dart';
import 'package:deck/backend/task/task_service.dart';
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
  late String selectedStatusLabel;
  //initial values
  late final TextEditingController _endDateController;
  late final TextEditingController _startDateController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _titleController;
  late NewTask _task;
  late String title,description,deadline,startDate;
  late int _priorityIndex;
  late String priorityLabel;
  late bool isEditable;
  late DateTime selectedStartDate;
  late DateTime selectedEndDate;
  final TaskService _taskService = TaskService();

  @override
  void initState() {
    super.initState();
    isEditable = false;
    _task = widget.task;
    title = widget.task.title;
    priorityLabel = widget.task.priority;
    _priorityIndex = TaskProvider.getPriorityIndex(_task.priority);
    selectedStatusLabel = widget.task.status;
    deadline = getNameDate(widget.task.endDate);
    startDate = getNameDate(widget.task.startDate);
    _titleController = TextEditingController(text: widget.task.title.toString());
    _descriptionController = TextEditingController(text: widget.task.description.toString());
    _startDateController = TextEditingController(text: widget.task.startDate.toString().split(" ")[0]);
    _endDateController = TextEditingController(text: widget.task.doneDate.toString().split(" ")[0]);
    _selectedStatus = determineStatusIndex(widget.task);
    selectedEndDate = widget.task.endDate;
    selectedStartDate = widget.task.startDate;
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

  void onUpdateTask() async{
    final taskFolderId = widget.task.taskFolderId;
    final taskId = widget.task.taskId;

    String? title = _titleController.text.toString().trim();
    String? description = _descriptionController.text.toString().trim();
    String? status = selectedStatusLabel;
    String? priority = priorityLabel;
    DateTime? startDate = selectedStartDate;
    DateTime? endDate = selectedEndDate;

    if(title.isEmpty || title == widget.task.title){
      title = null;
    }
    if(description.isEmpty || description == widget.task.description){
      description = null;
    }
    if(status.toLowerCase() == widget.task.status.toLowerCase()){
      status = null;
    }
    if(priority.toLowerCase() == widget.task.priority.toLowerCase()){
      priority = null;
    }
    if(endDate == widget.task.endDate){
      endDate = null;
    }
    if(startDate == widget.task.startDate){
      startDate = null;
    }

    try {
      final message = await _taskService.updateTask(
        taskFolderId: taskFolderId,
        taskId: taskId,
        title: title,
        description: description,
        status: status,
        priority: priority,
        startDate: startDate,
        endDate: endDate,
      );

      print('Task updated: $message');
      // You can then show a success snackbar or navigate back, etc.
    } catch (e) {
      print('Error: $e');
      // Show error dialog or snackbar
    }
  }

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
                          controller: _titleController,
                          hintText: title,
                          isReadOnly: isEditable,
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
                        BuildTextBox(
                          hintText: startDate,
                          isReadOnly: isEditable,
                          rightIcon: Icons.calendar_today_outlined,
                          onTap: () async{
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedStartDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );

                            if (pickedDate != null) {
                              setState(() {
                                selectedStartDate = pickedDate;
                                startDate = getNameDate(pickedDate);
                              });
                            }
                          },
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
                          onTap: () async{
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedEndDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );

                            if (pickedDate != null) {
                              setState(() {
                                selectedEndDate = pickedDate;
                                deadline = getNameDate(pickedDate);
                              });
                            }
                          },
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
                              priorityLabel = label;
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
                        },
                        const Text(
                          'Status',
                          style: TextStyle(
                            fontFamily: 'Nunito-Bold',
                            color: DeckColors.primaryColor,
                            fontSize: 16,
                          ),
                        ),
                        RadioButtonGroup(
                          buttonLabels: const ['Pending', 'In Progress', 'Completed'],
                          buttonColors: const [ DeckColors.primaryColor, DeckColors.primaryColor, DeckColors.primaryColor],
                          isClickable: true,
                          initialSelectedIndex: _selectedStatus,
                          onChange: (label, index) {
                            setState((){
                              _selectedStatus = index;
                              selectedStatusLabel = label;
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
                                        onUpdateTask();
                                        Navigator.pop(context);
                                  }
                              );
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
        ),
    );
  }
}
