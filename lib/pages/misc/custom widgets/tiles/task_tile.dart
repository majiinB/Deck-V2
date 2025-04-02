import 'package:deck/pages/misc/colors.dart';
import 'package:flutter/material.dart';
import '../functions/swipe_to_delete_and_retrieve.dart';


///
/// ------------ D E C K  T A S K T I L E ----------------------
/// a custom widget that is used in the task page
class TaskTile extends StatefulWidget {
  final String title;
  final String deadline;
  final String priority; // high, medium, low
  String progressStatus;
  final VoidCallback onDelete;
  final VoidCallback? onRetrieve, onTap;
  final bool enableRetrieve;

  TaskTile({
    super.key,
    required this.title,
    required this.deadline,
    required this.priority,
    this.progressStatus = 'to do',
    required this.onDelete,
    this.onRetrieve,
    this.enableRetrieve = false,
    this.onTap,
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

  // Function to change icon based on task status
  IconData _getProgressIcon() {
    switch (widget.progressStatus.toLowerCase()) {
      case 'to do':
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
      case "high":
        return Colors.red;
      case "medium":
        return Colors.yellow;
      case "low":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _onProgressChange(String value) {
    setState(() {
      widget.progressStatus = value; // Update the progress status
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          if (widget.onTap != null) {
            _containerColor = DeckColors.accentColor.withOpacity(0.7);
          }
        });
      },
      onTapUp: (_) {
        _containerColor = DeckColors.accentColor;
        widget.onTap?.call();
      },
      onTapCancel: () {
        _containerColor = DeckColors.accentColor;
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: SwipeToDeleteAndRetrieve(
          onRetrieve: widget.enableRetrieve ? widget.onRetrieve : null,
          enableRetrieve: widget.enableRetrieve,
          onDelete: widget.onDelete,
          child: Stack(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: _containerColor,
                ),
                child: Row(
                  children: [
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontFamily: 'Fraiche',
                              fontSize: 20,
                              color: DeckColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.deadline,
                            style: const TextStyle(
                              fontFamily: 'Nunito-Bold',
                              fontSize: 15,
                              color: DeckColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 30,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                    color: _updatePriorityColor(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
