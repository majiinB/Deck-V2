
import 'package:deck/backend/auth/auth_service.dart';
import 'package:deck/backend/auth/auth_utils.dart';
import 'package:deck/pages/auth/signup.dart';
import 'package:deck/pages/settings/change_password.dart';
import 'package:deck/pages/settings/edit_profile.dart';
import 'package:deck/pages/settings/recently_deleted.dart';
import 'package:deck/pages/settings/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../backend/flashcard/flashcard_service.dart';
import '../../backend/flashcard/flashcard_utils.dart';
import '../../backend/models/deck.dart';
import '../../backend/profile/profile_provider.dart';

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
      Provider.of<ProfileProvider>(context, listen: false).addListener(_updateAccountPage);
    });
  }

  @override
  void dispose() {
    FlashcardUtils.updateSettingsNeeded.removeListener(_updateAccountPage);
    super.dispose();
  }

  void getCoverUrl() async {
    coverUrl = await AuthUtils().getCoverPhotoUrl();
  }

  void _initUserDecks(User? user) async {
    if (user != null) {
      String userId = user.uid;
      List<Deck> decks = await _flashcardService.getDecksByUserId(userId); // Call method to fetch decks
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
        body: SingleChildScrollView(
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
                      padding: const EdgeInsets.only(top: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child:
                              BuildProfileImage(AuthUtils().getPhoto()),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 8.0),
                            child: Text(
                              AuthUtils().getDisplayName() ?? "Guest",
                              style: const TextStyle(
                                fontFamily: 'Fraiche',
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: DeckColors.primaryColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              AuthUtils().getEmail() ?? "guest@guest.com",
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                color: DeckColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, right: 7.0),
                    child: Center(
                      child: BuildButton(
                        onPressed: () async {
                          final result = await Navigator.of(context).push(
                            RouteGenerator.createRoute(const EditProfile()),
                          );
                          if(result != null && result['updated'] == true) {
                            _updateAccountPage();
                           Provider.of<ProfileProvider>(context, listen: false).addListener(_updateAccountPage);
                          }
                        },
                        buttonText: 'edit profile',
                        height: 40,
                        width: 140,
                        backgroundColor: DeckColors.white,
                        textColor: DeckColors.backgroundColor,
                        radius: 20.0,
                        fontSize: 16,
                        borderWidth: 0,
                        borderColor: Colors.transparent,
                      ),
                    ),
                  ),
              Padding(
                  padding: const EdgeInsets.only(top:50, left: 15, right: 15),
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
                      : const SizedBox()),
              Padding(
                padding: const EdgeInsets.only(top:8, left: 15, right: 15),
                child: BuildSettingsContainer(
                  selectedIcon: DeckIcons.trash_bin,
                  nameOfTheContainer: 'Recently Deleted',
                  showArrow: true,
                  showSwitch: false,
                  containerColor: DeckColors.accentColor, // Container Color
                  selectedColor: DeckColors.primaryColor, // Left Icon Color
                  textColor: Colors.white, // Text Color
                  toggledColor:
                  DeckColors.accentColor, // Left Icon Color when Toggled
                  onTap: () {
                    Navigator.of(context).push(
                      RouteGenerator.createRoute(const RecentlyDeletedPage()),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:8, left: 15, right: 15),
                child: BuildSettingsContainer(
                  selectedIcon: DeckIcons.logout,
                  nameOfTheContainer: 'Log Out',
                  showArrow: false,
                  showSwitch: false,
                  containerColor: DeckColors.accentColor, // Container Color
                  selectedColor: DeckColors.primaryColor, // Left Icon Color
                  textColor: Colors.white, // Text Color
                  toggledColor:
                  DeckColors.accentColor, // Left Icon Color when Toggled
                  onTap: () async {
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
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
