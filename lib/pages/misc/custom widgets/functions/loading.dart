/// DeckLoadingDialog - A reusable loading widget with a spinner and branded SVG.
///
/// This widget can be shown using `showDialog` to indicate background processing,
/// such as loading, submitting, or fetching data.
///
/// how to use
/// const DeckLoadingDialog(),
import 'package:deck/pages/misc/colors.dart';
import 'package:flutter/material.dart';
import '../../deck_icons2.dart';

class DeckLoadingDialog extends StatelessWidget {
  const DeckLoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            // width: 10,
            width:MediaQuery.of(context).size.width/3,
            height:MediaQuery.of(context).size.width/3,
            child: const CircularProgressIndicator(
              color: DeckColors.primaryColor,
              strokeWidth: 8.0,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Icon(
              DeckIcons2.hat,
              size: 50,
              color: DeckColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
