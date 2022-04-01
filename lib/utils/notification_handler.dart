import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../component/DashboardPage/home_page.dart';
import '../widget/bottom_nav.dart';

class NotificationHandler {
  BuildContext get context => context;

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
    late FirebaseMessaging firebaseMessaging;
     FirebaseMessaging.onMessage.listen((RemoteMessage message) { 
        RemoteNotification? notif = message.notification;
        AndroidNotification? android = message.notification?.android;
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message.toString());
      Fluttertoast.showToast(
          msg: " Notifikasi ${message}",
          backgroundColor: Colors.red,
          textColor: Colors.white);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Home(callpage: HomePage(), initIndexHome: 0,
                    
                  )));
    });
    // firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     getDataFcm(message);
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     getDataFcm(message);
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     getDataFcm(message);
    //   },
    // );
    // firebaseMessaging.requestNotificationPermissions(
    //   const IosNotificationSettings(
    //       sound: true, badge: true, alert: true, provisional: true),
    // );
  }
}
