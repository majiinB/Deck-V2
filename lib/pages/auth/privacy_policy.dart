import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../misc/colors.dart';
import '../misc/widget_method.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const AuthBar(
        automaticallyImplyLeading: true,
        title: '',
        color: DeckColors.white,
        fontSize: 24,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset('assets/images/Deck-Branding1.png')),
                  ),
                  const SizedBox( height: 20),
                  const Text("AGREEMENT",
                      style: TextStyle(
                        fontFamily: 'Fraiche',
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: DeckColors.white,
                      )
                  ),

                  ///
                  /// P R I V A C Y  P O L I C Y
                  ///

                  const Text("Privacy Policy",
                      style: TextStyle(
                        fontFamily: 'Fraiche',
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: DeckColors.white,
                      )
                  ),
                  const SizedBox( height: 10),
                  const Text('At Deck, we are committed to protecting your privacy. This '
                      'Privacy Policy describes how your personal information is collected, '
                      'used, and shared when you use the Deck application (the "App").',
                    textAlign: TextAlign.justify,

                    style: TextStyle(
                      fontFamily: 'nunito',
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: DeckColors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontFamily: 'nunito',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: DeckColors.white,
                      ),
                      children: [
                        TextSpan(
                          text: '1. Information We Collect\n\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'a. Information You Provide: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'When you register an account with Deck, we collect certain personal '
                              'information such as your name, email address, and password.\n\n',
                        ),
                        TextSpan(
                          text: 'b. Usage Information: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'We collect information about your interactions with the App, '
                              'including your study habits, flashcard usage, and preferences.\n\n',
                        ),
                        TextSpan(
                          text: 'c. Device Information: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'We collect information about the device you use to access the App, '
                              'including the hardware model, operating system version, and unique '
                              'device identifiers.\n\n\n',
                        ),
                        TextSpan(
                          text: '2. How We Use Your Information\n\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'We use the information we collect to provide and improve the App, '
                              'personalize your experience, communicate with you, and protect the '
                              'security of the App.\n\n\n',
                        ),
                        TextSpan(
                          text: '3. Sharing Your Information\n\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'We may share your personal information with third-party service '
                              'providers who assist us in providing the App, such as hosting providers '
                              'and analytics services. We may also share your information in response '
                              'to legal requests or to protect our rights or the rights of others.\n\n\n',
                        ),
                        TextSpan(
                          text: '4. Data Retention\n\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'We will retain your personal information for as long as necessary to '
                              'fulfill the purposes outlined in this Privacy Policy unless a longer '
                              'retention period is required or permitted by law.\n\n\n',
                        ),
                        TextSpan(
                          text: '5. Security\n\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'We take reasonable measures to protect the security of your '
                              'personal information and to prevent unauthorized access, disclosure, '
                              'alteration, or destruction.\n\n\n',
                        ),
                        TextSpan(
                          text: '6. Children\'s Privacy\n\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'Deck is not directed to children under the age of 13, and we do '
                              'not knowingly collect personal information from children under the '
                              'age of 13. If we become aware that we have collected personal '
                              'information from a child under the age of 13, we will take steps '
                              'to delete such information.\n\n\n',
                        ),
                        TextSpan(
                          text: '7. Changes to Privacy Policy\n\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'We reserve the right to modify this Privacy Policy at a'
                              'ny time. If we make material changes to this Privacy Policy, we '
                              'will notify you by email or by posting a notice in the App prior '
                              'to the changes taking effect.\n\n\n',
                        ),
                        TextSpan(
                          text: '8. Contact Us\n\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'If you have any questions or concerns about this Privacy '
                              'Policy, please contact us at \'deckoctopus@gmail.com\'.\n\n',
                        ),
                      ],
                    ),
                    textAlign: TextAlign.justify,


                  ),
                  const SizedBox(height: 10),
                  const Text("By using the Deck App, you consent to the "
                      "collection and use of your personal information as described in this Privacy Policy. "
                      "Thank you for using Deck!",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontFamily: 'nunito',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: DeckColors.white,
                      )
                  ),
                  const SizedBox(height: 40),

                ],
              ),
            ),
          )

      ),
    );
  }
}