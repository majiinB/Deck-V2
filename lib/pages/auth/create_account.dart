import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deck/backend/auth/auth_gate.dart';
import 'package:deck/backend/auth/auth_service.dart';
import 'package:deck/backend/fcm/fcm_service.dart';
import 'package:deck/backend/models/deck.dart';
import 'package:deck/pages/auth/privacy_policy.dart';
import 'package:deck/pages/auth/terms_of_use.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:google_fonts/google_fonts.dart';

import '../misc/custom widgets/buttons/custom_buttons.dart';
import '../misc/custom widgets/checkbox/checkbox.dart';
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
      // appBar: const AuthBar(
      //   automaticallyImplyLeading: true,
      //   title: 'create account',
      //   color: DeckColors.white,
      //   fontSize: 24,
      // ),
      body: _isLoading ?  const Center(
        child:CircularProgressIndicator()) :
    SingleChildScrollView(child: Column(
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
    Text('Create Account',
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
    fontFamily: 'Nunito-Black',
    fontSize: 16,
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
    padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Text(
    'Create New Password',
    style: TextStyle(
      fontFamily: 'Nunito-Black',
    fontSize: 16,
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
    padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Text(
    'Confirm New Password',
    style: TextStyle(
      fontFamily: 'Nunito-Black',
    fontSize: 16,
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
    padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
    child: Wrap(
    alignment: WrapAlignment.center,
    children: [
    SizedBox(
    width: 30,
    child: checkBox,
    ),
    const SizedBox(
    width: 10,
    ),
    const Text(
    "I accept Deck's",
    style: TextStyle(fontSize: 16.0, fontFamily: 'Nunito-Regular',),
    ),
    InkWell(
    onTap: () {
    Navigator.of(context).push(
    RouteGenerator.createRoute(const TermsOfUsePage()),
    );
    },
    borderRadius: BorderRadius.circular(8),
    splashColor: DeckColors.primaryColor.withOpacity(0.5),
    child: const Padding(
    padding: EdgeInsets.symmetric(
    vertical: 0, horizontal: 6), // Color of the InkWell
    child: Text(
    'Terms of Use',
    style: TextStyle(
      fontFamily: 'Nunito-Black',
    fontSize: 16,
    color: DeckColors.white,
    ),
    ),
    ),
    ),
    const Text(
    "and",
    style: TextStyle(fontSize: 16.0, fontFamily: 'Nunito-Regular',),
    ),
    InkWell(
    onTap: () {
    Navigator.of(context).push(
    RouteGenerator.createRoute(const PrivacyPolicyPage()),
    );
    },
    borderRadius: BorderRadius.circular(8),
    splashColor: DeckColors.primaryColor.withOpacity(0.5),
    child: const Padding(
    padding: EdgeInsets.symmetric(
    vertical: 0, horizontal: 6), // Color of the InkWell
    child: Text(
    'Privacy Policy',
    style: TextStyle(
      fontFamily: 'Nunito-Black',
    fontSize: 16,
    color: DeckColors.white,
    ),
    ),
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
    fontSize: 20,
    borderWidth: 0,
    borderColor: Colors.transparent,
    ),
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
      fontFamily: 'Nunito-Regular',
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
    ],
    )
    )
    );
  }
}
