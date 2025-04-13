import 'package:deck/main.dart';
import 'package:deck/pages/auth/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return const MainPage();
          } else {
            return const WelcomePage();
          }
        },
      ),
    );
  }
}
