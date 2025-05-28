import 'package:deck/backend/models/report.dart';
import 'package:deck/backend/models/reportedDeck.dart';
import 'package:deck/pages/settings/support%20and%20policies/selected%20issue%20content/ai_generated_content.dart';
import 'package:deck/pages/settings/support%20and%20policies/selected%20issue%20content/bug_issues.dart';
import 'package:deck/pages/settings/support%20and%20policies/selected%20issue%20content/someone_deck_content.dart';
import 'package:deck/pages/settings/support%20and%20policies/selected%20issue%20content/something_else.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../backend/auth/auth_service.dart';
import '../../../backend/report/report_service.dart';
import '../../auth/privacy_policy.dart';
import '../../misc/colors.dart';
import '../../misc/custom widgets/appbar/auth_bar.dart';
import '../../misc/custom widgets/buttons/custom_buttons.dart';
import '../../misc/custom widgets/buttons/radio_button.dart';
import '../../misc/custom widgets/dialogs/alert_dialog.dart';
import '../../misc/custom widgets/dialogs/confirmation_dialog.dart';
import '../../misc/widget_method.dart';


class ReportAProblem extends StatefulWidget {
  final String sourcePage;
  String? deckID;

  ReportAProblem({super.key, required this.sourcePage, this.deckID});

  @override
  _ReportAProblemState createState() => _ReportAProblemState();
}
class _ReportAProblemState extends State<ReportAProblem> {
  List<String> buttonLabels = [];
  List<String> buttonSubtexts = [];
  final TextEditingController textController = TextEditingController();

  late final BugIssues bugIssues;
  late final SomethingElse somethingElse;
  late final AIGeneratedContent aiGeneratedContent;
  late final SomeoneDeckContent someoneDeckContent;

  ///Handles the button selected in radio button behavior
  //tracks the selected radio button
  int selectedRadio = -1;

  //updates the selected radio button index
  void _radioButtonSelected(int index){
    setState(() {
      selectedRadio = index;
    });
  }
  ///----- E N D -------
  ///
  @override
  void initState(){
    super.initState();
    _setRadioBtnOptions();

    ///This sets default radio button selection based on the source page
    if (widget.sourcePage == 'AccountPage') {
      selectedRadio = 0; //AI-Generated Content
    } else if (widget.sourcePage == 'ViewDeckOwner'){
      selectedRadio = 0; //AI-Generated Content
    }
    else {
      selectedRadio = 0; //Someone's Deck Content
    }

     bugIssues = BugIssues(controller: textController);
     somethingElse = SomethingElse(controller: textController);
     aiGeneratedContent = AIGeneratedContent(controller: textController);
     someoneDeckContent = SomeoneDeckContent(controller: textController);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  ///This shows radio btns otpions based on the source page
  void _setRadioBtnOptions (){
    if (widget.sourcePage == 'AccountPage'){
      buttonLabels = [
        'Bug Issues',
        'Something Else',
      ];
      buttonSubtexts = [
        'App crashes, broken features, or unexpected behavior.',
        '', //null because there is no subtext for the 4th option
      ];
    }
    else if (widget.sourcePage == 'ViewDeckOwner'){
      buttonLabels = [
        'AI-Generated Content',
      ];
      buttonSubtexts = [
        'Harmful, incorrect, or biased AI-generated quiz or flashcard content.',
      ];
    }
    else {
      buttonLabels = ['Someone\'s Deck Content'];
      buttonSubtexts = ['Inappropriate, offensive, or misleading content in public decks.'];
    }
  }

  ///This returns the content of each radio btn based on the selectd radio btn on the src page
  Widget _getSelectRadioContent(){
    if(widget.sourcePage == 'AccountPage') {
      switch (selectedRadio) {
        case 0:
          return bugIssues;
        case 1:
          return somethingElse;
        default:
          return const SizedBox.shrink();
      }
    }
    else if (widget.sourcePage == 'ViewDeckOwner') {
      return selectedRadio == 0 ? aiGeneratedContent : const SizedBox.shrink();
    }
    else {
      return selectedRadio == 0 ? someoneDeckContent : const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthBar(
        automaticallyImplyLeading: true,
        title: 'Report A Problem',
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
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Text('Report A Problem',
                          style: TextStyle(
                            fontFamily: 'Fraiche',
                            fontWeight: FontWeight.bold,
                            color: DeckColors.primaryColor,
                            fontSize: 40,
                            height: 1.1,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Text('Found an issue on Deck? Report it here.',
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
                        child: Text('What issue are you reporting?',
                          style: TextStyle(
                            fontFamily: 'Fraiche',
                            color: DeckColors.primaryColor,
                            fontSize: 32,
                            height: 1.1,
                          ),
                        ),
                      ),

                ///this handles the radio button
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: BuildRadioButton(
                    numberOfButtons: buttonLabels.length, //number of radio buttons
                    //radio button label
                    buttonLabels: buttonLabels,
                    //subtexts for the radio button label
                    buttonSubtexts: buttonSubtexts,
                    textStyle:
                    const TextStyle(
                        fontFamily: 'Fraiche',
                        color: DeckColors.primaryColor,
                        fontSize: 24),
                    subtextStyle:
                    const TextStyle(
                        fontFamily: 'Nunito-Regular',
                        color: DeckColors.primaryColor,
                        fontSize: 16),
                        activeColor: DeckColors.primaryColor, //active radio button color
                        inactiveColor: DeckColors.primaryColor, //inactive radio button color
                        onButtonSelected: _radioButtonSelected,//for radio buttons behavior
                        selectedIndex: selectedRadio,

                  ),
                ),
                      ///shows the content based on the selected radio
                      _getSelectRadioContent(),
                      ///--- E N D -----

                      ///this section informs the user about the consequences or actions that will occur upon submitting the form.
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 15.0, right: 15.0),
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
                            String reportTitle = '';
                            String reportType = '';
                            String reportDetails = '';

                            if (widget.sourcePage == 'AccountPage') {
                              if (selectedRadio == 0) {
                                reportTitle = 'Bug Issues';
                                reportType = 'application';
                                reportDetails = bugIssues.getTextValue();
                              } else if (selectedRadio == 1) {
                                reportTitle = 'Something Else';
                                reportType = 'application';
                                reportDetails = somethingElse.getTextValue();
                              }
                            } else if (widget.sourcePage == 'ViewDeckOwner') {
                              reportTitle = 'AI-Generated Content';
                              reportType = 'deck';
                              reportDetails = aiGeneratedContent.getTextValue();
                            } else {
                              reportTitle = 'Someone\'s Deck Content';
                              reportType = 'deck';
                              reportDetails = someoneDeckContent.getTextValue();
                            }

                            if(reportType != 'deck') {
                              // Create and submit the report
                              Report report = Report(
                                userId: AuthService().getCurrentUser()!.uid,
                                title: reportTitle,
                                type: reportType,
                                details: reportDetails,
                                status: 'Pending',
                              );
                              ReportService().createReport(report);
                            } else {
                              ReportedDeck report = ReportedDeck(
                                  id: '',
                                  deckId: widget.deckID,
                                  reportedBy: AuthService().getCurrentUser()!.uid,
                                  title: reportTitle,
                                  details: reportDetails,
                                  status: 'Pending');
                              ReportService().createReportedDeck(report);
                            }

                            showDialog<bool>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return CustomAlertDialog(
                                    imagePath: 'assets/images/Deck-Dialogue3.png',
                                    title: 'Report Submitted',
                                    message: 'Thank you for helping keep Deck safe for everyone.',
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

    );
  }
}