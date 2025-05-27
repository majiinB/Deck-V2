import 'package:auto_size_text/auto_size_text.dart';
import 'package:deck/backend/task/task_provider.dart';
import 'package:deck/backend/task/task_service.dart';
import 'package:deck/pages/misc/custom%20widgets/progressbar/progress_bar.dart';
import 'package:deck/pages/task/view_task.dart';
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
// import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
// import 'package:deck/pages/task/view_task.dart';
import 'package:deck/pages/task/add_task.dart';
// import 'package:deck/pages/misc/deck_icons2.dart';
import '../../backend/models/TaskFolder.dart';
import '../../backend/models/newTask.dart';
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
import '../misc/custom widgets/functions/if_collection_empty.dart';
import '../misc/custom widgets/functions/tab_bar.dart';
import '../misc/custom widgets/tiles/task_list.dart';
import '../misc/custom widgets/tiles/task_tile.dart';
import '../misc/deck_icons.dart';
import '../misc/deck_icons2.dart';
import 'edit_task_folder.dart';

class ViewTaskFolderPage extends StatefulWidget {
  final TaskFolder taskFolder;

  ViewTaskFolderPage({
    super.key,
    required this.taskFolder
  });
  @override
  _ViewTaskFolderPageState createState() => _ViewTaskFolderPageState();
}

class _ViewTaskFolderPageState extends State<ViewTaskFolderPage> {
  bool _isLoading = false;
  int totalTask = 0;
  int totalPending = 0;
  int totalProgress = 0;
  int totalCompleted = 0;
  int totalHighPrio = 0;
  int totalMidPrio = 0;
  int totalLowPrio = 0;
  double progressValue = 0;
  String progressLabel ='';
  DateTime today = DateTime.now();
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  Map<String, double> workloadData = {};
  Map<String, double> priorityData = {};
  final TaskService _taskService = TaskService();
  List<NewTask> pendingTasks = [];
  List<NewTask> inProgressTasks = [];
  List<NewTask> completedTasks = [];
  List<NewTask> pendingByDateTasks = [];
  List<NewTask> inProgressByDateTasks = [];
  List<NewTask> completedByDateTasks = [];
  Map<DateTime, List<NewTask>> tasksByDate = {};
  List<Color> workLoadColorList =[DeckColors.deepGray,DeckColors.softGreen, DeckColors.accentColor];
  List<Color> priorityColorList =[DeckColors.deckRed,DeckColors.deckYellow,DeckColors.deckBlue];

  /// function to get the total number of all task, pending task, tasks in progress, completed task
  /// this will be used for the overview tab
  /// this need to be set again if user changes something for the new info to be displayed
  void _getOverview() {
    // Combine all tasks into one list
    List<NewTask> allTasks = [
      ...pendingTasks,
      ...inProgressTasks,
      ...completedTasks,
    ];

    int total = allTasks.length;

    // Count statuses
    int pendingCount = pendingTasks.length;
    int inProgressCount = inProgressTasks.length;
    int completedCount = completedTasks.length;

    // Count priority levels
    int highPriorityCount = allTasks.where((task) => task.priority == 'High').length;
    int mediumPriorityCount = allTasks.where((task) => task.priority == 'Medium').length;
    int lowPriorityCount = allTasks.where((task) => task.priority == 'Low').length;

    setState(() {
      totalTask = total;
      totalPending = pendingCount;
      totalProgress = inProgressCount;
      totalCompleted = completedCount;
      totalHighPrio = highPriorityCount;
      totalMidPrio = mediumPriorityCount;
      totalLowPrio = lowPriorityCount;
      workloadData = {
        "$totalPending - Pending": totalPending.toDouble(),
        "$totalProgress - In Progress": totalProgress.toDouble(),
        "$totalCompleted - Completed": totalCompleted.toDouble(),
      };
      priorityData = {
        "$totalHighPrio - High": totalPending.toDouble(),
        "$totalMidPrio - Medium": totalProgress.toDouble(),
        "$totalLowPrio - Low": totalCompleted.toDouble(),
      };
    });
  }

  void _getTasks() async {
    try{
      setState(() {
        _isLoading = true;
      });
      Map<String, List<NewTask>> taskGroups = await _taskService.fetchTasksByFolder(taskFolderId: widget.taskFolder.id);
      print(taskGroups);
      setState(() {
        pendingTasks = taskGroups['pending']!;
        inProgressTasks = taskGroups['inProgress']!;
        completedTasks = taskGroups['completed']!;
        _getOverview();
        _groupTasksByDate();
        _isLoading = false;
      });
    }catch(e){
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// function to update whenever the user selects a new day on the calendar.
  /// DateTime day: This is the day that was selected by the user (from the calendar).
  /// DateTime focusedDay: This is the currently focused day.
  void _onDaySelected(DateTime day, DateTime newFocusedDay) async{
    setState(() {
      selectedDay = day; //para sa display ng text
      focusedDay = newFocusedDay;
      _filterTasksByDate(day);
    });
  }

  void _filterTasksByDate(DateTime date) {
    final targetDate = DateFormat('yyyy-MM-dd').format(date); // adjust your date format to match task.startDate

    pendingByDateTasks = pendingTasks
        .where((task) => DateFormat('yyyy-MM-dd').format(task.startDate) == targetDate)
        .toList();

    inProgressByDateTasks = inProgressTasks
        .where((task) => DateFormat('yyyy-MM-dd').format(task.startDate) == targetDate)
        .toList();

    completedByDateTasks = completedTasks
        .where((task) => DateFormat('yyyy-MM-dd').format(task.startDate) == targetDate)
        .toList();
  }

  void _groupTasksByDate() {
    tasksByDate.clear();

    List<NewTask> allTasks = [
      ...pendingTasks,
      ...inProgressTasks,
      ...completedTasks,
    ];

    for (var task in allTasks) {
      final taskDate = DateTime(task.startDate.year, task.startDate.month, task.startDate.day);

      if (tasksByDate[taskDate] == null) {
        tasksByDate[taskDate] = [];
      }

      tasksByDate[taskDate]!.add(task);
    }
  }


  @override
  void initState() {
    super.initState();
    _getTasks();
  }

  Widget buildOverviewTab( int? total, int? complete){
    /// buildOverviewTab is a widget designed to present a comprehensive overview of task progress
    /// and distribution within the folder .
    /// It displays three primary sections:
    ///   overall progress,
    ///   workload by status,
    ///   and priority breakdown.
    progressValue = (total != 0) ? (complete ?? 0) / total! : 0.0;
    progressLabel = "$complete / $total";
    return  SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(20),
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
                    colorList: workLoadColorList,
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
                    dataMap: (priorityData != null && priorityData.isNotEmpty)
                        ? priorityData
                        : {"No Data": 100},
                    colorList: priorityColorList,
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
    /// buildListTab is a widget designed to present a list of all the task
    /// It  organizes tasks into different categories using tabs:
    ///   pending
    ///   in progress
    ///   completed

    return  Container(
        padding: EdgeInsets.only(left: 30,right: 30),
        decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(color: DeckColors.primaryColor, width: 3),
              right: BorderSide(color: DeckColors.primaryColor, width: 3),
              top: BorderSide(color: DeckColors.primaryColor, width: 3),
              bottom: BorderSide.none,
            ),
            color: DeckColors.white,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(50)
            )
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              BuildButton(
                  icon: Icons.add_rounded,
                  buttonText: "Add task",
                  // height: 30,
                  width: MediaQuery.of(context).size.width,
                  radius: 20,
                  backgroundColor: DeckColors.deckYellow,
                  textColor: DeckColors.primaryColor,
                  paddingIconText: 10,
                  iconColor:  DeckColors.primaryColor,
                  size: 20,
                  fontSize: 15,
                  borderWidth: 3,
                  borderColor: DeckColors.primaryColor,
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      RouteGenerator.createRoute(AddTaskPage(taskFolder: widget.taskFolder,)),
                    );
                    _getTasks();
                  }
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 500,
                child:BuildTabBar(
                  titles: ['Pending', 'In Progress', 'Completed'],
                  length: 3,
                  tabContent: [
                    SingleChildScrollView(
                      padding: EdgeInsets.only(top: 20, bottom: 100),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: pendingTasks.length,
                        itemBuilder: (context, index) {
                          return TaskTile(
                            taskName: pendingTasks[index].title,
                            deadline: pendingTasks[index].startDate,
                            priority: pendingTasks[index].priority,
                            progressStatus: pendingTasks[index].status,
                            onDelete: () {},
                            onPressed: () {
                              Navigator.push(
                                context,
                                RouteGenerator.createRoute(ViewTaskPage(task: pendingTasks[index], isEditable: true)),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    SingleChildScrollView(
                        padding: EdgeInsets.only(top: 20,bottom:100),
                        child:ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: inProgressTasks.length,
                          itemBuilder: (context, index) {
                            return TaskTile(
                              taskName: inProgressTasks[index].title,
                              deadline: inProgressTasks[index].startDate,
                              priority: inProgressTasks[index].priority,
                              progressStatus: inProgressTasks[index].status,
                              onDelete: () {},
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  RouteGenerator.createRoute(ViewTaskPage(task: inProgressTasks[index], isEditable: true)),
                                );
                              },
                            );
                          },
                        ),
                    ),
                    SingleChildScrollView(
                        padding: EdgeInsets.only(top: 20,bottom:100),
                        child:ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: completedTasks.length,
                          itemBuilder: (context, index) {
                            return TaskTile(
                              taskName: completedTasks[index].title,
                              deadline: completedTasks[index].startDate,
                              priority: completedTasks[index].priority,
                              progressStatus: completedTasks[index].status,
                              onDelete: () {},
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  RouteGenerator.createRoute(ViewTaskPage(task: completedTasks[index], isEditable: true)),
                                );
                              },
                            );
                          },
                        ),
                    ),
                  ],
                )
              )
            ],
          ),
        )
    );
  }
  Widget buildCalendarTab(){
    return  Container(
        padding: const EdgeInsets.only(left: 30,right: 30),
        decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(color: DeckColors.primaryColor, width: 3),
              right: BorderSide(color: DeckColors.primaryColor, width: 3),
              top: BorderSide(color: DeckColors.primaryColor, width: 3),
              bottom: BorderSide.none,
            ),
            color: DeckColors.white,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(50)
            )
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                  DateFormat('yyyy').format(focusedDay),
                  style: const TextStyle(
                      fontFamily: 'Fraiche',
                      fontSize: 20,
                      color: DeckColors.accentColor,
                      )
              ),
              TableCalendar(
                eventLoader: (day) {
                  final date = DateTime(day.year, day.month, day.day);
                  return tasksByDate[date] ?? [];
                },
                focusedDay: focusedDay,
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(DateTime.now().year + 5, 1, 1),
                onDaySelected: _onDaySelected,
                selectedDayPredicate: (day) => isSameDay(day, focusedDay),
                rowHeight: 35,
                daysOfWeekHeight: 20,
                calendarStyle: CalendarStyle(
                  cellMargin: EdgeInsets.all(2),
                  canMarkersOverflow: false,
                  markersMaxCount: 1,
                  markerDecoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle),
                  defaultTextStyle: const TextStyle(
                    color: DeckColors.primaryColor,
                    fontFamily: 'Nunito-Regular',
                    fontSize: 15,
                  ),
                  weekNumberTextStyle: const TextStyle(
                    color: DeckColors.primaryColor,
                    fontFamily: 'Nunito-Regular',
                    fontSize: 15,
                  ),
                  weekendTextStyle: const TextStyle(
                    color: DeckColors.primaryColor,
                    fontFamily: 'Nunito-Regular',
                    fontSize: 15,
                  ),
                  selectedTextStyle: const TextStyle(
                    color: DeckColors.white,
                    fontFamily: 'Nunito-Regular',
                    fontSize: 15,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: DeckColors.accentColor ,
                    // border: Border.all(
                    //   color: DeckColors.primaryColor,
                    //   width: 2,
                    // ),
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle:const TextStyle(
                    color: DeckColors.primaryColor,
                    fontFamily: 'Nunito-Regular',
                    fontSize: 15,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: DeckColors.primaryColor,
                      width: 2,
                    ),
                  ),
                  outsideDaysVisible: true,
                  outsideTextStyle: const TextStyle(
                    color: DeckColors.softGray,
                    fontFamily: 'Nunito-Regular',
                    fontSize: 15,
                  ),
                ),
                headerStyle: HeaderStyle(
                  headerPadding: EdgeInsets.zero,
                  titleTextFormatter: (date, locale) {
                    return DateFormat('MMMM d').format(date);
                  },
                  leftChevronIcon: const Icon(
                      Icons.arrow_left_rounded,
                      color: DeckColors.primaryColor
                  ),
                  leftChevronMargin: const EdgeInsets.only(right: 10),
                  leftChevronPadding: const EdgeInsets.only(right: 10),
                  rightChevronIcon: const Icon(
                      Icons.arrow_right_rounded,
                      color: DeckColors.primaryColor
                  ),
                  rightChevronPadding: const EdgeInsets.only(left: 10),
                  rightChevronMargin: EdgeInsets.zero,
                  formatButtonVisible: false,
                  titleTextStyle: const TextStyle(
                    color: DeckColors.accentColor,
                    fontSize: 40,
                    fontFamily: 'Fraiche',
                  ),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: DeckColors.primaryColor,
                    fontSize:  15,
                    fontFamily: 'Fraiche',
                  ),
                  weekendStyle: TextStyle(
                    color: DeckColors.primaryColor,
                    fontSize: 15,
                    fontFamily: 'Fraiche',
                  ),
                ),
              ),
              BuildButton(
                  icon: Icons.add_rounded,
                  buttonText: "Add task",
                  // height: 30,
                  width: MediaQuery.of(context).size.width,
                  radius: 20,
                  backgroundColor: DeckColors.deckYellow,
                  textColor: DeckColors.primaryColor,
                  paddingIconText: 10,
                  iconColor:  DeckColors.primaryColor,
                  size: 20,
                  fontSize: 15,
                  borderWidth: 3,
                  borderColor: DeckColors.primaryColor,
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      RouteGenerator.createRoute(AddTaskPage(taskFolder: widget.taskFolder)),
                    );
                    _getTasks();
                    _filterTasksByDate(selectedDay);
                  }
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 500,
                  child:BuildTabBar(
                    titles: ['Pending', 'In Progress', 'Completed'],
                    length: 3,
                    tabContent: [
                      SingleChildScrollView(
                        padding: EdgeInsets.only(top: 20, bottom: 100),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: pendingByDateTasks.length ?? 0,
                          itemBuilder: (context, index) {
                            final task = pendingByDateTasks[index];
                            return TaskTile(
                              taskName: task.title,
                              deadline: task.startDate,
                              priority: task.priority,
                              progressStatus: task.status,
                              onDelete: () {
                                // your delete logic
                              },
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  RouteGenerator.createRoute(
                                    ViewTaskPage(task: task, isEditable: true),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      SingleChildScrollView(
                        padding: EdgeInsets.only(top: 20, bottom: 100),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: inProgressByDateTasks.length ?? 0,
                          itemBuilder: (context, index) {
                            final task = inProgressByDateTasks[index];
                            return TaskTile(
                              taskName: task.title,
                              deadline: task.startDate,
                              priority: task.priority,
                              progressStatus: task.status,
                              onDelete: () {
                                // your delete logic
                              },
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  RouteGenerator.createRoute(
                                    ViewTaskPage(task: task, isEditable: true),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      SingleChildScrollView(
                        padding: EdgeInsets.only(top: 20, bottom: 100),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: completedByDateTasks.length ?? 0,
                          itemBuilder: (context, index) {
                            final task = completedByDateTasks[index];
                            return TaskTile(
                              taskName: task.title,
                              deadline: task.startDate,
                              priority: task.priority,
                              progressStatus: task.status,
                              onDelete: () {
                                // your delete logic
                              },
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  RouteGenerator.createRoute(
                                    ViewTaskPage(task: task, isEditable: true),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  )
              )
            ],
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
    List<Task> _eventLoader(DateTime day) {
      return tasks
          .where((task) => !task.isDone && isSameDay(task.deadline, day))
          .toList();
    }
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
                            widget.taskFolder.title ?? 'Unititled',
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
                // SizedBox(
                //   width: MediaQuery.of(context).size.width,
                //   height: MediaQuery.of(context).size.height * .6,
                //   child:
                // )
                Expanded(
                  child: Container(
                    child: BuildTabBar(
                      titles: const ['Overview','List Mode','Calendar'],
                      icons: const[Icons.folder_outlined,DeckIcons2.list,Icons.calendar_today],
                      length: 3,
                      hasContentPadding: false,
                      color: DeckColors.deckYellow,
                      tabContent: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: _isLoading
                              ? Center(child: CircularProgressIndicator())
                              : buildOverviewTab(totalTask, totalCompleted),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: buildListTab(),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: buildCalendarTab(),
                          ),
                        ),

                        // ListModeTab(),
                        // CalendarTab(),
                      ],
                    ),
                  )
                )

              ]
          )
      ),
    );
  }
}

