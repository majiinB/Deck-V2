import 'package:deck/backend/auth/auth_service.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

import '../misc/custom widgets/appbar/auth_bar.dart';
import '../misc/custom widgets/buttons/custom_buttons.dart';
import '../misc/custom widgets/dialogs/confirmation_dialog.dart';
import '../misc/custom widgets/textboxes/textboxes.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => ChangePasswordPageState();
}

class ChangePasswordPageState extends State<ChangePasswordPage> {
  bool _isLoading = false;
  final newPasswordController = TextEditingController();
  final newConfirmPasswordController = TextEditingController();
  final oldPasswordController = TextEditingController();

  ///This tracks if there are unsaved changes
  bool _hasUnsavedChanges() {
    return newPasswordController.text.isNotEmpty ||
        newConfirmPasswordController.text.isNotEmpty ||
        oldPasswordController.text.isNotEmpty;
  }

  ///This disposes controllers to free resources and prevent memory leaks
  @override
  void dispose() {
    newPasswordController.dispose();
    newConfirmPasswordController.dispose();
    oldPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }

        //Check for unsaved changes
        if (_hasUnsavedChanges()) {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return ShowConfirmationDialog(
                title: 'Are you sure you want to go back?',
                text: 'If you go back now, you will lose all your progress',
                onConfirm: () {
                  Navigator.of(context).pop(); //Return true to allow pop
                },
                onCancel: () {
                  //Return false to prevent pop
                },
              );
            },
          );

          //If the user confirmed, pop the current route
          if (shouldPop == true) {
            Navigator.of(context).pop(true);
          }
        } else {
          //No unsaved changes, allow pop without confirmation
          Navigator.of(context).pop(true);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: DeckColors.backgroundColor,
        appBar: const AuthBar(
          automaticallyImplyLeading: true,
          title: 'Change Password',
          color: DeckColors.primaryColor,
          fontSize: 24,
        ),
        ///wrap whole content with column and expanded so image can always stay at the bottom
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Text(
                            'Enter a new password below to change your password.',
                            style: TextStyle(
                              fontFamily: 'Nunito-Bold',
                              fontSize: 16,
                              color: DeckColors.primaryColor,
                            ),
                          ),
                        ),
                        const Padding(
                                padding: EdgeInsets.only(top: 60.0, left: 15, right: 15),
                                child: Text(
                                  'Old Password',
                                  style: TextStyle(
                                    fontFamily: 'Nunito-ExtraBold',
                                    color: DeckColors.primaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                                child: BuildTextBox(
                                  hintText: 'Enter Old Password',
                                  showPassword: true,
                                  controller: oldPasswordController,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 20.0, left: 15, right: 15),
                                child: Text(
                                  'New Password',
                                  style: TextStyle(
                                    fontFamily: 'Nunito-ExtraBold',
                                    color: DeckColors.primaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                                child: BuildTextBox(
                                  hintText: 'Enter New Password',
                                  showPassword: true,
                                  controller: newPasswordController,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 20.0, left: 15, right: 15),
                                child: Text(
                                  'Confirm New Password',
                                  style: TextStyle(
                                    fontFamily: 'Nunito-ExtraBold',
                                    color: DeckColors.primaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                                child: BuildTextBox(
                                  hintText: 'Confirm New Password',
                                  showPassword: true,
                                  controller: newConfirmPasswordController,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 30.0, left: 15, right: 15),
                                child: Divider(
                                  thickness: 1,
                                  color: DeckColors.primaryColor,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 40, left: 15, right: 15),
                                child: BuildButton(
                                  onPressed: () {
                                    // ignore: avoid_print
                                    print(
                                        "save button clicked"); //line to test if working ung onPressedLogic XD
                                    showConfirmationDialog(
                                      context,
                                      "Change Password",
                                      "Are you sure you want to change password?",
                                      () async {
                                        //when user clicks yes
                                        //add logic here
                                        setState(() => _isLoading = true);
                                        try{
                                          User? user = FirebaseAuth.instance.currentUser;
                                          String? email = user?.email;
                                          if(email == null){ return; }
                                          AuthCredential credential = EmailAuthProvider.credential(
                                            email: email,
                                            password: oldPasswordController.text,
                                          );
                                          await user?.reauthenticateWithCredential(credential);

                                          if(newPasswordController.text != newConfirmPasswordController.text){
                                            ///display error
                                            showInformationDialog(context, "Error changing password", "Passwords mismatch. Please try again.");
                                            return;
                                          } else if(newPasswordController.text == oldPasswordController.text || oldPasswordController.text == newConfirmPasswordController.text){
                                            ///display error
                                            showInformationDialog(context, "Error changing password", "You cannot set the same password as your new password. Please try again.");
                                            return;
                                          }
                                          AuthService().resetPass(newPasswordController.text);
                                          setState(() => _isLoading = false);
                                          ///display error
                                          showInformationDialog(context, "Success","You have successfully changed your password.");

                                          Navigator.pop(context);
                                        } on FirebaseAuthException catch (e){
                                          String message = '';
                                          if(e.code == 'user-mismatch'){
                                            message = "User credential mismatch! Please try again.";
                                          } else if (e.code == 'user-not-found'){
                                            message = 'User not found! Please try again.';
                                          } else if (e.code == 'invalid-credential') {
                                            message = 'Invalid credential! Please try again.';
                                          } else if (e.code == 'invalid-email'){
                                            message = 'Invalid email! Please try again.';
                                          } else if (e.code == 'wrong-password'){
                                            message = 'Wrong password! Please try again.';
                                          } else if (e.code == 'weak-password'){
                                            message = 'Password must be atleast 6 characters! Please try again.';
                                          } else {
                                            message = 'Error changing your password! Please try again.';
                                          }
                                          print(e.toString());
                                          setState(() => _isLoading = false);
                                          ///display error
                                          showInformationDialog(context, "Error changing password", message);

                                        } catch (e) {
                                          print(e.toString());
                                          setState(() => _isLoading = false);
                                          ///display error
                                          showInformationDialog(context, "Error changing password", "An Unknown error occured during the process. Please try again.");
                                        }
                                      },
                                      () {
                                        //when user clicks no
                                        //nothing happens
                                      },
                                    );
                                  },
                                  buttonText: 'Change Password',
                                  height: 50.0,
                                  width: MediaQuery.of(context).size.width,
                                  backgroundColor: DeckColors.primaryColor,
                                  textColor: DeckColors.white,
                                  radius: 10.0,
                                  borderColor: DeckColors.primaryColor,
                                  fontSize: 16,
                                  borderWidth: 0,
                                ),
                              ),
                      ],
                    ),
                  ),
            ),
            Image.asset(
              'assets/images/Deck-Bottom-Image.png',
              fit: BoxFit.fitWidth,
              width: MediaQuery.of(context).size.width,
            ),
          ],
        ),


                        /*Padding(
                          padding:
                              const EdgeInsets.only(top: 15, left: 20, right: 20),
                          child: BuildButton(
                            onPressed: () {
                              // ignore: avoid_print
                              print(
                                  "cancel button clicked"); //line to test if working ung onPressedLogic XD
                              Navigator.pop(context);
                            },
                            buttonText: 'Cancel',
                            height: 50.0,
                            width: MediaQuery.of(context).size.width,
                            backgroundColor: DeckColors.white,
                            textColor: DeckColors.primaryColor,
                            radius: 10.0,
                            borderColor: DeckColors.white,
                            fontSize: 16,
                            borderWidth: 0,
                          ),
                        ),*/
      ),
    );
  }
}
