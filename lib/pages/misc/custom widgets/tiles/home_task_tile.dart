import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';


///
/// ----------------------- S T A R T --------------------------
/// ------------ T A S K  T I L E  I N  H O M E-----------------

class HomeTaskTile extends StatelessWidget {
  final String taskName;
  final String deadline;
  // final double cardWidth;
  //final File? deckImage;
  final VoidCallback? onPressed;

  const HomeTaskTile({
    super.key,
    required this.taskName,
    required this.deadline,
    required this.onPressed,

    // required this.cardWidth,
    // required this.deckImage,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15.0),
      color: DeckColors.accentColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: () {
          if (onPressed != null) {
            onPressed!();
          }
        },
        child: Container(
          padding:
          const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Row(
            // Use Row to position the colored box and text side by side
            crossAxisAlignment:
            CrossAxisAlignment.start, // Aligns children vertically
            children: [
              Container(
                width: 10, // Set width for the colored box
                height: 60, // Set height for the colored box
                color: DeckColors.deckRed, // Set your desired color here
              ),
              const SizedBox(
                  width: 10), // Add some spacing between the box and text
              Expanded(
                // Use Expanded to fill available space
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start, // Aligns text to the left
                  children: [
                    Text(
                      taskName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'fraiche',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: DeckColors.white,
                      ),
                    ),
                    Text(
                      deadline,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Nunito-SemiBold',
                        fontSize: 14,
                        color: DeckColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ------------------------ E N D -----------------------------
/// ------------ T A S K  T I L E  I N  H O M E-----------------