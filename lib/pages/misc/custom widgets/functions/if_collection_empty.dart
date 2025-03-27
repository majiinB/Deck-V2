import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';


class IfCollectionEmpty extends StatelessWidget {
  final String ifCollectionEmptyText;
  final String? ifCollectionEmptySubText;
  final double ifCollectionEmptyHeight;
  final bool hasIcon;

  const IfCollectionEmpty(
      {super.key,
        required this.ifCollectionEmptyText,
        this.hasIcon = true,
        this.ifCollectionEmptySubText,
        required this.ifCollectionEmptyHeight});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ifCollectionEmptyHeight,
      child: Center(
          child:
          // Container(
          //     height: MediaQuery.of(context).size.width,
          //     width: MediaQuery.of(context).size.width - 100, // dunno what size
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       color: Colors.pinkAccent
          //     ),
          //     child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if(hasIcon)SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  height: 130,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset(
                      // 'assets/images/HDR-Branding.png',
                      'assets/images/Deck-Logo7.png',
                    ),
                  )),
              Text(
                ifCollectionEmptyText,
                style: const TextStyle(
                  fontFamily: 'Fraiche',
                  fontSize: 30,
                  color: DeckColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  height: 1.1
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                ifCollectionEmptySubText ?? "",
                style: const TextStyle(
                  fontFamily: 'Nunito-Regular',
                  fontSize: 14,
                  color: DeckColors.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          )
        // )
      ),
    );
  }
}