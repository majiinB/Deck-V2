import 'package:flutter/material.dart';


class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String text;
  final VoidCallback onConfirm;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.text,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      contentPadding: EdgeInsets.all(10) ,
      title: Text(title),
      content: Text(text),
    );
  }
}

//Used to show the Dialog Box
void showShowAlertDialog(BuildContext context, String title, String text,
    VoidCallback onConfirm) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return CustomAlertDialog(
        title: title,
        text: text,
        onConfirm: onConfirm
      );
    },
  );
}


