import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deck/backend/auth/auth_gate.dart';
import 'package:deck/backend/auth/auth_service.dart';
import 'package:deck/backend/fcm/fcm_service.dart';
import 'package:deck/pages/auth/privacy_policy.dart';
import 'package:deck/pages/auth/terms_of_use.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  bool _isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final DeckBox checkBox = DeckBox();

  String getAdjective(){

    List<String> adjective = [
      'Long', 'Short', 'Thick', 'Thin', 'Curved', 'Straight', 'Hard', 'Soft', 'Smooth',
      'Rough', 'Firm', 'Stiff', 'Limp', 'Engorged', 'Swollen', 'Massive',
      'Turgid', 'Plump', 'Slender', 'Enlarged', 'Lengthy', 'Trim', 'Sturdy', 'Malleable',
      'Elastic', 'Pulsating', 'Robust', 'Lithe', 'Luscious', 'Muscular', 'Rigid', 'Tender', 'Prominent', 'Noticeable',
      'Substantial', 'Compact', 'Potent', 'Dominant', 'Stretched', 'Expansive', 'Defined', 'Well-endowed'
    ];

    return "${adjective[Random().nextInt(adjective.length)]}_${getRandomNumber()}";
  }

  int getRandomNumber(){
    return 10000 + Random().nextInt(99999 + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthBar(
        automaticallyImplyLeading: true,
        title: 'create account',
        color: DeckColors.white,
        fontSize: 24,
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
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
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create New Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BuildTextBox(
                      hintText: 'Enter New Password',
                      showPassword: true,
                      leftIcon: DeckIcons.lock,
                      controller: passwordController,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Confirm New Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BuildTextBox(
                      hintText: 'Confirm Password',
                      showPassword: true,
                      leftIcon: DeckIcons.lock,
                      controller: confirmPasswordController,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 20),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    SizedBox(
                      width: 30,
                      child: checkBox,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      "I accept Deck's",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          RouteGenerator.createRoute(const TermsOfUsePage()),
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      splashColor: DeckColors.primaryColor.withOpacity(0.5),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 6), // Color of the InkWell
                        child: Text(
                          'Terms of Use',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: DeckColors.white,
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "and",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          RouteGenerator.createRoute(const PrivacyPolicyPage()),
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      splashColor: DeckColors.primaryColor.withOpacity(0.5),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 6), // Color of the InkWell
                        child: Text(
                          'Privacy Policy',
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
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: BuildButton(
                  onPressed: () async {
                    setState(() => _isLoading = true);
                    if(!checkBox.isChecked){
                      ///display error
                      setState(() => _isLoading = false);
                      showInformationDialog(context, "Error Signing Up","You haven't agreed to the Terms of Use and Privacy Policy. Please try again");
                      return;
                    }

                    if(passwordController.text != confirmPasswordController.text) {
                      setState(() => _isLoading = false);
                      ///display error
                      showInformationDialog(context, "Error Signing Up","Passwords do not match! Please try again.");
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
                      showInformationDialog(context, "Error creating your account!",message);
                    } catch (e) {
                      print(e.toString());
                      setState(() => _isLoading = false);
                      showInformationDialog(context, "Error creating your account!", "Unknown Error! Please try again.");
                    }
                  },
                  buttonText: 'Join the Deck Party!',
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  radius: 10,
                  backgroundColor: DeckColors.primaryColor,
                  textColor: DeckColors.white,
                  fontSize: 16,
                  borderWidth: 0,
                  borderColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
