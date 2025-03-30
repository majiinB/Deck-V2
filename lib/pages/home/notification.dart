import 'dart:io';

import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:flutter/material.dart';

import '../misc/custom widgets/appbar/auth_bar.dart';
import '../misc/custom widgets/appbar/deck_bar.dart';
import '../misc/custom widgets/buttons/custom_buttons.dart';
import '../misc/custom widgets/buttons/icon_button.dart';
import '../misc/custom widgets/dialogs/alert_dialog.dart';
import '../misc/custom widgets/dialogs/confirmation_dialog.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});
  @override
  _NotificationPageState createState() => _NotificationPageState();
}
class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return
      SafeArea(
          child: Scaffold(
            backgroundColor: DeckColors.backgroundColor,

            appBar: AuthBar(
              automaticallyImplyLeading: true,
              title: 'Notifications',
              color: DeckColors.primaryColor,
              fontSize: 24,
              onRightIconPressed: () {

              },
            ),
          )
      );
  }
}