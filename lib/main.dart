import 'dart:io';
import 'package:commons/commons.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horang/component/DashboardPage/home_page.dart';
import 'package:horang/component/Dummy/dummypin.dart';
import 'package:horang/component/Dummy/dummypin2.dart';
import 'package:horang/component/ProdukPage/Produk.List.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class MyHttpOverride extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    // TODO: implement createHttpClient
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// void main() => runApp(MyApp());
void main() {
  // SharedPreferences.setMockInitialValues({});
  if (Platform.isIOS) {
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({});
  }
  HttpOverrides.global = new MyHttpOverride();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: ProdukList(),
      home: WelcomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  final firebaseMessaging = FirebaseMessaging();
  final controllerTopic = TextEditingController();
  bool isSubscribed = false;
  String token = '';
  static String dataName = '';
  static String dataAge = '';

  static Future<dynamic> onBackgroundMessage(Map<String, dynamic> message) {
    debugPrint('onBackgroundMessage: $message');
    if (message.containsKey('data')) {
      String name = '';
      String age = '';
      if (Platform.isIOS) {
        name = message['name'];
        age = message['age'];
        print("NOTIF : " + name + age);
      } else if (Platform.isAndroid) {
        var data = message['data'];
        name = data['name'];
        age = data['age'];
      }
      dataName = name;
      dataAge = age;
      debugPrint('onBackgroundMessage: name: $name & age: $age');
    }
    return null;
  }

  @override
  void initState() {
    firebaseMessaging
        .getToken()
        .then((value) => print("Ini Tokennya2 : " + value));
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        debugPrint('onMessage: $message');
        // getDataFcm(message);
        successDialog(context, message['notification']['body'],
            title: message['notification']['title']);
      },
      onResume: (Map<String, dynamic> message) async {
        debugPrint('onResume: $message');
        // getDataFcm(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        debugPrint('onLaunch: $message');
        // getDataFcm(message);
      },
    );
    firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: true),
    );
    firebaseMessaging.onIosSettingsRegistered.listen((settings) {
      debugPrint('Settings registered: $settings');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('tokenff: $token');
    debugPrint('Value: $dataName');
    return MaterialApp(
      title: 'Gudang',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
      // home: ProdukList(),
    );
  }

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
    if (name.isNotEmpty && age.isNotEmpty) {
      setState(() {
        dataName = name;
        dataAge = age;
      });
    }
    debugPrint('getDataFcm: name: $name & age: $age');
  }
}
