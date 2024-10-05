import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deck/backend/auth/auth_gate.dart';
import 'package:deck/backend/fcm/fcm_service.dart';
import 'package:deck/pages/auth/recover_account.dart';
import 'package:deck/pages/auth/signup.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../backend/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthBar(
        automaticallyImplyLeading: false,
        title: 'log in',
        color: DeckColors.white,
        fontSize: 24,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    child: Image.asset('assets/images/Deck-Logo.png')),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email',
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
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BuildTextBox(
                      hintText: 'Enter Password',
                      showPassword: true,
                      leftIcon: DeckIcons.lock,
                      rightIcon: Icons.search,
                      controller: passwordController,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      RouteGenerator.createRoute(RecoverAccountPage()),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  splashColor: DeckColors.primaryColor.withOpacity(0.5),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4, horizontal: 6), // Color of the InkWell
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: DeckColors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              BuildButton(
                onPressed: () async {

                  try{
                    await AuthService().signInWithEmail(emailController.text, passwordController.text);
                    await FCMService().renewToken();
                    Navigator.of(context).push(
                      RouteGenerator.createRoute(const AuthGate()),
                    );
                  } on FirebaseAuthException catch(e){
                    String message = '';
                    if(e.code == 'wrong-password'){
                      message = 'Wrong password!';
                    } else if (e.code == 'user-not-found') {
                      message = 'User not found!';
                    } else if (e.code == 'invalid-email') {
                      message = 'Invalid email format!';
                    } else if (e.code == 'too-many-requests') {
                      message = 'Too many failed attempts, try again later!';
                    } else {
                      message = 'Error logging in user!';
                    }

                    ///display error
                    showInformationDialog(context, message, "A problem occured while signing in. Please try again.");

                  } catch (e) {

                    ///display error
                    print(e.toString());
                    showInformationDialog(context, "Error signing in.","A problem occured while signing in. Please try again.");
                  }
                },
                buttonText: 'Log In',
                height: 60,
                width: MediaQuery.of(context).size.width,
                radius: 10,
                backgroundColor: DeckColors.primaryColor,
                textColor: DeckColors.white,
                fontSize: 16,
                borderWidth: 0,
                borderColor: Colors.transparent,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 2,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'or',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 2,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              BuildButton(
                onPressed: () async{

                  final authService = AuthService();
                  try {
                    final currentUser = await authService.signUpWithGoogle();

                    final user = <String, dynamic> {
                      "email": currentUser?.email,
                      "name": currentUser?.displayName,
                      "uid": currentUser?.uid,
                      "cover_photo": "",
                      "fcm_token": await FCMService().getToken(),
                    };
                    final db = FirebaseFirestore.instance;
                    final snap = await db.collection("users").where('email',isEqualTo: currentUser?.email).get();
                    if(snap.docs.isEmpty){
                      await db.collection("users").add(user);
                    } else {
                      await FCMService().renewToken();
                    }
                    Navigator.of(context).push(
                      RouteGenerator.createRoute(const AuthGate()),
                    );
                  } catch (e){
                    print(e.toString());

                    ///display error
                    showInformationDialog(context, "Error signing in.","A problem occured while signing in. Please try again.");
                  }
                },
                buttonText: 'Continue with Google',
                height: 60,
                width: MediaQuery.of(context).size.width,
                radius: 10,
                backgroundColor: Colors.transparent,
                textColor: DeckColors.white,
                fontSize: 16,
                borderWidth: 1,
                borderColor: Colors.white,
                svg: 'assets/icons/google-icon.svg',
                svgHeight: 24,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop(
                          RouteGenerator.createRoute(const SignUpPage()),
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      splashColor: DeckColors.primaryColor.withOpacity(0.5),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 6), // Color of the InkWell
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
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
      )
    );
  }
}