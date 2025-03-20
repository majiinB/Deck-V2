import 'package:flutter/material.dart';
import 'package:deck/pages/misc/colors.dart';

/// CustomConfirmDialog - A reusable confirmation dialog for displaying alerts.
///
/// This dialog presents a message with an image, a title, and one or two buttons.
/// It is often used when a confirmation action is needed with or without a cancel option.
///
/// Usage:
/// showConfirmDialog(
///   context,
///   "assets/images/imagename.png",
///   "Title",
///   "Message",
///   "Confirm",
///   () {
///     // Action when confirm button is clicked
///   },
///   "Cancel", // Optional
///   () {
///     // Action when cancel button is clicked (optional)
///   }
/// );
///
/// Parameters:
/// - imagePath: The path of the image to display in the dialog.
/// - title: The title of the alert.
/// - message: The message content of the dialog.
/// - button1: The text for the confirm button.
/// - button2: (Optional) The text for the cancel button, default is "Cancel".
/// - onConfirm: Callback function for when the confirm button is pressed.
/// - onCancel: (Optional) Callback function for when the cancel button is pressed.
///

class CustomConfirmDialog extends StatelessWidget {
  final String imagePath, title,message,button1,button2;
  final VoidCallback onConfirm,onCancel;

  const CustomConfirmDialog({
    super.key,
    required this.imagePath,
    required this.title,
    required this.button1,
    required this.button2,
    required this.message,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: DeckColors.white ,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      contentPadding: const EdgeInsets.all(20) ,
      content:Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(imagePath, width: 190, fit: BoxFit.fill,
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(color: DeckColors.primaryColor , fontSize: 25, fontFamily: 'Fraiche'),
              textAlign: TextAlign.center,),
            const SizedBox(height: 5),
            Text(
              message,
              style: const TextStyle(color: DeckColors.primaryColor, fontSize: 15, fontFamily: 'Nunito-Regular'),
              textAlign: TextAlign.center,),
            const SizedBox(height: 5),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: DeckColors.primaryColor,
                minimumSize: const Size(double.infinity, 40),
              ),
              onPressed: () {
                onConfirm();
              },
              child: Text(button1, style: const TextStyle(fontSize: 15, fontFamily: 'Nunito-Bold', color: DeckColors.white)),
            ),
            OutlinedButton(
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(double.infinity, 40)),

                  side: MaterialStateProperty.all(
                    BorderSide(
                        width: 2 ,
                        color: DeckColors.primaryColor
                    )
                )
              ),
              onPressed: () {
                onCancel();
              },
              child: Text(button2, style: const TextStyle(fontSize: 15, fontFamily: 'Nunito-Bold', color: DeckColors.primaryColor)),
            ),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: DeckColors.white,
            //     minimumSize: const Size(double.infinity, 40),
            //   ),
            //   onPressed: () {
            //     onCancel();
            //   },
            //   child: Text(button2, style: const TextStyle(fontSize: 15, fontFamily: 'Nunito-Regular', color: DeckColors.primaryColor)),
            // ),
          ]
      ),
    );
  }
}

//Used to show the Dialog Box
void showConfirmDialog(
    BuildContext context,
    String imagePath,
    String title,
    String message,
    String button1,
    VoidCallback onConfirm,
    { String button2 = "Cancel",
      VoidCallback? onCancel,
    }) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return CustomConfirmDialog(
        imagePath:imagePath, //image of deck
        title: title, // title of alert
        message: message, //subtitle or detailed message
        button1: button1,//text of button
        onConfirm: onConfirm,//when button is pressed perform action
        button2: button2, //text of button, default is Cancel
        onCancel: onCancel ?? () { Navigator.of(context).pop(); }, //when button is pressed perform action
      );
    },
  );
}
