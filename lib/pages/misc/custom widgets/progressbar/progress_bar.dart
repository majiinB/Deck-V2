import 'package:flutter/material.dart';

import '../../colors.dart';

class ProgressBar extends StatelessWidget{
  final double progress;
  final Color progressColor;
  final double height;
  const ProgressBar({
    Key? key,
    required this.progress,
    this.progressColor = DeckColors.primaryColor,
    this.height = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: height,
          width: double.infinity, // Adjust width based on progress
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: DeckColors.primaryColor,
              width: 2,
            ),
          ),
          child:LinearProgressIndicator(
            value: progress,
            color: progressColor,
            backgroundColor: Colors.transparent,
            minHeight: height,
            borderRadius: BorderRadius.circular(15),
          ),
        );
      },
    );
  }
  
}