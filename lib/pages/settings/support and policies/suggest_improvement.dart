import 'package:flutter/material.dart';

import '../../auth/privacy_policy.dart';
import '../../misc/colors.dart';
import '../../misc/custom widgets/appbar/auth_bar.dart';
import '../../misc/custom widgets/buttons/custom_buttons.dart';
import '../../misc/custom widgets/textboxes/textboxes.dart';
import '../../misc/widget_method.dart';


class SuggestImprovement extends StatefulWidget {
  const SuggestImprovement({super.key});

  @override
  _SuggestImprovementState createState() => _SuggestImprovementState();
}
class _SuggestImprovementState extends State<SuggestImprovement> {
  final suggestionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthBar(
        automaticallyImplyLeading: true,
        title: 'Suggest Improvement',
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
                child: Text('Suggest Improvement',
                style: TextStyle(
                  fontFamily: 'Fraiche',
                  fontWeight: FontWeight.bold,
                  color: DeckColors.primaryColor,
                  fontSize: 48,
                  height: 1.1,
                ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                child: Text('We’d love to know what you want to see in the'
                    ' future or what could be improved. '
                    'We may contact you about the feedback you’ve shared '
                    'and research opportunities related to your feedback.',
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
                child: Text('How can we make Deck better?',
                  style: TextStyle(
                    fontFamily: 'Fraiche',
                    color: DeckColors.primaryColor,
                    fontSize: 40,
                    height: 1.1,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top:20.0),
                child: BuildTextBox(
                  showPassword: false,
                  hintText: "Suggest Improvement",
                  isMultiLine: true,
                  controller: suggestionController,
                ),
              ),
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
               Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
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
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top:30),
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
               Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Image(
                  image: const AssetImage('assets/images/Deck-Bottom-Image.png'),
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ), // Placeholder for body content
      ),
    );
  }
}