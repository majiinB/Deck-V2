import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../backend/models/task.dart';
import '../../../../backend/task/task_provider.dart';
import '../../../task/view_task.dart';
import '../dialogs/confirmation_dialog.dart';
import '../tiles/task_tile.dart';
import 'if_collection_empty.dart';

/// TaskListWidget - A reusable widget for displaying a filtered list of tasks.
///
/// This widget dynamically filters a list of tasks based on a provided condition.
/// If there are matching tasks, it displays them in a scrollable list. Otherwise,
/// it shows an empty state message.
///
/// Usage:
/// TaskListWidget(
///   tasks: myTasks, // List of Task objects
///   filter: (task) => !task.getIsDone, // Filter condition (e.g., show only pending tasks)
/// )
///
/// Parameters:
/// - tasks: A list of Task objects to be displayed.
/// - filter: A function that determines which tasks should be shown.
///

class TaskList extends StatelessWidget{
  final List<Task> tasks;
  final bool Function(Task) filter;

  const TaskList({
    Key? key,
    required this.tasks,
    required this.filter,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final filteredTasks = tasks.where(filter).toList();
    if (filteredTasks.isNotEmpty) {
      return ListView.builder(
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          Task task = filteredTasks[index];
          return Padding(
            padding: const EdgeInsets.only(top: 5),
            child: DeckTaskTile(
              title: task.title,
              deadline: TaskProvider.getNameDate(task.deadline),
              priority: task.priority,
              progressStatus: 'to do',
              onDelete: () {
                final String deletedTitle = task.title;
                showConfirmDialog(
                  context,
                  "assets/images/Deck-Dialogue1.png",
                  "Delete Item",
                  "Are you sure you want to delete '$deletedTitle'?",
                  "Delete Item",
                      () {
                    Provider.of<TaskProvider>(context, listen: false)
                        .deleteTask(task.uid);
                  },
                );
              },
              enableRetrieve: false,
              onTap: () {
                print("Clicked task tile!");
                print(
                    'Task: ${task.title}, IsDone: ${task.getIsDone}, IsActive: ${task.getIsActive}, Deadline: ${task.deadline}');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ViewTaskPage(task: task, isEditable: true),
                  ),
                );
              },
            ),
          );
        },
      );
    } else {
      return IfCollectionEmpty(
        ifCollectionEmptyText:
        'Seems like there aren’t any\n task for today, wanderer!',
        ifCollectionEmptySubText:
        'Now’s the perfect time to get ahead. Start\nadding new tasks and stay \non top of your game!',
        ifCollectionEmptyHeight: MediaQuery.of(context).size.height / 2,
      );
    }
  }
}