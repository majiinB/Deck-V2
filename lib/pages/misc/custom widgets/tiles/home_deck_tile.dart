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
/// ------------ D E C K  T I L E  I N  H O M E-----------------
class HomeDeckTile extends StatelessWidget {
  final String deckName;
  final Color deckColor;
  final double cardWidth;
  final String? deckImageUrl;
  final VoidCallback? onPressed;

  const HomeDeckTile({
    super.key,
    required this.deckName,
    required this.deckColor,
    required this.cardWidth,
    this.onPressed,
    this.deckImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: () {
          if (onPressed != null) {
            onPressed!();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: SizedBox(
              width: cardWidth,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: DeckColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: deckImageUrl != null
                          ? Image.network(
                        deckImageUrl!,
                        width: cardWidth,
                        height: double.infinity,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: DeckColors.white,
                            child: const Center(
                                child: Icon(Icons.broken_image,
                                    color: Colors.white)),
                          );
                        },
                      )
                          : Container(
                        color: DeckColors.white,
                        child: const Center(
                            child: Icon(Icons.image_not_supported,
                                color: Colors.white)),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: SizedBox(
                      width: cardWidth,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: DeckColors.accentColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        // decoration: BoxDecoration(
                        //   gradient: LinearGradient(
                        //     begin: Alignment.topCenter,
                        //     end: Alignment.bottomCenter,
                        //     colors: [
                        //       Colors.transparent,
                        //       Colors.black.withOpacity(0.9),
                        //     ],
                        //   ),
                        //   borderRadius: const BorderRadius.only(
                        //     bottomLeft: Radius.circular(10),
                        //     bottomRight: Radius.circular(10),
                        //   ),
                        // ),
                        child: Text(
                          deckName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Fraiche',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ------------------------- E N D ----------------------------
/// ------------ D E C K  T I L E  I N  H O M E-----------------
