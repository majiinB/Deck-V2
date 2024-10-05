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

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const AuthBar(
        automaticallyImplyLeading: false,
        title: 'sign up',
        color: DeckColors.primaryColor,
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
                    height: 400,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    child: Image.asset('assets/images/Deck-Logo.png')),
              ),
              const SizedBox(
                height: 30,
              ),
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

                      Navigator.of(context).push(
                        RouteGenerator.createRoute(const AuthGate()),
                      );

                    } catch (e){
                      print(e.toString());


                      ///display error
                      showInformationDialog(context, "Error signing up", "A problem occured while signing up. Please try again.");

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
                onPressed: () {
                  Navigator.of(context).push(
                    RouteGenerator.createRoute(const CreateAccountPage()),
                  );

                },
                buttonText: 'Continue with Email',
                height: 60,
                width: MediaQuery.of(context).size.width,
                radius: 10,
                backgroundColor: DeckColors.primaryColor,
                textColor: DeckColors.white,
                fontSize: 16,
                borderWidth: 0,
                borderColor: Colors.transparent,
                icon: DeckIcons.account,
                iconColor: DeckColors.white,
                size: 24,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an Account? ',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          RouteGenerator.createRoute(LoginPage()),
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      splashColor: DeckColors.primaryColor.withOpacity(0.5),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 6), // Color of the InkWell
                        child: Text(
                          'Log In',
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
