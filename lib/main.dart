import 'package:deck/backend/auth/auth_gate.dart';
import 'package:deck/backend/fcm/notifications_service.dart';
import 'package:deck/backend/models/task.dart';
import 'package:deck/backend/profile/profile_provider.dart';
import 'package:deck/pages/flashcard/flashcard.dart';
import 'package:deck/pages/home/home.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:deck/pages/settings/account.dart';
import 'package:deck/pages/task/main_task.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import 'backend/fcm/fcm_service.dart';
import 'backend/task/task_provider.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FCMService().initializeNotifications();
  NotificationService().initLocalNotifications();
  FlutterNativeSplash.remove();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => TaskProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _myAppState createState() => _myAppState();
}

class _myAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    listenNotifications();
  }

  void listenNotifications() =>
      NotificationService().onNotifications.listen(onClickedNotification);
  void onClickedNotification(String? payload) {}

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Deck',
      // theme: Provider.of<ThemeProvider>(context).themeData,
      // navigatorKey: navigatorKey,
      // theme: darkMode,
      home: const AuthGate(),
    );
  }
}

/// Main Page
// ignore: must_be_immutable
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  int _currentIndex = 0;

  final screens = const [
    HomePage(),
    TaskPage(),
    FlashcardPage(),
    AccountPage(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Provider.of<TaskProvider>(context, listen: false)
          .checkIfDeadlineIsToday()) {
        NotificationService().showNotification(
            title: 'You have due tasks today!',
            body: 'Finish them!',
            payload: 'load');
      }
    });
  }

  ///  Navbar Icons and Label
  final items = const [
    CurvedNavigationBarItem(
      child: Icon(
        DeckIcons.home,
        color: DeckColors.primaryColor,
      ),
      label: 'Home',
      labelStyle: TextStyle(
        color: DeckColors.primaryColor,
        fontSize: 10,
        fontFamily: 'Fraiche',
      ),
    ),
    CurvedNavigationBarItem(
      child: Icon(
        DeckIcons.task,
        color: DeckColors.primaryColor,
      ),
      label: 'Tasks',
      labelStyle: TextStyle(
        color: DeckColors.primaryColor,
        fontSize: 10,
        fontFamily: 'Fraiche',
      ),
    ),
    CurvedNavigationBarItem(
      child: Center(
        child: Icon(
          DeckIcons.flashcard,
          color: DeckColors.primaryColor,
        ),
      ),
      label: 'Flashcards',
      labelStyle: TextStyle(
        color: DeckColors.primaryColor,
        fontSize: 10,
        fontFamily: 'Fraiche',
      ),
    ),
    CurvedNavigationBarItem(
      child: Icon(
        DeckIcons.account,
        color: DeckColors.primaryColor,
      ),
      label: 'Account',
      labelStyle: TextStyle(
        color: DeckColors.primaryColor,
        fontSize: 10,
        fontFamily: 'Fraiche',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        extendBody: true,
        appBar: null,
        body: screens[_currentIndex],
        bottomNavigationBar: curvedNavigationBar(),
      ),
    );
  }

  CurvedNavigationBar curvedNavigationBar() {
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      backgroundColor: Colors.transparent,
      buttonBackgroundColor: DeckColors.softGreen,
      color: DeckColors.softGreen,
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: Curves.easeInOut,
      height: 80,
      index: _currentIndex,
      items: items,
      onTap: (index) => setState(() => _currentIndex = index),
    );
  }
}
