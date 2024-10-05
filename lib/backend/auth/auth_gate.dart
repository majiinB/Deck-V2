import 'package:deck/main.dart';
import 'package:deck/pages/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../pages/misc/widget_method.dart';

/// The AuthGate widget serves as the entry point for the authentication flow.
/// It listens to Firebase authentication state changes and updates the user
/// interface accordingly, either showing the MainPage or the SignUpPage.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  _AuthGateState createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // StreamBuilder listens to Firebase authentication state changes.
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              // If the connection is still waiting, show the loading spinner.
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(
                    width: 50.0, // Set the width of the loading indicator
                    height: 50.0, // Set the height of the loading indicator
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent), // Set the color of the progress indicator
                      strokeWidth: 8.0, // Adjust the thickness of the progress indicator
                    ),
                  ),
                );
              }

              // If authenticated (snapshot has data), navigate to MainPage.
              if (snapshot.hasData) {
                return MainPage(index: 0); // Display MainPage for authenticated users
              } else {
                // If not authenticated, show the SignUpPage.
                return const SignUpPage(); // Display SignUpPage for unauthenticated users
              }
            },
          ),
        ],
      ),
    );
  }
}
