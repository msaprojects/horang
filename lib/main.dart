import 'dart:io';
import 'package:flutter/material.dart';
import 'package:horang/component/Dummy/dummy.dart';
import 'package:horang/component/Dummy/dummypin.dart';
import 'package:horang/component/OrderPage/KonfirmasiPembayaran.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/widget/bottom_nav.dart';

import 'component/Dummy/syncfusion_datepicker.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class MyHttpOverride extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context) {
    // TODO: implement createHttpClient
    return super.createHttpClient(context)
    ..badCertificateCallback = (X509Certificate cert, String host, int port)=>true;
  }
}

// void main() => runApp(MyApp());
void main(){
  HttpOverrides.global = new MyHttpOverride();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
      // home: LoginPage(),
      // home: dummyDesign(),
    );
  }
}

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {

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

  // @override
  // void initState() {
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
  // }

  // @override
  // Widget build(BuildContext context) {
  //   // debugPrint('tokenff: $token');
  //   return MaterialApp(
  //     title: 'Gudang',
  //     theme: ThemeData(
  //       scaffoldBackgroundColor: Colors.grey[100],
  //     ),
  //     debugShowCheckedModeBanner: false,
  //     home: WelcomePage(),
  //   );
  // }

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

// }