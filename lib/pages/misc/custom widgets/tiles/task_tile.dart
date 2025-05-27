import 'package:auto_size_text/auto_size_text.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../functions/swipe_to_delete_and_retrieve.dart';

/// TaskTile is a widget that represents an individual task item in the task page.
/// note that this is different from hometasktile
/// Parameters:
/// - `taskName`: The title of the task.
/// - `deadline`: The due date and time of the task.
/// - `priority`: An integer representing the task's priority level (0 = High, 1 = Medium, 2 = Low).
/// - `progressStatus`: A string indicating the current progress status of the task. Expected values are 'pending', 'in progress', or 'completed'.
/// - `onDelete`: A callback function triggered when the task is deleted.
/// - `onPressed`: (Optional) A callback function triggered when the tile is tapped.
///
/// how to call
/// TaskTile(
///   taskName: 'Design Meeting',
///   deadline: DateTime.now().add(Duration(days: 2)),
///   priority: 1,
///   progressStatus: 'in progress',
///   onDelete: () {
///     // Handle delete action
///   },
///   onPressed: () {
///     // Handle tap action
///   },
/// )

class TaskTile extends StatefulWidget {
  final String taskName;
  final DateTime deadline;
  final String priority; // high, medium, low
  String progressStatus; // pending, progress, completed
  final VoidCallback onDelete;
  final VoidCallback? onPressed;

  TaskTile({
    super.key,
    required this.taskName,
    required this.deadline,
    required this.priority,
    this.progressStatus = 'pending',
    required this.onDelete,
    this.onPressed,
  });

  @override
  State<TaskTile> createState() => DeckTaskTileState();
}

class DeckTaskTileState extends State<TaskTile> {
  Color _containerColor = DeckColors.white; // Default color

  @override
  void initState() {
    super.initState();
    _updatePriorityColor(); // Set initial color based on priority
  }
  Row getDeadline(DateTime dateTime){
    /// formats a givenDateTime objecr into a readable string.
    ///
    /// The output format is: `"Month Day, Year'
    /// The output format is: ' HH:MM AM/PM"`
    /// Example: `"March 02, 2025 || 12:40 AM"`
    ///
    /// - [dateTime]: The DateTime to be formatted
    String formattedDate = DateFormat("MMMM dd, yyyy").format(dateTime);
    String formattedTime = DateFormat("hh:mm a").format(dateTime);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          'Deadline: $formattedDate',
          textAlign: TextAlign.start,
          maxLines: 1,
          minFontSize: 8,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Nunito-SemiBold',
            fontSize: 10,
            color: DeckColors.primaryColor,
          ),
        ),
        const Expanded(
            child: SizedBox()
        ),
      ],
    );
  }

  // Function to change icon based on task status
  IconData _getProgressIcon() {
    switch (widget.progressStatus.toLowerCase()) {
      case 'pending':
        return Icons.circle_outlined;
      case 'in progress':
        return Icons.radio_button_checked_rounded;
      case 'completed':
        return Icons.check_circle;
      default:
        return Icons.circle_outlined;
    }
  }

  // Function to set the container color based on priority level
  Color _updatePriorityColor() {
    switch (widget.priority.toString().toLowerCase()) {
      case "high":
        return DeckColors.deckRed;
      case "medium":
        return DeckColors.deckYellow;
      case "low":
        return DeckColors.deckBlue;
      default:
        return DeckColors.white;
    }
  }

  void _onProgressChange(String value) {
    setState(() {
      widget.progressStatus = value; // Update the progress status
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15.0),
      color: DeckColors.white,
      child: InkWell(
          borderRadius: BorderRadius.circular(15.0),
          onTap: () {
            if (widget.onPressed != null) {
              widget.onPressed!();
            }
          },
        child: Container(
          padding: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            border: Border.all(color: DeckColors.primaryColor, width: 3),
            borderRadius: BorderRadius.circular(15.0),
          ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  _getProgressIcon(),
                  color: _updatePriorityColor(),
                  size:20,
                  weight:2,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child:Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        getDeadline(widget.deadline),
                        AutoSizeText(
                          widget.taskName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'fraiche',
                            fontSize: 20,
                            color: DeckColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                    width: 20,
                    height: 63,
                    decoration: BoxDecoration(
                        color: _updatePriorityColor(),
                        borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(12)
                        )
                    )
                ),
              ],
            )
        )
      ),
    );
  }
}
