import 'package:deck/pages/misc/colors.dart';
import 'package:flutter/material.dart';
import '../../deck_icons2.dart';

/// DeckLoadingDialog - A reusable loading widget with a spinner and branded SVG.
///
/// Use:
/// showDialog(
///   context: context,
///   barrierDismissible: false,
///   builder: (context) => const DeckLoadingDialog(message: "Creating deck, please wait for a second..."),
/// );
class DeckLoadingDialog extends StatelessWidget {
  final String? message;

  const DeckLoadingDialog({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min, // compact vertically
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.width / 3,
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
          if (message != null) ...[
            const SizedBox(height: 24),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Nunito-Bold',
                color: DeckColors.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
