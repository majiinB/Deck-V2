import 'package:deck/pages/task/view_task_folder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../backend/models/task.dart';
import '../../backend/task/task_provider.dart';
import '../misc/colors.dart';
import '../misc/custom widgets/functions/if_collection_empty.dart';
//import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:deck/pages/task/view_task.dart';
// import 'package:deck/pages/task/add_task.dart';
import 'package:deck/pages/misc/deck_icons2.dart';

import '../misc/custom widgets/tiles/home_task_tile.dart';
import '../misc/widget_method.dart';
// import '../../backend/models/task.dart';
// import '../misc/custom widgets/dialogs/confirmation_dialog.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});
  @override
  _TaskPageState createState() => _TaskPageState();
}
class _TaskPageState extends State<TaskPage> {
  ///selectedDay : actual day selected by the user, used for highlighting.
  DateTime selectedDay = DateTime.now();
  /// focusedDay : variable that tracks which day is currently in focus
  DateTime focusedDay = DateTime.now();

  DateTime today = DateTime.now();
  List<Map<String, dynamic>> sampleTasks = [
    {'folderName': 'ArchOrg', 'taskName': 'Make a circuit board', 'deadline': DateTime.now(), 'priority': 0, 'isDone': false},
    {'folderName': 'Hello', 'taskName': 'Exam in Quizalize', 'deadline': DateTime.now(), 'priority': 1, 'isDone': false},
    {'folderName': 'SoftEng', 'taskName': 'Nyehehe', 'deadline': DateTime.now(), 'priority': 2, 'isDone': false},
    {'folderName': 'Math', 'taskName': 'Finish homework', 'deadline': DateTime.now(), 'priority': 0, 'isDone': false},
    {'folderName': 'Science', 'taskName': 'Read module', 'deadline': DateTime.now(), 'priority': 1, 'isDone': false},
  ];
  // bool showAllTask = false;
  // @override
  // void initState() {
  //   super.initState();
  //   _getTasks();
  // }
  //
  // void _getTasks() async {
  //   await Provider.of<TaskProvider>(context, listen: false).loadTasks();
  // }
  // Widget _buildTaskList(List<Task> tasks, bool Function(Task) filter) {
  //   final filteredTasks = tasks.where(filter).toList();
  //   if(filteredTasks.isNotEmpty) {
  //     return ListView.builder(
  //       itemCount: filteredTasks.length,
  //       itemBuilder: (context, index) {
  //         Task task = filteredTasks[index]; // Access the Task model directly
  //         // Check if the task should be displayed based on the conditions
  //         return Padding(
  //           padding: EdgeInsets.only(bottom: 10),
  //           // child: HomeTaskTile(
  //           //   folderName: task['folderName'],//task.folderName
  //           //   taskName: task['taskName'],// task.taskName
  //           //   deadline: getDeadline(selectedDay),
  //           //   onPressed: () {},
  //           //   priority: task['priority'],//task.priority
  //           ),
  //         )
  //         // Return an empty widget if conditions are not met
  //       },
  //     );
  //   } else {
  //     return IfCollectionEmpty(
  //       ifCollectionEmptyText: 'Seems like there aren’t any\n task for today, wanderer!',
  //       ifCollectionEmptySubText:
  //       'Now’s the perfect time to get ahead. Start\nadding new tasks and stay \non top of your game!',
  //       ifCollectionEmptyHeight: MediaQuery.of(context).size.height/2,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: DeckColors.backgroundColor,

        body: SafeArea(
            top: true,
            bottom: false,
            left: true,
            right: true,
            child:SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                    children:[
                      Padding(
                        padding: const EdgeInsets.only(left:30, right:30, top: 20.0),
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
                                      RouteGenerator.createRoute(ViewTaskFolderPage()),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const Text(
                                'Task Folders',
                                style: TextStyle(
                                    fontFamily: 'Fraiche',
                                    fontSize: 30,
                                    color: DeckColors.primaryColor,
                                    fontWeight: FontWeight.bold
                                )
                            ),
                            // if(taskToday.isEmpty)
                            const IfCollectionEmpty(
                              hasIcon: false,
                              hasBackground: true,
                              ifCollectionEmptyText: 'YIPEE! No upcoming deadlines! ',
                              ifCollectionEmptySubText:
                              'Now’s the perfect time to get ahead. Start adding new tasks and stay on top of your game!',
                            ),
                          ]
                        ),
                      ),
                      SizedBox(
                        height: 200.0,
                        child:
                        ListView(
                          // This next line does the trick.
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            Container(width: 30, color: Colors.transparent),
                            Container(width: 160, color: Colors.blue),
                            Container(width: 160, color: Colors.green),
                            Container(width: 160, color: Colors.yellow),
                            Container(width: 160, color: Colors.orange),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:30, right:30, top: 20.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                  'Upcoming Deadlines',
                                  style: TextStyle(
                                      fontFamily: 'Fraiche',
                                      fontSize: 20,
                                      color: DeckColors.primaryColor,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                              // if(taskToday.isEmpty)
                              const IfCollectionEmpty(
                                hasIcon: false,
                                hasBackground: true,
                                ifCollectionEmptyText: 'YIPEE! No upcoming deadlines! ',
                                ifCollectionEmptySubText:
                                'Now’s the perfect time to get ahead. Start adding new tasks and stay on top of your game!',
                              ),
                            ]
                        ),
                      ),
                    ]
                )
            )
        )
    );
  }
}