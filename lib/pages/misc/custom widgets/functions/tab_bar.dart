import 'package:auto_size_text/auto_size_text.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:flutter/material.dart';

/// BuildTabBar is a widget that displays a tabbed interface with optional icons and content views.
/// Parameters:
/// - `titles`: A list of strings representing the titles of each tab.
/// - `length`: The number of tabs.
/// - `tabContent`: A list of widgets corresponding to the content displayed for each tab.
/// - `icons`: (Optional) A list of [IconData] to display alongside each tab title.
/// - `color`: (Optional) The color of the selected tab indicator and label. Defaults to [DeckColors.accentColor].
/// - `hasContentPadding`: (Optional) A boolean indicating whether to apply horizontal padding to the tab bar. Defaults to true.
///
/// how to call
/// BuildTabBar(
///   titles: ['Home', 'Settings'],
///   length: 2,
///   tabContent: [HomeWidget(), SettingsWidget()],
///   icons: [Icons.home, Icons.settings],
///   color: Colors.blue,
///   hasContentPadding: false,
/// )

class BuildTabBar extends StatelessWidget {
  final List<String> titles;
  final int length;
  final List<Widget> tabContent;
  final List<IconData>? icons;
  final Color color;
  final bool hasContentPadding;

  const BuildTabBar({
    super.key,
    required this.titles,
    required this.length,
    required this.tabContent,
    this.icons,
    this.color = DeckColors.accentColor,
    this.hasContentPadding = true
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: length,
      child: Column(
        children: [
          Padding(
        padding: hasContentPadding
            ? const EdgeInsets.all(0) : const EdgeInsets.symmetric(horizontal: 30),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: DeckColors.softGray,
                ),
                child: TabBar(
                  padding: EdgeInsets.zero,
                  labelPadding: EdgeInsets.zero,
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  labelColor: DeckColors.white,
                  unselectedLabelColor: DeckColors.white,
                  tabs: buildTabs(),
                ),
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
    return List.generate(titles.length, (index) {
      final title = titles[index];
      final icon = (icons != null && index < icons!.length) ? icons![index] : null;
      return buildContentTabBar(title: title, icon: icon);
    });
  }


  Widget buildContentTabBar({required String title, IconData? icon}) {
    return Tab(
      iconMargin: const EdgeInsets.all(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
                icon,
                size: 16,
                color: DeckColors.white
            ),
            const SizedBox(width: 5), // Spacing between icon and text
          ],
          AutoSizeText(
            title,
            maxLines: 1,
            minFontSize: 5,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Fraiche',
              fontSize: 15,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
