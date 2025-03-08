import 'package:flutter/cupertino.dart';

import '../../../misc/colors.dart';
import '../../../misc/custom widgets/images/screenshot_image.dart';
import '../../../misc/custom widgets/textboxes/textboxes.dart';

class BugIssues extends StatefulWidget {

  @override
  _BugIssuesState createState() => _BugIssuesState();
}
  class _BugIssuesState extends State<BugIssues>{
  final detailsController = TextEditingController();

    @override
    Widget build(BuildContext context){
      return Padding(
          padding: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tell us what you were doing in Deck when you saw the bug, '
                  'and what you expected to happen instead. Include as much '
                  'detail as possible.',
              style: TextStyle(
                fontFamily: 'Fraiche',
                fontSize: 24,
                color: DeckColors.primaryColor,
                height: 1.2,
              ),
            ),
            ///Textbox to enter additional details about the bug issues content being reported
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: BuildTextBox(
                showPassword: false,
                hintText: 'Enter additional details',
                controller: detailsController,
                isMultiLine: true,
              ),
            ),
            ///----- E N D ------
            const Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
              child: Text('Don’t include any sensitive information such as you password in your message.',
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
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                'Attach a screenshot of the content you’re reporting',
                style: TextStyle(
                  fontFamily: 'Fraiche',
                  fontSize: 24,
                  color: DeckColors.primaryColor,
                ),
              ),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                ///This calls the screen shot images containers
                child: BuildScreenshotImage(
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 15.0),
              child: Center(
                child: Text('Upload up to 3 PNG or JPG files. Max file size 10 MB.',
                  style: TextStyle(
                    fontFamily: 'Nunito-Regular',
                    color: DeckColors.primaryColor,
                    fontSize: 12,
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }


