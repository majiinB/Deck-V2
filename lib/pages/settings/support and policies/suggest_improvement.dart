import 'package:deck/backend/models/report.dart';
import 'package:deck/pages/misc/custom%20widgets/dialogs/alert_dialog.dart';
import 'package:flutter/material.dart';

import '../../../backend/auth/auth_service.dart';
import '../../../backend/report/report_service.dart';
import '../../auth/privacy_policy.dart';
import '../../misc/colors.dart';
import '../../misc/custom widgets/appbar/auth_bar.dart';
import '../../misc/custom widgets/buttons/custom_buttons.dart';
import '../../misc/custom widgets/dialogs/confirmation_dialog.dart';
import '../../misc/custom widgets/textboxes/textboxes.dart';
import '../../misc/widget_method.dart';

class SuggestImprovement extends StatefulWidget {
  const SuggestImprovement({super.key});

  @override
  _SuggestImprovementState createState() => _SuggestImprovementState();
}

class _SuggestImprovementState extends State<SuggestImprovement> {
  final suggestionController = TextEditingController();

  ///This is used to check if there are unsaved changes
  bool _hasUnsavedChanges() {
    return suggestionController.text.isNotEmpty;
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
                  Navigator.of(context)
                      .pop(false); //Return false to prevent pop
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
        resizeToAvoidBottomInset: false,
        appBar: const AuthBar(
          automaticallyImplyLeading: true,
          title: 'Suggest Improvement',
          color: DeckColors.primaryColor,
          fontSize: 24,
        ),
        backgroundColor: DeckColors.backgroundColor,

        ///wrap whole content with column and expanded so image can always stay at the bottom
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                        child: Text(
                          'Share feedback! Help us improve Deck together',
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
                        padding:
                            EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                        child: Text(
                          'How can we make Deck better?',
                          style: TextStyle(
                            fontFamily: 'Fraiche',
                            color: DeckColors.primaryColor,
                            fontSize: 32,
                            height: 1.1,
                          ),
                        ),
                      ),

                      ///this handles the textbox for user to input suggestion
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 20.0),
                        child: BuildTextBox(
                          showPassword: false,
                          hintText: "Suggest Improvement",
                          isMultiLine: true,
                          controller: suggestionController,
                        ),
                      ),

                      ///---- E N D -----

                      const Padding(
                        padding:
                            EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
                        child: Text(
                          'Don’t include any sensitive information such as you password in your message.',
                          style: TextStyle(
                            fontFamily: 'Nunito-Regular',
                            color: DeckColors.primaryColor,
                            fontSize: 12,
                            height: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      ///This section informs the user about the consequences or actions that will occur upon submitting the form
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 20.0),
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          children: [
                            const Text(
                              'By submitting this form, you agree to Deck'
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
                                  RouteGenerator.createRoute(
                                      const PrivacyPolicyPage()),
                                );
                              },
                              borderRadius: BorderRadius.circular(8),
                              splashColor:
                                  DeckColors.primaryColor.withOpacity(0.5),
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
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 30),
                        child: BuildButton(
                          onPressed: () {
                            Report report = Report(
                                userId: AuthService().getCurrentUser()!.uid,
                                title: 'Feedback Suggestion',
                                type: 'feedback',
                                details: suggestionController.text,
                                status: 'Pending');
                            ReportService().createReport(report);

                            showDialog<bool>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return CustomAlertDialog(
                                    imagePath:
                                        'assets/images/Deck-Dialogue3.png',
                                    title: 'Suggestion received!',
                                    message:
                                        'Thanks for helping us improve Deck. Your feedback matters!',
                                    button1: 'Ok',
                                    onConfirm: () {
                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
                                    });
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
                    ],
                  ),
                ),
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
    );
  }
}
