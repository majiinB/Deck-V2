import 'package:auto_size_text/auto_size_text.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../functions/swipe_to_delete_and_retrieve.dart';

class TaskTile extends StatefulWidget {
  final String taskName;
  final DateTime deadline;
  final String priority; // high, medium, low
  String progressStatus; // pending, progress, completed
  final VoidCallback onDelete;
  final VoidCallback? onRetrieve, onPressed;
  final bool enableRetrieve;

  TaskTile({
    super.key,
    required this.taskName,
    required this.deadline,
    required this.priority,
    this.progressStatus = 'pending',
    required this.onDelete,
    this.onRetrieve,
    this.enableRetrieve = false,
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
          formattedDate,
          textAlign: TextAlign.start,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Nunito-SemiBold',
            fontSize: 14,
            color: DeckColors.primaryColor,
          ),
        ),
        const Expanded(
            child: SizedBox()
        ),
        AutoSizeText(
          formattedTime,
          textAlign: TextAlign.start,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Nunito-SemiBold',
            fontSize: 14,
            color: DeckColors.primaryColor,
          ),
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
        return Icons.circle;
      case 'completed':
        return Icons.check_circle;
      default:
        return Icons.circle_outlined;
    }
  }

  // Function to set the container color based on priority level
  Color _updatePriorityColor() {
    switch (widget.priority.toLowerCase()) {
      case 0:
        return DeckColors.deckRed;
      case 1:
        return DeckColors.deckYellow;
      case 2:
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
          decoration: BoxDecoration(
            border: Border.all(color: DeckColors.primaryColor, width: 3),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               const SizedBox(width: 10),
               Expanded(
                 child:Padding(
                   padding: const EdgeInsets.symmetric(vertical: 10),
                   child: Column(
                     crossAxisAlignment:
                     CrossAxisAlignment.start,
                     children: [
                       getDeadline(DateTime.now()),
                       AutoSizeText(
                         widget.taskName,
                         maxLines: 1,
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
               Container(
                   width: 20,
                   height: 80,
                   decoration: BoxDecoration(
                       color: _updatePriorityColor(),
                       borderRadius: const BorderRadius.horizontal(
                           right: Radius.circular(12)
                       )
                   )
               ),

             ],
            )
          ),
        )
      ),
    );
  }
}
