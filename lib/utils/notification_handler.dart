import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationHandler {
  void getDataFcm(Map<String, dynamic> message) {
    String name = '';
    String age = '';
    if (Platform.isIOS) {
      name = message['name'];
      age = message['age'];
    } else if (Platform.isAndroid) {
      var data = message['data'];
      name = data['name'];
      age = data['age'];
    }
  }

  void FirebaseHandler() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        getDataFcm(message);
      },
      onResume: (Map<String, dynamic> message) async {
        getDataFcm(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        getDataFcm(message);
      },
    );
    firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: true),
    );
  }
}
