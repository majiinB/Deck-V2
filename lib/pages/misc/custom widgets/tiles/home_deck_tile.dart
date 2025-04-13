import 'package:auto_size_text/auto_size_text.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../menus/pop_up_menu.dart';


class HomeDeckTile extends StatefulWidget {
  final String? deckCoverPhotoUrl;
  final String titleOfDeck;
  final String ownerOfDeck;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final VoidCallback? onRetrieve;
  final bool enableSwipeToRetrieve;
  final int numberOfCards;
  final ValueChanged<int>? onItemsSelected;
  final List<String>? items;
  final List<IconData>? icons;

  const HomeDeckTile({
    super.key,
    required this.onDelete,
    this.onRetrieve,
    this.enableSwipeToRetrieve = true,
    this.deckCoverPhotoUrl,
    required this.titleOfDeck,
    required this.ownerOfDeck,
    required this.onTap,
    required this.numberOfCards,
    this.onItemsSelected,
    this.items,
    this.icons,
  });

  @override
  State<HomeDeckTile> createState() => HomeDeckTileState();
}

class HomeDeckTileState extends State<HomeDeckTile> {
  Color _containerColor = DeckColors.white;
  final String defaultImageUrl =
      "https://firebasestorage.googleapis.com/v0/b/deck-f429c.appspot.com/o/deckCovers%2Fdefault%2FdeckDefault.png?alt=media&token=2b0faebd-9691-4c37-8049-dc30289460c2";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _containerColor = DeckColors.white.withOpacity(0.3);
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
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: _containerColor,
          border: Border.all(
            color: DeckColors.primaryColor,
            width: 3.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: (widget.deckCoverPhotoUrl != null &&
                    widget.deckCoverPhotoUrl != "no_image")
                    ? null
                    : Colors.transparent,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
              ),
              width: 200,
              height: 80,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                child: (widget.deckCoverPhotoUrl != null && widget.deckCoverPhotoUrl != "no_image")
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
                          color: Colors.transparent,
                          child: const Center(
                            child: Icon(Icons.broken_image,
                                color: DeckColors.primaryColor),
                          ),
                        );
                      },
                    );
                  },
                )
                //     : Image.network(
                //   defaultImageUrl,
                //   width: double.infinity,
                //   height: double.infinity,
                //   fit: BoxFit.cover,
                //   errorBuilder: (context, error, stackTrace) {
                //     return Container(
                //       color: Colors.transparent,
                //       child: const Center(
                //         child: Icon(Icons.image_not_supported,
                //             color: DeckColors.primaryColor),
                //       ),
                //     );
                //   },
                // ),
                    : Image.asset(
                    'assets/images/Deck-Branding1.png',
                    fit: BoxFit.cover
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(top: 5.0,bottom: 10.0, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    widget.titleOfDeck,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Fraiche',
                      fontSize: 20,
                      color: DeckColors.primaryColor,
                    ),
                  ),
                  AutoSizeText(
                    '${widget.numberOfCards} Cards • By: ${widget.ownerOfDeck}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Nunito-Regular',
                      fontSize: 14,
                      color: DeckColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
