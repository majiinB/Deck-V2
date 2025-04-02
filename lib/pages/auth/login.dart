import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deck/backend/auth/auth_gate.dart';
import 'package:deck/backend/fcm/fcm_service.dart';
import 'package:deck/pages/auth/create_account.dart';
import 'package:deck/pages/auth/privacy_policy.dart';
import 'package:deck/pages/auth/recover_account.dart';
import 'package:deck/pages/auth/terms_of_use.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../backend/auth/auth_service.dart';
import '../misc/custom widgets/buttons/custom_buttons.dart';
import '../misc/custom widgets/dialogs/alert_dialog.dart';
import '../misc/custom widgets/textboxes/textboxes.dart';

/// The LoginPage widget allows users to log in with email/password or via Google.
/// It includes input fields for email and password, and buttons for login
/// and password recovery.

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/// _LoginPageState handles the login logic and user input for LoginPage.
/// It includes text controllers for email and password and integrates
/// Firebase for authentication services.
class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  // Controllers to handle input from the email and password text fields.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DeckColors.backgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child:  Column(
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
                       padding: EdgeInsets.all(20.0),
                       child: Text('Log In',
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
                  Padding(
                    padding: EdgeInsets.only( left: 30, right: 30),
                    child:Column(
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
                        const SizedBox(height: 30,),

                        // Password input field.
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

                        // Forgot password button. Navigates to the password recovery page.
                        Align(
                          alignment: Alignment.centerRight,
                          child:InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                RouteGenerator.createRoute(RecoverAccountPage()),
                              );
                            },
                            borderRadius: BorderRadius.circular(8),
                            splashColor: DeckColors.primaryColor.withOpacity(0.2),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 6),
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontFamily: 'Nunito-Regular',
                                  fontSize: 14,
                                  color: DeckColors.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height:20,),

                        // Log In button. Triggers email/password authentication.
                        BuildButton(
                          onPressed: () async {
                            setState(() => _isLoading = true);
                            try {
                              // Authenticate using email and password.
                              await AuthService().signInWithEmail(
                                  emailController.text, passwordController.text);

                              // After logging in, renew FCM token for notifications.
                              await FCMService().renewToken();

                              if (mounted) {
                                setState(() => _isLoading = false);
                                // Navigate to AuthGate after successful login.
                                Navigator.of(context).pushAndRemoveUntil(
                                  RouteGenerator.createRoute(const AuthGate()),
                                      (Route<dynamic> route) => false, // Removes all previous routes
                                );
                              }
                            } on FirebaseAuthException catch (e) {
                              // Handle specific Firebase authentication errors.
                              String message = '';
                              if (e.code == 'wrong-password') {
                                message = 'Wrong password!';
                              } else if (e.code == 'user-not-found') {
                                message = 'User not found!';
                              } else if (e.code == 'invalid-email') {
                                message = 'Invalid email format!';
                              } else if (e.code == 'too-many-requests') {
                                message =
                                'Too many failed attempts, try again later!';
                              } else {
                                message = 'Error logging in user!';
                              }

                              if (mounted) {
                                setState(() => _isLoading = false);
                                // Display error dialog to the user.
                                showAlertDialog(
                                  context,
                                  "assets/images/Deck-Dialogue1.png",
                                  "Uh oh. Something went wrong.",
                                  "Error signing up!$message Please try again.",
                                );

                              }
                            } catch (e) {
                              // Handle any other errors.
                              print(e.toString());
                              if (mounted) {
                                setState(() => _isLoading = false);
                                showAlertDialog(
                                  context,
                                  "assets/images/Deck-Dialogue1.png",
                                  "Uh oh. Something went wrong.",
                                  "Error signing up! A problem occurred while signing in.Please try again.",
                                );
                              }
                            }
                          },
                          buttonText: 'Log In',
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          radius: 10,
                          backgroundColor: DeckColors.accentColor,
                          textColor: DeckColors.primaryColor,
                          fontSize: 16,
                          borderWidth: 3,
                          borderColor: DeckColors.primaryColor
                        ),

                        Align(
                          alignment: Alignment.center,
                          child:Row(
                              mainAxisSize: MainAxisSize.min,
                              children:[
                                const Text(
                                    "Don’t have an account?",
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
                                      RouteGenerator.createRoute(const CreateAccountPage()),
                                    );
                                  },
                                  child:const Text(
                                    "Sign Up",
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
                        const SizedBox(height: 10),
                        BuildButton(
                          onPressed: () async {
                            setState(() => _isLoading = true);
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
                              setState(() => _isLoading = false);
                              Navigator.of(context).push(
                                RouteGenerator.createRoute(const AuthGate()),
                              );

                            } catch (e){
                              print(e.toString());
                              setState(() => _isLoading = false);
                              ///display error
                              showAlertDialog(
                                context,
                                "assets/images/Deck-Dialogue1.png",
                                "Uh oh. Something went wrong.",
                                "Error signing up! A problem occurred while signing in.Please try again.",
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


                      ],
                    ),
                  ),
                  Image(
                    image: const AssetImage('assets/images/Deck-Bottom-Image3.png'),
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),

                  // Google sign-in button. Uses Firebase Authentication with Google.
                  // BuildButton(
                  //   onPressed: () async {
                  //     setState(() => _isLoading = true);
                  //     final authService = AuthService();
                  //     try {
                  //       // Sign in using Google.
                  //       final currentUser =
                  //       await authService.signUpWithGoogle();
                  //
                  //       // Create a user object to save in Firestore.
                  //       final user = <String, dynamic>{
                  //         "email": currentUser?.email,
                  //         "name": currentUser?.displayName,
                  //         "uid": currentUser?.uid,
                  //         "cover_photo": "",
                  //         "fcm_token": await FCMService().getToken(),
                  //       };
                  //
                  //       final db = FirebaseFirestore.instance;
                  //
                  //       // Check if the user exists in Firestore; if not, create a new entry.
                  //       final snap = await db
                  //           .collection("users")
                  //           .where('email', isEqualTo: currentUser?.email)
                  //           .get();
                  //       if (snap.docs.isEmpty) {
                  //         await db.collection("users").add(user);
                  //       } else {
                  //         // Renew FCM token if the user already exists.
                  //         await FCMService().renewToken();
                  //       }
                  //       if (mounted) {
                  //         setState(() => _isLoading = false);
                  //         // Navigate to AuthGate after successful login.
                  //         Navigator.of(context).push(
                  //           RouteGenerator.createRoute(const AuthGate()),
                  //         );
                  //       }
                  //     } catch (e) {
                  //       print(e.toString());
                  //       if (mounted) {
                  //         setState(() => _isLoading = false);
                  //         showInformationDialog(context, "Error signing in.",
                  //             "A problem occurred while signing in. Please try again.");
                  //       }
                  //     }
                  //   },
                  //   buttonText: 'Continue with Google',
                  //   height: 60,
                  //   width: MediaQuery.of(context).size.width,
                  //   radius: 10,
                  //   backgroundColor: Colors.transparent,
                  //   textColor: DeckColors.white,
                  //   fontSize: 16,
                  //   borderWidth: 1,
                  //   borderColor: Colors.white,
                  //   svg:
                  //   'assets/icons/google-icon.svg', // Google icon for the button.
                  //   svgHeight: 24,
                  // ),
                ],
              )
            ),
    );
  }
}
