import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';


class BuildTabBar extends StatelessWidget {
  final List<String> titles;
  final int length;
  final List<Widget> tabContent;

  const BuildTabBar({
    super.key,
    required this.titles,
    required this.length,
    required this.tabContent,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: length,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.grey,
              ),
              child: TabBar(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: DeckColors.primaryColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                labelColor: DeckColors.white,
                unselectedLabelColor: DeckColors.white,
                tabs: buildTabs(),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: tabContent,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildTabs() {
    return titles.map((title) {
      return buildContentTabBar(title: title);
    }).toList();
  }

  Widget buildContentTabBar({required String title}) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Nunito-Bold',
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
