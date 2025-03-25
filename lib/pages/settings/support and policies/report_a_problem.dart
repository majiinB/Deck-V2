import 'package:deck/pages/settings/support%20and%20policies/selected%20issue%20content/ai_generated_content.dart';
import 'package:deck/pages/settings/support%20and%20policies/selected%20issue%20content/bug_issues.dart';
import 'package:deck/pages/settings/support%20and%20policies/selected%20issue%20content/someone_deck_content.dart';
import 'package:deck/pages/settings/support%20and%20policies/selected%20issue%20content/something_else.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../auth/privacy_policy.dart';
import '../../misc/colors.dart';
import '../../misc/custom widgets/appbar/auth_bar.dart';
import '../../misc/custom widgets/buttons/custom_buttons.dart';
import '../../misc/custom widgets/buttons/radio_button.dart';
import '../../misc/custom widgets/dialogs/confirmation_dialog.dart';
import '../../misc/widget_method.dart';


class ReportAProblem extends StatefulWidget {
  final String sourcePage;

  const ReportAProblem({super.key, required this.sourcePage});

  @override
  _ReportAProblemState createState() => _ReportAProblemState();
}
class _ReportAProblemState extends State<ReportAProblem> {
  List<String> buttonLabels = [];
  List<String> buttonSubtexts = [];

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
    } else {
      selectedRadio = 0; //Someone's Deck Content
    }
  }

  ///This shows radio btns otpions based on the source page
  void _setRadioBtnOptions (){
    if (widget.sourcePage == 'AccountPage'){
      buttonLabels = [
        'AI-Generated Content',
        'Bug Issues',
        'Something Else',
      ];
      buttonSubtexts = [
        'Harmful, incorrect, or biased AI-generated quiz or flashcard content.',
        'App crashes, broken features, or unexpected behavior.',
        '', //null because there is no subtext for the 4th option
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
          return AIGeneratedContent();
        case 1:
          return BugIssues();
        case 2:
          return SomethingElse();
        default:
          return const SizedBox.shrink();
      }
    }
    else {
      return selectedRadio == 0 ? SomeoneDeckContent() : const SizedBox.shrink();
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
                        padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                        child: Text('Found something on Deck that doesn’t '
                            'seem right? Help us improve Deck by reporting it.',
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
                        'assets/images/Deck-Bottom-Image.png',
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