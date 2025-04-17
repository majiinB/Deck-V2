import 'package:deck/pages/misc/colors.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../misc/custom widgets/functions/intro_page.dart';
import 'package:deck/pages/auth/welcome.dart';

import '../misc/widget_method.dart';
import 'create_account.dart';

class IntroductoryPage extends StatefulWidget{
  const IntroductoryPage({super.key});

  @override
  State<IntroductoryPage> createState() => _IntroductoryPageState();

}
class _IntroductoryPageState extends State<IntroductoryPage> {
  final PageController _controller = PageController();
  bool onLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DeckColors.softGreen,
      body: Stack(
        children: [
          PageView(
            onPageChanged: (index){
              setState((){
                onLastPage = (index == 3);
              });
            },
            controller: _controller,
            children: const [
              DeckIntroPage(
                img: 'assets/images/Deck-Introduction2.png',
                title: 'Stay on top of your\nto-dos.',
                subtitle: 'Easily create, organize, and track your tasks with our intuitive to-do list feature.',
              ),
              DeckIntroPage(
                img: 'assets/images/Deck-Introduction3.png',
                title: 'Learn and revise\nefficiently.',
                subtitle: 'Create flashcards manually or use our AI to generate them automatically from your notes.',
              ),
              DeckIntroPage(
                img: 'assets/images/Deck-Introduction4.png',
                title: 'Study. Quiz. Repeat.',
                subtitle: 'Strengthen your memory with our seamless study and quiz modes.',
              ),
              DeckIntroPage(
                img: 'assets/images/Deck-Introduction5.png',
                title: 'Get Started with Deck!',
                subtitle: 'Let\'s begin your journey to a more organized and productive life with Deck.',
                hasButton: true,
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                // height: 50,
                // width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap:onLastPage ?(){} : (){
                          _controller.animateToPage(
                            3,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.symmetric(vertical:20,horizontal: 30),
                            child: Text(
                                "Skip",
                                style: TextStyle(
                                  fontFamily: 'Nunito-Italic',
                                  fontSize: 15,
                                  color: onLastPage ? DeckColors.primaryColor : DeckColors.white,
                                )
                            )
                        )
                    ),
                    const Expanded(
                      child: SizedBox()
                    ),
                    SmoothPageIndicator(
                      controller: _controller,
                      count: 4,
                      effect: CustomizableEffect(
                        spacing: 10,
                        activeDotDecoration: DotDecoration(
                          width: 30,
                          height: 15,
                          color: DeckColors.white,
                          borderRadius: BorderRadius.circular(20),
                          dotBorder: const DotBorder(
                            width: 2,
                            color: DeckColors.white,
                          ),
                        ),
                        dotDecoration: DotDecoration(
                          width: 20,
                          height: 15,
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          dotBorder: const DotBorder(
                            width: 2,
                            color: DeckColors.white,
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                        child: SizedBox()
                    ),
                    GestureDetector(
                        onTap:(){
                          if (onLastPage) {
                              Navigator.of(context).push(
                                RouteGenerator.createRoute(const CreateAccountPage()),
                              );
                            }
                           else {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                        child:  Container(
                          color: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical:20, horizontal: 30),
                          child: Text(
                              "Next",
                              style: TextStyle(
                                fontFamily: 'Nunito-Regular',
                                fontSize: 15,
                                color: DeckColors.white,
                              )
                          ),
                        )
                    ),
                  ],
                )
            )
          )
        ],
      ),
    );
  }
}
