import 'package:deck/backend/task/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:deck/pages/task/view_task.dart';
import 'package:deck/pages/task/add_task.dart';
import 'package:deck/pages/misc/deck_icons2.dart';
import '../../backend/models/task.dart';
//sample

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  /// bool variable to toggle view
  bool isCalendarView = true;
  ///selectedDay : actual day selected by the user, used for highlighting.
  DateTime selectedDay = DateTime.now();
  /// focusedDay : variable that tracks which day is currently in focus
  DateTime focusedDay = DateTime.now();

  //funstion to switch the view
  void _toggleView() async {
    setState(() {
      isCalendarView = !isCalendarView;
    });
  }
  /// function to update whenever the user selects a new day on the calendar.
  /// DateTime day: This is the day that was selected by the user (from the calendar).
  /// DateTime focusedDay: This is the currently focused day.
  void _onDaySelected(DateTime day, DateTime newFocusedDay) {
    setState(() {
      selectedDay = day; //para sa display ng text
      focusedDay = newFocusedDay;
    });
  }

  DateTime today = DateTime.now();
  bool showAllTask = false;
  @override
  void initState() {
    super.initState();
    _getTasks();
  }

  void _getTasks() async {
    await Provider.of<TaskProvider>(context, listen: false).loadTasks();
  }

  Widget _buildTaskList(List<Task> tasks, bool Function(Task) filter) {
    final filteredTasks = tasks.where(filter).toList();
    if(filteredTasks.isNotEmpty) {
      return ListView.builder(
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          Task task = filteredTasks[index]; // Access the Task model directly
          // Check if the task should be displayed based on the conditions
          return Padding(
            padding: EdgeInsets.only(top:5),
            child: DeckTaskTile(
              title: task.title,
              deadline: TaskProvider.getNameDate(task.deadline),
              priority: task.priority, // You can customize this if needed
              progressStatus: 'to do',
              onDelete: () {
                final String deletedTitle = task.title;
                showConfirmationDialog(
                    context, "Delete Item",
                    "Are you sure you want to delete '$deletedTitle'?", () {
                  Provider.of<TaskProvider>(context, listen: false).deleteTask(task.uid);
                }, () {
                  setState(() {}); // You may need to handle state updates accordingly
                });
              },
              enableRetrieve: false,
              onTap: () {
                print("Clicked task tile!");
                print('Task: ${task.title}, IsDone: ${task.getIsDone}, IsActive: ${task.getIsActive}, Deadline: ${task.deadline}');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewTaskPage(task: task, isEditable: true),
                  ),
                );
              },
            ),
          );
          // Return an empty widget if conditions are not met
        },
      );
    } else {
      return IfCollectionEmpty(
        ifCollectionEmptyText: 'Seems like there aren’t any\n task for today, wanderer!',
        ifCollectionEmptySubText:
        'Now’s the perfect time to get ahead. Start\nadding new tasks and stay \non top of your game!',
        ifCollectionEmptyHeight: MediaQuery.of(context).size.height/2,
      );
    }
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
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom: 100),
      //   child:
        // DeckFAB(
        //   text: "Add Task",
        //   fontSize: 12,
        //   icon: Icons.add,
        //   foregroundColor: DeckColors.primaryColor,
        //   backgroundColor: DeckColors.gray,
        //   onPressed: () { Navigator.push( context, MaterialPageRoute(builder: (context) => const AddTaskPage()),);
        //   },
        // ),
      // ),
      body: SafeArea(
        top: true, bottom: false, left: true, right: true, minimum: const EdgeInsets.only(left: 20, right: 20),
        child: CustomScrollView(
          slivers: <Widget>[
            // DeckSliverHeader(
            //   backgroundColor: DeckColors.accentColor,
            //   headerTitle: "",
            //   textStyle: const TextStyle(
            //     color: DeckColors.white,
            //     fontFamily: 'Fraiche',
            //     fontSize: 30,
            //   ),
            //   isPinned: false,
            //   max: 60,
            //   min: 60,
            //   hasIcon: true,
            //   onPressed: _toggleView,
            //   icon: isCalendarView ? Icons.list :  Icons.calendar_today,
            // ),
            SliverToBoxAdapter(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        children: [
                          const Icon(
                            DeckIcons2.hat,
                            color: DeckColors.white,
                            size: 32,
                          ),
                          const Spacer(),
                          IconButton(
                              icon: const Icon (Icons.add,
                                  color: DeckColors.white,
                                  size: 32),
                              onPressed: () { Navigator.push( context, MaterialPageRoute(builder: (context) => const AddTaskPage()),);}

                          ),
                          IconButton(
                            icon:  Icon(
                                isCalendarView ? Icons.list :  Icons.calendar_today,
                                color: DeckColors.white,
                                size: 32),
                            onPressed: () {
                              setState(() {
                                isCalendarView = !isCalendarView;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ]
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      DateFormat('yyyy').format(focusedDay),
                      style: const TextStyle(
                          fontFamily: 'Fraiche',
                          fontSize: 30,
                          color: DeckColors.primaryColor,
                          fontWeight: FontWeight.bold)
                  ),
                  Text(
                      DateFormat('MMMM dd').format(focusedDay),
                      style: const TextStyle(
                          fontFamily: 'Fraiche',
                          fontSize: 56,
                          color: DeckColors.primaryColor,
                          fontWeight: FontWeight.bold)
                  ),
                ],
              ),
            ),

            /// if view option is calendar view, a calendar will be displayed
            if (isCalendarView) SliverList(
                delegate: SliverChildListDelegate([
                  TableCalendar(
                    eventLoader: _eventLoader,
                    focusedDay: focusedDay,
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(DateTime.now().year + 5, 1, 1),
                    onDaySelected: _onDaySelected,
                    selectedDayPredicate: (day) => isSameDay(day, focusedDay),
                    rowHeight: 40,
                    daysOfWeekHeight: 40,
                    calendarStyle: CalendarStyle(
                      canMarkersOverflow: false,
                      markersMaxCount: 1,
                      markerDecoration: const BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.rectangle),
                      defaultTextStyle: const TextStyle(
                        color: DeckColors.white,
                        fontFamily: 'nunito',
                        fontSize: 16,
                      ),
                      weekNumberTextStyle: const TextStyle(
                        color: DeckColors.white,
                        fontFamily: 'nunito',
                        fontSize: 16,
                      ),
                      weekendTextStyle: const TextStyle(
                        color: DeckColors.white,
                        fontFamily: 'nunito',
                        fontSize: 16,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: DeckColors.primaryColor,
                        border: Border.all(
                          color: DeckColors.primaryColor,
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: const BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      outsideDaysVisible: true,
                      outsideTextStyle: const TextStyle(
                        color: DeckColors.white,
                        fontFamily: 'nunito',
                        fontSize: 16,
                      ),
                    ),
                    headerStyle: HeaderStyle(
                      titleTextFormatter: (date, locale) {
                        return DateFormat('MMMM').format(date);
                      },
                      leftChevronIcon: const Icon(Icons.arrow_back_ios_rounded,
                          color: DeckColors.white),
                      leftChevronMargin: const EdgeInsets.only(right: 10),
                      leftChevronPadding: const EdgeInsets.all(10),
                      rightChevronIcon: const Icon(Icons.arrow_forward_ios_rounded,
                          color: DeckColors.white),
                      rightChevronPadding: const EdgeInsets.all(10),
                      rightChevronMargin: EdgeInsets.zero,
                      formatButtonVisible: false,
                      titleTextStyle: const TextStyle(
                        color: DeckColors.white,
                        fontSize: 20,
                        fontFamily: 'Fraiche',
                      ),
                    ),
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        color: DeckColors.primaryColor,
                        fontSize: 20,
                        fontFamily: 'Fraiche',
                      ),
                      weekendStyle: TextStyle(
                        color: DeckColors.white,
                        fontSize: 20,
                        fontFamily: 'Fraiche',
                      ),
                    ),
                    calendarBuilders: CalendarBuilders(markerBuilder: (context, date, events) {
                      if (events.isNotEmpty) {
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            width: 5,
                            height: 2,
                            color: DeckColors.primaryColor,
                          ),
                        );
                      }
                    }),
                  )
                ])
            ),
            if(isCalendarView) const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
            /// calendar view, will show list of task
            if(isCalendarView) SliverToBoxAdapter(
              child: Container(
                height: (MediaQuery.of(context).size.height/2),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal:50),
                decoration: const BoxDecoration(
                  color: DeckColors.coverImageColorSettings,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),  // Rounded top-left corner
                    topRight: Radius.circular(60), // Rounded top-right corner
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: BuildTabBar(
                    titles: const ['To Do', 'Active', 'Done'],
                    length: 3,
                    tabContent: [
                      _buildTaskList(tasks, (task) => !task.getIsDone && !task.getIsActive && isSameDay(task.deadline, selectedDay)),
                      _buildTaskList(tasks, (task) => task.getIsActive && !task.getIsDone && isSameDay(task.deadline, selectedDay)),
                      _buildTaskList(tasks, (task) => task.getIsDone && !task.getIsActive && isSameDay(task.deadline, selectedDay)),
                      // if (isThereTaskForDay(today, false) || showAllTask)
                      //   ListView.builder(
                      //     shrinkWrap:
                      //         true, // Allow the ListView to wrap its content
                      //     physics: const NeverScrollableScrollPhysics(),
                      //     itemCount: tasks.length,
                      //     itemBuilder: (context, index) {
                      //       if ((showAllTask && tasks[index].getIsDone) ||
                      //           (tasks[index].getIsDone &&
                      //               isSameDay(
                      //                   tasks[index].deadline, selectedDay))) {
                      //         return Padding(
                      //           padding: const EdgeInsets.symmetric(vertical: 10),
                      //           child: DeckTaskTile(
                      //             title: tasks[index].title,
                      //             deadline: tasks[index]
                      //                 .deadline
                      //                 .toString()
                      //                 .split(" ")[0],
                      //             isChecked: tasks[index].getIsDone,
                      //             onChanged: (newValue) {
                      //               setState(() {
                      //                 tasks[index].setIsDone = newValue ?? false;
                      //                 Provider.of<TaskProvider>(context,
                      //                         listen: false)
                      //                     .setTaskUndone(tasks[index]);
                      //               });
                      //             },
                      //             onDelete: () {
                      //               final String deletedTitle =
                      //                   tasks[index].title;
                      //               showConfirmationDialog(
                      //                 context,
                      //                 "Delete Item",
                      //                 "Are you sure you want to delete '$deletedTitle'?",
                      //                 () {
                      //                   Provider.of<TaskProvider>(context,
                      //                           listen: false)
                      //                       .deleteTask(tasks[index].uid);
                      //                 },
                      //                 () {
                      //                   setState(() {});
                      //                 },
                      //               );
                      //             },
                      //             enableRetrieve: false,
                      //             onTap: () {
                      //               print("Clicked task tile!");
                      //               Navigator.push(
                      //                 context,
                      //                 MaterialPageRoute(
                      //                     builder: (context) => ViewTaskPage(
                      //                           task: tasks[index],
                      //                           isEditable: true,
                      //                         )),
                      //               );
                      //             },
                      //           ),
                      //         );
                      //       } else {
                      //         return const SizedBox(
                      //             height: 0); // Placeholder for empty space
                      //       }
                      //     },
                      //   )
                      // else

                      ///old codes here please delete if d na need
                      //                if (isThereTaskForDay(today, true))
                      //                  ListView.builder(
                      //                   shrinkWrap:  true, // Allow the ListView to wrap its content
                      //                   physics: const NeverScrollableScrollPhysics(),
                      //                   itemCount: tasks.length,
                      //                   itemBuilder: (context, index) {
                      //                     if ((showAllTask && !tasks[index].getIsDone) || (!tasks[index].getIsDone && isSameDay(tasks[index].deadline, selectedDay))) {
                      //                       return Padding(
                      //                         padding: const EdgeInsets.symmetric(vertical: 10),
                      //                         child: DeckTaskTile(
                      //                           title:
                      //                           , deadline:.
                      //                           priority: ,
                      //                           progressStatus:.
                      //                           onDelete,
                      //                           onRetrieve:,
                      //                           onTap: ,
                      //                           enableRetrieve:
                      //                         ),
                      // DeckTaskTile(
                      //   title: tasks[index].title,
                      //   deadline: tasks[index]
                      //       .deadline
                      //       .toString()
                      //       .split(" ")[0],
                      //   isChecked: tasks[index].getIsDone,
                      //   onChanged: (newValue) {
                      //     setState(() {
                      //       tasks[index].setIsDone = newValue ?? false;
                      //       Provider.of<TaskProvider>(context,
                      //               listen: false)
                      //           .setTaskDone(tasks[index]);
                      //     });
                      //   },
                      //   onDelete: () {
                      //     final String deletedTitle =
                      //         tasks[index].title;
                      //     showConfirmationDialog(
                      //       context,
                      //       "Delete Item",
                      //       "Are you sure you want to delete '$deletedTitle'?",
                      //       () {
                      //         Provider.of<TaskProvider>(context,
                      //                 listen: false)
                      //             .deleteTask(tasks[index].uid);
                      //       },
                      //       () { setState(() {}); },
                      //     );
                      //   },
                      //   enableRetrieve: false,
                      //   onTap: () {
                      //     // print("Clicked task tile!");
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => ViewTaskPage(  task: tasks[index],  isEditable: true,)),
                      //     );
                      //   },
                      // ),
                      //                       );
                      //                     } else { ///
                      //                       return const SizedBox( height:  0); // do not remove. tasks will not show up.
                      //                     }
                      //                   },
                      //                  )
                      //             else ///show this if there are no task
                      ///
                    ],
                  ),
                ),
              ),
            )
            else SliverToBoxAdapter(
              child: Container(
                height: (MediaQuery.of(context).size.height/1.25),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal:50),
                decoration: const BoxDecoration(
                  color: DeckColors.coverImageColorSettings,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),  // Rounded top-left corner
                    topRight: Radius.circular(60), // Rounded top-right corner
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: BuildTabBar(
                    titles: const ['To Do', 'Active', 'Done'],
                    length: 3,
                    tabContent: [
                      _buildTaskList(tasks, (task) => !task.getIsDone && !task.getIsActive),
                      _buildTaskList(tasks, (task) => task.getIsActive && !task.getIsDone),
                      _buildTaskList(tasks, (task) => task.getIsDone && !task.getIsActive)

                      ///if TO DO tab does not contain a task

                      ///in progress tab
                      // SingleChildScrollView(
                      //   padding: EdgeInsets.only(top: 20),
                      //   child:
                      //   ListView.builder(
                      //     shrinkWrap:  true, // Allow the ListView to wrap its content
                      //     physics: const NeverScrollableScrollPhysics(),
                      //     itemCount: 10 /*tasks.length*/,
                      //     itemBuilder: (context, index) {
                      //       return DeckTaskTile(
                      //         title: 'a high priority task',
                      //         deadline: 'March 18, 2024 || 10:00 AM',
                      //         priority: 'medium',
                      //         progressStatus: 'to do',
                      //         // title: tasks[index]['title'],
                      //         // deadline: tasks[index]['deadline'],
                      //         // priority: tasks[index]['priority'],
                      //         // progressStatus: tasks[index]['progressStatus'],
                      //         onDelete: () {
                      //           // final String deletedTitle = tasks[index].title;
                      //           // showConfirmationDialog(
                      //           //   context, "Delete Item",
                      //           //   "Are you sure you want to delete '$deletedTitle'?",() {
                      //           //     Provider.of<TaskProvider>(context,listen: false).deleteTask(tasks[index].uid);},() { setState(() {}); },
                      //           // );
                      //         },
                      //         enableRetrieve: false,
                      //         onTap: () {
                      //           print("Clicked task tile!");
                      //           // Navigator.push(
                      //           // context,
                      //           // MaterialPageRoute(
                      //           //   builder: (context) => ViewTaskPage(  task: tasks[index],  isEditable: true,)),
                      //           // );
                      //         },
                      //       );
                      //     },
                      //   ),
                      // ),
                      ///if IN PROGRESS tab does not contain a task
                      /// if Complete tab does not contain a task
                      // IfCollectionEmpty(
                      //   ifCollectionEmptyText: 'Seems like there aren’t any\n task for today, wanderer!',
                      //   ifCollectionEmptySubText: 'Now’s the perfect time to get ahead. Start\nadding new tasks and stay \non top of your game!',
                      //   ifCollectionEmptyHeight: MediaQuery.of(context).size.height/2,
                      // )
                      // if (isThereTaskForDay(today, false) || showAllTask)
                      //   ListView.builder(
                      //     shrinkWrap:
                      //         true, // Allow the ListView to wrap its content
                      //     physics: const NeverScrollableScrollPhysics(),
                      //     itemCount: tasks.length,
                      //     itemBuilder: (context, index) {
                      //       if ((showAllTask && tasks[index].getIsDone) ||
                      //           (tasks[index].getIsDone &&
                      //               isSameDay(
                      //                   tasks[index].deadline, selectedDay))) {
                      //         return Padding(
                      //           padding: const EdgeInsets.symmetric(vertical: 10),
                      //           child: DeckTaskTile(
                      //             title: tasks[index].title,
                      //             deadline: tasks[index]
                      //                 .deadline
                      //                 .toString()
                      //                 .split(" ")[0],
                      //             isChecked: tasks[index].getIsDone,
                      //             onChanged: (newValue) {
                      //               setState(() {
                      //                 tasks[index].setIsDone = newValue ?? false;
                      //                 Provider.of<TaskProvider>(context,
                      //                         listen: false)
                      //                     .setTaskUndone(tasks[index]);
                      //               });
                      //             },
                      //             onDelete: () {
                      //               final String deletedTitle =
                      //                   tasks[index].title;
                      //               showConfirmationDialog(
                      //                 context,
                      //                 "Delete Item",
                      //                 "Are you sure you want to delete '$deletedTitle'?",
                      //                 () {
                      //                   Provider.of<TaskProvider>(context,
                      //                           listen: false)
                      //                       .deleteTask(tasks[index].uid);
                      //                 },
                      //                 () {
                      //                   setState(() {});
                      //                 },
                      //               );
                      //             },
                      //             enableRetrieve: false,
                      //             onTap: () {
                      //               print("Clicked task tile!");
                      //               Navigator.push(
                      //                 context,
                      //                 MaterialPageRoute(
                      //                     builder: (context) => ViewTaskPage(
                      //                           task: tasks[index],
                      //                           isEditable: true,
                      //                         )),
                      //               );
                      //             },
                      //           ),
                      //         );
                      //       } else {
                      //         return const SizedBox(
                      //             height: 0); // Placeholder for empty space
                      //       }
                      //     },
                      //   )
                      // else

                      ///old codes here please delete if d na need
                      //                if (isThereTaskForDay(today, true))
                      //                  ListView.builder(
                      //                   shrinkWrap:  true, // Allow the ListView to wrap its content
                      //                   physics: const NeverScrollableScrollPhysics(),
                      //                   itemCount: tasks.length,
                      //                   itemBuilder: (context, index) {
                      //                     if ((showAllTask && !tasks[index].getIsDone) || (!tasks[index].getIsDone && isSameDay(tasks[index].deadline, selectedDay))) {
                      //                       return Padding(
                      //                         padding: const EdgeInsets.symmetric(vertical: 10),
                      //                         child: DeckTaskTile(
                      //                           title:
                      //                           , deadline:.
                      //                           priority: ,
                      //                           progressStatus:.
                      //                           onDelete,
                      //                           onRetrieve:,
                      //                           onTap: ,
                      //                           enableRetrieve:
                      //                         ),
                      // DeckTaskTile(
                      //   title: tasks[index].title,
                      //   deadline: tasks[index]
                      //       .deadline
                      //       .toString()
                      //       .split(" ")[0],
                      //   isChecked: tasks[index].getIsDone,
                      //   onChanged: (newValue) {
                      //     setState(() {
                      //       tasks[index].setIsDone = newValue ?? false;
                      //       Provider.of<TaskProvider>(context,
                      //               listen: false)
                      //           .setTaskDone(tasks[index]);
                      //     });
                      //   },
                      //   onDelete: () {
                      //     final String deletedTitle =
                      //         tasks[index].title;
                      //     showConfirmationDialog(
                      //       context,
                      //       "Delete Item",
                      //       "Are you sure you want to delete '$deletedTitle'?",
                      //       () {
                      //         Provider.of<TaskProvider>(context,
                      //                 listen: false)
                      //             .deleteTask(tasks[index].uid);
                      //       },
                      //       () { setState(() {}); },
                      //     );
                      //   },
                      //   enableRetrieve: false,
                      //   onTap: () {
                      //     // print("Clicked task tile!");
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => ViewTaskPage(  task: tasks[index],  isEditable: true,)),
                      //     );
                      //   },
                      // ),
                      //                       );
                      //                     } else { ///
                      //                       return const SizedBox( height:  0); // do not remove. tasks will not show up.
                      //                     }
                      //                   },
                      //                  )
                      //             else ///show this if there are no task
                      ///
                    ],
                  ),
                ),
              ),
            )
            // else
          ],
        ),
      ),
    );
  }
}