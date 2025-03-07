import 'package:flutter/material.dart';
/// this is a custom widget for a pop up menu that uses the standard popup animation.
/// it requires an item list and icon list ehe

/// how to use this?
  ///PopupMenu(
  /// items: const ['publish deck', 'edit deck', 'delete deck'], //list all ano ng pop up(eg. publish deck)
  /// icons: const [ Icons.download_outlined , Icons.share_outlined, Icons.delete_outline], //list all icons, make sure match ung count nito sa list
  /// onItemSelected: (int index) {   //callback is triggered when a menu item is selected
  ///   put LOGIC HERE when the item is selected
  /// },
  ///),
///


class PopupMenu extends StatelessWidget {
  final List<String> items;
  final List<IconData> icons;
  final ValueChanged<int>? onItemSelected;

  const PopupMenu({
    Key? key,
    required this.items,
    required this.icons,
    this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
        icon: const Icon(Icons.more_vert_rounded), //change the icon if may custom icon for this
        onSelected: onItemSelected,
        // build menu item for each element in list
        itemBuilder: (BuildContext context) => List<PopupMenuEntry<int>>.generate(
            items.length, // number of items to generate
                (int index) => PopupMenuItem<int>(
              value: index, //when item is selected, value of the iem is returned
              child: ListTile(
                leading: Icon(icons[index]),
                title: Text(items[index]),
              ),
            )
        )
    );
  }
}


