import 'package:deck/backend/models/newTask.dart';
import 'package:deck/backend/models/task.dart';
import 'package:deck/backend/task/task_provider.dart';
import 'package:deck/backend/task/task_service.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:deck/pages/misc/deck_icons2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:flutter/widgets.dart';
// import 'package:deck/pages/task/edit_task.dart';
import 'package:provider/provider.dart';

import '../misc/custom widgets/appbar/auth_bar.dart';
import '../misc/custom widgets/buttons/custom_buttons.dart';
import '../misc/custom widgets/buttons/radio_button_group.dart';
import '../misc/custom widgets/dialogs/alert_dialog.dart';
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
    _startDateController = TextEditingController(text: startDate);
    _endDateController = TextEditingController(text: deadline);
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

  void onUpdateTask() async{
    final taskFolderId = widget.task.taskFolderId;
    final taskId = widget.task.taskId;

    String? title = _titleController.text.toString().trim();
    String? description = _descriptionController.text.toString().trim();
    String? status = selectedStatusLabel;
    String? priority = priorityLabel;
    DateTime? startDate = selectedStartDate;
    DateTime? endDate = selectedEndDate;

    try {
      if(title.isEmpty){
        throw Exception("Task title is required");
      }
      if(title == widget.task.title){
        title = null;
      }
      if(description == widget.task.description){
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
      if(title == null &&
        description == null &&
        status == null &&
        priority == null &&
        endDate == null &&
        startDate == null
      ){
        throw Exception("At least one field must change in order to update a task.");
      }

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

      Navigator.of(context).pop();
      Navigator.of(context).pop();
      // You can then show a success snackbar or navigate back, etc.
    } catch (e) {
      String errorMessage = 'An unknown error occurred.';
      if (e is Exception) {
        errorMessage = e.toString().replaceFirst("Exception: ", "");
      }
      showAlertDialog(
        context,
        "assets/images/Deck-Dialogue1.png",
        "Uh oh. Something went wrong.",
        errorMessage,
      );
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

  Future<void> _selectDate(BuildContext context, String controller) async {
    DateTime initialDate = DateTime.now();

    if(controller == "START_DATE"){
      initialDate = selectedStartDate;
    }else if (controller == "END_DATE"){
      initialDate = selectedEndDate;
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2070), //edit nyo nlng toh
      initialDate: initialDate,
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
              surface: DeckColors.white,
              primary: DeckColors.primaryColor,
              // Title, selected date and month/year picker color (dark and light mode)
              onSurface: DeckColors.primaryColor,
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

    // Update text in the controller with selected date
    if (pickedDate != null) {
      if(controller == "START_DATE"){
        setState(() {
          selectedStartDate = pickedDate;
          startDate = getNameDate(pickedDate);
          _startDateController.text = startDate;
        });
      }else if (controller == "END_DATE"){
        setState(() {
          selectedEndDate = pickedDate;
          deadline = getNameDate(pickedDate);
          _endDateController.text = deadline;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AuthBar(
        title: isEditable ? 'Edit Task' : 'View Task',
        automaticallyImplyLeading: true,
        color: DeckColors.primaryColor,
        fontSize: 24,
        rightIcon: isEditable ? Icons.close_rounded : DeckIcons.pencil,
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
      backgroundColor: DeckColors.backgroundColor,
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
                    padding: const EdgeInsets.only(left:15.0,right:15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        if(isEditable) ... {
                          const Text(
                            'Edit Mode',
                            style: TextStyle(
                              fontFamily: 'Fraiche',
                              color: DeckColors.primaryColor,
                              fontSize: 32,
                            ),
                          ),
                          const Text (
                            'Click the \'x\' icon above to exit edit mode.',
                            style: TextStyle(
                              fontFamily: 'Nunito-Regular',
                              color: DeckColors.primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        }
                        else ... {
                          const Text(
                            'View A Task',
                            style: TextStyle(
                              fontFamily: 'Fraiche',
                              color: DeckColors.primaryColor,
                              fontSize: 32,
                            ),
                          ),
                          const Text (
                            'Click the pencil icon above to edit the task',
                            style: TextStyle(
                              fontFamily: 'Nunito-Regular',
                              color: DeckColors.primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        },
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Title',
                          style: TextStyle(
                            fontFamily: 'Nunito-Bold',
                            color: DeckColors.primaryColor,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        IgnorePointer(
                          ignoring: !isEditable,
                          child: BuildTextBox(
                            controller: _titleController,
                            hintText: title,
                            isReadOnly: isEditable,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
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
                          height: 5,
                        ),
                        IgnorePointer(
                          ignoring: !isEditable,
                          child: BuildTextBox(
                            hintText: startDate,
                            controller: _startDateController,
                            isReadOnly: isEditable,
                            rightIcon: Icons.calendar_today_outlined,
                            onTap: () => _selectDate(context, "START_DATE")
                          ),
                        ),
                        const SizedBox(
                          height: 10,
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
                          height: 5,
                        ),
                        IgnorePointer(
                          ignoring: !isEditable,
                          child: BuildTextBox(
                            hintText: deadline,
                            controller: _endDateController,
                            isReadOnly: true,
                            rightIcon: Icons.calendar_today_outlined,
                            onTap: () => _selectDate(context, "END_DATE"),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontFamily: 'Nunito-Bold',
                            color: DeckColors.primaryColor,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        IgnorePointer(
                          ignoring: !isEditable,
                          child: BuildTextBox(
                            controller: _descriptionController,
                            hintText: "Task Description",
                            showPassword: false,
                            isMultiLine: true,
                            isReadOnly: isEditable,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
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
                          const SizedBox(
                            height: 10,
                          ),
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
                                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                                decoration: BoxDecoration(
                                  color: getPriorityColor(_priorityIndex),
                                  borderRadius: BorderRadius.circular(10),
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
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Status',
                          style: TextStyle(
                            fontFamily: 'Nunito-Bold',
                            color: DeckColors.primaryColor,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        IgnorePointer(
                          ignoring: !isEditable,
                          child: RadioButtonGroup(
                            buttonLabels: const ['Pending', 'In Progress', 'Completed'],
                            buttonColors: const [ DeckColors.accentColor, DeckColors.accentColor, DeckColors.accentColor],
                            isClickable: true,
                            initialSelectedIndex: _selectedStatus,
                            onChange: (label, index) {
                              setState((){
                                _selectedStatus = index;
                                selectedStatusLabel = label;
                              });
                            }
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if(isEditable)
                          BuildButton(
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
                              showConfirmDialog(
                                  context,
                                  "assets/images/Deck-Dialogue4.png",
                                  "Save Task?",
                                  "",
                                  "Save",
                                      () {
                                        onUpdateTask();
                                  }
                              );
                            },
                          ),
                        const SizedBox(
                          height: 10,
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
                                    () async {
                                     await _taskService.deleteTask(
                                         taskFolderId: widget.task.taskFolderId,
                                         taskId: widget.task.taskId);
                                     Navigator.of(context).pop();
                                     Navigator.of(context).pop();
                                });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    'assets/images/Deck-Bottom-Image1.png',
                    fit: BoxFit.fitWidth,
                    width: MediaQuery.of(context).size.width,
                  ),
                ]
            ),
          )
        ),
    );
  }
}
