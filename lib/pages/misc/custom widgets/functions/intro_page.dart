import 'package:auto_size_text/auto_size_text.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';


class DeckIntroPage extends StatelessWidget {
  final String img;
  final String title;
  final String subtitle;

  const DeckIntroPage({
    super.key,
    required this.img,
    required this.title,
    required this.subtitle,
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
                  image: AssetImage('assets/images/Deck_Bottom_Image.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 40,right: 40,top: 150),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                        title,
                        style:const TextStyle(
                          height:1,
                          fontSize: 40,
                          fontFamily: 'Fraiche',
                          color: DeckColors.softGreen,
                        )
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AutoSizeText(
                        subtitle,
                        maxLines: 2,
                        style:const TextStyle(
                          height:1,
                          fontSize: 15,
                          fontFamily: 'Nunito-SemiBold',
                          color: DeckColors.white,
                        )
                    ),
                  ],
                ),
              ),
            )
        ),
      ],
    );
  }
}