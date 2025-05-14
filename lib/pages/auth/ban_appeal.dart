import 'package:deck/pages/misc/custom%20widgets/textboxes/textboxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../auth/privacy_policy.dart';
import '../misc/colors.dart';
import '../misc/custom widgets/appbar/auth_bar.dart';
import '../misc/custom widgets/buttons/custom_buttons.dart';
import '../misc/custom widgets/buttons/radio_button.dart';
import '../misc/custom widgets/dialogs/alert_dialog.dart';
import '../misc/custom widgets/dialogs/confirmation_dialog.dart';
import '../misc/custom widgets/images/screenshot_image.dart';
import '../misc/widget_method.dart';


class BanAppealPage extends StatefulWidget {

  const BanAppealPage({super.key});

  @override
  _BanAppealPageState createState() => _BanAppealPageState();
}
class _BanAppealPageState extends State<BanAppealPage> {
  final appealTitle = TextEditingController();
  final appealDetails = TextEditingController();
  bool hasUploadedImages = false;

  ///This tracks if images are uploaded
  void _onImageUploadChange(bool hasImages) {
    setState(() {
      hasUploadedImages = hasImages;
    });
  }

  ///This tracks if there are unsaved changes
  bool _hasUnsavedChanges() {
    return appealTitle.text.isNotEmpty || appealDetails.text.isNotEmpty ||
        hasUploadedImages;
  }
  ///This disposes controllers to free resources and prevent memory leaks
  @override
  void dispose() {
    appealTitle.dispose();
    appealDetails.dispose();
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
        if (_hasUnsavedChanges()) {
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
      child: Scaffold(
        appBar: const AuthBar(
          automaticallyImplyLeading: true,
          title: 'Account Ban Appeal',
          color: DeckColors.primaryColor,
          fontSize: 24,
        ),
        backgroundColor: DeckColors.backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                  child: Text('Something on Deck that doesn’t seem right? '
                      'Account got banned for no reason? Help us improve Deck by appealing it.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontFamily: 'Nunito-Regular',
                      color: DeckColors.primaryColor,
                      fontSize: 16,
                      height: 1.3,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                  child: Text('Title of your Appeal',
                    style: TextStyle(
                      fontFamily: 'Fraiche',
                      color: DeckColors.primaryColor,
                      fontSize: 32,
                      height: 1.1,
                    ),
                  ),
                ),
                ///Title of your appeal textbox
                Padding(
                  padding: const EdgeInsets.only(top:10, left: 15.0, right: 15.0),
                  child: BuildTextBox(
                    hintText: 'Enter title of your appeal',
                      controller: appealTitle,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                  child: Text(
                    'Tell us why you believe your account was wrongfully banned.',
                    style: TextStyle(
                      fontFamily: 'Fraiche',
                      color: DeckColors.primaryColor,
                      fontSize: 32,
                      height: 1.1,
                    ),
                  ),
                ),
                ///Details for the reason of your appeal textbox
                Padding(
                  padding: const EdgeInsets.only(top:10, left: 15.0, right: 15.0),
                  child: BuildTextBox(
                    hintText: 'Enter any relevant details',
                    isMultiLine: true,
                    controller: appealDetails,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top:10, left: 15.0, right: 15.0),
                  child: Text('Don’t include any sensitive information such as your password in your message.',
                    style: TextStyle(
                      fontFamily: 'Nunito-Regular',
                      color: DeckColors.primaryColor,
                      fontSize: 12,
                      height: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                  child: Text(
                    'Attach a screenshot of the evidence you’re reporting',
                    style: TextStyle(
                      fontFamily: 'Fraiche',
                      color: DeckColors.primaryColor,
                      fontSize: 32,
                      height: 1.1,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top:10, left: 15.0, right: 15.0),
                    ///This calls the screen shot images containers
                    child: BuildScreenshotImage(
                      onImageUploadChange: _onImageUploadChange,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: Center(
                    child: Text('Upload up to 3 PNG or JPG files. Max file size 10 MB.',
                      style: TextStyle(
                        fontFamily: 'Nunito-Regular',
                        color: DeckColors.primaryColor,
                        fontSize: 12,
                        height: 1,
                      ),
                    ),
                  ),
                ),
                ///this section informs the user about the consequences or actions that will occur upon submitting the form.
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      const Text('By submitting this form, you agree to Deck'
                          ' processing your information as outlined in our',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: 'Nunito-Regular',
                          color: DeckColors.primaryColor,
                          fontSize: 16,
                          height: 1.3,
                        ),
                      ),
                      ///this handles when user clicks the privacy policy
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            RouteGenerator.createRoute(const PrivacyPolicyPage()),
                          );
                        },
                        borderRadius: BorderRadius.circular(8),
                        splashColor: DeckColors.primaryColor.withOpacity(0.5),
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            'Privacy Policy',
                            style: TextStyle(
                              fontFamily: 'Nunito-ExtraBold',
                              color: DeckColors.primaryColor,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                              decorationColor: DeckColors.primaryColor,
                              decorationThickness: 3,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                ///------ E N D ---------

                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, top:10, bottom: 20),
                  child: BuildButton(
                    onPressed: () {
                      showDialog<bool>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return CustomAlertDialog(
                              imagePath: 'assets/images/Deck-Dialogue3.png',
                              title: 'Appeal Submitted',
                              message: 'Thanks for taking the time to submit an appeal. We’ll look into your case and get back to you soon.',
                              button1: 'Ok',
                              onConfirm: () {
                                ///Pop twice: first, close the dialog, then navigate back to the previous page
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }
                          );
                        },

                      );
                    },
                    buttonText: 'Submit',
                    height: 50.0,
                    width: MediaQuery.of(context).size.width,
                    backgroundColor: DeckColors.primaryColor,
                    textColor: DeckColors.white,
                    radius: 10.0,
                    borderColor: DeckColors.primaryColor,
                    fontSize: 16,
                    borderWidth: 0,
                  ),
                ),
                Image.asset(
                  'assets/images/Deck-Bottom-Image1.png',
                  fit: BoxFit.fitWidth,
                  width: MediaQuery.of(context).size.width,
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }
}