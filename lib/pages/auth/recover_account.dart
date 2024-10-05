import 'package:deck/backend/auth/auth_service.dart';
import 'package:deck/pages/auth/login.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecoverAccountPage extends StatelessWidget {
  RecoverAccountPage({super.key});

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthBar(
        automaticallyImplyLeading: true,
        title: 'recover account',
        color: DeckColors.white,
        fontSize: 24,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 30),
                child: Text(
                    'Please enter the email address associated with your account. '
                        'We will send you instructions on how to reset your password.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontFamily: 'nunito',
                    fontSize: 16
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter Email',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
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
              const SizedBox(
                height: 60,
              ),
              BuildButton(
                onPressed: () async {
                  try {
                    await AuthService().sendResetPass(emailController.text).then((_) => {
                    showInformationDialog(context, "Success!", "Process was a success. Please check your email."),
                    Navigator.of(context).pop(RouteGenerator.createRoute(LoginPage()),)
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
                    showInformationDialog(context, "Error while trying to recover account", message);

                  } catch (e){
                    print(e.toString());
                    showInformationDialog(context, "Error while trying to recover account", "An unknown error occured while performing process. Please try again");
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
            ],
          ),
        ),
      ),
    );
  }
}
