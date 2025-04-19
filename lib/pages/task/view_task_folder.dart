import 'package:auto_size_text/auto_size_text.dart';
import 'package:deck/backend/task/task_provider.dart';
import 'package:deck/pages/misc/custom%20widgets/progressbar/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:flutter/widgets.dart';
// import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
// import 'package:deck/pages/task/view_task.dart';
import 'package:deck/pages/task/add_task.dart';
// import 'package:deck/pages/misc/deck_icons2.dart';
import '../../backend/models/task.dart';
// import '../misc/custom widgets/dialogs/confirmation_dialog.dart';
// import '../misc/custom widgets/functions/if_collection_empty.dart';
// import '../misc/custom widgets/functions/tab_bar.dart';
// import '../misc/custom widgets/tiles/home_task_tile.dart';
// import '../misc/custom widgets/tiles/task_tile.dart';
import '../misc/custom widgets/appbar/auth_bar.dart';
import '../misc/custom widgets/buttons/custom_buttons.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:pie_chart/pie_chart.dart';
import '../misc/custom widgets/dialogs/confirmation_dialog.dart';
import '../misc/custom widgets/functions/tab_bar.dart';
import '../misc/deck_icons.dart';
import '../misc/deck_icons2.dart';
import 'edit_task_folder.dart';

class ViewTaskFolderPage extends StatefulWidget {
  final String? title;

  ViewTaskFolderPage({
    super.key,
    required this.title,

  });
  @override
  _ViewTaskFolderPageState createState() => _ViewTaskFolderPageState();
}

class _ViewTaskFolderPageState extends State<ViewTaskFolderPage> {
  bool _isLoading = false;
  // double progress = (taskTotal != 0) ? (taskDone ?? 0) / taskTotal! : 0.0;

  int totalTask = 0;
  int totalPending = 0;
  int totalProgress = 0;
  int totalCompleted = 0;
  int totalHighPrio = 0;
  int totalMidPrio = 0;
  int totalLowPrio = 0;
  late final Map<String, double> workloadData;
  late final Map<String, double> priorityData;

  /// function to get the total number of all task, pending task, tasks in progress, completed task
  /// this will be used for the overview tab
  /// this need to be set again if user changes something for the new info to be displayed
  void _getOverview() {
    setState(() {
      totalTask = 100;
      totalPending = 10;
      totalProgress = 10;
      totalCompleted = 80;
      totalHighPrio = 50;
      totalMidPrio = 30;
      totalLowPrio = 20;
      workloadData = {
        "$totalPending - Pending": totalPending.toDouble(),
        "$totalProgress - In Progress": totalProgress.toDouble(),
        "$totalLowPrio - Completed": totalCompleted.toDouble(),
      };
      priorityData = {
        "$totalHighPrio - Pending": totalPending.toDouble(),
        "$totalMidPrio - In Progress": totalProgress.toDouble(),
        "$totalCompleted - Completed": totalCompleted.toDouble(),
      };
    });

    // switch (task.status) {
    //   case 'pending':
    //     totalPending++;
    //     break;
    //   case 'progress':
    //     totalProgress++;
    //     break;
    //   case 'completed':
    //     totalCompleted++;
    //     break;
    //   default:
    //   // Handle unknown status if necessary
    //     break;
    // }
  }

  // bool isCalendarView = true;  /// bool variable to toggle view
  // /// function to switch the view
  // void _toggleView() async {
  //   setState(() {
  //     isCalendarView = !isCalendarView;
  //   });
  // }

  DateTime today = DateTime.now();
  DateTime selectedDay = DateTime.now();  ///selectedDay : actual day selected by the user, used for highlighting.
  DateTime focusedDay = DateTime.now();  /// focusedDay : variable that tracks which day is currently in focus

  /// function to update whenever the user selects a new day on the calendar.
  /// DateTime day: This is the day that was selected by the user (from the calendar).
  /// DateTime focusedDay: This is the currently focused day.
  void _onDaySelected(DateTime day, DateTime newFocusedDay) {
    setState(() {
      selectedDay = day; //para sa display ng text
      focusedDay = newFocusedDay;
    });
  }

  bool showAllTask = false;
  @override
  void _getTasks() async {
    await Provider.of<TaskProvider>(context, listen: false).loadTasks();
  }

  Widget _buildTaskList(List<Task> tasks, bool Function(Task) filter) {
    final filteredTasks = tasks.where(filter).toList();
    // if(filteredTasks.isNotEmpty) {
      return ListView.builder(
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          Task task = filteredTasks[index]; // Access the Task model directly
          // Check if the task should be displayed based on the conditions
          return const Padding(
            padding: EdgeInsets.only(top:5),
            // child: HomeTaskTile(
            //   folderName: task['folderName'],//task.folderName
            //   taskName: task['taskName'],// task.title
            //   deadline: getDeadline(selectedDay),//TaskProvider.getNameDate(task.deadline)
            //   onPressed: () {
            //     print("Clicked task tile!");
            //     print('Task: ${task.title}, IsDone: ${task.getIsDone}, IsActive: ${task.getIsActive}, Deadline: ${task.deadline}');
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => ViewTaskPage(task: task, isEditable: true),
            //       ),
            //     );
            //   },
            //   priority: task['priority'],//task.priority
            // ),
            // DeckTaskTile(
            //   title: task.title,
            //   deadline: TaskProvider.getNameDate(task.deadline),
            //   priority: task.priority, // You can customize this if needed
            //   progressStatus: 'to do',
            //   onDelete: () {
            //     final String deletedTitle = task.title;
            //     showConfirmDialog(
            //         context,
            //         "assets/images/Deck-Dialogue1.png",
            //         "Delete Item",
            //         "Are you sure you want to delete '$deletedTitle'?",
            //         "Delete Item",
            //             () {Provider.of<TaskProvider>(context, listen: false).deleteTask(task.uid);},
            //         // "Cancel",
            //         //     () {setState(() {}); // You may need to handle state updates accordingly
            //     // }
            //     );
            //   },
            //   enableRetrieve: false,
            //   onTap: () {
            //     print("Clicked task tile!");
            //     print('Task: ${task.title}, IsDone: ${task.getIsDone}, IsActive: ${task.getIsActive}, Deadline: ${task.deadline}');
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => ViewTaskPage(task: task, isEditable: true),
            //       ),
            //     );
            //   },
            // ),
          );
        },
      );
    // }
    // else {
    //   return IfCollectionEmpty(
    //     ifCollectionEmptyText: 'Seems like there aren’t any\n task for today, wanderer!',
    //     ifCollectionEmptySubText:
    //     'Now’s the perfect time to get ahead. Start\nadding new tasks and stay \non top of your game!',
    //     ifCollectionEmptyHeight: MediaQuery.of(context).size.height/2,
    //   );
    // }
  }

  void initState() {
    super.initState();
    _getTasks();
    _getOverview();
  }
  double progressValue = 0;
  String progressLabel ='';


  Widget buildOverviewTab( int? total, int? complete){
    progressValue = (total != 0) ? (complete ?? 0) / total! : 0.0;
    progressLabel = "$complete / $total";

    return  SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: DeckColors.primaryColor, width: 3),
                color: DeckColors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AutoSizeText(
                        'Progress',
                        maxLines: 1,
                        minFontSize: 20,
                        style: TextStyle(
                          height:1,
                          fontFamily: 'Fraiche',
                          fontSize: 30,
                          color: DeckColors.primaryColor,
                        ),
                      ),
                      AutoSizeText(
                        progressLabel,
                        maxLines: 1,
                        minFontSize: 15,
                        style: const TextStyle(
                          height:1,
                          fontFamily: 'Fraiche',
                          fontSize: 25,
                          color: DeckColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ProgressBar(
                    progress: progressValue,
                  )
                ],
              )
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: DeckColors.primaryColor, width: 3),
                color: DeckColors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AutoSizeText(
                    'Workload by status',
                    maxLines: 1,
                    minFontSize: 20,
                    style: TextStyle(
                      height:1,
                      fontFamily: 'Fraiche',
                      fontSize: 30,
                      color: DeckColors.primaryColor,
                    ),
                  ),
                  PieChart(
                    dataMap: workloadData,
                    emptyColor: DeckColors.softGray,
                    animationDuration: const Duration(milliseconds: 800),
                    chartLegendSpacing: 32,
                    chartRadius: MediaQuery.of(context).size.width / 3.2,
                    initialAngleInDegree: 0,
                    legendOptions: const LegendOptions(
                      showLegendsInRow: false,
                      legendPosition: LegendPosition.right,
                      showLegends: true,
                      legendShape: BoxShape.rectangle,
                      legendTextStyle: TextStyle(
                        height:1,
                        fontFamily: 'Fraiche',
                        fontSize: 20,
                        color: DeckColors.primaryColor,
                      ),
                    ),
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValueBackground: false,
                      showChartValues: false,
                      showChartValuesInPercentage: false,
                      showChartValuesOutside: false,
                      decimalPlaces: 1,
                    ),
                    // gradientList: ---To add gradient colors---
                    // emptyColorGradient: ---Empty Color gradient---
                  )
                ],
              )
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              padding: EdgeInsets.all(20),

              decoration: BoxDecoration(
                border: Border.all(color: DeckColors.primaryColor, width: 3),
                color: DeckColors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AutoSizeText(
                    'Priority breakdown',
                    maxLines: 1,
                    minFontSize: 20,
                    style: TextStyle(
                      height:1,
                      fontFamily: 'Fraiche',
                      fontSize: 30,
                      color: DeckColors.primaryColor,
                    ),
                  ),
                  PieChart(
                    dataMap: priorityData,
                    animationDuration: const Duration(milliseconds: 800),
                    chartLegendSpacing: 32,
                    chartRadius: MediaQuery.of(context).size.width / 3.2,
                    initialAngleInDegree: 0,
                    legendOptions: const LegendOptions(
                      showLegendsInRow: false,
                      legendPosition: LegendPosition.right,
                      showLegends: true,
                      legendShape: BoxShape.rectangle,
                      legendTextStyle: TextStyle(
                        height:1,
                        fontFamily: 'Fraiche',
                        fontSize: 20,
                        color: DeckColors.primaryColor,
                      ),
                    ),
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValueBackground: false,
                      showChartValues: false,
                      showChartValuesInPercentage: false,
                      showChartValuesOutside: false,
                      decimalPlaces: 1,
                    ),
                    // gradientList: ---To add gradient colors---
                    // emptyColorGradient: ---Empty Color gradient---
                  )
                ],
              )
          ),

        ],
      ),
    );
  }

  Widget buildListTab(){
    return  Expanded(
        child: SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical:10),
          decoration: BoxDecoration(
              border: Border.all(color: DeckColors.primaryColor, width: 3),
              color: DeckColors.white,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15)
              )
          ),
          child: Column(
            children: [
            ],
          )
      ),
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final tasks = provider.getList;

    //check if there is task for the day
    bool isThereTaskForDay(DateTime selectedDay, bool isToDo) {
      List<Task> tasksForSelectedDay =
      tasks.where((task) => isSameDay(task.deadline, selectedDay)).toList();

      if (isToDo) {
        return tasksForSelectedDay.any((task) => !task.isDone);
      } else {
        return tasksForSelectedDay.any((task) => task.isDone);
      }
    }
    // List<Task> _eventLoader(DateTime day) {
    //   return tasks
    //       .where((task) => !task.isDone && isSameDay(task.deadline, day))
    //       .toList();
    // }
    return Scaffold(
      appBar: AuthBar(
          automaticallyImplyLeading: true,
          title: 'View Task Folder',
          color: DeckColors.primaryColor,
          fontSize: 24,
          showPopMenu: true,
          items: const ['Edit Folder Info', 'Delete Folder'],
          icons: const [DeckIcons.pencil, DeckIcons.trash_bin],
          ///LOGIC OF POP UP MENU BUTTON (ung three dots)
          onItemsSelected: (index) {
              /// Edit Task folder info option
              if (index == 0) {
                Navigator.of(context).push(
                  RouteGenerator.createRoute(const EditTaskFolderPage()),
                );
              }
              /// Delete Task Folder Option
              else if (index == 1) {
                showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return CustomConfirmDialog(
                        title: 'Delete this folder?',
                        message: 'This action is permanent and will remove all ${totalTask} tasks inside.',
                        imagePath: 'assets/images/Deck-Dialogue4.png',
                        button1: 'Delete',
                        button2: 'Cancel',
                        onConfirm: () async {
                          ///TODO add function
                          Navigator.of(context).pop();
                        },
                        onCancel: () {
                          Navigator.of(context).pop();
                        },
                      );
                    }
                );
              }
          }
      ),
      backgroundColor: DeckColors.backgroundColor,
      body: SafeArea(
        top: true,
        bottom: false,
        left: true,
        right: true,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                      widget.title ?? 'Unititled',
                      maxLines: 2,
                      style: const TextStyle(
                        fontFamily: 'Fraiche',
                        fontSize: 30,
                        color: DeckColors.primaryColor,
                      )
                  ),
                 SizedBox(
                   height: 10,
                 ),
                ],
              )
            ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .6,
                child:  BuildTabBar(
                  titles: const ['Overview','List Mode','Calendar'],
                  icons: const[Icons.folder_outlined,DeckIcons2.list,Icons.calendar_today],
                  length: 3,
                  hasContentPadding: false,
                  color: DeckColors.deckYellow,
                  tabContent: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: buildOverviewTab(totalTask,totalCompleted),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: buildListTab(),
                      ),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          child:
                          BuildButton(
                              buttonText: "add task",
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
                                print("Add task pressed");
                                Navigator.push(
                                  context,
                                  RouteGenerator.createRoute(const AddTaskPage()),//TODO ADD THE INDEX OF THE FOLDER HERE
                                );              }
                          ),

                        )
                    ),

                    // ListModeTab(),
                    // CalendarTab(),
                  ],
                ),
              )

            // CustomScrollView(
            //   slivers: <Widget>[
            //     SliverToBoxAdapter(
            //       child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Padding(
            //               padding: const EdgeInsets.only(top: 20.0),
            //               child: Row(
            //                 children: [
            //                   const Icon(
            //                     DeckIcons2.hat,
            //                     color: DeckColors.primaryColor,
            //                     size: 32,
            //                   ),
            //                   const Spacer(),
            //                   IconButton(
            //                       icon: const Icon (Icons.add,
            //                           color: DeckColors.primaryColor,
            //                           size: 32),
            //                       onPressed: () { Navigator.push( context, MaterialPageRoute(builder: (context) => const AddTaskPage()),);}
            //
            //                   ),
            //                   IconButton(
            //                     icon:  Icon(
            //                         isCalendarView ? Icons.list :  Icons.calendar_today,
            //                         color: DeckColors.primaryColor,
            //                         size: 32),
            //                     onPressed: () {
            //                       setState(() {
            //                         isCalendarView = !isCalendarView;
            //                       });
            //                     },
            //                   )
            //                 ],
            //               ),
            //             ),
            //           ]
            //       ),
            //     ),
            //     SliverToBoxAdapter(
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //               DateFormat('yyyy').format(focusedDay),
            //               style: const TextStyle(
            //                   fontFamily: 'Fraiche',
            //                   fontSize: 30,
            //                   color: DeckColors.primaryColor,
            //                   fontWeight: FontWeight.bold)
            //           ),
            //           Text(
            //               DateFormat('MMMM dd').format(focusedDay),
            //               style: const TextStyle(
            //                   fontFamily: 'Fraiche',
            //                   fontSize: 56,
            //                   color: DeckColors.primaryColor,
            //                   fontWeight: FontWeight.bold)
            //           ),
            //         ],
            //       ),
            //     ),
            //
            //     /// if view option is calendar view, a calendar will be displayed
            //     if (isCalendarView) SliverList(
            //         delegate: SliverChildListDelegate([
            //           TableCalendar(
            //             eventLoader: _eventLoader,
            //             focusedDay: focusedDay,
            //             firstDay: DateTime.utc(2020, 1, 1),
            //             lastDay: DateTime.utc(DateTime.now().year + 5, 1, 1),
            //             onDaySelected: _onDaySelected,
            //             selectedDayPredicate: (day) => isSameDay(day, focusedDay),
            //             rowHeight: 40,
            //             daysOfWeekHeight: 40,
            //             calendarStyle: CalendarStyle(
            //               canMarkersOverflow: false,
            //               markersMaxCount: 1,
            //               markerDecoration: const BoxDecoration(
            //                   color: Colors.transparent,
            //                   shape: BoxShape.rectangle),
            //               defaultTextStyle: const TextStyle(
            //                 color: DeckColors.primaryColor,
            //                 fontFamily: 'Nunito-Regular',
            //                 fontSize: 16,
            //               ),
            //               weekNumberTextStyle: const TextStyle(
            //                 color: DeckColors.primaryColor,
            //                 fontFamily: 'Nunito-Regular',
            //                 fontSize: 16,
            //               ),
            //               weekendTextStyle: const TextStyle(
            //                 color: DeckColors.primaryColor,
            //                 fontFamily: 'Nunito-Regular',
            //                 fontSize: 16,
            //               ),
            //               selectedDecoration: BoxDecoration(
            //                 color: DeckColors.primaryColor,
            //                 border: Border.all(
            //                   color: DeckColors.primaryColor,
            //                   width: 2,
            //                 ),
            //                 shape: BoxShape.circle,
            //               ),
            //               todayDecoration: const BoxDecoration(
            //                 color: Colors.transparent,
            //                 shape: BoxShape.circle,
            //               ),
            //               outsideDaysVisible: true,
            //               outsideTextStyle: const TextStyle(
            //                 color: DeckColors.primaryColor,
            //                 fontFamily: 'Nunito-Regular',
            //                 fontSize: 16,
            //               ),
            //             ),
            //             headerStyle: HeaderStyle(
            //               titleTextFormatter: (date, locale) {
            //                 return DateFormat('MMMM').format(date);
            //               },
            //               leftChevronIcon: const Icon(Icons.arrow_back_ios_rounded,
            //                   color: DeckColors.primaryColor),
            //               leftChevronMargin: const EdgeInsets.only(right: 10),
            //               leftChevronPadding: const EdgeInsets.all(10),
            //               rightChevronIcon: const Icon(Icons.arrow_forward_ios_rounded,
            //                   color: DeckColors.primaryColor),
            //               rightChevronPadding: const EdgeInsets.all(10),
            //               rightChevronMargin: EdgeInsets.zero,
            //               formatButtonVisible: false,
            //               titleTextStyle: const TextStyle(
            //                 color: DeckColors.primaryColor,
            //                 fontSize: 20,
            //                 fontFamily: 'Fraiche',
            //               ),
            //             ),
            //             daysOfWeekStyle: const DaysOfWeekStyle(
            //               weekdayStyle: TextStyle(
            //                 color: DeckColors.primaryColor,
            //                 fontSize: 20,
            //                 fontFamily: 'Fraiche',
            //               ),
            //               weekendStyle: TextStyle(
            //                 color: DeckColors.primaryColor,
            //                 fontSize: 20,
            //                 fontFamily: 'Fraiche',
            //               ),
            //             ),
            //             calendarBuilders: CalendarBuilders(markerBuilder: (context, date, events) {
            //               if (events.isNotEmpty) {
            //                 return Align(
            //                   alignment: Alignment.bottomCenter,
            //                   child: Container(
            //                     margin: const EdgeInsets.only(bottom: 8),
            //                     width: 5,
            //                     height: 2,
            //                     color: DeckColors.primaryColor,
            //                   ),
            //                 );
            //               }
            //             }),
            //           )
            //         ])
            //     ),
            //     if(isCalendarView) const SliverToBoxAdapter(
            //       child: SizedBox(height: 30),
            //     ),
            //     /// calendar view, will show list of task
            //     if(isCalendarView) SliverToBoxAdapter(
            //       child: Container(
            //         height: (MediaQuery.of(context).size.height/2),
            //         padding: const EdgeInsets.symmetric(vertical: 10, horizontal:50),
            //         decoration: const BoxDecoration(
            //           color: DeckColors.white,
            //           borderRadius: BorderRadius.only(
            //             topLeft: Radius.circular(60),  // Rounded top-left corner
            //             topRight: Radius.circular(60), // Rounded top-right corner
            //           ),
            //         ),
            //         child: Padding(
            //           padding: const EdgeInsets.only(top: 20),
            //           child: BuildTabBar(
            //             titles: const ['To Do', 'Active', 'Done'],
            //             length: 3,
            //             tabContent: [
            //               _buildTaskList(tasks, (task) => !task.getIsDone && !task.getIsActive && isSameDay(task.deadline, selectedDay)),
            //               _buildTaskList(tasks, (task) => task.getIsActive && !task.getIsDone && isSameDay(task.deadline, selectedDay)),
            //               _buildTaskList(tasks, (task) => task.getIsDone && !task.getIsActive && isSameDay(task.deadline, selectedDay)),
            //               // if (isThereTaskForDay(today, false) || showAllTask)
            //               //   ListView.builder(
            //               //     shrinkWrap:
            //               //         true, // Allow the ListView to wrap its content
            //               //     physics: const NeverScrollableScrollPhysics(),
            //               //     itemCount: tasks.length,
            //               //     itemBuilder: (context, index) {
            //               //       if ((showAllTask && tasks[index].getIsDone) ||
            //               //           (tasks[index].getIsDone &&
            //               //               isSameDay(
            //               //                   tasks[index].deadline, selectedDay))) {
            //               //         return Padding(
            //               //           padding: const EdgeInsets.symmetric(vertical: 10),
            //               //           child: DeckTaskTile(
            //               //             title: tasks[index].title,
            //               //             deadline: tasks[index]
            //               //                 .deadline
            //               //                 .toString()
            //               //                 .split(" ")[0],
            //               //             isChecked: tasks[index].getIsDone,
            //               //             onChanged: (newValue) {
            //               //               setState(() {
            //               //                 tasks[index].setIsDone = newValue ?? false;
            //               //                 Provider.of<TaskProvider>(context,
            //               //                         listen: false)
            //               //                     .setTaskUndone(tasks[index]);
            //               //               });
            //               //             },
            //               //             onDelete: () {
            //               //               final String deletedTitle =
            //               //                   tasks[index].title;
            //               //               showConfirmationDialog(
            //               //                 context,
            //               //                 "Delete Item",
            //               //                 "Are you sure you want to delete '$deletedTitle'?",
            //               //                 () {
            //               //                   Provider.of<TaskProvider>(context,
            //               //                           listen: false)
            //               //                       .deleteTask(tasks[index].uid);
            //               //                 },
            //               //                 () {
            //               //                   setState(() {});
            //               //                 },
            //               //               );
            //               //             },
            //               //             enableRetrieve: false,
            //               //             onTap: () {
            //               //               print("Clicked task tile!");
            //               //               Navigator.push(
            //               //                 context,
            //               //                 MaterialPageRoute(
            //               //                     builder: (context) => ViewTaskPage(
            //               //                           task: tasks[index],
            //               //                           isEditable: true,
            //               //                         )),
            //               //               );
            //               //             },
            //               //           ),
            //               //         );
            //               //       } else {
            //               //         return const SizedBox(
            //               //             height: 0); // Placeholder for empty space
            //               //       }
            //               //     },
            //               //   )
            //               // else
            //
            //               ///old codes here please delete if d na need
            //               //                if (isThereTaskForDay(today, true))
            //               //                  ListView.builder(
            //               //                   shrinkWrap:  true, // Allow the ListView to wrap its content
            //               //                   physics: const NeverScrollableScrollPhysics(),
            //               //                   itemCount: tasks.length,
            //               //                   itemBuilder: (context, index) {
            //               //                     if ((showAllTask && !tasks[index].getIsDone) || (!tasks[index].getIsDone && isSameDay(tasks[index].deadline, selectedDay))) {
            //               //                       return Padding(
            //               //                         padding: const EdgeInsets.symmetric(vertical: 10),
            //               //                         child: DeckTaskTile(
            //               //                           title:
            //               //                           , deadline:.
            //               //                           priority: ,
            //               //                           progressStatus:.
            //               //                           onDelete,
            //               //                           onRetrieve:,
            //               //                           onTap: ,
            //               //                           enableRetrieve:
            //               //                         ),
            //               // DeckTaskTile(
            //               //   title: tasks[index].title,
            //               //   deadline: tasks[index]
            //               //       .deadline
            //               //       .toString()
            //               //       .split(" ")[0],
            //               //   isChecked: tasks[index].getIsDone,
            //               //   onChanged: (newValue) {
            //               //     setState(() {
            //               //       tasks[index].setIsDone = newValue ?? false;
            //               //       Provider.of<TaskProvider>(context,
            //               //               listen: false)
            //               //           .setTaskDone(tasks[index]);
            //               //     });
            //               //   },
            //               //   onDelete: () {
            //               //     final String deletedTitle =
            //               //         tasks[index].title;
            //               //     showConfirmationDialog(
            //               //       context,
            //               //       "Delete Item",
            //               //       "Are you sure you want to delete '$deletedTitle'?",
            //               //       () {
            //               //         Provider.of<TaskProvider>(context,
            //               //                 listen: false)
            //               //             .deleteTask(tasks[index].uid);
            //               //       },
            //               //       () { setState(() {}); },
            //               //     );
            //               //   },
            //               //   enableRetrieve: false,
            //               //   onTap: () {
            //               //     // print("Clicked task tile!");
            //               //     Navigator.push(
            //               //       context,
            //               //       MaterialPageRoute(
            //               //           builder: (context) => ViewTaskPage(  task: tasks[index],  isEditable: true,)),
            //               //     );
            //               //   },
            //               // ),
            //               //                       );
            //               //                     } else { ///
            //               //                       return const SizedBox( height:  0); // do not remove. tasks will not show up.
            //               //                     }
            //               //                   },
            //               //                  )
            //               //             else ///show this if there are no task
            //               ///
            //             ],
            //           ),
            //         ),
            //       ),
            //     )
            //     else SliverToBoxAdapter(
            //       child: Container(
            //         height: (MediaQuery.of(context).size.height/1.25),
            //         padding: const EdgeInsets.symmetric(vertical: 10, horizontal:50),
            //         decoration: const BoxDecoration(
            //           color: DeckColors.white,
            //           borderRadius: BorderRadius.only(
            //             topLeft: Radius.circular(60),  // Rounded top-left corner
            //             topRight: Radius.circular(60), // Rounded top-right corner
            //           ),
            //         ),
            //         child: Padding(
            //           padding: const EdgeInsets.only(top: 20),
            //           child: BuildTabBar(
            //             titles: const ['To Do', 'Active', 'Done'],
            //             length: 3,
            //             tabContent: [
            //               _buildTaskList(tasks, (task) => !task.getIsDone && !task.getIsActive),
            //               _buildTaskList(tasks, (task) => task.getIsActive && !task.getIsDone),
            //               _buildTaskList(tasks, (task) => task.getIsDone && !task.getIsActive)
            //
            //               ///if TO DO tab does not contain a task
            //
            //               ///in progress tab
            //               // SingleChildScrollView(
            //               //   padding: EdgeInsets.only(top: 20),
            //               //   child:
            //               //   ListView.builder(
            //               //     shrinkWrap:  true, // Allow the ListView to wrap its content
            //               //     physics: const NeverScrollableScrollPhysics(),
            //               //     itemCount: 10 /*tasks.length*/,
            //               //     itemBuilder: (context, index) {
            //               //       return DeckTaskTile(
            //               //         title: 'a high priority task',
            //               //         deadline: 'March 18, 2024 || 10:00 AM',
            //               //         priority: 'medium',
            //               //         progressStatus: 'to do',
            //               //         // title: tasks[index]['title'],
            //               //         // deadline: tasks[index]['deadline'],
            //               //         // priority: tasks[index]['priority'],
            //               //         // progressStatus: tasks[index]['progressStatus'],
            //               //         onDelete: () {
            //               //           // final String deletedTitle = tasks[index].title;
            //               //           // showConfirmationDialog(
            //               //           //   context, "Delete Item",
            //               //           //   "Are you sure you want to delete '$deletedTitle'?",() {
            //               //           //     Provider.of<TaskProvider>(context,listen: false).deleteTask(tasks[index].uid);},() { setState(() {}); },
            //               //           // );
            //               //         },
            //               //         enableRetrieve: false,
            //               //         onTap: () {
            //               //           print("Clicked task tile!");
            //               //           // Navigator.push(
            //               //           // context,
            //               //           // MaterialPageRoute(
            //               //           //   builder: (context) => ViewTaskPage(  task: tasks[index],  isEditable: true,)),
            //               //           // );
            //               //         },
            //               //       );
            //               //     },
            //               //   ),
            //               // ),
            //               ///if IN PROGRESS tab does not contain a task
            //               /// if Complete tab does not contain a task
            //               // IfCollectionEmpty(
            //               //   ifCollectionEmptyText: 'Seems like there aren’t any\n task for today, wanderer!',
            //               //   ifCollectionEmptySubText: 'Now’s the perfect time to get ahead. Start\nadding new tasks and stay \non top of your game!',
            //               //   ifCollectionEmptyHeight: MediaQuery.of(context).size.height/2,
            //               // )
            //               // if (isThereTaskForDay(today, false) || showAllTask)
            //               //   ListView.builder(
            //               //     shrinkWrap:
            //               //         true, // Allow the ListView to wrap its content
            //               //     physics: const NeverScrollableScrollPhysics(),
            //               //     itemCount: tasks.length,
            //               //     itemBuilder: (context, index) {
            //               //       if ((showAllTask && tasks[index].getIsDone) ||
            //               //           (tasks[index].getIsDone &&
            //               //               isSameDay(
            //               //                   tasks[index].deadline, selectedDay))) {
            //               //         return Padding(
            //               //           padding: const EdgeInsets.symmetric(vertical: 10),
            //               //           child: DeckTaskTile(
            //               //             title: tasks[index].title,
            //               //             deadline: tasks[index]
            //               //                 .deadline
            //               //                 .toString()
            //               //                 .split(" ")[0],
            //               //             isChecked: tasks[index].getIsDone,
            //               //             onChanged: (newValue) {
            //               //               setState(() {
            //               //                 tasks[index].setIsDone = newValue ?? false;
            //               //                 Provider.of<TaskProvider>(context,
            //               //                         listen: false)
            //               //                     .setTaskUndone(tasks[index]);
            //               //               });
            //               //             },
            //               //             onDelete: () {
            //               //               final String deletedTitle =
            //               //                   tasks[index].title;
            //               //               showConfirmationDialog(
            //               //                 context,
            //               //                 "Delete Item",
            //               //                 "Are you sure you want to delete '$deletedTitle'?",
            //               //                 () {
            //               //                   Provider.of<TaskProvider>(context,
            //               //                           listen: false)
            //               //                       .deleteTask(tasks[index].uid);
            //               //                 },
            //               //                 () {
            //               //                   setState(() {});
            //               //                 },
            //               //               );
            //               //             },
            //               //             enableRetrieve: false,
            //               //             onTap: () {
            //               //               print("Clicked task tile!");
            //               //               Navigator.push(
            //               //                 context,
            //               //                 MaterialPageRoute(
            //               //                     builder: (context) => ViewTaskPage(
            //               //                           task: tasks[index],
            //               //                           isEditable: true,
            //               //                         )),
            //               //               );
            //               //             },
            //               //           ),
            //               //         );
            //               //       } else {
            //               //         return const SizedBox(
            //               //             height: 0); // Placeholder for empty space
            //               //       }
            //               //     },
            //               //   )
            //               // else
            //
            //               ///old codes here please delete if d na need
            //               //                if (isThereTaskForDay(today, true))
            //               //                  ListView.builder(
            //               //                   shrinkWrap:  true, // Allow the ListView to wrap its content
            //               //                   physics: const NeverScrollableScrollPhysics(),
            //               //                   itemCount: tasks.length,
            //               //                   itemBuilder: (context, index) {
            //               //                     if ((showAllTask && !tasks[index].getIsDone) || (!tasks[index].getIsDone && isSameDay(tasks[index].deadline, selectedDay))) {
            //               //                       return Padding(
            //               //                         padding: const EdgeInsets.symmetric(vertical: 10),
            //               //                         child: DeckTaskTile(
            //               //                           title:
            //               //                           , deadline:.
            //               //                           priority: ,
            //               //                           progressStatus:.
            //               //                           onDelete,
            //               //                           onRetrieve:,
            //               //                           onTap: ,
            //               //                           enableRetrieve:
            //               //                         ),
            //               // DeckTaskTile(
            //               //   title: tasks[index].title,
            //               //   deadline: tasks[index]
            //               //       .deadline
            //               //       .toString()
            //               //       .split(" ")[0],
            //               //   isChecked: tasks[index].getIsDone,
            //               //   onChanged: (newValue) {
            //               //     setState(() {
            //               //       tasks[index].setIsDone = newValue ?? false;
            //               //       Provider.of<TaskProvider>(context,
            //               //               listen: false)
            //               //           .setTaskDone(tasks[index]);
            //               //     });
            //               //   },
            //               //   onDelete: () {
            //               //     final String deletedTitle =
            //               //         tasks[index].title;
            //               //     showConfirmationDialog(
            //               //       context,
            //               //       "Delete Item",
            //               //       "Are you sure you want to delete '$deletedTitle'?",
            //               //       () {
            //               //         Provider.of<TaskProvider>(context,
            //               //                 listen: false)
            //               //             .deleteTask(tasks[index].uid);
            //               //       },
            //               //       () { setState(() {}); },
            //               //     );
            //               //   },
            //               //   enableRetrieve: false,
            //               //   onTap: () {
            //               //     // print("Clicked task tile!");
            //               //     Navigator.push(
            //               //       context,
            //               //       MaterialPageRoute(
            //               //           builder: (context) => ViewTaskPage(  task: tasks[index],  isEditable: true,)),
            //               //     );
            //               //   },
            //               // ),
            //               //                       );
            //               //                     } else { ///
            //               //                       return const SizedBox( height:  0); // do not remove. tasks will not show up.
            //               //                     }
            //               //                   },
            //               //                  )
            //               //             else ///show this if there are no task
            //               ///
            //             ],
            //           ),
            //         ),
            //       ),
            //     )
            //   ],
            // ),
          ]
        )
      ),
    );
  }
}

