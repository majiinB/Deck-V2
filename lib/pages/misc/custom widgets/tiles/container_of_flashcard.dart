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


class BuildContainerOfFlashCards extends StatefulWidget {
  final VoidCallback onDelete;
  final VoidCallback? onRetrieve, onTap;
  final bool enableSwipeToRetrieve;
  final String titleOfFlashCard, contentOfFlashCard;
  bool isStarShaded;
  final VoidCallback onStarShaded;
  final VoidCallback onStarUnshaded;

  BuildContainerOfFlashCards({
    super.key,
    required this.onDelete,
    required this.isStarShaded,
    required this.onStarShaded,
    required this.onStarUnshaded,
    this.onRetrieve,
    required this.enableSwipeToRetrieve,
    required this.titleOfFlashCard,
    required this.contentOfFlashCard,
    this.onTap,
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
            _containerColor = Colors.grey.withOpacity(0.7);
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
      child: SwipeToDeleteAndRetrieve(
        onDelete: widget.onDelete,
        onRetrieve: widget.enableSwipeToRetrieve ? widget.onRetrieve : null,
        enableRetrieve: widget.enableSwipeToRetrieve,
        child: Container(
          height: 200,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: _containerColor,
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
                        color: DeckColors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Toggle the state of isStarShaded
                        widget.isStarShaded = !widget.isStarShaded;
                        if (widget.isStarShaded) {
                          widget.onStarShaded();
                        } else {
                          widget.onStarUnshaded();
                        }
                      });
                    },
                    child: Icon(
                      size: 24,
                      widget.isStarShaded ? Icons.star : Icons.star_border,
                      color: widget.isStarShaded
                          ? DeckColors.primaryColor
                          : DeckColors.primaryColor,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  color: DeckColors.white,
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  widget.contentOfFlashCard,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontFamily: 'Nunito-Regular',
                    fontSize: 16,
                    color: DeckColors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
