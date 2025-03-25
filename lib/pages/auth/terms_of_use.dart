import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../misc/colors.dart';
import '../misc/custom widgets/appbar/auth_bar.dart';
import '../misc/deck_icons.dart';
import '../misc/widget_method.dart';

class TermsOfUsePage extends StatelessWidget {
  const TermsOfUsePage({super.key});

  @override
  Widget build(BuildContext context) {
   return  Scaffold(
     backgroundColor: DeckColors.backgroundColor,
     body: SafeArea(
        child: SingleChildScrollView(
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             ///This is the header of the terms of use page
             Stack(
               children: [
                 Image.asset('assets/images/Deck-Header.png',
                   fit: BoxFit.fitWidth,
                   width: MediaQuery.of(context).size.width,
                 ),
                 Positioned(
                   bottom: 20,
                   left: 10,
                   child: IconButton(
                     icon: const Icon(DeckIcons.back_arrow,
                         color: DeckColors.primaryColor,
                         size: 24),
                     onPressed: () {
                       Navigator.pop(context);
                     },
                   ),
                 ),
               ],
             ),
             ///---- E N D  O F  T H E  H E A D E R ----
             const Padding(
               padding: EdgeInsets.symmetric(horizontal: 15.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text("AGREEMENT",
                       textAlign: TextAlign.start,
                       style: TextStyle(
                         fontFamily: 'Fraiche',
                         fontSize: 16,
                         fontWeight: FontWeight.w300,
                         color: DeckColors.primaryColor,
                       )
                   ),
             ///
             /// T E R M S  O  F  U S E
             ///
             ///
             Text("Terms of Use",
                 textAlign: TextAlign.start,
                 style: TextStyle(
                   fontFamily: 'Fraiche',
                   fontSize: 32,
                   fontWeight: FontWeight.w900,
                   color: DeckColors.primaryColor,
                    )
                ),
             Text("Welcome to Deck: Study Smarter, Plan Better!",
                 style: TextStyle(
                   fontFamily: 'Fraiche',
                   fontSize: 20,
                   fontWeight: FontWeight.w600,
                   color: DeckColors.primaryColor,
                 ),
               ),
             SizedBox(height: 20),
             Text('These Terms of Use (Terms) govern your access to '
                     'and use of the Deck application ("Deck" or the "App"), '
                     'including any content, functionality, and services offered '
                     'on or through the App. By accessing or using Deck, you '
                     'agree to be bound by these Terms. If you do not agree to '
                     'these Terms, please do not access or use our Deck.',
               textAlign: TextAlign.justify,
               style: TextStyle(
                     fontFamily: 'Nunito-Regular',
                     fontSize: 16,
                     color: DeckColors.primaryColor,
                   ),
                 ),
             SizedBox(
                   height: 20,
                 ),
              Text.rich(
               TextSpan(
                 style: TextStyle(
                   fontFamily: 'Nunito-Regular',
                   fontSize: 16,
                   color: DeckColors.primaryColor,
                 ),
                 children: [
                   TextSpan(
                     text: '1. Your Use of Deck\n\n',
                     style: TextStyle(fontFamily: 'Nunito-ExtraBold'),
                   ),
                   TextSpan(
                     text: 'a. Eligibility: ',
                     style: TextStyle(fontFamily: 'Nunito-ExtraBold'),
                   ),
                   TextSpan(
                     text: 'You must be at least 13 years old to use Deck. '
                         'By using Deck, you represent and warrant that you are at least 13 years old.\n\n',
                   ),
                   TextSpan(
                     text: 'b. Accounts: ',
                     style: TextStyle(fontFamily: 'Nunito-ExtraBold'),
                   ),
                   TextSpan(
                     text: 'In order to access certain features of Deck, you may be required to '
                         'create an account. You agree to provide accurate, current, and complete '
                         'information during the registration process and to update such information'
                         ' to keep it accurate, current, and complete.\n\n',
                   ),
                   TextSpan(
                     text: 'c. Use Restrictions: ',
                     style: TextStyle(fontFamily: 'Nunito-ExtraBold'),
                   ),
                   TextSpan(
                     text: 'You agree to use Deck only for its intended purposes and in '
                         'accordance with these Terms. You may not use Deck for any illegal or '
                         'unauthorized purpose.\n\n\n',
                   ),
                   TextSpan(
                     text: '2. Privacy Policy\n\n',
                     style: TextStyle(fontFamily: 'Nunito-ExtraBold'),
                   ),
                   TextSpan(
                     text: 'Your privacy is important to us. Our Privacy Policy explains how '
                         'we collect, use, disclose, and protect your personal information. '
                         'By accessing or using Deck, you consent to the collection, use, '
                         'disclosure, and protection of your personal '
                         'information as described in our Privacy Policy.\n\n\n',
                   ),
                   TextSpan(
                     text: '3. Intellectual Property\n\n',
                     style: TextStyle(fontFamily: 'Nunito-ExtraBold'),
                   ),
                   TextSpan(
                     text: 'Deck and its entire contents, features, and functionality '
                         '(including but not limited to all information, software, text, '
                         'displays, images, video, and audio, and the design, selection, and '
                         'arrangement thereof) are owned by Deck or its licensors and are protected '
                         'by copyright, trademark, patent, trade secret, and other intellectual '
                         'property or proprietary rights laws.\n\n\n',
                   ),
                   TextSpan(
                     text: '4. Disclaimer\n\n',
                     style: TextStyle(fontFamily: 'Nunito-ExtraBold'),
                   ),
                   TextSpan(
                     text: 'Deck is provided as is and as available without any warranties '
                         'of any kind, express or implied. We do not warrant that Deck will be '
                         'error-free or uninterrupted, that defects will be corrected, or that '
                         'Deck is free of viruses or other harmful components.\n\n\n',
                   ),
                   TextSpan(
                     text: '5. Limitation of Liability\n\n',
                     style: TextStyle(fontFamily: 'Nunito-ExtraBold'),
                   ),
                   TextSpan(
                     text: 'In no event shall Deck, its affiliates, or their respective officers, '
                         'directors, employees, or agents be liable for any indirect, incidental, '
                         'special, consequential, or punitive damages, including without limitation '
                         'damages for loss of profits, data, use, goodwill, or other intangible losses, '
                         'arising out of or in connection with your access to or use of Deck.\n\n\n',
                   ),
                   TextSpan(
                     text: '6. Governing Law\n\n',
                     style: TextStyle(fontFamily: 'Nunito-ExtraBold'),
                   ),
                   TextSpan(
                     text: 'These Terms are governed by and construed in accordance with the laws of '
                         'the Philippines, without regard to its conflict of law principles.\n\n\n',
                   ),
                   TextSpan(
                     text: '7. Changes to Terms\n\n',
                     style: TextStyle(fontFamily: 'Nunito-ExtraBold'),
                   ),
                   TextSpan(
                     text: 'We reserve the right, at our sole discretion, to modify or replace'
                         ' these Terms at any time. If a revision is material, we will provide at least '
                         '30 days notice prior to any new terms taking effect. What constitutes a '
                         'material change will be determined at our sole discretion.',
                   ),
                 ],
               ),
                 textAlign: TextAlign.justify
             ),
             const SizedBox(height:50),
                 ],
               ),
             ),
           ],
         ),
       )

       ),
   );
  }
}