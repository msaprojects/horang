import 'dart:io';
import 'package:commons/commons.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/notification_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer_util.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class MyHttpOverride extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  if (Platform.isIOS) {
    SharedPreferences.setMockInitialValues({});
  }
  HttpOverrides.global = new MyHttpOverride();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
<<<<<<< Updated upstream
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
=======
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          SizerUtil().init(constraints, orientation);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: WelcomePage(),
          );
        });
      },
>>>>>>> Stashed changes
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  String token = '';
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    firebaseMessaging
        .getToken()
        .then((value) => print("Ini Tokennya2 : " + value));
    NotificationHandler().FirebaseHandler();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gudang',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}
