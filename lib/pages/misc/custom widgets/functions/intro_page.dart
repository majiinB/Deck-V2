import 'package:auto_size_text/auto_size_text.dart';
import 'package:deck/pages/auth/login.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:flutter/material.dart';
import '../../../auth/create_account.dart';
import '../../widget_method.dart';

class DeckIntroPage extends StatelessWidget {
  final String img;
  final String title;
  final String subtitle;
  final bool hasButton;

  const DeckIntroPage({
    super.key,
    required this.img,
    required this.title,
    required this.subtitle,
    this.hasButton = false,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.60,
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              img,
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
                  image: AssetImage('assets/images/Deck-Bottom-Image2.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 40,right: 40,top: 130),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AutoSizeText(
                        title,
                        maxLines: hasButton ? 1 : 2,
                        style: const TextStyle(
                          height:1,
                          fontSize: 35,
                          fontFamily: 'Fraiche',
                          color: DeckColors.softGreen,
                        )
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AutoSizeText(
                        subtitle,
                        maxLines: hasButton ? 2 : 3,
                        minFontSize: 10,
                        style: TextStyle(
                          // height:1,
                          fontSize: hasButton ? 15 : 20,
                          fontFamily: 'Nunito-SemiBold',
                          color: DeckColors.white,
                        )
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if(hasButton)SizedBox(
                        width: double.infinity,
                        child:TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                RouteGenerator.createRoute(const CreateAccountPage()),
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: DeckColors.softGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Create New Account",
                                  style: TextStyle(
                                    fontFamily: 'Nunito-Bold',
                                    fontSize: 15,
                                    color: DeckColors.primaryColor,
                                  ),
                                ),
                              ],
                            )
                        )
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    if(hasButton)Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        const Text(
                            "Have an account?",
                            maxLines: 1,
                            style:TextStyle(
                              height:1,
                              fontSize: 15,
                              fontFamily: 'Nunito-Regular',
                              color: DeckColors.white,
                            )
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                            onPressed: () {
                              Navigator.of(context).push(
                                RouteGenerator.createRoute(const LoginPage()),
                              );
                            },
                            child:const Text(
                              "Log In",
                              style: TextStyle(
                                fontFamily: 'Nunito-Bold',
                                fontSize: 15,
                                color: DeckColors.softGreen,
                              ),
                            ),
                        )
                      ]
                    )
                  ],
                ),
              ),
            )
        ),
      ],
    );
  }
}