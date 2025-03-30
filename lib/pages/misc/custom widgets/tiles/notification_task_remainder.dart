import 'package:flutter/material.dart';

class TaskReminderNotification extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onView;
  final VoidCallback onSnooze;
  final VoidCallback onDelete;

  const TaskReminderNotification({
    Key? key,
    required this.title,
    required this.message,
    required this.onView,
    required this.onSnooze,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}