import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';

import '../menus/pop_up_menu.dart';


///
///
/// AuthBar is an AppBar with the font Fraiche (used in auth and main routes)
class AuthBar extends StatelessWidget implements PreferredSizeWidget {
  const AuthBar({
    super.key,
    required this.title,
    required this.color,
    required this.fontSize,
    this.rightIcon,
    this.automaticallyImplyLeading = false,
    this.onRightIconPressed,
    this.onItemsSelected,
    this.items,
    this.icons,
    this. showPopMenu,
  });
  final String title;
  final Color color;
  final double fontSize;
  final IconData? rightIcon;
  final bool automaticallyImplyLeading;
  final VoidCallback? onRightIconPressed;
  final ValueChanged<int>? onItemsSelected;
  final List<String>? items;
  final List<IconData>? icons;
  final bool? showPopMenu;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: AppBar(
        automaticallyImplyLeading: automaticallyImplyLeading,
        iconTheme: const IconThemeData(
          color: DeckColors.primaryColor,
        ),
        backgroundColor: DeckColors.white,
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Fraiche',
            fontSize: fontSize,
            color: color,
          ),
        ),
        centerTitle: true,
        actions: [
          if (showPopMenu ?? false && items != null && icons != null && items!.isNotEmpty && icons!.isNotEmpty)
            PopupMenu(
              items: items!,
              icons: icons!,
              onItemSelected: onItemsSelected,
            ),
          if(rightIcon != null)
            IconButton(
                onPressed: onRightIconPressed,
                icon: Icon(rightIcon))
        ],
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
