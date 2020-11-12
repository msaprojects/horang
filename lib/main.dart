import 'dart:io';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:horang/component/dummy1.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/widget/bottom_nav.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: Dummy1(),
      home: Home(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // final scaffoldState = GlobalKey<ScaffoldState>();
  // final firebaseMessaging = FirebaseMessaging();
  // final controllerTopic = TextEditingController();
  // bool isSubscribed = false;
  // String token = '';
  // static String dataName = '';
  // static String dataAge = '';

  // static Future<dynamic> onBackgroundMessage(Map<String, dynamic> message) {
  //   debugPrint('onBackgroundMessage: $message');
  //   if (message.containsKey('data')) {
  //     String name = '';
  //     String age = '';
  //     if (Platform.isIOS) {
  //       name = message['name'];
  //       age = message['age'];
  //     } else if (Platform.isAndroid) {
  //       var data = message['data'];
  //       name = data['name'];
  //       age = data['age'];
  //     }
  //     dataName = name;
  //     dataAge = age;
  //     debugPrint('onBackgroundMessage: name: $name & age: $age');
  //   }
  //   return null;
  // }

  @override
  void initState() {
  //   firebaseMessaging.configure(
  //     onMessage: (Map<String, dynamic> message) async {
  //       debugPrint('onMessage: $message');
  //       getDataFcm(message);
  //     },
  //     onBackgroundMessage: onBackgroundMessage,
  //     onResume: (Map<String, dynamic> message) async {
  //       debugPrint('onResume: $message');
  //       getDataFcm(message);
  //     },
  //     onLaunch: (Map<String, dynamic> message) async {
  //       debugPrint('onLaunch: $message');
  //       getDataFcm(message);
  //     },
  //   );
  //   firebaseMessaging.requestNotificationPermissions(
  //     const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: true),
  //   );
  //   firebaseMessaging.onIosSettingsRegistered.listen((settings) {
  //     debugPrint('Settings registered: $settings');
  //   });
  //   firebaseMessaging.getToken().then((token) => setState(() {
  //     this.token = token;
  //   }));
  //   super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('tokenff: $token');
    return MaterialApp(
      title: 'Gudang',
      theme: ThemeData(
//        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
      // home: LoginPage(),
      // home: LoginPage(),
    );
  }

  // void getDataFcm(Map<String, dynamic> message) {
  //   String name = '';
  //   String age = '';
  //   if (Platform.isIOS) {
  //     name = message['name'];
  //     age = message['age'];
  //   } else if (Platform.isAndroid) {
  //     var data = message['data'];
  //     name = data['name'];
  //     age = data['age'];
  //   }
  //   if (name.isNotEmpty && age.isNotEmpty) {
  //     setState(() {
  //       dataName = name;
  //       dataAge = age;
  //     });
  //   }
  //   debugPrint('getDataFcm: name: $name & age: $age');
  // }

}