import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/custom%20widgets/menus/pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


///
///
///DeckList is a method for Container of Decks but only for design
///This is used in recently deleted page
class DeckList extends StatefulWidget {
  final String? deckImageUrl;
  final String titleText, numberText;
  final VoidCallback onDelete;
  final VoidCallback? onRetrieve;
  final bool enableSwipeToRetrieve;
  final ValueChanged<int>? onItemsSelected;
  final List<String>? items;
  final List<IconData>? icons;

  const DeckList({
    super.key,
    this.deckImageUrl,
    required this.titleText,
    required this.numberText,
    required this.onDelete,
    this.onRetrieve,
    this.enableSwipeToRetrieve = true,
    this.onItemsSelected,
    this.items,
    this.icons,
  });

  @override
  State<DeckList> createState() => DeckListState();
}

class DeckListState extends State<DeckList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: DeckColors.white,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: widget.deckImageUrl != null ? null : DeckColors.white,
            height: 75,
            width: 75,
            child: widget.deckImageUrl != null
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
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
                  ),
                )
                : const Placeholder(
              color: DeckColors.white,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.titleText,
                          style: const TextStyle(
                            fontFamily: 'Fraiche',
                            fontSize: 16,
                            color: DeckColors.primaryColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Spacer(),
                      if (widget.items != null && widget.icons != null && widget.onItemsSelected != null)
                        PopupMenu(
                          items: widget.items!,
                          icons: widget.icons!,
                          onItemSelected: widget.onItemsSelected,
                        ),
                    ],
                  ),
                  Container(
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
