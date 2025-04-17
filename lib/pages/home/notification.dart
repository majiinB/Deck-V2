import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:flutter/material.dart';

import '../misc/custom widgets/appbar/auth_bar.dart';
import '../misc/custom widgets/appbar/deck_bar.dart';
import '../misc/custom widgets/buttons/custom_buttons.dart';
import '../misc/custom widgets/buttons/icon_button.dart';
import '../misc/custom widgets/dialogs/alert_dialog.dart';
import '../misc/custom widgets/dialogs/confirmation_dialog.dart';
import '../misc/custom widgets/functions/if_collection_empty.dart';
import '../misc/custom widgets/tiles/notification_deck_approval.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});
  @override
  _NotificationPageState createState() => _NotificationPageState();
}
class _NotificationPageState extends State<NotificationPage> {
  final bool hasNotification = true;

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
            body:   SingleChildScrollView(
              padding: EdgeInsets.only(top: 20),
              child: hasNotification ?
              Column(
                  children:[
                    DeckApprovalNotification(
                      title: 'Your Deck is now Published!',
                      message: 'The admin has approved your deck entitled “A very long deck title" check your deck out now',
                      onView: () {  },
                      onDelete: () {  },)
                  ]
              )
                  :
              // ListView.builder(
              //     itemBuilder: (context, count){
              //
              //     }
              // ) :
              Center(
                heightFactor:MediaQuery.of(context).size.height,
                widthFactor: MediaQuery.of(context).size.width,
                child: IfCollectionEmpty(
                  ifCollectionEmptyText: 'No Results Found',
                  ifCollectionEmptySubText:
                  'Try adjusting your search to \nfind what your looking for.',
                  ifCollectionEmptyHeight:
                  MediaQuery.of(context).size.height,
                ),
              ),
            )
          )
      );
  }
}