import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deck/backend/auth/auth_gate.dart';
import 'package:deck/backend/fcm/fcm_service.dart';
import 'package:deck/pages/auth/create_account.dart';
import 'package:deck/pages/auth/login.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../backend/auth/auth_service.dart';

/// The SignUpPage widget allows users to sign up for the application.
/// It provides options to sign up using Google or email.
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    // Get the default color scheme from the current theme.
    final defaultColorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const AuthBar(
        automaticallyImplyLeading: false,
        title: 'Sign Up', // Title of the app bar.
        color: DeckColors.primaryColor, // Background color of the app bar.
        fontSize: 24, // Font size for the title.
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            children: [
              // Logo section with image asset.
              ClipRRect(
                borderRadius: BorderRadius.circular(10), // Round the corners of the image.
                child: Container(
                  height: 400, // Height of the logo container.
                  width: MediaQuery.of(context).size.width, // Width of the container.
                  color: Colors.transparent,
                  child: Image.asset('assets/images/Deck-Logo.png'), // Logo image.
                ),
              ),
              const SizedBox(height: 70), // Space between logo and button.

              // Button to sign up with Google.
              BuildButton(
                onPressed: () async {
                  final authService = AuthService(); // Instance of AuthService for authentication.

                  try {
                    // Attempt to sign up with Google.
                    final currentUser = await authService.signUpWithGoogle();

                    // Prepare user data for Firestore.
                    final user = <String, dynamic>{
                      "email": currentUser?.email,
                      "name": currentUser?.displayName,
                      "user_id": currentUser?.uid,
                      "cover_photo": "",
                      "fcm_token": await FCMService().getToken(), // Get FCM token for notifications.
                    };

                    final db = FirebaseFirestore.instance; // Instance of Firestore.
                    // Check if user already exists in Firestore.
                    final snap = await db.collection("users").where('email', isEqualTo: currentUser?.email).get();

                    if (snap.docs.isEmpty) {
                      // If the user does not exist, add them to Firestore.
                      await db.collection("users").add(user);
                    } else {
                      // If the user exists, renew FCM token.
                      await FCMService().renewToken();
                    }

                    // Navigate to AuthGate after successful sign-up.
                    Navigator.of(context).push(
                      RouteGenerator.createRoute(const AuthGate()),
                    );
                  } catch (e) {
                    // Print error to console for debugging.
                    print(e.toString());

                    // Display an error dialog to inform the user of the issue.
                    showInformationDialog(context, "Error signing up", "A problem occurred while signing up. Please try again.");
                  }
                },
                buttonText: 'Continue with Google', // Text displayed on the button.
                height: 60, // Button height.
                width: MediaQuery.of(context).size.width, // Button width.
                radius: 10, // Border radius for the button.
                backgroundColor: Colors.transparent, // Background color for the button.
                textColor: DeckColors.white, // Text color for the button.
                fontSize: 16, // Font size for the button text.
                borderWidth: 1, // Border width for the button.
                borderColor: Colors.white, // Border color for the button.
                svg: 'assets/icons/google-icon.svg', // SVG icon for Google sign-in.
                svgHeight: 24, // Height of the SVG icon.
              ),

              const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 2, // Thickness of the divider.
                        color: Colors.black, // Color of the divider.
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'or', // Text displayed between the dividers.
                        style: TextStyle(
                          fontSize: 16, // Font size for the text.
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 2, // Thickness of the divider.
                        color: Colors.black, // Color of the divider.
                      ),
                    ),
                  ],
                ),
              ),

              // Button to continue with email.
              BuildButton(
                onPressed: () {
                  // Navigate to CreateAccountPage when pressed.
                  Navigator.of(context).push(
                    RouteGenerator.createRoute(const CreateAccountPage()),
                  );
                },
                buttonText: 'Continue with Email', // Text displayed on the button.
                height: 60, // Button height.
                width: MediaQuery.of(context).size.width, // Button width.
                radius: 10, // Border radius for the button.
                backgroundColor: DeckColors.primaryColor, // Background color for the button.
                textColor: DeckColors.white, // Text color for the button.
                fontSize: 16, // Font size for the button text.
                borderWidth: 0, // Border width for the button.
                borderColor: Colors.transparent, // Border color for the button.
                icon: DeckIcons.account, // Icon displayed on the button.
                iconColor: DeckColors.white, // Icon color for the button.
                size: 24, // Size of the icon.
              ),

              // Row for the option to log in if the user already has an account.
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an Account? ', // Prompt text for existing users.
                      style: TextStyle(fontSize: 16.0), // Style for the text.
                    ),
                    InkWell(
                      onTap: () {
                        // Navigate to LoginPage when tapped.
                        Navigator.of(context).push(
                          RouteGenerator.createRoute(LoginPage()),
                        );
                      },
                      borderRadius: BorderRadius.circular(8), // Round the corners of the InkWell.
                      splashColor: DeckColors.primaryColor.withOpacity(0.5), // Color of the splash effect.
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6), // Padding for the text.
                        child: Text(
                          'Log In', // Text displayed for login prompt.
                          style: GoogleFonts.nunito(
                            fontSize: 16, // Font size for the text.
                            fontWeight: FontWeight.w900, // Font weight for the text.
                            color: DeckColors.white, // Text color for the login prompt.
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

