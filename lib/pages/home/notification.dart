import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deck/pages/misc/colors.dart';
import 'package:deck/pages/misc/deck_icons.dart';
import 'package:flutter/material.dart';

import '../flashcard/view_deck.dart';
import '../misc/custom widgets/appbar/auth_bar.dart';
import '../misc/custom widgets/appbar/deck_bar.dart';
import '../misc/custom widgets/buttons/custom_buttons.dart';
import '../misc/custom widgets/buttons/icon_button.dart';
import '../misc/custom widgets/dialogs/alert_dialog.dart';
import '../misc/custom widgets/dialogs/confirmation_dialog.dart';
import '../misc/custom widgets/functions/if_collection_empty.dart';
import '../misc/custom widgets/tiles/notification_deck_approval.dart';
import '../misc/custom widgets/tiles/notification_task_reminder.dart';
import '../misc/widget_method.dart';
import '../task/view_task.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});
  @override
  _NotificationPageState createState() => _NotificationPageState();
}
class _NotificationPageState extends State<NotificationPage> {
  final bool hasNotification = true;
  // final bool isTaskNotification = true;

  final List<Map<String, String>> notifications = [
    {
      'type': 'deck',
      'title': 'Your Deck is now Published!',
      'message': 'The admin has approved your deck entitled “A very long deck title". Check your deck out now.',
    },
    {
      'type': 'task',
      'title': 'Snoozed Reminder! A sample of a very long task title',
      'message': 'You have a task due today at 11:30 AM.',
    },
    {
      'type': 'deck',
      'title': 'Your Deck is now Published!',
      'message': 'The admin has approved your deck entitled “UHWEUHWEHHH". Check your deck out now.',
    },
    {
      'type': 'task',
      'title': 'Snoozed Reminder! THIS is a diferent task title',
      'message': 'You have a task due today at 11:30 AM.',
    },

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AuthBar(
          automaticallyImplyLeading: true,
          title: 'Notifications',
          color: DeckColors.primaryColor,
          fontSize: 24,
          onRightIconPressed: () {
          },
        ),
        backgroundColor: DeckColors.backgroundColor,
        body:  SafeArea(
            top: true,
            child:  SingleChildScrollView(
              child: hasNotification ? Column(
                children: [
                  SizedBox(
                    height:MediaQuery.of(context).size.height,
                    child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: notifications.length,
                    itemBuilder:(context, index){
                      final notification = notifications[index];
                      final type = notification['type'];
                      final title = notification['title'] ?? '';
                      final message = notification['message'] ?? '';

                      if (type == 'deck') {
                        return Padding(
                          padding: EdgeInsets.only(top: 20),
                            child: DeckApprovalNotification(
                              title: title,
                              message: message,
                              onView: () {
                                // RouteGenerator.createRoute(ViewDeckPage(deck: deck[index],))
                              },
                              onDelete: () {
                                showDialog<bool>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return CustomConfirmDialog(
                                        title: 'Delete this Notification?',
                                        message: 'Deleting a notification will permanently remove Notification.',
                                        imagePath: 'assets/images/Deck-Dialogue4.png',
                                        button1: 'Delete',
                                        button2: 'Cancel',
                                        onConfirm: () async {
                                          ///TODO add function
                                          Navigator.of(context).pop();
                                        },
                                        onCancel: () {
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    }
                                );
                              },
                            )
                        );
                      } else if (type == 'task') {
                        return Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: TaskReminderNotification(
                            title: title,
                            message: message,
                            onView: () {
                              // RouteGenerator.createRoute(ViewTaskPage(task: _tasks[index], isEditable: false))
                            },
                            onSnooze: () {

                            },
                            onDelete: () {
                              showDialog<bool>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return CustomConfirmDialog(
                                      title: 'Delete this Notification?',
                                      message: 'Deleting a notification will permanently remove Notification.',
                                      imagePath: 'assets/images/Deck-Dialogue4.png',
                                      button1: 'Delete',
                                      button2: 'Cancel',
                                      onConfirm: () async {
                                        ///TODO add function
                                        Navigator.of(context).pop();
                                      },
                                      onCancel: () {
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  }
                              );
                            },
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  )
                ],
              )
                  : Center(
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
