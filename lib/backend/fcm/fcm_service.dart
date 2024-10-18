import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deck/backend/auth/auth_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void handleMessage(RemoteMessage? message){
    if(message == null) return;
  }

  Future<void> initializeNotifications() async{
    await _firebaseMessaging.requestPermission();
    final token = await getToken();
    final currentUser = AuthService().getCurrentUser();
    print(currentUser);
    print(token);
    if (currentUser != null && token != null) {
      final db = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await db.collection('users').where('user_id', isEqualTo: currentUser?.uid).limit(1).get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot docu = querySnapshot.docs.first;
        docu.reference.update({'fcm_token': token,}).then((_) => {
          print('new token generated!'),
          print(token)
        });
      }
    }
    print('done! initializing foreground..');
    await initPushNotifications();
  }

  Future initPushNotifications() async{
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true
    );
    _firebaseMessaging.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  Future<void> renewToken() async {
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      final currentUser = AuthService().getCurrentUser();
      if (currentUser != null) {
        final db = FirebaseFirestore.instance;
        QuerySnapshot querySnapshot = await db.collection('users').where('user_id', isEqualTo: currentUser?.uid).limit(1).get();
        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot docu = querySnapshot.docs.first;
          docu.reference.update({'fcm_token': newToken,}).then((_) => {
            print('new token generated!')
          });
        }
      }
    });
  }
}