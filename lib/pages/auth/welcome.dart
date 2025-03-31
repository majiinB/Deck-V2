import 'package:auto_size_text/auto_size_text.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:flutter/material.dart';
import 'package:deck/pages/misc/widget_method.dart';
import 'introductory.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? const Center(
        child:CircularProgressIndicator()) :
          Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.60,
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'assets/images/Deck_Introduction1.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/Deck_Bottom_Image.png'),
                          fit: BoxFit.cover,
                        ),
                    ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40,right: 40,top: 150),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                            "Welcome to Deck!",
                            style:TextStyle(
                              height:1,
                              fontSize: 35,
                              fontFamily: 'Fraiche',
                              color: DeckColors.softGreen,
                            )
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const AutoSizeText(
                            "Study Smarter,\nPlan Better",
                            maxLines: 2,
                            style:TextStyle(
                              height:1,
                              fontSize: 65,
                              fontFamily: 'Fraiche',
                              color: DeckColors.white,
                            )
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                            width: double.infinity,
                            child:TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  RouteGenerator.createRoute(const IntroductoryPage()),
                                );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: DeckColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Get Started",
                                    style: TextStyle(
                                      fontFamily: 'Nunito-SemiBold',
                                      fontSize: 15,
                                      color: DeckColors.primaryColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(Icons.arrow_forward,color: DeckColors.primaryColor),
                                ],
                              )
                            )
                        ),
                      ],
                    ),
                  ),
                )
              ),
            ],
          )
    );
  }
}
