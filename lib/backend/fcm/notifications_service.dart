import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  final _notifications = FlutterLocalNotificationsPlugin();
  final onNotifications = BehaviorSubject<String?>();

  Future initLocalNotifications({bool initSchedule = false}) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _notifications.initialize(settings, onDidReceiveNotificationResponse: (payload) async => {onNotifications});
  }

  Future _notificationsDetails() async{
    return const NotificationDetails(
      android: AndroidNotificationDetails(
          'id',
          'name',
          channelDescription: 'desc',
          importance: Importance.max,
          icon: '@drawable/deck_hat_green',
      ),
    );
  }

  Future showNotification ({int id = 0, String? title, String? body, String? payload}) async {
    _notifications.show(id, title, body, await _notificationsDetails(), payload: payload);
  }
}