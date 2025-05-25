import 'package:deck/pages/misc/custom%20widgets/textboxes/textboxes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../misc/colors.dart';
import '../../../misc/custom widgets/dialogs/confirmation_dialog.dart';
import '../../../misc/custom widgets/images/screenshot_image.dart';


class AIGeneratedContent extends StatefulWidget{

  @override
  _AIGeneratedContentState createState() => _AIGeneratedContentState();
}
class _AIGeneratedContentState extends State<AIGeneratedContent> {
  final addDetailsController = TextEditingController();


  ///This is used to check if there are unsaved changes
  bool _hasUnsavedChanges() {
    return addDetailsController.text.isNotEmpty;
  }

  ///This disposes controllers to free resources and prevent memory leaks
  @override
  void dispose() {
    addDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }

        //Check for unsaved changes
        if (_hasUnsavedChanges()) { //TODO FIX THIS (status: FIXED!!!)
          final shouldPop = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) { 
              return CustomConfirmDialog(
                title: 'Are you sure you want to go back?',
                message: 'Going back now will lose all your progress.',
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
          padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top:10.0),
              child: Text(
                'Give us additional details about your report',
                style: TextStyle(
                  fontFamily: 'Fraiche',
                  fontSize: 24,
                  color: DeckColors.primaryColor,
                ),
              ),
            ),
            ///Textbox to enter additional details about the ai-genrated content being reported
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
              child: BuildTextBox(
                showPassword: false,
                hintText: 'Enter additional details',
                controller: addDetailsController,
                isMultiLine: true,
              ),
            ),
            ///----- E N D ------
          ],
        ),
      ),
    );
  }
}