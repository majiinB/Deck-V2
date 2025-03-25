import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/custom%20widgets/buttons/icon_button.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';

import '../../widget_method.dart';
import '../functions/swipe_to_delete_and_retrieve.dart';


class BuildContainerOfFlashCards extends StatefulWidget {
  final VoidCallback? onDelete;
  final VoidCallback? onRetrieve, onTap;
  final bool enableSwipeToRetrieve;
  final String titleOfFlashCard, contentOfFlashCard;
  bool? isStarShaded;
  final VoidCallback? onStarShaded;
  final VoidCallback? onStarUnshaded;
  final VoidCallback iconOnPressed;
  final Icon? rightIcon;
  final Color? rightIconColor;
  final bool showStar;

  BuildContainerOfFlashCards({
    super.key,
    this.onDelete,
    this.isStarShaded,
    this.onStarShaded,
    this.onStarUnshaded,
    this.onRetrieve,
    required this.enableSwipeToRetrieve,
    required this.titleOfFlashCard,
    required this.contentOfFlashCard,
    this.onTap,
    required this.iconOnPressed,
    this.rightIcon,
    required this.showStar,
    this.rightIconColor,
  });

  @override
  State<BuildContainerOfFlashCards> createState() =>
      BuildContainerOfFlashCardsState();
}

class BuildContainerOfFlashCardsState extends State<BuildContainerOfFlashCards>
    with SingleTickerProviderStateMixin {
  Color _containerColor = DeckColors.accentColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          if (widget.onTap != null) {
            _containerColor = Colors.white.withOpacity(0.1);
          }
        });
      },
      onTapUp: (_) {
        setState(() {
          _containerColor = DeckColors.white;
        });
        widget.onTap?.call();
      },
      onTapCancel: () {
        setState(() {
          _containerColor = DeckColors.white;
        });
      },
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(20.0),
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.titleOfFlashCard,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Nunito-Bold',
                      fontSize: 16,
                      color: DeckColors.primaryColor,
                    ),
                  ),
                ),
                if(widget.showStar)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      // Toggle the state of isStarShaded
                      widget.isStarShaded = !(widget.isStarShaded ?? false);
                      if (widget.isStarShaded == true) {
                        widget.onStarShaded?.call();
                      } else {
                        widget.onStarUnshaded?.call();
                      }
                    });
                  },
                  child: Icon(
                    size: 24,
                    (widget.isStarShaded ?? false)? Icons.star : Icons.star_border,
                    color: (widget.isStarShaded ?? false)
                        ? DeckColors.deckYellow
                        : DeckColors.deckYellow,
                  ),
                ),

                BuildIconButton(
                    onPressed: widget.iconOnPressed,
                    icon: widget.rightIcon?.icon ?? DeckIcons.trash_bin,
                    iconColor: widget.rightIconColor ?? DeckColors.primaryColor,
                    backgroundColor: DeckColors.white,
                    containerWidth: 40,
                    containerHeight: 40)
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                color: DeckColors.primaryColor,
                width: MediaQuery.of(context).size.width,
                height: 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                widget.contentOfFlashCard,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontFamily: 'Nunito-Regular',
                  fontSize: 16,
                  color: DeckColors.primaryColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
