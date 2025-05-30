import 'package:deck/backend/auth/auth_service.dart';
import 'package:deck/backend/auth/ban_service.dart';
import 'package:deck/pages/misc/custom%20widgets/textboxes/textboxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  final String adminReason;
  final String banId;
  const BanAppealPage({super.key,
    required this.adminReason, required this.banId});

  @override
  _BanAppealPageState createState() => _BanAppealPageState();
}
class _BanAppealPageState extends State<BanAppealPage> {
  final appealReason = TextEditingController();
  final appealDetails = TextEditingController();


  ///This tracks if there are unsaved changes
  bool _hasUnsavedChanges() {
    return appealDetails.text.isNotEmpty;
  }
  ///This disposes controllers to free resources and prevent memory leaks
  @override
  void dispose() {
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
                message: 'Going back now will lose all your progress',
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
                  padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                  child: Text('Your account has been banned!',
                    style: TextStyle(
                      fontFamily: 'Fraiche',
                      color: DeckColors.primaryColor,
                      fontSize: 32,
                      height: 1.1,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                  child: Text(
                      widget.adminReason,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontFamily: 'Nunito-Regular',
                      color: DeckColors.primaryColor,
                      fontSize: 16,
                      height: 1.3,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                  child: Text(
                    'Provide the reason for your appeal',
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
                    hintText: 'Enter relevant details',
                    isMultiLine: true,
                    controller: appealDetails,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top:10, left: 15.0, right: 15.0),
                  child: Text('Don’t include any sensitive information in your message.',
                    style: TextStyle(
                      fontFamily: 'Nunito-Regular',
                      color: DeckColors.primaryColor,
                      fontSize: 12,
                      height: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                ///this section informs the user about the consequences or actions that will occur upon submitting the form.
                Padding(
                  padding: const EdgeInsets.only(top:20, left: 15.0, right: 15.0),
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
                    onPressed: () async {
                      // Capture user input
                       // Replace with your actual ID generation logic
                      String userId = AuthService().getCurrentUser()!.uid; // Retrieve the current user ID dynamically
                      DateTime appealedAt = DateTime.now();
                      String title = 'Ban Appeal';
                      String details = appealDetails.text.trim();
                      String status = 'Pending'; // Initial status

                      if (details.isNotEmpty) {
                        await BanService().submitBanAppeal(
                          userId: userId,
                          appealedAt: appealedAt,
                          title: title,
                          details: details,
                          status: status,
                          banId: widget.banId,
                        );

                        // Show confirmation dialog after submission
                        showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return CustomAlertDialog(
                              imagePath: 'assets/images/Deck-Dialogue3.png',
                              title: 'Appeal Submitted',
                              message: 'Appeal submitted. We’ll review it soon.',
                              button1: 'Ok',
                              onConfirm: () async {
                                final authService = AuthService();
                                await authService.signOut();
                                GoogleSignIn _googleSignIn = GoogleSignIn();
                                if (await _googleSignIn.isSignedIn()) {
                                await _googleSignIn.signOut();
                                }
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      } else {
                        // Handle empty appeal details
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomAlertDialog(
                              imagePath: 'assets/images/Deck-Dialogue3.png',
                              title: 'Error',
                              message: 'Please enter details for your appeal before submitting.',
                              button1: 'Ok',
                              onConfirm: () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      }
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