import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';


///
/// M E T H O D  T O  C A L L  L O A D I N G
///

void showLoad(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(
          color: DeckColors.primaryColor,
        ),
      );
    },
  );
}

///
/// M E T H O D  T O  H I D E  L O A D I N G
///

void hideLoad(BuildContext context) {
  Navigator.of(context).pop();
}
