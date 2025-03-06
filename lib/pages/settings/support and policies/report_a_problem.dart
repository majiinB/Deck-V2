import 'package:flutter/material.dart';

import '../../misc/colors.dart';
import '../../misc/custom widgets/appbar/auth_bar.dart';


class ReportAProblem extends StatefulWidget {
  const ReportAProblem({super.key});

  @override
  _ReportAProblemState createState() => _ReportAProblemState();
}
class _ReportAProblemState extends State<ReportAProblem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthBar(
        automaticallyImplyLeading: true,
        title: 'Report A Problem',
        color: DeckColors.primaryColor,
        fontSize: 24,
      ),
      backgroundColor: DeckColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Text('Report A Problem',
                  style: TextStyle(
                    fontFamily: 'Fraiche',
                    fontWeight: FontWeight.bold,
                    color: DeckColors.primaryColor,
                    fontSize: 48,
                    height: 1.1,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                child: Text('Found something on Deck that doesn’t '
                    'seem right? Help us improve Deck by reporting it.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontFamily: 'Nunito-Regular',
                    color: DeckColors.primaryColor,
                    fontSize: 16,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}