import 'package:flutter/material.dart';
class DeckApprovalNotification extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onView;
  final VoidCallback onDelete;

  const DeckApprovalNotification({
    Key? key,
    required this.title,
    required this.message,
    required this.onView,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.zero);
  }
}