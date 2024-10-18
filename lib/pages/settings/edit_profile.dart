import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deck/backend/auth/auth_service.dart';
import 'package:deck/backend/auth/auth_utils.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../backend/profile/profile_provider.dart';
import '../../backend/profile/profile_utils.dart';
import '../auth/signup.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  final TextEditingController firstNameController = TextEditingController(text: AuthUtils().getFirstName());
  final TextEditingController lastNameController = TextEditingController(text: AuthUtils().getLastName());
  final TextEditingController emailController = TextEditingController(text: AuthUtils().getEmail());

  XFile? pfpFile, coverFile;
  late Image? photoUrl, coverUrl;

  @override
  void initState() {
    super.initState();
    getUrls();
  }

  void getUrls() async {
    photoUrl = null;
    coverUrl = null;
    coverUrl = await AuthUtils().getCoverPhotoUrl();
    setState(() {
      photoUrl = AuthUtils().getPhoto();
      print(coverUrl);
    });
  }

  Future<void> updateAccountInformation(BuildContext context) async {
    User? user = AuthService().getCurrentUser();
    List<String>? userName = user?.displayName?.split(' ');
    String? lastName = userName?.removeLast();
    String newName = getNewName();
    String uniqueFileName = '${AuthService().getCurrentUser()?.uid}-${DateTime.now().millisecondsSinceEpoch}';
    String coverUrlString = coverUrl.toString();

    if(firstNameController.text.isEmpty || lastNameController.text.isEmpty || emailController.text.isEmpty){
      ///display error
      showInformationDialog(context, "Error changing information", "Please fill out all of the input fields and try again.");
      return;
    }

    if(newName != '$userName $lastName') await _updateDisplayName(user, newName);
    if(user?.email != emailController.text) {
      bool isEmailValid = await _updateEmail(user);
      if (!isEmailValid) {
        return;
      }
    }
    print('pfpFile: $pfpFile');
    print('photoUrl: $photoUrl');
    print('coverFile: $coverFile');
    print('coverUrl: $coverUrl');
    print('coverUrlString: $coverUrlString');
    await _updateProfilePhoto(user, uniqueFileName);
    await _updateCoverPhoto(user, uniqueFileName, context, coverUrlString);

    Provider.of<ProfileProvider>(context, listen: false).updateProfile();
    String message = 'Updated user information!';
    if(user?.email != emailController.text) {
      message = "Updated user information! Please check your new email in order to change.";
    }
    showInformationDialog(context, "Sucessfully updated information", message);

    if(user?.email != emailController.text) {
      AuthService().signOut();
      Navigator.of(context).pushAndRemoveUntil(
        RouteGenerator.createRoute(const SignUpPage()),
            (Route<dynamic> route) => false);
      return;
    }
    Navigator.pop(context, {'updated': true, 'file': coverUrl});
  }

  String getNewName() {
    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();
    return "$firstName $lastName";
  }

  Future<void> _updateDisplayName(User? user, String newName) async {
    if (user?.displayName != newName) {
      await user?.updateDisplayName(newName);
    }
  }

  Future<bool> _updateEmail(User? user) async {
    try {
      await user?.verifyBeforeUpdateEmail(emailController.text);
      final db = FirebaseFirestore.instance;
      var querySnapshot = await db.collection('users').where('email', isEqualTo: AuthUtils().getEmail()).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        String docId = doc.id;

        await db.collection('users').doc(docId).update({'email': emailController.text, 'user_id': user?.uid});
      }
      return true;
    } on FirebaseAuthException catch (e){
      String message = '';
      if(e.code == 'invalid-email'){
        message = 'Invalid email format! Plewase try again.';
      } else {
        message = e.toString();
      }
      print(e);
      showInformationDialog(context, "Error changing information", message);

      return false;
    } catch (e){
      print(e);
      showInformationDialog(context, "Error changing information", e.toString());

      return false;
    }

  }

  Future<void> _updateProfilePhoto(User? user, String uniqueFileName) async {
    if (photoUrl != null) {
      Reference refRoot = FirebaseStorage.instance.ref();
      Reference refDirPfpImg = refRoot.child('userProfiles/${user?.uid}');
      Reference refPfpUpload = refDirPfpImg.child(uniqueFileName);

      bool pfpExists = await ProfileUtils().doesFileExist(refPfpUpload);
      if (!pfpExists && pfpFile != null) {
        await refPfpUpload.putFile(File(pfpFile!.path));
        String newPhotoUrl = await refPfpUpload.getDownloadURL();
        await user?.updatePhotoURL(newPhotoUrl);
      }
    } else if (photoUrl == null) {
      await user!.updatePhotoURL(null);
    }
    await user?.reload();
    setState(() {});
  }

  Future<void> _updateCoverPhoto(User? user, String uniqueFileName, BuildContext context, String coverPhotoUrl) async {
    if (coverPhotoUrl != Image.asset('assets/images/Deck-Logo.png').toString()) {
      Reference refRoot = FirebaseStorage.instance.ref();
      Reference refDirCoverImg = refRoot.child('userCovers/${user?.uid}');
      Reference refCoverUpload = refDirCoverImg.child(uniqueFileName);

      bool coverExists = await ProfileUtils().doesFileExist(refCoverUpload);
      print(coverExists);
      if (!coverExists && coverFile != null) {
        await refCoverUpload.putFile(File(coverFile!.path));
        String photoCover = await refCoverUpload.getDownloadURL();
        print(photoCover);

        final db = FirebaseFirestore.instance;
        var querySnapshot = await db.collection('users').where('email', isEqualTo: AuthUtils().getEmail()).limit(1).get();
        if (querySnapshot.docs.isNotEmpty) {
          var doc = querySnapshot.docs.first;
          String docId = doc.id;
          print(docId);
          await db.collection('users').doc(docId).update({'cover_photo': photoCover});
        }
      }
    } else if (coverPhotoUrl == Image.asset('assets/images/Deck-Logo.png').toString()) {
      final db = FirebaseFirestore.instance;
      var querySnapshot = await db.collection('users').where('email', isEqualTo: AuthUtils().getEmail()).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        String docId = doc.id;

        await db.collection('users').doc(docId).update({'cover_photo': ''});
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DeckBar(
        title: 'Edit Account Information',
        color: DeckColors.white,
        fontSize: 24,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // BuildCoverImage(borderRadiusContainer: 0, borderRadiusImage: 0, coverPhotoFile: coverUrl,),
                // Positioned(
                //   top: 150,
                //   left: 10,
            Center(
            child: Padding(padding: const EdgeInsets.only(top: 50),
                  child: BuildProfileImage(photoUrl),
                  ),
            ),
                // ),
               /* Positioned(
                  top: 140,
                  right: 10,
                  child: BuildIconButton(
                    containerWidth: 40,
                    containerHeight: 40,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),
                            ),
                            child: Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              color: DeckColors.gray,
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: BuildContentOfBottomSheet(
                                    bottomSheetButtonText: 'Upload Cover Photo',
                                    bottomSheetButtonIcon: Icons.image,
                                    onPressed: () async {
                                      ImagePicker imagePicker = ImagePicker();
                                      XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
                                      if(file == null) return;
                                      setState(() {
                                        coverUrl = Image.file(File(file!.path));
                                        coverFile = file;
                                        print(coverUrl);
                                      });
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: BuildContentOfBottomSheet(
                                    bottomSheetButtonText: 'Remove Cover Photo',
                                    bottomSheetButtonIcon: Icons.remove_circle,
                                    onPressed: () {
                                      setState(() {
                                        coverUrl = Image.asset('assets/images/Deck-Logo.png');
                                        coverFile = null;
                                        print(coverUrl);
                                      });
                                    },
                                  ),
                                ),
                              ]),
                            ),
                          );
                        },
                      );
                    },
                    icon: DeckIcons.pencil,
                    iconColor: DeckColors.white,
                    backgroundColor: DeckColors.accentColor,
                  ),
                ),*/
                Positioned(
                  top: 160,
                  left: 110,
                  child: Padding(
                padding: const EdgeInsets.only(left: 100),
                child: BuildIconButton(
                  containerWidth: 40,
                  containerHeight: 40,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                          child: Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            color: DeckColors.gray,
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: BuildContentOfBottomSheet(
                                  bottomSheetButtonText: 'Upload Profile Photo',
                                  bottomSheetButtonIcon: Icons.image,
                                  onPressed: () async {
                                    ImagePicker imagePicker = ImagePicker();
                                    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
                                    if(file == null) return;
                                    setState(() {
                                      photoUrl = Image.file(File(file!.path));
                                      pfpFile = file;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: BuildContentOfBottomSheet(
                                  bottomSheetButtonText: 'Remove Profile Photo',
                                  bottomSheetButtonIcon: Icons.remove_circle,
                                  onPressed: () {
                                    setState(() {
                                      photoUrl = null;
                                      pfpFile = null;
                                      print(photoUrl);
                                    });
                                  },
                                ),
                              ),
                            ]),
                          ),
                        );
                      },
                    );
                  },
                  icon: DeckIcons.pencil,
                  iconColor: DeckColors.white,
                  backgroundColor: DeckColors.accentColor,
                  borderColor: DeckColors.backgroundColor,
                  borderWidth: 3.0,
                )),
                ),
            ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60, left: 15, right: 15),
              child: BuildTextBox(showPassword: false, hintText: "First Name", controller: firstNameController,),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
              child: BuildTextBox(showPassword: false, hintText: "Last Name", controller: lastNameController,),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
              child: !AuthService().getCurrentUser()!.providerData[0].providerId.contains('google.com') ?
                BuildTextBox(
                  showPassword: false,
                  hintText: "Email",
                  controller: emailController,
                ) :
                const SizedBox()
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
              child: BuildButton(
                onPressed: () {
                  print(
                      "save button clicked"); //line to test if working ung onPressedLogic XD
                  showConfirmationDialog(
                    context,
                    "Save Account Information",
                    "Are you sure you want to change your account information?",
                    () async {
                      try {
                        await updateAccountInformation(context);
                      } catch (e){
                        print(e);
                        showInformationDialog(context, "Error changing information", e.toString());
                      }
                    } ,
                    () {
                      //when user clicks no
                      //add logic here
                    },
                  );
                },
                buttonText: 'Save Changes',
                height: 50.0,
                width: MediaQuery.of(context).size.width,
                backgroundColor: DeckColors.primaryColor,
                textColor: DeckColors.white,
                radius: 10.0,
                fontSize: 16,
                borderWidth: 0,
                borderColor: Colors.transparent,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: BuildButton(
                onPressed: () {
                  print("cancel button clicked"); //line to test if working ung onPressedLogic XD
                  Navigator.pop(context);
                },
                buttonText: 'Cancel',
                height: 50.0,
                width: MediaQuery.of(context).size.width,
                backgroundColor: DeckColors.white,
                textColor: DeckColors.primaryColor,
                radius: 10.0,
                fontSize: 16,
                borderWidth: 0,
                borderColor: Colors.transparent,
              ),
            ),
        ],
        ),
      ),
    );
  }
}
