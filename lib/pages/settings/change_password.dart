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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DeckColors.backgroundColor,
      appBar: const AuthBar(
        automaticallyImplyLeading: true,
        title: 'Change Password',
        color: DeckColors.primaryColor,
        fontSize: 24,
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter a new password below to change your password.',
              style: TextStyle(
                fontFamily: 'Nunito-Bold',
                fontSize: 16,
                color: DeckColors.primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 30.0),
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
                    padding: const EdgeInsets.only(top: 10),
                    child: BuildTextBox(
                      hintText: 'Enter Old Password',
                      showPassword: true,
                      controller: oldPasswordController,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0),
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
                    padding: const EdgeInsets.only(top: 10),
                    child: BuildTextBox(
                      hintText: 'Enter New Password',
                      showPassword: true,
                      controller: newPasswordController,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0),
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
                    padding: const EdgeInsets.only(top: 10),
                    child: BuildTextBox(
                      hintText: 'Confirm New Password',
                      showPassword: true,
                      controller: newConfirmPasswordController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Container(
                      width: double.infinity,
                      height: 1,
                      color: DeckColors.primaryColor,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
