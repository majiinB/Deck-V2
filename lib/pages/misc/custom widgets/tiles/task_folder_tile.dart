import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../colors.dart';
import '../menus/pop_up_menu.dart';
import '../progressbar/progress_bar.dart';

class TaskFolderTile extends StatelessWidget{
  final String? folderName;
  final int? taskDone;
  final int? taskTotal;
  // final int? folderBackground;
  final VoidCallback? onPressed;

  TaskFolderTile({
    super.key,
    required this.folderName,
    // required this.folderBackground,
    required this.taskDone,
    required this.taskTotal,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double progress = (taskTotal != 0) ? (taskDone ?? 0) / taskTotal! : 0.0;

    return Material(
      borderRadius: BorderRadius.circular(15.0),
      color: DeckColors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: () {
          if (onPressed != null) {
            onPressed!();
          }
        },
        child: Container(
            padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: DeckColors.primaryColor, width: 2),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              PopupMenu(
                items: const ['Publish Deck', 'Edit Deck', 'Delete Deck'], // Menu items
                icons: const [Icons.download_outlined, Icons.share_outlined, Icons.delete_outline], // Corresponding icons
                onItemSelected: (int index) {
                  },
              ),
              AutoSizeText(
                  '$folderName',
                  maxLines:3,
                  minFontSize:20,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Fraiche',
                    fontSize: 30,
                    color: DeckColors.primaryColor,
                )
              ),
              AutoSizeText(
                '$taskDone/$taskTotal',
                  maxLines:1,
                  overflow: TextOverflow.ellipsis,
                  minFontSize:15,
                style: const TextStyle(
                    fontFamily: 'Fraiche',
                    fontSize: 20,
                    color: DeckColors.primaryColor,
                )
              ),
              ProgressBar(
                progress: progress,
                progressColor: DeckColors.deckYellow,
                height: 15.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
