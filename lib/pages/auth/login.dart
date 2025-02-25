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
import '../misc/custom widgets/buttons/custom_buttons.dart';
import '../misc/custom widgets/dialogs/confirmation_dialog.dart';
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
      // Custom app bar for the login screen witddh specific styles.
      // appBar: const AuthBar(
      //   automaticallyImplyLeading: false,
      //   title: 'Log In',
      //   color: DeckColors.primaryColor,
      //   fontSize: 24,
      // ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child:  Column(
                children: [
                  Image(
                    image: const AssetImage('assets/images/AddDeck_Header.png'),
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width:MediaQuery.of(context).size.width,
                            child:  const Padding(padding: EdgeInsets.only(top: 10),
                              child:
                              Text('Log In',
                                style: TextStyle(
                                  fontFamily: 'Fraiche',
                                  color: DeckColors.primaryColor,
                                  fontSize: 52,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),)
                        ]
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontFamily: 'Nunito',
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

                  // Password input field.
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
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
                        const SizedBox(height: 10),
                        // BuildTextBox is a custom widget for the password text box.
                        BuildTextBox(
                          hintText: 'Enter Password',
                          showPassword: true,
                          leftIcon: DeckIcons.lock,
                          rightIcon: Icons.search, // Optional right icon.
                          controller: passwordController,
                        ),
                      ],
                    ),
                  ),

                  // Forgot password button. Navigates to the password recovery page.
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
                            vertical: 4, horizontal: 6),
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
                  const SizedBox(height: 20),
                  // Log In button. Triggers email/password authentication.
                  Padding(
                      padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                    child:
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
                            Navigator.of(context).push(
                              RouteGenerator.createRoute(const AuthGate()),
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
                            showInformationDialog(context, message,
                                "A problem occurred while signing in. Please try again.");
                          }
                        } catch (e) {
                          // Handle any other errors.
                          print(e.toString());
                          if (mounted) {
                            setState(() => _isLoading = false);
                            showInformationDialog(context, "Error signing in.",
                                "A problem occurred while signing in. Please try again.");
                          }
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
                    )
                  ),


                  const Padding(
                    padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 2,
                            color: DeckColors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'or continue with',
                            style: TextStyle(
                                fontSize: 16,
                                color: DeckColors.white
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 2,
                            color: DeckColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: BuildButton(
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
                          showInformationDialog(context, "Error signing up", "A problem occured while signing up. Please try again.");
                        }
                      },
                      buttonText: 'Google',
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      radius: 10,
                      backgroundColor: Colors.transparent,
                      textColor: DeckColors.white,
                      fontSize: 24,
                      borderWidth: 2,
                      borderColor: Colors.white,
                      svg: 'assets/icons/google-icon.svg',
                      svgHeight: 24,
                    ),
                  ),
                  const SizedBox(height: 50),

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
