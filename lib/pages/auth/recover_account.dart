import 'package:deck/backend/auth/auth_service.dart';
import 'package:deck/pages/auth/login.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../misc/custom widgets/buttons/custom_buttons.dart';
import '../misc/custom widgets/dialogs/alert_dialog.dart';
import '../misc/custom widgets/dialogs/confirmation_dialog.dart';
import '../misc/custom widgets/textboxes/textboxes.dart';

class RecoverAccountPage extends StatelessWidget {
  RecoverAccountPage({super.key});

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const AuthBar(
      //   automaticallyImplyLeading: true,
      //   title: 'recover account',
      //   color: DeckColors.white,
      //   fontSize: 24,
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image(
              image: const AssetImage('assets/images/AddDeck_Header.png'),
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width:MediaQuery.of(context).size.width,
              child:  const Padding(padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                child:
                Text('Forgot Password',
                  style: TextStyle(
                    fontFamily: 'Fraiche',
                    color: DeckColors.primaryColor,
                    fontSize: 52,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),),
            const Padding(
              padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
              child: Text(
                'Enter your email address below, and we\'ll send you a link to reset your password. Follow the instructions in the email to regain access to your account.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontFamily: 'Nunito-Regular',
                    fontSize: 20
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter Email',
                    style: TextStyle(
                      fontFamily: 'Nunito-Black',
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  BuildTextBox(
                    hintText: 'Enter Email Address',
                    showPassword: false,
                    leftIcon: DeckIcons.account,
                    controller: emailController,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
              child:BuildButton(
                onPressed: () async {
                  try {
                    await AuthService().sendResetPass(emailController.text).then((_) => {
                    showAlertDialog(
                    context,
                    "assets/images/Deck-Dialogue1.png",
                    "Success!",
                    "Please check your email to verify.",
                    ),
                      Navigator.of(context).pop(RouteGenerator.createRoute(const LoginPage()),)
                    });
                  } on FirebaseAuthException catch (e) {
                    print(e.toString());
                    String message = '';
                    if(e.code == 'invalid-email'){
                      message = 'You have entered an invalid email format! Please try again.';
                    } else if (e.code == 'user-not-found'){
                      message = 'User is not found! Please try again.';
                    } else {
                      message = 'There was an error finding email! Please try again';
                    }
                    showAlertDialog(
                      context,
                      "assets/images/Deck-Dialogue1.png",
                      "Uh oh. Something went wrong.",
                      "Error while trying to recover account! $message Please try again.",
                    );
                  } catch (e){
                    print(e.toString());
                    showAlertDialog(
                      context,
                      "assets/images/Deck-Dialogue1.png",
                      "Uh oh. Something went wrong.",
                      "Error while trying to recover account! An unknown error occured while performing process. Please try again.",
                    );
                  }
                },
                buttonText: 'Recover Account',
                height: 60,
                width: MediaQuery.of(context).size.width,
                radius: 10,
                backgroundColor: DeckColors.primaryColor,
                textColor: DeckColors.white,
                fontSize: 16,
                borderWidth: 0,
                borderColor: Colors.transparent,
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
              child:
              BuildButton(
                buttonText: "Cancel",
                height: 60,
                width: MediaQuery.of(context).size.width,
                radius: 10,
                backgroundColor: Colors.transparent,
                textColor: DeckColors.white,
                size: 16,
                fontSize: 20,
                borderWidth: 2,
                borderColor:  DeckColors.white,
                onPressed: () {
                  print("Cancel button clicked");
                  Navigator.pop(context);
                },
              ),

            )
          ],
        ),
      ),
    );
  }
}
