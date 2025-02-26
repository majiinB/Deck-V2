import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';

import '../buttons/icon_button.dart';


/// ----------------------- S T A R T ---------------------------
/// ------------ D E C K  S L I V E R H E A D E R ---------------

///
///
///SLiverHeader
class DeckSliverHeader extends StatelessWidget {
  final Color backgroundColor;
  final String headerTitle;
  final bool? isPinned;
  final bool hasIcon;
  final TextStyle textStyle;
  final double? max;
  final double? min;
  final VoidCallback? onPressed;
  final IconData? icon;
  const DeckSliverHeader({
    super.key,
    required this.backgroundColor,
    required this.headerTitle,
    required this.textStyle,
    this.onPressed,
    required this.hasIcon,
    this.isPinned,
    this.max,
    this.min,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: isPinned ?? true,
      floating: false,
      delegate: DeckDelegate(
        backgroundColor,
        headerTitle,
        onPressed ?? () {},
        hasIcon,
        textStyle,
        max,
        min,
        icon ?? Icons.calendar_month_rounded,
      ),
    );
  }
}

class DeckDelegate extends SliverPersistentHeaderDelegate {
  final Color backgroundColor;
  final String headerTitle;
  final TextStyle textStyle;
  final double? max;
  final double? min;
  final VoidCallback onPressed;
  final bool hasIcon;
  final IconData icon;

  DeckDelegate(this.backgroundColor, this.headerTitle, this.onPressed,
      this.hasIcon, this.textStyle, this.max, this.min, this.icon);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                headerTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyle,
              ),
            ),
          ),
          if (hasIcon)
            BuildIconButton(
              onPressed: onPressed,
              icon: icon,
              iconColor: DeckColors.white,
              backgroundColor: backgroundColor,
              containerWidth: 60,
              containerHeight: 60,
            ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => max ?? 180;

  @override
  double get minExtent => min ?? 180;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

/// ------------------------ E N D -----------------------------
/// ------------ D E C K  S L I V E R H E A D E R --------------
