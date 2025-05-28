import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../misc/colors.dart';
import '../../../misc/custom widgets/dialogs/confirmation_dialog.dart';
import '../../../misc/custom widgets/images/screenshot_image.dart';
import '../../../misc/custom widgets/textboxes/textboxes.dart';

class BugIssues extends StatefulWidget {
  final TextEditingController controller;

  const BugIssues({super.key, required this.controller});

  String getTextValue() {
    return controller.text;
  }
  @override
  _BugIssuesState createState() => _BugIssuesState();
}
  class _BugIssuesState extends State<BugIssues>{
  bool hasUploadedImages = false;

  String getTextValue() {
    return widget.controller.text;
  }

  ///This tracks if images are uploaded
  void _onImageUploadChange(bool hasImages) {
    setState(() {
      hasUploadedImages = hasImages;
    });
  }

  ///This tracks if there are unsaved changes
  bool _hasUnsavedChanges() {
    return widget.controller.text.isNotEmpty ||
        hasUploadedImages;
  }

  ///This disposes controllers to free resources and prevent memory leaks
  
    @override
    Widget build(BuildContext context){
      return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          if (didPop) {
            return;
          }

          //Check for unsaved changes
          if (_hasUnsavedChanges()) { // TODO FIX THIS (status: FIXED!!!)
            final shouldPop = await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return CustomConfirmDialog(
                title: 'Are you sure you want to go back?',
                message: 'If you go back now, you will lose all your progress',
                imagePath: 'assets/images/Deck-Dialogue4.png',
                button1: 'Go Back',
                button2: 'Cancel',
                onConfirm: () {
                  Navigator.of(context).pop(true); //Return true to allow pop
                },
                onCancel: () {
                  Navigator.of(context).pop(false); //Return false to prevent pop
                },
              );
              },
            );

            //If the user confirmed, pop the current route
            if (shouldPop == true) {
              Navigator.of(context).pop(true);
            }
          } else {
            //No unsaved changes, allow pop without confirmation
            Navigator.of(context).pop(true);
          }
        },
        child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Describe what happened, and what you expected instead',
                style: TextStyle(
                  fontFamily: 'Fraiche',
                  fontSize: 24,
                  color: DeckColors.primaryColor,
                  height: 1.2,
                ),
              ),
              ///Textbox to enter additional details about the bug issues content being reported
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: BuildTextBox(
                  showPassword: false,
                  hintText: 'Enter additional details',
                  controller: widget.controller,
                  isMultiLine: true,
                ),
              ),
              ///----- E N D ------
              const Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
                child: Text('Don’t include any sensitive information such as you password in your message.',
                  style: TextStyle(
                    fontFamily: 'Nunito-Regular',
                    color: DeckColors.primaryColor,
                    fontSize: 12,
                    height: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }


