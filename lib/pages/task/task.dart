import 'package:deck/backend/task/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:deck/pages/task/view_task.dart';
import 'package:deck/pages/task/add_task.dart';

import '../../backend/models/task.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  DateTime today = DateTime.now();
  DateTime selectedDay = DateTime.now();
  bool showAllTask = false;
  @override
  void initState() {
    super.initState();
    _getTasks();
  }

  void _toggleView() async {
    setState(() {
      showAllTask = !showAllTask;
    });
  }

  void _getTasks() async {
    await Provider.of<TaskProvider>(context, listen: false).loadTasks();
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
      selectedDay = day; //para sa display ng text
    });
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: DeckFAB(
          text: "Add Task",
          fontSize: 12,
          icon: Icons.add,
          foregroundColor: DeckColors.primaryColor,
          backgroundColor: DeckColors.gray,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddTaskPage()),
            );
          },
        ),
      ),
      body: SafeArea(
        top: true,
        bottom: false,
        left: true,
        right: true,
        minimum: const EdgeInsets.only(left: 20, right: 20),
        child: CustomScrollView(
          slivers: <Widget>[
            DeckSliverHeader(
              backgroundColor: DeckColors.backgroundColor,
              headerTitle: showAllTask
                  ? "All Task"
                  : DateFormat('EEEE, MMMM dd').format(selectedDay),
              textStyle: const TextStyle(
                color: DeckColors.primaryColor,
                fontFamily: 'Fraiche',
                fontSize: 30,
              ),
              max: 50,
              min: 50,
              hasIcon: true,
              onPressed: _toggleView,
              icon: showAllTask ? Icons.calendar_today : Icons.list,
            ),
            if (!showAllTask)
              SliverList(
                  delegate: SliverChildListDelegate([
                TableCalendar(
                  eventLoader: _eventLoader,
                  focusedDay: today,
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(DateTime.now().year + 5, 1, 1),
                  onDaySelected: _onDaySelected,
                  selectedDayPredicate: (day) => isSameDay(day, today),
                  rowHeight: 40,
                  daysOfWeekHeight: 40,
                  calendarStyle: CalendarStyle(
                    canMarkersOverflow: false,
                    markersMaxCount: 1,
                    markerDecoration: const BoxDecoration(
                        color: Colors.transparent, shape: BoxShape.rectangle),
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
                  headerStyle: const HeaderStyle(
                    leftChevronIcon: Icon(Icons.arrow_back_ios_rounded,
                        color: DeckColors.white),
                    leftChevronMargin: EdgeInsets.only(right: 10),
                    leftChevronPadding: EdgeInsets.all(10),
                    rightChevronIcon: Icon(Icons.arrow_forward_ios_rounded,
                        color: DeckColors.white),
                    rightChevronPadding: EdgeInsets.all(10),
                    rightChevronMargin: EdgeInsets.zero,
                    formatButtonVisible: false,
                    titleTextStyle: TextStyle(
                      color: DeckColors.white,
                      fontSize: 28,
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
                  calendarBuilders:
                      CalendarBuilders(markerBuilder: (context, date, events) {
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
              ])),
            SliverFillRemaining(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: BuildTabBar(
                  titles: const ['To Do', 'Done'],
                  length: 2,
                  tabContent: [
                    // To Do Tab
                    if (isThereTaskForDay(today, true) || showAllTask)
                      ListView.builder(
                        shrinkWrap:
                            true, // Allow the ListView to wrap its content
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          if ((showAllTask && !tasks[index].getIsDone) ||
                              (!tasks[index].getIsDone &&
                                  isSameDay(
                                      tasks[index].deadline, selectedDay))) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: DeckTaskTile(
                                title: tasks[index].title,
                                deadline: tasks[index]
                                    .deadline
                                    .toString()
                                    .split(" ")[0],
                                isChecked: tasks[index].getIsDone,
                                onChanged: (newValue) {
                                  setState(() {
                                    tasks[index].setIsDone = newValue ?? false;
                                    Provider.of<TaskProvider>(context,
                                            listen: false)
                                        .setTaskDone(tasks[index]);
                                  });
                                },
                                onDelete: () {
                                  final String deletedTitle =
                                      tasks[index].title;
                                  showConfirmationDialog(
                                    context,
                                    "Delete Item",
                                    "Are you sure you want to delete '$deletedTitle'?",
                                    () {
                                      Provider.of<TaskProvider>(context,
                                              listen: false)
                                          .deleteTask(tasks[index].uid);
                                    },
                                    () {
                                      setState(() {});
                                    },
                                  );
                                },
                                enableRetrieve: false,
                                onTap: () {
                                  print("Clicked task tile!");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ViewTaskPage(
                                              task: tasks[index],
                                              isEditable: true,
                                            )),
                                  );
                                },
                              ),
                            );
                          } else {
                            return const SizedBox(
                                height:
                                    0); // do not remove. tasks will not show up.
                          }
                        },
                      )
                    else
                      IfCollectionEmpty(
                        ifCollectionEmptyText: 'No new task',
                        ifCollectionEmptySubText:
                            'To create another Task, \nsimply Click the "+" button  ',
                        ifCollectionEmptyHeight:
                            MediaQuery.of(context).size.height * 0.1,
                      ),

                    // Done Tab
                    if (isThereTaskForDay(today, false) || showAllTask)
                      ListView.builder(
                        shrinkWrap:
                            true, // Allow the ListView to wrap its content
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          if ((showAllTask && tasks[index].getIsDone) ||
                              (tasks[index].getIsDone &&
                                  isSameDay(
                                      tasks[index].deadline, selectedDay))) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: DeckTaskTile(
                                title: tasks[index].title,
                                deadline: tasks[index]
                                    .deadline
                                    .toString()
                                    .split(" ")[0],
                                isChecked: tasks[index].getIsDone,
                                onChanged: (newValue) {
                                  setState(() {
                                    tasks[index].setIsDone = newValue ?? false;
                                    Provider.of<TaskProvider>(context,
                                            listen: false)
                                        .setTaskUndone(tasks[index]);
                                  });
                                },
                                onDelete: () {
                                  final String deletedTitle =
                                      tasks[index].title;
                                  showConfirmationDialog(
                                    context,
                                    "Delete Item",
                                    "Are you sure you want to delete '$deletedTitle'?",
                                    () {
                                      Provider.of<TaskProvider>(context,
                                              listen: false)
                                          .deleteTask(tasks[index].uid);
                                    },
                                    () {
                                      setState(() {});
                                    },
                                  );
                                },
                                enableRetrieve: false,
                                onTap: () {
                                  print("Clicked task tile!");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ViewTaskPage(
                                              task: tasks[index],
                                              isEditable: true,
                                            )),
                                  );
                                },
                              ),
                            );
                          } else {
                            return const SizedBox(
                                height: 0); // Placeholder for empty space
                          }
                        },
                      )
                    else
                      IfCollectionEmpty(
                        ifCollectionEmptyText: 'No new task',
                        ifCollectionEmptyHeight:
                            MediaQuery.of(context).size.height * 0.1,
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}