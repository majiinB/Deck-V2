import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deck/backend/auth/auth_gate.dart';
import 'package:deck/backend/auth/auth_service.dart';
import 'package:deck/backend/fcm/fcm_service.dart';
import 'package:deck/backend/models/deck.dart';
import 'package:deck/pages/auth/login.dart';
import 'package:deck/pages/auth/privacy_policy.dart';
import 'package:deck/pages/auth/terms_of_use.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../misc/custom widgets/buttons/custom_buttons.dart';
import '../misc/custom widgets/checkbox/checkbox.dart';
import '../misc/custom widgets/dialogs/alert_dialog.dart';
import '../misc/custom widgets/dialogs/confirmation_dialog.dart';
import '../misc/custom widgets/textboxes/textboxes.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  bool _isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();
  final DeckBox checkBox = DeckBox();

  String getAdjective() {
    List<String> adjective = [
      'Long',
      'Short',
      'Thick',
      'Thin',
      'Curved',
      'Straight',
      'Hard',
      'Soft',
      'Smooth',
      'Rough',
      'Firm',
      'Stiff',
      'Limp',
      'Engorged',
      'Swollen',
      'Massive',
      'Turgid',
      'Plump',
      'Slender',
      'Enlarged',
      'Lengthy',
      'Trim',
      'Sturdy',
      'Malleable',
      'Elastic',
      'Pulsating',
      'Robust',
      'Lithe',
      'Luscious',
      'Muscular',
      'Rigid',
      'Tender',
      'Prominent',
      'Noticeable',
      'Substantial',
      'Compact',
      'Potent',
      'Dominant',
      'Stretched',
      'Expansive',
      'Defined',
      'Well-endowed'
    ];

    return "${adjective[Random().nextInt(adjective.length)]}_${getRandomNumber()}";
  }

  int getRandomNumber() {
    return 10000 + Random().nextInt(99999 + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: DeckColors.backgroundColor,
        body: _isLoading ?  const Center(
            child:CircularProgressIndicator()) :
        Column(
          children: [
            Stack(
              children: [
                Image(
                  image: AssetImage('assets/images/Deck-Header.png'),
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                const Positioned(
                  left: 10,
                  bottom: 0,
                  child:Padding(
                    padding: EdgeInsets.only(left:20.0),
                    child: Text('Sign Up',
                      style: TextStyle(
                        fontFamily: 'Fraiche',
                        color: DeckColors.primaryColor,
                        fontSize: 56,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only( left: 30, right: 30),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email',
                            style: TextStyle(
                                fontFamily: 'Nunito-Bold',
                                fontSize: 16,
                                color: DeckColors.primaryColor
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          BuildTextBox(
                            hintText: 'Enter Email Address',
                            showPassword: false,
                            controller: emailController,
                          ),
                          const SizedBox(height: 20,),

                          //password input
                          const Text(
                            'Password',
                            style: TextStyle(
                                fontFamily: 'Nunito-Bold',
                                fontSize: 16,
                                color: DeckColors.primaryColor
                            ),
                          ),
                          const SizedBox(height: 10),
                          BuildTextBox(
                            hintText: 'Enter Password',
                            showPassword: true,
                            controller: passwordController,
                          ),
                          const SizedBox(height: 20,),

                          //conmfirm pass inpout
                          const Text(
                            'Confirm Password',
                            style: TextStyle(
                                fontFamily: 'Nunito-Bold',
                                fontSize: 16,
                                color: DeckColors.primaryColor
                            ),
                          ),
                          const SizedBox(height: 10),
                          BuildTextBox(
                            hintText: 'Confirm Password',
                            showPassword: true,
                            controller: confirmPasswordController,
                          ),
                          SizedBox(height: 20),

                          //Sign up button
                          BuildButton(
                              onPressed: () async {
                                setState(() => _isLoading = true);
                                // if(!checkBox.isChecked){
                                //   ///display error
                                //   setState(() => _isLoading = false);
                                //   showAlertDialog(
                                //     context,
                                //     "assets/images/Deck-Dialogue1.png",
                                //     "Uh oh. Something went wrong.",
                                //     "Error Signing Up! You haven't agreed to the Terms of Use and Privacy Policy. Please try again",
                                //   );
                                //   return;
                                // }

                                if(passwordController.text != confirmPasswordController.text) {
                                  setState(() => _isLoading = false);
                                  ///display error
                                  showAlertDialog(
                                    context,
                                    "assets/images/Deck-Dialogue1.png",
                                    "Uh oh. Something went wrong.",
                                    "Error Signing Up! Passwords do not match! Please try again.",
                                  );
                                  return;
                                }

                                try{
                                  final authService = AuthService();
                                  String name = "Anon ${getAdjective()}";
                                  await authService.signUpWithEmail(emailController.text, passwordController.text, name);

                                  final user = <String, dynamic> {
                                    "email": emailController.text,
                                    "name": name,
                                    "user_id":  authService.getCurrentUser()?.uid,
                                    "cover_photo": "",
                                    "fcm_token": await FCMService().getToken(),
                                  };

                                  final db = FirebaseFirestore.instance;
                                  await db.collection("users").add(user);
                                  setState(() => _isLoading = false);
                                  Navigator.of(context).push(
                                    RouteGenerator.createRoute(const AuthGate()),
                                  );
                                } on FirebaseAuthException catch (e) {
                                  String message = '';
                                  print(e.toString());
                                  if(e.code == 'invalid-email'){
                                    message = "Invalid email format! Please try again.";
                                  } else if (e.code == 'email-already-in-use'){
                                    message = "Email is already taken! Please try again.";
                                  } else if (e.code == 'weak-password'){
                                    message = "Password should be at least 6 characters! Please try again.";
                                  } else if (e.code == 'email-already-in-use'){
                                    message = "Email is already in use! Please try again.";
                                  } else {
                                    message = "Unknown Error! Please try again.";
                                  }
                                  setState(() => _isLoading = false);
                                  showAlertDialog(
                                    context,
                                    "assets/images/Deck-Dialogue1.png",
                                    "Uh oh. Something went wrong.",
                                    "Error creating your account!$message Please try again.",
                                  );
                                } catch (e) {
                                  print(e.toString());
                                  setState(() => _isLoading = false);
                                  showAlertDialog(
                                    context,
                                    "assets/images/Deck-Dialogue1.png",
                                    "Uh oh. Something went wrong.",
                                    "Error creating your account!Unknown Error! Please try again.",
                                  );
                                }
                              },
                              buttonText: 'Join the Deck Party!',
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              radius: 10,
                              backgroundColor: DeckColors.accentColor,
                              textColor: DeckColors.primaryColor,
                              fontSize: 16,
                              borderWidth: 3,
                              borderColor: DeckColors.primaryColor
                          ),
                          const SizedBox(height: 10),

                          Align(
                            alignment: Alignment.center,
                            child:Row(
                                mainAxisSize: MainAxisSize.min,
                                children:[
                                  const Text(
                                      "Have an account?",
                                      maxLines: 2,
                                      style:TextStyle(
                                        height:1,
                                        fontSize: 14,
                                        fontFamily: 'Nunito-Regular',
                                        color: DeckColors.primaryColor,
                                      )
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                        RouteGenerator.createRoute(const LoginPage()),
                                      );
                                    },
                                    child:const Text(
                                      "Log In",
                                      style: TextStyle(
                                        fontFamily: 'Nunito-Bold',
                                        fontSize: 14,
                                        color: DeckColors.primaryColor,
                                      ),
                                    ),
                                  )
                                ]
                            ),
                          ),
                          const SizedBox(height: 10),

                          //Google sign-in button. Uses Firebase Authentication with Google.
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: DeckColors.primaryColor,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),

                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  'or continue with',
                                  style: TextStyle(
                                      fontFamily: 'Nunito-Regular',
                                      fontSize: 14,
                                      color: DeckColors.primaryColor
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: DeckColors.primaryColor,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),

                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          BuildButton(
                            onPressed: () async {
                              final authService = AuthService();
                              try {
                                final currentUser = await authService.signUpWithGoogle();
                                final user = <String, dynamic> {
                                  "email": currentUser?.email,
                                  "name": currentUser?.displayName,
                                  "user_id": currentUser?.uid,
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
                                Navigator.of(context).pushAndRemoveUntil(
                                  RouteGenerator.createRoute(const AuthGate()),
                                      (Route<dynamic> route) => false, // Removes all previous routes
                                );
                              } catch (e){
                                print(e.toString());
                                ///display error
                                showAlertDialog(
                                  context,
                                  "assets/images/Deck-Dialogue1.png",
                                  "Uh oh. Something went wrong.",
                                  "Error signing up!A problem occured while signing up.Please try again.",
                                );
                              }
                            },
                            buttonText: 'Google',
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            radius: 10,
                            backgroundColor: DeckColors.white,
                            textColor: DeckColors.primaryColor,
                            fontSize: 16,
                            borderWidth: 3,
                            borderColor: DeckColors.primaryColor,
                            svg: 'assets/icons/google-icon.svg',
                            svgHeight: 20,
                          ),

                          //terms&policy
                          const SizedBox(height: 20),
                          RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  style: TextStyle(
                                      fontFamily: 'Nunito-Regular',
                                      fontSize: 12,
                                      color: DeckColors.primaryColor
                                  ),
                                  children: [
                                    TextSpan(text: "By proceeding, you acknowledge that you have read, understood, and agree to our "),
                                    TextSpan(
                                      text: "Terms of Use",
                                      style: TextStyle(
                                          fontFamily: 'Nunito-Bold',
                                          color: DeckColors.primaryColor, decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.of(context).push(RouteGenerator.createRoute(TermsOfUsePage()),);
                                        },
                                    ),
                                    TextSpan(text: " and "),
                                    TextSpan(
                                      text: "Privacy Policy.",
                                      style: TextStyle(
                                          fontFamily: 'Nunito-Bold',
                                          color: DeckColors.primaryColor,
                                          decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.of(context).push(RouteGenerator.createRoute(PrivacyPolicyPage()),);
                                        },
                                    ),
                                  ]
                              )
                          )
                        ]
                    ),
                  )
              ),
            ),
            Image(
              image: const AssetImage('assets/images/Deck-Bottom-Image3.png'),
              width: MediaQuery.of(context).size.width,
              height:80,
              fit: BoxFit.fill,
            ),
          ],
        )
    );
  }
}
