import 'package:flutter/material.dart';
import '../../colors.dart';

/// PopupMenu - A custom widget for displaying a popup menu with standard animation.
///
/// This widget provides a dropdown menu with a list of selectable items, each
/// accompanied by an icon. It triggers a callback when an item is selected.
///
/// Usage:
/// PopupMenu(
///   items: const ['Publish Deck', 'Edit Deck', 'Delete Deck'], // Menu items
///   icons: const [Icons.download_outlined, Icons.share_outlined, Icons.delete_outline], // Corresponding icons
///   onItemSelected: (int index) {
///     // Logic when an item is selected
///   },
/// ),
///
/// Parameters:
/// - items: A list of strings representing the menu options.
/// - icons: A list of IconData corresponding to each menu item (must match the items list count).
/// - onItemSelected: A callback function triggered when a menu item is selected.
///
/// Notes:
/// - Ensure that the number of items matches the number of icons.



class PopupMenu extends StatelessWidget {
  final List<String> items;
  final List<IconData> icons;
  final ValueChanged<int>? onItemSelected;
  final Icon? icon;
  final double offset;

  const PopupMenu({
    Key? key,
    required this.items,
    required this.icons,
    this.onItemSelected,
    this.offset = 0,
    this.icon,
  }) : assert(items.length == icons.length, "Items and icons list must be of the same length"),
        super(key: key);


  @override
  Widget build(BuildContext context) {
    debugPrint("PopupMenu is built");

    return SizedBox(
        // height: 30.0,
        // width: 80.0,
        child: PopupMenuButton<int>(
          offset: Offset(offset,0),
          padding: EdgeInsets.all(5),
          color: DeckColors.backgroundColor,
          icon: icon ?? const Icon(
              Icons.more_vert_rounded,
              color: DeckColors.primaryColor), //change the icon if may custom icon for this
          shape: RoundedRectangleBorder(
            side: BorderSide(color: DeckColors.primaryColor, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          onSelected: onItemSelected,
          // build menu item for each element in list
          itemBuilder: (BuildContext context) {
            debugPrint("PopupMenu itemBuilder is called with ${items.length} items");

            List<PopupMenuEntry<int>> menuItems = [];

            for (int index = 0; index < items.length; index++) {
              menuItems.add(
                PopupMenuItem<int>(
                  value: index,
                  child: ListTile(
                    leading: Icon(icons[index]),
                    title: Text(items[index],
                      maxLines:1,
                      style: const TextStyle(
                        height:1,
                        fontSize: 10,
                        fontFamily: 'Nunito-SemiBold',
                        color: DeckColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              );

              // Add a divider after every item except the last one
              if (index < items.length - 1) {
                menuItems.add(const PopupMenuDivider(
                  height: 2,
                ));
              }
            }
            return menuItems;
          },
        ),
    );
  }
}


