import 'package:deck/pages/misc/custom%20widgets/tiles/task_folder_tile.dart';
import 'package:deck/pages/task/view_task_folder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../backend/models/task.dart';
import '../../backend/task/task_provider.dart';
import '../misc/colors.dart';
import '../misc/custom widgets/functions/if_collection_empty.dart';
//import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:deck/pages/task/view_task.dart';
// import 'package:deck/pages/task/add_task.dart';
import 'package:deck/pages/misc/deck_icons2.dart';

import '../misc/custom widgets/menus/pop_up_menu.dart';
import '../misc/custom widgets/tiles/home_task_tile.dart';
import '../misc/custom widgets/tiles/task_list.dart';
import '../misc/deck_icons.dart';
import '../misc/widget_method.dart';
import 'add_task_folder.dart';
// import '../../backend/models/task.dart';
// import '../misc/custom widgets/dialogs/confirmation_dialog.dart';

class TaskPage extends StatefulWidget {
  final bool openViewTask;

  const TaskPage({
    super.key,
    this.openViewTask = false,
  });
  @override
  _TaskPageState createState() => _TaskPageState();
}
class _TaskPageState extends State<TaskPage> {
  ///selectedDay : actual day selected by the user, used for highlighting.
  DateTime selectedDay = DateTime.now();
  /// focusedDay : variable that tracks which day is currently in focus
  DateTime focusedDay = DateTime.now();
  DateTime today = DateTime.now();


  bool showAllTask = false;

  @override
  void initState() {
    super.initState();
    if (widget.openViewTask) {
      // Delay to ensure the widget is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ViewTaskFolderPage(title: 'sample',)),//TODO change title
        );
      });
    }
    _getTasks();
  }
  //
  void _getTasks() async {
    await Provider.of<TaskProvider>(context, listen: false).loadTasks();
  }

  String getDeadline(DateTime dateTime){
    /// formats a givenDateTime objecr into a readable string.
    ///
    /// The output format is: `"Month Day, Year || HH:MM AM/PM"`
    /// Example: `"March 02, 2025 || 12:40 AM"`
    ///
    /// - [dateTime]: The DateTime to be formatted
    String formattedDate = DateFormat("MMMM dd, yyyy").format(dateTime);
    String formattedTime = DateFormat("hh:mm a").format(dateTime);
    return "$formattedDate || $formattedTime";
  }

  @override
  Widget build(BuildContext context) {
    List<TaskFolder> taskFolders = [
      TaskFolder(name: "Archorg", tasksDone: 5, totalTasks: 10, folderBackground: 1, ),
      TaskFolder(name: "safghfghfghfhfhgfhgfhgfhfghfhfgjhfkhkhjmple", tasksDone: 3, totalTasks: 8, folderBackground: 2,),
      TaskFolder(name: "hehe", tasksDone: 4, totalTasks: 5, folderBackground: 2,),
      TaskFolder(name: "raqwr", tasksDone: 2, totalTasks: 5,folderBackground: 3,),
      TaskFolder(name: "sdaf", tasksDone: 2, totalTasks: 5,folderBackground: 3,),
      TaskFolder(name: "jugmuk", tasksDone: 2, totalTasks: 5,folderBackground: 1,),
      TaskFolder(name: "truijn juytjtjy", tasksDone: 50, totalTasks: 41,folderBackground: 3,),
      TaskFolder(name: "raqjyuyjiwr", tasksDone: 1, totalTasks: 77,folderBackground: 2,),      TaskFolder(name: "Archorg", tasksDone: 5, totalTasks: 10, folderBackground: 1, ),
      TaskFolder(name: "fdf", tasksDone: 3, totalTasks: 8, folderBackground: 2,),
      TaskFolder(name: "uoi;poghfmnvc ", tasksDone: 45, totalTasks: 54, folderBackground: 2,),
      TaskFolder(name: "k,hk,", tasksDone: 7, totalTasks: 33,folderBackground: 3,),
      TaskFolder(name: "sdacjhdfjfgf", tasksDone: 5, totalTasks: 5,folderBackground: 3,),
      TaskFolder(name: "fghfghjjkjlkio", tasksDone: 2, totalTasks: 5,folderBackground: 1,),
      TaskFolder(name: "ioioioioio juytjtjy", tasksDone: 2, totalTasks: 4,folderBackground: 3,),
      TaskFolder(name: "hgjguygy", tasksDone: 66, totalTasks: 77,folderBackground: 2,),
    ];

    List<Map<String, dynamic>> sampleTasks = [
      {'folderName': 'ArchOrg', 'taskName': 'Make a circuit board', 'deadline': DateTime.now(), 'priority': 0, 'isDone': false},
      {'folderName': 'Hello', 'taskName': 'Exam in Quizalize', 'deadline': DateTime.now(), 'priority': 1, 'isDone': false},
      {'folderName': 'SoftEng', 'taskName': 'Nyehehe', 'deadline': DateTime.now(), 'priority': 2, 'isDone': false},
      {'folderName': 'Math', 'taskName': 'Finish homework', 'deadline': DateTime.now(), 'priority': 0, 'isDone': false},
      {'folderName': 'Science', 'taskName': 'Read module', 'deadline': DateTime.now(), 'priority': 1, 'isDone': false},
    ];
    List<Map<String, dynamic>> taskToday = sampleTasks
        .where((task) => isSameDay(task['deadline'], DateTime.now()) && task['isDone'] == false)
        .toList();

    // List<Task> taskToday = _tasks
    //     .where((task) => isSameDay(task.deadline, selectedDay) && !task.isDone)
    //     .toList();

    return  Scaffold(
        backgroundColor: DeckColors.backgroundColor,
        body: SafeArea(
            top: true,
            bottom: false,
            left: true,
            right: true,
            child:SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                    children:[
                      Padding(
                        padding: const EdgeInsets.only(left:30, right:30),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children:[
                              Row(
                              children: [
                                const Icon(
                                  DeckIcons2.hat,
                                  color: DeckColors.primaryColor,
                                  size: 32,
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.add,
                                      color: DeckColors.primaryColor, size: 32),
                                  onPressed: () async {
                                    Navigator.push(
                                      context,
                                      RouteGenerator.createRoute(AddTaskFolderPage()),
                                    );
                                  },
                                ),
                              ],
                            ),
                              if (taskFolders.isNotEmpty)
                            const Text(
                                'Task Folders',
                                style: TextStyle(
                                    fontFamily: 'Fraiche',
                                    fontSize: 30,
                                    color: DeckColors.primaryColor,
                                )
                            ),
                          ]
                        ),
                      ),
                      if (taskFolders.isNotEmpty)
                        SizedBox(
                        height: 150.0,
                        child:
                        ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: taskFolders.length,
                          itemBuilder:(context, index){
                            final taskFolder = taskFolders[index];
                            // First item is a SizedBox
                              return Padding(
                                  padding: EdgeInsets.only(left: index == 0 ? 30 : 10, right: 10) ,
                                    child: TaskFolderTile(
                                      folderName: taskFolder.name, //TODO: CHANGE PLACEHOLDERS
                                      totalCompleted: taskFolder.tasksDone,
                                      totalTask: taskFolder.totalTasks,
                                      folderBackground: taskFolder.folderBackground,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          RouteGenerator.createRoute(ViewTaskFolderPage(title: taskFolder.name,)),//TODO change title and ADD THE INDEX OF THE FOLDER HERE
                                        );
                                      },
                                  )
                              );
                          },
                        ),
                      ),
                      if (taskFolders.isNotEmpty || taskToday.isNotEmpty)
                        Padding(
                        padding:  const EdgeInsets.only(left:30, right:30, top: 20.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                               const Text(
                                  'Upcoming Deadlines',
                                  style: TextStyle(
                                      fontFamily: 'Fraiche',
                                      fontSize: 25,
                                      color: DeckColors.primaryColor,
                                      fontWeight: FontWeight.bold
                                  ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount:sampleTasks.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context,index){
                                  final task = sampleTasks[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child:HomeTaskTile(//TODO: update
                                      folderName: task['folderName'],//task.folderName
                                      taskName: task['taskName'],// task.taskName
                                      deadline: getDeadline(selectedDay),
                                      onPressed: () {},
                                      priority: task['priority'],//task.priority
                                    ),
                                  );
                                },
                              )
                            ]
                        ),
                      ),
                      if (taskFolders.isEmpty)
                        const IfCollectionEmpty(
                          hasIcon: false,
                          ifCollectionEmptyText: 'YIPEE! No upcoming deadlines! ',
                          ifCollectionEmptySubText:
                          'Now’s the perfect time to get ahead. Start adding new tasks and stay on top of your game!',
                        )
                    ]
                )
            )
        )
    );
  }
}

//TODO remove this po kasi ginawa ko lng toh para may sample
class TaskFolder {
  final String name;
  final int folderBackground;
  final int tasksDone;
  final int totalTasks;

  TaskFolder({
    required this.name,
    required this.tasksDone,
    required this.totalTasks,
    required this.folderBackground
  });
}
