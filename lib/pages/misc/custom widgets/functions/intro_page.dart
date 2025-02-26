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
  final String text;

  const DeckIntroPage({
    super.key,
    required this.img,
    required this.text,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(img, fit: BoxFit.contain),
    );
  }
}