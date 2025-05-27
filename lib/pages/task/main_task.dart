import 'package:deck/backend/models/TaskFolder.dart';
import 'package:deck/backend/models/newTask.dart';
import 'package:deck/backend/task/task_service.dart';
import 'package:deck/pages/misc/custom%20widgets/tiles/task_folder_tile.dart';
import 'package:deck/pages/task/view_task_folder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../misc/colors.dart';
import '../misc/custom widgets/functions/if_collection_empty.dart';
//import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:deck/pages/task/view_task.dart';
// import 'package:deck/pages/task/add_task.dart';
import 'package:deck/pages/misc/deck_icons2.dart';

import '../misc/custom widgets/tiles/home_task_tile.dart';
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
  TaskService _taskService = TaskService();
  List<TaskFolder> taskFolders = [];
  List<NewTask> upcomingTasks = [];


  bool showAllTask = false;

  @override
  void initState() {
    super.initState();
    _getTaskFolder();
    _getTasks();
  }
  //
  void _getTasks() async {
    List <NewTask> retrievedTasks = await _taskService.fetchNearingDueTasks();
    setState(() {
      upcomingTasks = retrievedTasks;
    });
  }
  void _getTaskFolder() async {
    List <TaskFolder> retrievedFolders = await _taskService.getTaskFolders();
    setState(() {
      taskFolders = retrievedFolders;
    });
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
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const AddTaskFolderPage()),
                                    );

                                    if (result != null && result is TaskFolder) {
                                      await Navigator.push(
                                        context,
                                        RouteGenerator.createRoute(ViewTaskFolderPage(taskFolder: result)),
                                      );
                                    }

                                    _getTaskFolder();
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
                            int folderBg = 1;
                            if(taskFolder.background == 'assets/images/Deck-Background9.svg'){
                              folderBg = 1;
                            }else if(taskFolder.background == 'assets/images/Deck-Background7.svg'){
                              folderBg = 2;
                            }else if(taskFolder.background == 'assets/images/Deck-Background8.svg'){
                              folderBg = 3;
                            }
                            // First item is a SizedBox
                              return Padding(
                                  padding: EdgeInsets.only(left: index == 0 ? 30 : 10, right: 10) ,
                                    child: TaskFolderTile(
                                      folderName: taskFolder.title, //TODO: CHANGE PLACEHOLDERS
                                      totalCompleted: taskFolder.completedTasksCount,
                                      totalTask: taskFolder.totalTasks,
                                      folderBackground: folderBg,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          RouteGenerator.createRoute(ViewTaskFolderPage(taskFolder: taskFolder,)),
                                        );
                                      },
                                  )
                              );
                          },
                        ),
                      ),
                      if (taskFolders.isNotEmpty || upcomingTasks.isNotEmpty)
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
                                itemCount: upcomingTasks.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context,index){
                                  final task = upcomingTasks[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child:HomeTaskTile(//TODO: update
                                      folderName: task.folderSource!,//task.folderName
                                      taskName: task.title,// task.taskName
                                      deadline: task.endDate,
                                      onPressed: () {},
                                      priority: task.priority,//task.priority
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
                          'Get ahead now! Add tasks and stay sharp!',
                        )
                    ]
                )
            )
        )
    );
  }
}
