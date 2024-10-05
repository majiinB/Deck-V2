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

/// The LoginPage widget allows users to log in with email/password or via Google.
/// It includes input fields for email and password, and buttons for login
/// and password recovery.
class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/// _LoginPageState handles the login logic and user input for LoginPage.
/// It includes text controllers for email and password and integrates
/// Firebase for authentication services.
class _LoginPageState extends State<LoginPage> {
  // Controllers to handle input from the email and password text fields.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Custom app bar for the login screen with specific styles.
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
              // Logo displayed at the top of the login screen.
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                  child: Image.asset('assets/images/Deck-Logo.png'),
                ),
              ),

              // Email input field.
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
                    const SizedBox(height: 10),
                    // BuildTextBox is a custom widget for the email text box.
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
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
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

              const SizedBox(height: 50),

              // Log In button. Triggers email/password authentication.
              BuildButton(
                onPressed: () async {
                  try {
                    // Authenticate using email and password.
                    await AuthService().signInWithEmail(
                        emailController.text, passwordController.text);

                    // After logging in, renew FCM token for notifications.
                    await FCMService().renewToken();

                    // Navigate to AuthGate (main application screen).
                    Navigator.of(context).push(
                      RouteGenerator.createRoute(const AuthGate()),
                    );
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
                      message = 'Too many failed attempts, try again later!';
                    } else {
                      message = 'Error logging in user!';
                    }

                    // Display error dialog to the user.
                    showInformationDialog(
                        context, message, "A problem occurred while signing in. Please try again.");
                  } catch (e) {
                    // Handle any other errors.
                    print(e.toString());
                    showInformationDialog(
                        context, "Error signing in.", "A problem occurred while signing in. Please try again.");
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

              // Google sign-in button. Uses Firebase Authentication with Google.
              BuildButton(
                onPressed: () async {
                  final authService = AuthService();
                  try {
                    // Sign in using Google.
                    final currentUser = await authService.signUpWithGoogle();

                    // Create a user object to save in Firestore.
                    final user = <String, dynamic>{
                      "email": currentUser?.email,
                      "name": currentUser?.displayName,
                      "uid": currentUser?.uid,
                      "cover_photo": "",
                      "fcm_token": await FCMService().getToken(),
                    };

                    final db = FirebaseFirestore.instance;

                    // Check if the user exists in Firestore; if not, create a new entry.
                    final snap = await db.collection("users").where('email', isEqualTo: currentUser?.email).get();
                    if (snap.docs.isEmpty) {
                      await db.collection("users").add(user);
                    } else {
                      // Renew FCM token if the user already exists.
                      await FCMService().renewToken();
                    }

                    // Navigate to AuthGate after successful login.
                    Navigator.of(context).push(
                      RouteGenerator.createRoute(const AuthGate()),
                    );
                  } catch (e) {
                    print(e.toString());
                    showInformationDialog(context, "Error signing in.", "A problem occurred while signing in. Please try again.");
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
                svg: 'assets/icons/google-icon.svg', // Google icon for the button.
                svgHeight: 24,
              ),

              // Sign-up link for users without an account.
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
                        // Navigate to the SignUpPage.
                        Navigator.of(context).pop(
                          RouteGenerator.createRoute(const SignUpPage()),
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      splashColor: DeckColors.primaryColor.withOpacity(0.5),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
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
        ),
      ),
    );
  }
}
