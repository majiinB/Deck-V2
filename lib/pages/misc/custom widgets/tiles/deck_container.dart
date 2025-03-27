import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';

import '../../widget_method.dart';
import '../functions/swipe_to_delete_and_retrieve.dart';
import '../menus/pop_up_menu.dart';

/// THIS METHOD IS FOR THE DECKS CONTAINER IN THE FLASHCARD PAGE
class BuildDeckContainer extends StatefulWidget {
  final String? deckCoverPhotoUrl;
  final String titleOfDeck;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final VoidCallback? onRetrieve;
  final bool enableSwipeToRetrieve;
  final int numberOfCards;
  final ValueChanged<int>? onItemsSelected;
  final List<String>? items;
  final List<IconData>? icons;

  const BuildDeckContainer({
    super.key,
    required this.onDelete,
    this.onRetrieve,
    this.enableSwipeToRetrieve = true,
    this.deckCoverPhotoUrl,
    required this.titleOfDeck,
    required this.onTap,
    required this.numberOfCards,
    this.onItemsSelected,
    this.items,
    this.icons,
  });

  @override
  State<BuildDeckContainer> createState() => BuildDeckContainerState();
}

class BuildDeckContainerState extends State<BuildDeckContainer> {
  Color _containerColor = DeckColors.white;
  final String defaultImageUrl =
      "https://firebasestorage.googleapis.com/v0/b/deck-f429c.appspot.com/o/deckCovers%2Fdefault%2FdeckDefault.png?alt=media&token=2b0faebd-9691-4c37-8049-dc30289460c2";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _containerColor = Colors.grey.withOpacity(0.3);
        });
      },
      onTapUp: (_) {
        setState(() {
          _containerColor = DeckColors.white;
        });
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          _containerColor = DeckColors.white;
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 204,
          padding: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: _containerColor,
            border: Border.all(
              color: DeckColors.primaryColor,
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 20,
                offset: const Offset(0, 4),
              )
            ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: (widget.deckCoverPhotoUrl != null &&
                      widget.deckCoverPhotoUrl != "no_image")
                      ? null
                      : DeckColors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                  child: (widget.deckCoverPhotoUrl != null &&
                      widget.deckCoverPhotoUrl != "no_image")
                      ? Image.network(
                    widget.deckCoverPhotoUrl!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        defaultImageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: DeckColors.white,
                            child: const Center(
                              child: Icon(Icons.broken_image,
                                  color: DeckColors.primaryColor),
                            ),
                          );
                        },
                      );
                    },
                  )
                      : Image.network(
                    defaultImageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: DeckColors.white,
                        child: const Center(
                          child: Icon(Icons.image_not_supported,
                              color: DeckColors.primaryColor),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(top: 15.0, left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.titleOfDeck,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Fraiche',
                            fontSize: 16,
                            color: DeckColors.primaryColor,
                          ),
                        ),
                        const Spacer(),
                        if (widget.items != null && widget.icons != null && widget.onItemsSelected != null)
                          PopupMenu(
                          items: widget.items!,
                          icons: widget.icons!,
                          onItemSelected: widget.onItemsSelected,
                        ),
                      ],
                    ),
                    Text(
                      '${widget.numberOfCards} cards',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Nunito-Regular',
                        fontSize: 12,
                        color: DeckColors.primaryColor,
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
