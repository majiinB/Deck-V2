import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';


///
///
///SwipeToDeleteAndRetrieve is to delete and retrieve Decks
class SwipeToDeleteAndRetrieve extends StatelessWidget {
  final Widget child;
  final VoidCallback onDelete;
  final VoidCallback? onRetrieve;
  final bool enableRetrieve;

  const SwipeToDeleteAndRetrieve({
    super.key,
    required this.child,
    required this.onDelete,
    this.onRetrieve,
    this.enableRetrieve = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: enableRetrieve
          ? DismissDirection.horizontal
          : DismissDirection.endToStart,
      background: enableRetrieve
          ? Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: DeckColors.primaryColor,
        ),
        child: const Icon(Icons.undo, color: DeckColors.white),
      )
          : Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.red,
        ),
        child: const Icon(DeckIcons.trash_bin, color: DeckColors.white),
      ),
      secondaryBackground: enableRetrieve
          ? Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.red, // Red background for delete
        ),
        child: const Icon(DeckIcons.trash_bin, color: DeckColors.white),
      )
          : null,
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDelete();
        } else if (direction == DismissDirection.startToEnd && enableRetrieve) {
          onRetrieve?.call();
        }
      },
      child: child,
    );
  }
}