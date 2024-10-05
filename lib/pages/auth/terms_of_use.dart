import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../misc/colors.dart';
import '../misc/widget_method.dart';

class TermsOfUsePage extends StatelessWidget {
  const TermsOfUsePage({super.key});

  @override
  Widget build(BuildContext context) {
   return  Scaffold(
     appBar: const AuthBar(
       automaticallyImplyLeading: true,
       title: '',
       color: DeckColors.white,
       fontSize: 24,
     ),     body: SafeArea(
       child: SingleChildScrollView(
         child: Padding(
           padding: const EdgeInsets.only(top: 10,left: 30, right: 30),
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
                   textAlign: TextAlign.start,
                   style: TextStyle(
                     fontFamily: 'Fraiche',
                     fontSize: 16,
                     fontWeight: FontWeight.w300,
                     color: DeckColors.white,
                   )
               ),
               ///
               /// T E R M S  O  F  U S E
               ///
               /// 
               const Text("Terms of Use",
                   textAlign: TextAlign.start,

                   style: TextStyle(
                 fontFamily: 'Fraiche',
                 fontSize: 32,
                 fontWeight: FontWeight.w600,
                 color: DeckColors.white,
               )
                 ),
               const SizedBox( height: 20),
               const Text("Welcome to Deck!",
                   style: TextStyle(
                     fontFamily: 'Fraiche',
                     fontSize: 20,
                     fontWeight: FontWeight.w600,
                     color: DeckColors.white,
                   ),
                 ),
               const SizedBox(height: 20),
               const Text('These Terms of Use (Terms) govern your access to '
                       'and use of the Deck application ("Deck" or the "App"), '
                       'including any content, functionality, and services offered '
                       'on or through the App. By accessing or using Deck, you '
                       'agree to be bound by these Terms. If you do not agree to '
                       'these Terms, please do not access or use our Deck.',
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
                       text: '1. Your Use of Deck\n\n',
                       style: TextStyle(fontWeight: FontWeight.bold),
                     ),
                     TextSpan(
                       text: 'a. Eligibility: ',
                       style: TextStyle(fontWeight: FontWeight.bold),
                     ),
                     TextSpan(
                       text: 'You must be at least 13 years old to use Deck. '
                           'By using Deck, you represent and warrant that you are at least 13 years old.\n\n',
                     ),
                     TextSpan(
                       text: 'b. Accounts: ',
                       style: TextStyle(fontWeight: FontWeight.bold),
                     ),
                     TextSpan(
                       text: 'In order to access certain features of Deck, you may be required to '
                           'create an account. You agree to provide accurate, current, and complete '
                           'information during the registration process and to update such information'
                           ' to keep it accurate, current, and complete.\n\n',
                     ),
                     TextSpan(
                       text: 'c. Use Restrictions: ',
                       style: TextStyle(fontWeight: FontWeight.bold),
                     ),
                     TextSpan(
                       text: 'You agree to use Deck only for its intended purposes and in '
                           'accordance with these Terms. You may not use Deck for any illegal or '
                           'unauthorized purpose.\n\n\n',
                     ),
                     TextSpan(
                       text: '2. Privacy Policy\n\n',
                       style: TextStyle(fontWeight: FontWeight.bold),
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
                       style: TextStyle(fontWeight: FontWeight.bold),
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
                       style: TextStyle(fontWeight: FontWeight.bold),
                     ),
                     TextSpan(
                       text: 'Deck is provided as is and as available without any warranties '
                           'of any kind, express or implied. We do not warrant that Deck will be '
                           'error-free or uninterrupted, that defects will be corrected, or that '
                           'Deck is free of viruses or other harmful components.\n\n\n',
                     ),
                     TextSpan(
                       text: '5. Limitation of Liability\n\n',
                       style: TextStyle(fontWeight: FontWeight.bold),
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
                       style: TextStyle(fontWeight: FontWeight.bold),
                     ),
                     TextSpan(
                       text: 'These Terms are governed by and construed in accordance with the laws of '
                           'the Philippines, without regard to its conflict of law principles.\n\n\n',
                     ),
                     TextSpan(
                       text: '7. Changes to Terms\n\n',
                       style: TextStyle(fontWeight: FontWeight.bold),
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
       )
         
       ),
   );
  }
}