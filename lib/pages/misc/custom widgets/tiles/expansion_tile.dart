import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';

class CustomExpansionTile extends StatefulWidget {
  const CustomExpansionTile({super.key});

  @override
  CustomExpansionTileState createState() => CustomExpansionTileState();
}

class CustomExpansionTileState extends State<CustomExpansionTile> {
  bool customIcon = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: ExpansionTile(
            title: Text(
              'Instructions ',
              style: GoogleFonts.nunito(
                color: DeckColors.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            trailing: Icon(customIcon
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded),
            onExpansionChanged: (bool expanded) {
              setState(() {
                customIcon = expanded;
              });
            },
            tilePadding: const EdgeInsets.all(10),
            backgroundColor: DeckColors.gray,
            collapsedBackgroundColor: DeckColors.gray,
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: DeckColors.gray),
            ),
            children: <Widget>[
              ListTile(
                title: Text(
                  '1. Use the "Enter Subject," and "Enter Topic" fields to assist AI in '
                      'generating a more specific and relevant set of flashcards.',
                  style: GoogleFonts.nunito(
                    color: DeckColors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  '2. Next, provide information in the "Enter Description" text field to '
                      'guide AI in generating content for your flashcards.',
                  style: GoogleFonts.nunito(
                    color: DeckColors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Enter Subject: Specify the subject Area (e.g. English)'
                      '\nEnter Topic: State the specific topic (e.g. Verb)'
                      '\nEnter Description: Provide details about what you want to cover (e.g. Focus on verbs, their types, and usage)',
                  style: GoogleFonts.nunito(
                    color: DeckColors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  '3. Optionally, if you want to upload a PDF instead; just upload your existing PDF and '
                      'it will prompt the application to automatically generate flashcards for you.',
                  style: GoogleFonts.nunito(
                    color: DeckColors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  '4.  Ensure that you specified the number (2-20) of flashcards you desire'
                      ' for the AI to generate.',
                  style: GoogleFonts.nunito(
                    color: DeckColors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Note: You have the ability to employ both features simultaneously. Also, the AI may generate less flashcards than what you have indicated due to lack of information. Moreover, rest assured that AI-generated flashcards content can be edited by the user.',
                  style: GoogleFonts.nunito(
                    color: DeckColors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
