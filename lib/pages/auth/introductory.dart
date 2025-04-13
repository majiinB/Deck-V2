import 'package:deck/pages/misc/colors.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../misc/custom widgets/functions/intro_page.dart';
import 'package:deck/pages/auth/welcome.dart';

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
                subtitle: 'Easily create, organize, and track your\ntasks with our intuitive to-do list feature.',
              ),
              DeckIntroPage(
                img: 'assets/images/Deck-Introduction3.png',
                title: 'Learn and revise\nefficiently.',
                subtitle: 'Create flashcards manually or use our AI\nto generate them automatically from\nyour notes.',
              ),
              DeckIntroPage(
                img: 'assets/images/Deck-Introduction4.png',
                title: '',
                subtitle: '',
              ),
              DeckIntroPage(
                img: 'assets/images/Deck-Introduction5.png',
                title: '',
                subtitle: '',
                hasButton: true,
              ),
            ],
          ),
          Container(
              alignment: const Alignment(0,0.75),
              child: Row(
                children: [
                  GestureDetector(
                      onTap:(){
                        _controller.jumpToPage(2);
                      },
                      child: const Text("")),
                  SmoothPageIndicator(controller: _controller, count: 4,),
                  onLastPage ?
                  SizedBox() :
                  GestureDetector(
                      onTap:(){},
                      child: const Text("Next",
                          style: TextStyle(
                            fontFamily: 'Nunito-Regular',
                            fontSize: 16,
                            color: DeckColors.white,
                          )
                      )
                  ),
                ],
              )
          )
        ],
      ),
    );
  }
}
