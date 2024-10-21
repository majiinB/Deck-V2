import 'package:deck/backend/models/task.dart';
import 'package:deck/pages/flashcard/view_deck.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../backend/auth/auth_service.dart';
import '../../backend/flashcard/flashcard_service.dart';
import '../../backend/models/deck.dart';
import '../../backend/task/task_provider.dart';
import '../task/view_task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  final FlashcardService _flashcardService = FlashcardService();
  List<Deck> _decks = [];
  late User? _user;
  //Initial values for testing
  String greeting = "";

  DateTime today = DateTime.now();
  DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
  DateTime selectedDay = DateTime.now();
  // void goToPage(int pageIndex) {
  //   setState(() {
  //     index = pageIndex;
  //   });
  // }
  @override
  void initState() {
    super.initState();
    _user = _authService.getCurrentUser();
    _initUserDecks(_user);
    _initUserTasks(_user);
    _initGreeting();
  }

  void _initUserDecks(User? user) async {
    if (user != null) {
      String userId = user.uid;
      List<Deck> decks = await _flashcardService
          .getDecksByUserIdNewestFirst(userId); // Call method to fetch decks
      setState(() {
        _decks = decks; // Update state with fetched decks
      });
    }
  }

  void _initUserTasks(User? user) async {
    await Provider.of<TaskProvider>(context, listen: false).loadTasks();
  }

  void _initGreeting() {
    _user?.reload();
    String? firstName = _user?.displayName?.split(" ").first ?? 'User';
    setState(() {
      greeting = "Hi, $firstName!";
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final _tasks = provider.getList;
    List<Task> taskToday = _tasks
        .where((task) => isSameDay(task.deadline, selectedDay) && !task.isDone)
        .toList();

    return Scaffold(
      backgroundColor: DeckColors.backgroundColor,
      body: SafeArea(
          top: true,
          bottom: false,
          left: true,
          right: true,
          minimum: const EdgeInsets.only(left: 20, right: 20),
          child: CustomScrollView(
            slivers: <Widget>[
              DeckSliverHeader(
                backgroundColor: Colors.transparent,
                headerTitle: greeting,
                textStyle: const TextStyle(
                  color: DeckColors.primaryColor,
                  fontFamily: 'Fraiche',
                  fontSize: 48,
                ),
                isPinned: false,
                max: 100,
                min: 100,
                hasIcon: false,
              ),
              const DeckSliverHeader(
                backgroundColor: Colors.transparent,
                headerTitle: "Let's be productive today as well!",
                textStyle: TextStyle(
                  color: DeckColors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
                isPinned: false,
                max: 50,
                min: 50,
                hasIcon: false,
              ),
              if (taskToday.isEmpty)
                // SliverToBoxAdapter(
                //     child: IfCollectionEmpty(
                //         ifCollectionEmptyText: "No Task(s) Available Today",
                //         ifCollectionEmptyHeight:
                //             MediaQuery.of(context).size.height * 0.3))
                const DeckSliverHeader(
                  backgroundColor: Colors.transparent,
                  headerTitle: "Upcoming Deadlines",
                  textStyle: TextStyle(
                    color: DeckColors.primaryColor,
                    fontFamily: 'Fraiche',
                    fontSize: 24,
                  ),
                  isPinned: false,
                  max: 50,
                  min: 50,
                  hasIcon: false,
                )
              else if (taskToday.isNotEmpty)
                const DeckSliverHeader(
                  backgroundColor: Colors.transparent,
                  headerTitle: "Upcoming Deadlines",
                  textStyle: TextStyle(
                    color: DeckColors.primaryColor,
                    fontFamily: 'Fraiche',
                    fontSize: 24,
                  ),
                  isPinned: false,
                  max: 50,
                  min: 50,
                  hasIcon: false,
                ),
              SliverList(
                delegate: SliverChildBuilderDelegate(childCount: _tasks.length,
                    (context, index) {
                  DateTime deadline = DateTime(_tasks[index].deadline.year,
                      _tasks[index].deadline.month, _tasks[index].deadline.day);
                  DateTime notifyRange = DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day)
                      .add(const Duration(days: 1));
                  DateTime today = DateTime(DateTime.now().year,
                      DateTime.now().month, DateTime.now().day);
                  if (!_tasks[index].isDone &&
                      deadline.isBefore(notifyRange) &&
                      deadline.isAtSameMomentAs(today)) {
                    return LayoutBuilder(
                        builder: (context, BoxConstraints constraints) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: HomeTaskTile(
                          taskName: _tasks[index].title,
                          deadline:
                              _tasks[index].deadline.toString().split(" ")[0],
                          onPressed: () {
                            print('YOU TOUCHED THE TASK!');
                            Navigator.push(
                              context,
                              RouteGenerator.createRoute(ViewTaskPage(
                                  task: _tasks[index], isEditable: false)),
                            );
                          },
                        ),
                      );
                    });
                  } else {
                    return const SizedBox();
                  }
                }),
              ),
              if ((taskToday.isNotEmpty || _decks.isNotEmpty))
                const DeckSliverHeader(
                  backgroundColor: Colors.transparent,
                  headerTitle: "Continue Learning",
                  textStyle: TextStyle(
                    color: DeckColors.primaryColor,
                    fontFamily: 'Fraiche',
                    fontSize: 24,
                  ),
                  isPinned: false,
                  max: 50,
                  min: 50,
                  hasIcon: false,
                ),
              if (_decks.isEmpty && taskToday.isNotEmpty)
                SliverToBoxAdapter(
                    child: IfCollectionEmpty(
                        ifCollectionEmptyText: "No Deck(s) Available",
                        ifCollectionEmptyHeight:
                            MediaQuery.of(context).size.height * 0.5))
              else if (_decks.isNotEmpty)
                SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                        childCount: _decks.length, (context, index) {
                      return LayoutBuilder(
                          builder: (context, BoxConstraints constraints) {
                        double cardWidth = constraints.maxWidth;
                        return HomeDeckTile(
                          deckName: _decks[index].title.toString(),
                          deckImageUrl: _decks[index].coverPhoto.toString(),
                          deckColor: DeckColors.gray,
                          cardWidth: cardWidth - 8,
                          onPressed: () {
                            print('U TOUCHED MI DECK!');
                            Navigator.push(
                              context,
                              RouteGenerator.createRoute(
                                  ViewDeckPage(deck: _decks[index])),
                            );
                          },
                        );
                      });
                    }),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    )),
              const SliverPadding(padding: EdgeInsets.symmetric(vertical: 60))
            ],
          )),
    );
  }
}
