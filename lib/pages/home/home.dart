import 'package:deck/backend/models/task.dart';
import 'package:deck/pages/flashcard/view_deck.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons2.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../backend/auth/auth_service.dart';
import '../../backend/flashcard/flashcard_service.dart';
import '../../backend/models/deck.dart';
import '../../backend/task/task_provider.dart';
import '../misc/custom widgets/functions/if_collection_empty.dart';
import '../misc/custom widgets/tiles/custom_home_deck_tile.dart';
import '../misc/custom widgets/tiles/deck_task_tile.dart';
import '../task/view_task.dart';
import 'notification.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final AuthService _authService = AuthService();
  // final FlashcardService _flashcardService = FlashcardService();
  // List<Deck> _decks = [];
  // late User? _user;
  //Initial values
  String greeting = "";
  bool hasTakenARecentQuiz = true;
  bool hasUnreadNotif = true;

  String correct = "50";
  String total = "100";
  String score = "";
  bool isRecentQuizPassed = true;
  //
  // DateTime today = DateTime.now();
  // DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
  // DateTime selectedDay = DateTime.now();
  // // void goToPage(int pageIndex) {
  // //   setState(() {
  // //     index = pageIndex;
  // //   });
  // // }
  @override
  void initState() {
    super.initState();
    // _user = _authService.getCurrentUser();
    // _initUserDecks(_user);
    // _initUserTasks(_user);
    _initGreeting();
    _initScore();//temporary
  }
  //
  // void _initUserDecks(User? user) async {
  //   if (user != null) {
  //     String userId = user.uid;
  //     List<Deck> decks = await _flashcardService
  //         .getDecksByUserIdNewestFirst(userId); // Call method to fetch decks
  //     setState(() {
  //       _decks = decks; // Update state with fetched decks
  //     });
  //   }
  // }
  //
  // void _initUserTasks(User? user) async {
  //   await Provider.of<TaskProvider>(context, listen: false).loadTasks();
  // }
  //
  void _initGreeting() {
    String firstName = "Longusername";

    //   _user?.reload();
  //   String? firstName = _user?.displayName?.split(" ").first ?? 'User';
    setState(() {
      greeting = "Hello, $firstName!";
    });
  }
  void _initScore() {
    setState(() { //need ng logic here para madetermine ung scoe ng previous qui
      score = "$correct/$total";});
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<TaskProvider>(context);
    // final _tasks = provider.getList;
    // _tasks.sort((a, b) {
    //   // Define your priority order
    //   int getPriorityIndex(String priority) {
    //     switch (priority) {
    //       case 'High':
    //         return 0;
    //       case 'Medium':
    //         return 1;
    //       case 'Low':
    //         return 2;
    //       default:
    //         return 3; // Fallback if the priority is not recognized
    //     }
    //   }
    //
    //   // Compare priorities (High -> Low)
    //   return getPriorityIndex(a.priority).compareTo(getPriorityIndex(b.priority));
    // });
    //
    // List<Task> taskToday = _tasks
    //     .where((task) => isSameDay(task.deadline, selectedDay) && !task.isDone)
    //     .toList();
    return Scaffold(
      backgroundColor: DeckColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Stack(
              children: [
                Image.asset(
                  'assets/images/Deck-Home-Header.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    iconSize: 10,
                    icon: hasUnreadNotif ?
                      Icon( Icons.notifications, color: DeckColors.deckRed):
                      Icon( Icons.notifications, color: DeckColors.primaryColor),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationPage(),
                        )
                      );
                    },
                  ),
                ),
              ],
            ),

            //greeting section
            Text(
                greeting,
                style: const TextStyle(
                    fontFamily: 'Fraiche',
                    fontSize: 35,
                    color: DeckColors.primaryColor,
                    fontWeight: FontWeight.bold)
            ),
            const Text(
                'Let\'s be productive today as well!',
                style: TextStyle(
                  fontFamily: 'Nunito-SemiBold',
                  fontSize: 15,
                  color: DeckColors.primaryColor,
                )
            ),
            // ad and quiz tiles
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  hasTakenARecentQuiz
                      ? Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: DeckColors.white,
                      image: const DecorationImage(
                        image: AssetImage('assets/images/Deck-Background2.png'),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: DeckColors.deepGray,
                          blurRadius: 4,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "You had a score of",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height:1,
                            fontSize: 10,
                            fontFamily: 'Nunito-SemiBold',
                            color: DeckColors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          score,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height:1,
                            fontSize: 15,
                            fontFamily: 'Fraiche',
                            color: isRecentQuizPassed ? DeckColors.accentColor : DeckColors.deckRed ,
                          ),
                        ),

                        const SizedBox(height: 10),
                        const Text(
                          "on your previous quiz.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height:1,
                            fontSize: 10,
                            fontFamily: 'Nunito-SemiBold',
                            color: DeckColors.white,
                          ),
                        ),
                    ],
                  ),
                  ) :
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/images/Deck-Background1.png'),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: DeckColors.deepGray,
                          blurRadius: 4,
                          offset: Offset(1, 1),
                        ),
                      ],
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [DeckColors.accentColor, DeckColors.deepblue],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Text
                        const Text(
                          "Start Fresh: Create\nYour New Deck Now!",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            height:1,
                            fontSize: 15,
                            fontFamily: 'Fraiche',
                            color: DeckColors.white,
                          ),
                        ),
                        const SizedBox(height: 10), // Space between text and button

                        // Search for Decks Button
                        ElevatedButton(
                          onPressed: () {

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: DeckColors.white,
                            foregroundColor: DeckColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text("Create Deck",
                              style: TextStyle(
                                  fontFamily: 'Nunito-SemiBold',
                                  fontSize: 10,
                                  color: DeckColors.primaryColor,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  )
                  ,
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/images/Deck-Background1.png'),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: DeckColors.deepGray,
                          blurRadius: 4,
                          offset: Offset(1, 1),
                        ),
                      ],
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [DeckColors.deepgreen ,DeckColors.primaryColor, DeckColors.deepblue],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Text
                        const Text(
                          "Spark Your Interest\nwith Fun Quizzes!",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            height:1,
                            fontSize: 15,
                            fontFamily: 'Fraiche',
                            color: DeckColors.white,
                          ),
                        ),
                        const SizedBox(height: 10), // Space between text and button

                        // Search for Decks Button
                        ElevatedButton(
                          onPressed: () {

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: DeckColors.white,
                            foregroundColor: DeckColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text("Search for Decks",
                              style: TextStyle(
                                  fontFamily: 'Nunito-SemiBold',
                                  fontSize: 10,
                                  color: DeckColors.primaryColor,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  )
                ]
            ),
            SizedBox(height: 20),

            //upcoming deadline section
            SizedBox(height: 20),
            Text(
                'Upcoming Deadlines',
                style: TextStyle(
                    fontFamily: 'Fraiche',
                    fontSize: 30,
                    color: DeckColors.primaryColor,
                    fontWeight: FontWeight.bold)
            ),

            //recently accessed decks section
            SizedBox(height: 20),
            Text(
                'Continue Learning',
                style: TextStyle(
                    fontFamily: 'Fraiche',
                    fontSize: 30,
                    color: DeckColors.primaryColor,
                    fontWeight: FontWeight.bold)
            ),

            //Explore section
            SizedBox(height: 20),
            Text(
                'Explore',
                style: TextStyle(
                    fontFamily: 'Fraiche',
                    fontSize: 30,
                    color: DeckColors.primaryColor,
                    fontWeight: FontWeight.bold)
            ),
          ]
        ),
      )
      // SafeArea(
      //     top: true,
      //     bottom: false,
      //     left: true,
      //     right: true,
      //     minimum: const EdgeInsets.only(left: 20, right: 20),
      //     child:
      //
      //
      //     CustomScrollView(
      //       slivers: <Widget>[
      //         const SliverToBoxAdapter(
      //           child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Padding(
      //                   padding: EdgeInsets.only(top: 20.0),
      //                   child: Row(
      //                     children: [
      //                       Icon(
      //                        DeckIcons2.hat,
      //                         color: DeckColors.white,
      //                         size: 32,
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ]
      //           ),
      //         ),
      //         SliverToBoxAdapter(
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Text(
      //                   greeting,
      //                   style: const TextStyle(
      //                       fontFamily: 'Fraiche',
      //                       fontSize: 60,
      //                       color: DeckColors.primaryColor,
      //                       fontWeight: FontWeight.bold)
      //               ),
      //               const Text(
      //                   'Let\'s be productive today as well!',
      //                   style: TextStyle(
      //                       fontFamily: 'Nunito-Bold',
      //                       fontSize: 16,
      //                       color: DeckColors.white,
      //                       )
      //               ),
      //             ],
      //           ),
      //         ),
      //
      //         const SliverToBoxAdapter(
      //           child: SizedBox(height: 30,),
      //         ),
      //         // const DeckSliverHeader(
      //         //   backgroundColor: Colors.transparent,
      //         //   headerTitle: "Let's be productive today as well!",
      //         //   textStyle: TextStyle(
      //         //     color: DeckColors.white,
      //         //     fontWeight: FontWeight.w300,
      //         //     fontSize: 16,
      //         //   ),
      //         //   isPinned: false,
      //         //   max: 50,
      //         //   min: 50,
      //         //   hasIcon: false,
      //         // ),
      //         const SliverToBoxAdapter(
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Text(
      //                   'Upcoming Deadlines',
      //                   style: TextStyle(
      //                       fontFamily: 'Fraiche',
      //                       fontSize: 30,
      //                       color: DeckColors.primaryColor,
      //                       fontWeight: FontWeight.bold)
      //               ),
      //             ],
      //           ),
      //         ),
      //         const SliverToBoxAdapter(
      //           child: SizedBox(height: 30,),
      //         ),
      //         // const DeckSliverHeader(
      //         //   backgroundColor: Colors.transparent,
      //         //   headerTitle: "Upcoming Deadlines",
      //         //   textStyle: TextStyle(
      //         //     color: DeckColors.primaryColor,
      //         //     fontFamily: 'Fraiche',
      //         //     fontSize: 24,
      //         //   ),
      //         //   isPinned: false,
      //         //   max: 50,
      //         //   min: 50,
      //         //   hasIcon: false,
      //         // ),
      //
      //         if(taskToday.isEmpty)
      //           SliverToBoxAdapter(
      //             child: Container(
      //               padding: const EdgeInsets.all(30),
      //               decoration: const BoxDecoration(
      //                 color: DeckColors.white,
      //                   borderRadius: BorderRadius.all(Radius.circular(40)),
      //               ),
      //               child: IfCollectionEmpty(
      //                 hasIcon: false,
      //                 ifCollectionEmptyText: 'YIPEE! No upcoming deadlines! ',
      //                 ifCollectionEmptySubText:
      //                 'Now’s the perfect time to get ahead. Start adding new tasks and stay on top of your game!',
      //                 ifCollectionEmptyHeight: MediaQuery.of(context).size.height/5,
      //               ),
      //             )
      //           )
      //         else if (taskToday.isNotEmpty)
      //           SliverList(
      //           delegate: SliverChildBuilderDelegate(childCount: _tasks.length.clamp(0, 5),
      //               (context, index) {
      //             DateTime deadline = DateTime(_tasks[index].deadline.year,
      //                 _tasks[index].deadline.month, _tasks[index].deadline.day);
      //             DateTime notifyRange = DateTime(DateTime.now().year,
      //                     DateTime.now().month, DateTime.now().day)
      //                 .add(const Duration(days: 1));
      //             DateTime today = DateTime(DateTime.now().year,
      //                 DateTime.now().month, DateTime.now().day);
      //             if (!_tasks[index].isDone &&
      //                 deadline.isBefore(notifyRange) &&
      //                 deadline.isAtSameMomentAs(today)
      //                 ) {
      //               return
      //                 LayoutBuilder(
      //                   builder: (context, BoxConstraints constraints) {
      //                 return  DeckTaskTile(
      //                   title: _tasks[index].title,
      //                   deadline: TaskProvider.getNameDate(_tasks[index].deadline),
      //                   priority: _tasks[index].priority,
      //                   progressStatus: 'to do',
      //                   // title: tasks[index]['title'],
      //                   // deadline: _tasks[index].deadline.toString().split(" ")[0],
      //                   // priority: tasks[index]['priority'],
      //                   // progressStatus: tasks[index]['progressStatus'],
      //                   enableRetrieve: false,
      //                   onTap: () {
      //                     print("Clicked task tile!");
      //                     Navigator.push(
      //                       context,
      //                       RouteGenerator.createRoute(ViewTaskPage(task: _tasks[index], isEditable: false)),
      //                     );
      //                   }, onDelete: () {  },
      //                 );
      //               });
      //             } else {
      //               return const SizedBox();
      //             }
      //           }),
      //         ),
      //         const SliverToBoxAdapter(
      //           child: SizedBox(height: 30,),
      //         ),
      //         const SliverToBoxAdapter(
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Text(
      //                   'Continue Learning',
      //                   style: TextStyle(
      //                       fontFamily: 'Fraiche',
      //                       fontSize: 30,
      //                       color: DeckColors.primaryColor,
      //                       fontWeight: FontWeight.bold)
      //               ),
      //             ],
      //           ),
      //         ),
      //
      //         // const DeckSliverHeader(
      //         //   backgroundColor: Colors.transparent,
      //         //   headerTitle: "Continue Learning",
      //         //   textStyle: TextStyle(
      //         //     color: DeckColors.primaryColor,
      //         //     fontFamily: 'Fraiche',
      //         //     fontSize: 24,
      //         //   ),
      //         //   isPinned: false,
      //         //   max: 50,
      //         //   min: 50,
      //         //   hasIcon: false,
      //         // ),
      //         const SliverToBoxAdapter(
      //           child: SizedBox(height: 30,),
      //         ),
      //         if (_decks.isEmpty)
      //           SliverToBoxAdapter(
      //               child: Container(
      //                 padding: EdgeInsets.all(30),
      //                 decoration: const BoxDecoration(
      //                   color: DeckColors.white,
      //                   borderRadius: BorderRadius.all(Radius.circular(40)),
      //                 ),
      //                 child: IfCollectionEmpty(
      //                   hasIcon: false,
      //                   ifCollectionEmptyText: 'No Recent Decks Yet!',
      //                   ifCollectionEmptySubText:
      //                   'Now’s the perfect time to get ahead. Create your own Deck now to keep learning.',
      //                   ifCollectionEmptyHeight: MediaQuery.of(context).size.height/5,
      //                 ),
      //               )
      //           )
      //         else if (_decks.isNotEmpty)
      //           SliverGrid(
      //               delegate: SliverChildBuilderDelegate(
      //                   childCount: _decks.length, (context, index) {
      //                 return LayoutBuilder(
      //                     builder: (context, BoxConstraints constraints) {
      //                   double cardWidth = constraints.maxWidth;
      //                   return HomeDeckTile(
      //                     deckName: _decks[index].title.toString(),
      //                     deckImageUrl: _decks[index].coverPhoto.toString(),
      //                     deckColor: DeckColors.white,
      //                     cardWidth: cardWidth - 8,
      //                     onPressed: () {
      //                       print('frck tile clicked');
      //                       Navigator.push(
      //                         context,
      //                         RouteGenerator.createRoute(
      //                             ViewDeckPage(deck: _decks[index])),
      //                       );
      //                     },
      //                   );
      //                 });
      //               }),
      //               gridDelegate:
      //                   const SliverGridDelegateWithFixedCrossAxisCount(
      //                 crossAxisCount: 2,
      //                 mainAxisSpacing: 10,
      //                 crossAxisSpacing: 10,
      //               )),
      //       ],
      //     )),
    );
  }
}
