import 'package:deck/backend/auth/auth_service.dart';
import 'package:deck/backend/auth/auth_utils.dart';
import 'package:deck/pages/auth/privacy_policy.dart';
import 'package:deck/pages/auth/signup.dart';
import 'package:deck/pages/auth/terms_of_use.dart';
import 'package:deck/pages/misc/custom%20widgets/dialogs/alert_dialog.dart';
import 'package:deck/pages/settings/change_password.dart';
import 'package:deck/pages/settings/edit_profile.dart';
import 'package:deck/pages/settings/recently_deleted.dart';
import 'package:deck/pages/settings/settings.dart';
import 'package:deck/pages/settings/support%20and%20policies/report_a_problem.dart';
import 'package:deck/pages/settings/support%20and%20policies/suggest_improvement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../backend/flashcard/flashcard_service.dart';
import '../../backend/flashcard/flashcard_utils.dart';
import '../../backend/models/deck.dart';
import '../../backend/profile/profile_provider.dart';
import '../misc/custom widgets/buttons/custom_buttons.dart';
import '../misc/custom widgets/dialogs/confirmation_dialog.dart';
import '../misc/custom widgets/images/profile_image.dart';
import '../misc/custom widgets/tiles/settings_container.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  bool _isLoading = false;
  String name = '';
  final AuthService _authService = AuthService();
  final FlashcardService _flashcardService = FlashcardService();
  List<Deck> _decks = [];
  Map<String, int> _deckCardCount = {};
  late User? _user;
  late Image? coverUrl;

  @override
  void initState() {
    coverUrl = null;
    getCoverUrl();
    super.initState();
    FlashcardUtils.updateSettingsNeeded.addListener(_updateAccountPage);
    _user = _authService.getCurrentUser();
    _initUserDecks(_user);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false)
          .addListener(_updateAccountPage);
    });
  }

  @override
  void dispose() {
    FlashcardUtils.updateSettingsNeeded.removeListener(_updateAccountPage);
    super.dispose();
  }

  void getCoverUrl() async {
    coverUrl = await AuthUtils().getCoverPhotoUrl();
    setState(() {
      print(coverUrl);
    });
  }

  void _initUserDecks(User? user) async {
    if (user != null) {
      String userId = user.uid;
      List<Deck> decks = await _flashcardService
          .getDecksByUserId(userId); // Call method to fetch decks
      Map<String, int> deckCardCount = {};
      for (Deck deckCount in decks) {
        int count = await deckCount.getCardCount();
        deckCardCount[deckCount.deckId] = count;
      }
      setState(() {
        _decks = decks; // Update state with fetched decks
        _deckCardCount = deckCardCount; // Update state with fetched decks count
      });
    }
  }

  void _updateAccountPage() {
    if (FlashcardUtils.updateSettingsNeeded.value) {
      setState(() {
        _initUserDecks(_user);
      });
      FlashcardUtils.updateSettingsNeeded.value = false; // Reset the notifier
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: DeckColors.backgroundColor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 15, right: 15,bottom: 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /*Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.centerLeft,
                children: [
                  BuildCoverImage(
                    borderRadiusContainer: 0,
                    borderRadiusImage: 0,
                    coverPhotoFile: coverUrl,
                  ),
                  Positioned(
                    top: 200,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 0,
                      color: DeckColors.gray,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 16,
                    child: BuildIconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          RouteGenerator.createRoute(const SettingPage()),
                        );
                        _initUserDecks(_user);
                      },
                      icon: DeckIcons.settings,
                      iconColor: DeckColors.white,
                      backgroundColor: DeckColors.accentColor,
                      containerWidth: 40,
                      containerHeight: 40,
                    ),
                  ),
                  Positioned(
                    top: 150,
                    child: */
             Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: BuildProfileImage(AuthUtils().getPhoto(),
                          width: 170,
                          height: 170,),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              overflow: TextOverflow.visible,
                              maxLines: 2,
                              AuthUtils().getDisplayName() ?? "Guest",
                              style: const TextStyle(
                                fontFamily: 'Fraiche',
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: DeckColors.primaryColor,
                                height: 1,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              overflow: TextOverflow.visible,
                              maxLines: 2,
                              AuthUtils().getEmail() ?? "guest@guest.com",
                              style: const TextStyle(
                                fontFamily: 'Nunito-Bold',
                                fontSize: 16,
                                color: DeckColors.primaryColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12, right: 7.0),
                            child: BuildButton(
                              onPressed: () async {
                                final result = await Navigator.of(context).push(
                                  RouteGenerator.createRoute(const EditProfile()),
                                );
                                if (result != null && result['updated'] == true) {
                                  _updateAccountPage();
                                  Provider.of<ProfileProvider>(context, listen: false)
                                      .addListener(_updateAccountPage);
                                  setState(() {
                                    coverUrl = result['file'];
                                  });
                                }
                              },
                              buttonText: 'edit profile',
                              height: 40,
                              width: 140,
                              backgroundColor: DeckColors.primaryColor,
                              textColor: DeckColors.white,
                              radius: 20.0,
                              fontSize: 16,
                              borderWidth: 0,
                              borderColor: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 25.0),
                child: Divider(
                  height: 1,
                  color: DeckColors.primaryColor,
                ),
              ),
              /*Padding(
                  padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                  child: !AuthService()
                          .getCurrentUser()!
                          .providerData[0]
                          .providerId
                          .contains('google.com')
                      ? BuildSettingsContainer(
                          selectedIcon: DeckIcons.lock,
                          nameOfTheContainer: 'Change Password',
                          showArrow: true,
                          showSwitch: false,
                          containerColor:
                              DeckColors.accentColor, // Container Color
                          selectedColor:
                              DeckColors.primaryColor, // Left Icon Color
                          textColor: Colors.white, // Text Color
                          toggledColor: DeckColors
                              .accentColor, // Left Icon Color when Toggled
                          onTap: () {
                            Navigator.of(context).push(
                              RouteGenerator.createRoute(
                                  const ChangePasswordPage()),
                            );
                          },
                        )
                      : const SizedBox()),*/
              ///RECENTLY DELETED
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: BuildSettingsContainer(
                  selectedIcon: DeckIcons.trash_bin,
                  nameOfTheContainer: 'Recently Deleted Deck',
                  showArrow: true,
                  showSwitch: false,
                  containerColor: DeckColors.white, // Container Color
                  selectedColor: DeckColors.primaryColor, // Left Icon Color
                  textColor: DeckColors.primaryColor, // Text Color
                  toggledColor:
                      DeckColors.accentColor, // Left Icon Color when Toggled
                  onTap: () {
                    Navigator.of(context).push(
                      RouteGenerator.createRoute(const RecentlyDeletedPage()),
                    );
                  },
                ),
              ),
              ///----- E N D -----
              const Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Divider(
                  thickness: 1,
                  color: DeckColors.primaryColor,
                ),
              ),

              ///SUGGEST IMPROVEMENT
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: BuildSettingsContainer(
                  selectedIcon: Icons.self_improvement_rounded,
                  nameOfTheContainer: 'Suggest Improvement',
                  showArrow: true,
                  showSwitch: false,
                  containerColor: DeckColors.white, // Container Color
                  selectedColor: DeckColors.primaryColor, // Left Icon Color
                  textColor: DeckColors.primaryColor, // Text Color
                  toggledColor:
                  DeckColors.accentColor, // Left Icon Color when Toggled
                  onTap: () {
                    Navigator.of(context).push(
                      RouteGenerator.createRoute(const SuggestImprovement()),
                    );
                  },
                ),
              ),
              ///----- E N D -----

              ///REPORT A PROBLEM
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: BuildSettingsContainer(
                  selectedIcon: Icons.report_rounded,
                  nameOfTheContainer: 'Report a Problem',
                  showArrow: true,
                  showSwitch: false,
                  containerColor: DeckColors.white, // Container Color
                  selectedColor: DeckColors.primaryColor, // Left Icon Color
                  textColor: DeckColors.primaryColor, // Text Color
                  toggledColor:
                  DeckColors.accentColor, // Left Icon Color when Toggled
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReportAProblem(sourcePage: 'AccountPage'),
                      ),
                    );
                  },
                ),
              ),
              ///----- E N D -----

              ///TERMS OF USE
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: BuildSettingsContainer(
                  selectedIcon: Icons.note_alt_rounded,
                  nameOfTheContainer: 'Terms of Use',
                  showArrow: true,
                  showSwitch: false,
                  containerColor: DeckColors.white, // Container Color
                  selectedColor: DeckColors.primaryColor, // Left Icon Color
                  textColor: DeckColors.primaryColor, // Text Color
                  toggledColor:
                  DeckColors.accentColor, // Left Icon Color when Toggled
                  onTap: () {
                    Navigator.of(context).push(
                      RouteGenerator.createRoute(const TermsOfUsePage()),
                    );
                  },
                ),
              ),
              ///----- E N D -----

              ///PRIVACY POLICY
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: BuildSettingsContainer(
                  selectedIcon: Icons.privacy_tip_rounded,
                  nameOfTheContainer: 'Privacy Policy',
                  showArrow: true,
                  showSwitch: false,
                  containerColor: DeckColors.white, // Container Color
                  selectedColor: DeckColors.primaryColor, // Left Icon Color
                  textColor: DeckColors.primaryColor, // Text Color
                  toggledColor:
                  DeckColors.accentColor, // Left Icon Color when Toggled
                  onTap: () {
                    Navigator.of(context).push(
                      RouteGenerator.createRoute(const PrivacyPolicyPage()),
                    );
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Divider(
                  thickness: 1,
                  color: DeckColors.primaryColor,
                ),
              ),
              ///----- E N D -----

              ///LOG OUT
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: BuildSettingsContainer(
                  selectedIcon: DeckIcons.logout,
                  nameOfTheContainer: 'Log Out',
                  showArrow: false,
                  showSwitch: false,
                  containerColor: DeckColors.primaryColor, // Container Color
                  selectedColor: DeckColors.white, // Left Icon Color
                  iconColor: DeckColors.white,
                  textColor: DeckColors.white, // Text Color
                  toggledColor:
                      DeckColors.accentColor, // Left Icon Color when Toggled
                  onTap: () async {
                    showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return CustomConfirmDialog(
                          title: 'Logging Out?',
                          message: 'Are you sure you want to log out?',
                          imagePath: 'assets/images/Deck_Dialogue4.png',
                          button1: 'Log Out',
                          button2: 'Cancel',
                          onConfirm: () async {
                            //dialog is closed first, then execute the log out logic
                            Navigator.of(context).pop(); // Close the dialog

                            //Perform the log out logic after dialog is closed
                            setState(() => _isLoading = true);
                            await Future.delayed(const Duration(milliseconds: 300));
                            final authService = AuthService();
                            await authService.signOut();
                            GoogleSignIn _googleSignIn = GoogleSignIn();
                            if (await _googleSignIn.isSignedIn()) {
                              await _googleSignIn.signOut();
                            }

                            if (mounted) {
                              setState(() => _isLoading = false);

                              // Use the rootNavigator to ensure you navigate properly
                              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                                RouteGenerator.createRoute(const SignUpPage()),
                                    (Route<dynamic> route) => false,
                              );
                            }
                            print("Log Out Clicked");
                          },
                          onCancel: () {
                            Navigator.of(context).pop(false); // Close the dialog
                          },
                        );
                      },
                    );
                  },
                  /*onTap: () async {
                    setState(() => _isLoading = true);
                    await Future.delayed(const Duration(milliseconds: 300));
                    final authService = AuthService();
                    await authService.signOut();
                    GoogleSignIn _googleSignIn = GoogleSignIn();
                    if (await _googleSignIn.isSignedIn()) {
                      await _googleSignIn.signOut();
                    }
                    if (mounted) {
                      setState(() => _isLoading = false);
                      Navigator.of(context).pushAndRemoveUntil(
                        RouteGenerator.createRoute(const SignUpPage()),
                            (Route<dynamic> route) => false,
                      );
                    }
                    // Navigator.of(context).pop()
                    // Navigator.of(context).push(
                    //   RouteGenerator.createRoute(const SignUpPage()),
                    // );
                    // ignore: avoid_print
                    print("Log Out Clicked");
                  },*/
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Divider(
                  thickness: 1,
                  color: DeckColors.primaryColor,
                ),
              ),
              ///----- E N D -----

              ///DELETE ACCOUNT
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: BuildSettingsContainer(
                  selectedIcon: Icons.delete_forever_rounded,
                  nameOfTheContainer: 'Delete Account',
                  showArrow: false,
                  showSwitch: false,
                  containerColor: DeckColors.deckRed,
                  borderColor: DeckColors.deckRed,
                  selectedColor: DeckColors.white,
                  textColor: DeckColors.white, // Text Color
                  iconColor: DeckColors.white, //Color of the icon at the left
                  iconArrowColor: DeckColors.white, //Color of the arrow icon at the right
                  toggledColor: DeckColors.accentColor,
                  onTap: () {
                    // Show the first confirmation dialog
                    showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return CustomConfirmDialog(
                          title: 'Leaving already, wanderer?',
                          message: 'Deleting your account will remove all your decks, tasks, '
                              'and progress permanently. Deck will surely miss you… '
                              'Are you sure you want to go?',
                          imagePath: 'assets/images/Deck_Dialogue1.png',
                          button1: 'Delete Account',
                          button2: 'Cancel',
                          onConfirm: () async {
                            //dialog is closed first, then execute the delete acc logic
                            Navigator.of(context).pop();  //Close the first dialog

                            //Wait until the first dialog has been dismissed
                            await Future.delayed(Duration.zero);

                            //Show the second alert dialog
                            showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return CustomAlertDialog(
                                  imagePath: 'assets/images/Deck_Dialogue1.png',
                                  title: 'Goodbye, wanderer',
                                  message: 'Your account has been deleted. Thank you for '
                                      'being part of Deck. See you again someday!',
                                  button1: 'Ok',
                                  onConfirm: () {
                                    Navigator.of(context).pop(); // Close the second dialog
                                  },
                                );
                              },
                            );
                          },
                          onCancel: () {
                            Navigator.of(context).pop(false); // Close the first dialog on cancel
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              ///----- E N D -----
            ],
          ),
        ),
      ),
    );
  }
}
