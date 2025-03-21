import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';

import '../../widget_method.dart';
import '../functions/swipe_to_delete_and_retrieve.dart';
/*import '../theme/theme_provider.dart';
import '../misc/custom widgets/buttons/custom_buttons.dart';*/

///
///
///BuidListOfDecks is a method for Container of Decks but only for design
class BuildListOfDecks extends StatefulWidget {
  final String? deckImageUrl;
  final String titleText, numberText;
  final VoidCallback onDelete;
  final VoidCallback? onRetrieve;
  final bool enableSwipeToRetrieve;

  const BuildListOfDecks({
    super.key,
    this.deckImageUrl,
    required this.titleText,
    required this.numberText,
    required this.onDelete,
    this.onRetrieve,
    this.enableSwipeToRetrieve = true,
  });

  @override
  State<BuildListOfDecks> createState() => BuildListOfDecksState();
}

class BuildListOfDecksState extends State<BuildListOfDecks> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: DeckColors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: widget.deckImageUrl != null ? null : DeckColors.white,
            height: 75,
            width: 75,
            child: widget.deckImageUrl != null
                ? Image.network(
              widget.deckImageUrl!,
              width: 20,
              height: 10,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: DeckColors.white,
                  child: const Center(
                      child:
                      Icon(Icons.broken_image, color: Colors.grey)),
                );
              },
            )
                : const Placeholder(
              color: DeckColors.white,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.titleText,
                    style: const TextStyle(
                      fontFamily: 'Fraiche',
                      fontSize: 24,
                      color: DeckColors.primaryColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 7.0),
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: DeckColors.primaryColor,
                      ),
                      child: Text(
                        widget.numberText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Nunito-Regular',
                          fontSize: 16,
                          color: DeckColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
