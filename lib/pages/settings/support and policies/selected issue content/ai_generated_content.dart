import 'package:deck/pages/misc/custom%20widgets/textboxes/textboxes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../misc/colors.dart';
import '../../../misc/custom widgets/images/screenshot_image.dart';


class AIGeneratedContent extends StatefulWidget{

  @override
  _AIGeneratedContentState createState() => _AIGeneratedContentState();
}
class _AIGeneratedContentState extends State<AIGeneratedContent> {
  final addDetailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Attach a screenshot of the content you’re reporting',
            style: TextStyle(
              fontFamily: 'Fraiche',
              fontSize: 24,
              color: DeckColors.primaryColor,
            ),
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: BuildScreenshotImage(
              ),
              ),
            ),
          const Center(
            child: Text('Upload up to 3 PNG or JPG files. Max file size 10 MB.',
              style: TextStyle(
                fontFamily: 'Nunito-Regular',
                color: DeckColors.primaryColor,
                fontSize: 12,
                height: 1,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top:10.0),
            child: Text(
              'Give us additional details about your report',
              style: TextStyle(
                fontFamily: 'Fraiche',
                fontSize: 24,
                color: DeckColors.primaryColor,
              ),
            ),
          ),
          ///Textbox to enter additional details about the ai-genrated content being reported
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
            child: BuildTextBox(
              showPassword: false,
              hintText: 'Enter additional details',
              controller: addDetailsController,
              isMultiLine: true,
            ),
          ),
          ///---- E N D -----
        ],
      ),
    );
  }
}