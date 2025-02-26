import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deck/backend/auth/auth_gate.dart';
import 'package:deck/backend/fcm/fcm_service.dart';
import 'package:deck/pages/auth/create_account.dart';
import 'package:deck/pages/auth/login.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/widget_method.dart';
// import 'package:google_fonts/google_fonts.dart';

import '../../backend/auth/auth_service.dart';
import '../misc/custom widgets/buttons/custom_buttons.dart';

/// The SignUpPage widget allows users to sign up for the application.
/// It provides options to sign up using Google or email.
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const AuthBar(
      //   automaticallyImplyLeading: false,
      //   title: 'Sign Up',
      //   color: DeckColors.primaryColor,
      //   fontSize: 24,
      // ),
      body: _isLoading ? const Center(
        child:CircularProgressIndicator()) :
    SingleChildScrollView(child:
    Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: const AssetImage('assets/images/startDeck.png'),
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fitWidth,
          ),
          const SizedBox(height: 30),
          SizedBox(
            width:  MediaQuery.of(context).size.width,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child:  Text(
                'Get Started\nWith Deck!',
                style: TextStyle(
                  height: 0.9,
                  color: DeckColors.primaryColor,
                  fontFamily: 'Fraiche',
                  fontSize: 60,
                ),
              ),
            )
          ),
          SizedBox(
              width:  MediaQuery.of(context).size.width,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15) ,
                child:  Text(
                  'Let\'s begin your journey to a more organized and productive life with Deck.',
                  style: TextStyle(
                    color: DeckColors.white,
                    fontFamily: 'Nunito-Regular',
                    fontSize: 24,
                  ),
                ),
              )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15) ,
            child : BuildButton(
              onPressed: () {
                Navigator.of(context).push(
                  RouteGenerator.createRoute(const CreateAccountPage()),
                );
                },
              buttonText: 'Create New Account',
              height: 60,
              width: MediaQuery.of(context).size.width,
              radius: 10,
              backgroundColor: DeckColors.white,
              textColor: DeckColors.backgroundColor,
              fontSize: 20,
              borderWidth: 0,
              borderColor: Colors.transparent,
              icon: DeckIcons.account,
              iconColor: DeckColors.backgroundColor,
              size: 24,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Have an Account? ',
                  style: TextStyle(fontSize: 16.0, fontFamily: 'NUnito-Regular'),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      RouteGenerator.createRoute(const LoginPage()),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  splashColor: DeckColors.primaryColor.withOpacity(0.5),
                  child: const Padding(
                    padding:
                    EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                    child: Text(
                      'Log In',
                      style: TextStyle(
                        fontFamily: 'Nunito-Black',
                        fontSize: 16,
                        color: DeckColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
    );
  }
}
