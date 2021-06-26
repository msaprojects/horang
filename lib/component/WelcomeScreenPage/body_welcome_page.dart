import 'dart:async';
import 'dart:io';
import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launcher_icons/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/component/Dummy/dummypin2.dart';
import 'package:horang/component/Dummy/cobakeyboard.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/RegistrationPage/Registrasi.Input.dart';
import 'package:horang/component/account_page/ubah_pin.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:new_version/new_version.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaml/yaml.dart';
import 'background_welcome_page.dart';
import 'package:get_version/get_version.dart';

class BodyWelcomePage extends StatefulWidget {
  @override
  _BodyWelcomePageState createState() => _BodyWelcomePageState();
}

class _BodyWelcomePageState extends State<BodyWelcomePage> {
  var pin = '';
  var access_token = '';
  bool _showbutton = false;
  String _projectVersion = '';
  String _platformVersion = 'Unknown';
  String _projectCode = '';
  String _projectAppID = '';
  String _projectName = '';
  SharedPreferences sp;

  initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await GetVersion.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    String projectVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectVersion = await GetVersion.projectVersion;
    } on PlatformException {
      projectVersion = 'Failed to get project version.';
    }

    String projectCode;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectCode = await GetVersion.projectCode;
    } on PlatformException {
      projectCode = 'Failed to get build number.';
    }

    String projectAppID;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectAppID = await GetVersion.appID;
    } on PlatformException {
      projectAppID = 'Failed to get app ID.';
    }

    String projectName;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectName = await GetVersion.appName;
    } on PlatformException {
      projectName = 'Failed to get app name.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _projectVersion = projectVersion;
      _platformVersion = platformVersion;
      _projectCode = projectCode;
      _projectAppID = projectAppID;
      _projectName = projectName;
    });
  }

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    pin = sp.getString("pin");
    print("pinnya adalah $pin + $access_token");
    //checking jika token kosong maka di arahkan ke menu login jika tidak akan meng-hold token dan refresh token
    if (access_token == null) {
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => WelcomePage()));
      return false;
      // } else if (pin == '0' && access_token != null) {
      //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> UbahPin()));
    } else {
      if (Platform.isIOS) {
        new Future.delayed(
            const Duration(seconds: 3),
            () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage())));
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => LoginPage(),
        //     ));
      } else if (Platform.isAndroid && access_token != null) {
        if (access_token != null) {
          // loadingScreen(context,
          //     duration: Duration(seconds: 3), loadingType: LoadingType.SCALING);
          new Future.delayed(
              const Duration(seconds: 3),
              () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Pinauth())));
        }
      }
    }
  }

  @override
  void initState() {
    NewVersion(
      androidId: 'com.cvdtc.horang',
      iOSId: 'com.cvdtc.horang',
      context: context,
    ).showAlertIfNecessary();
    cekToken();
    initPlatformState();
    print("cek pin ada nggk yazzz $pin ");
  }

  @override
  Widget build(BuildContext context) {
    print("object11 $access_token");
    // Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Container(
                height: 120,
                // width: 70,
                child: Image.asset(
                  "assets/image/logogudang.png",
                  alignment: Alignment.center,
                  fit: BoxFit.fill,
                ),
              ),
              Text('Version $_projectVersion'),
              SizedBox(
                height: 10,
              ),
              Text("Hei, Selamat Datang !",
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.black87)),
              SizedBox(
                height: 8,
              ),
              Text("Registrasi sekarang untuk memulai aplikasi",
                  style: GoogleFonts.lato(fontSize: 14, color: Colors.black45)),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.5,
                child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.blue[900],
                    child: Text("Registrasi",
                        style: GoogleFonts.lato(fontSize: 14)),
                    shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegistrasiPage()));
                    }),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.8,
                child: OutlineButton(
                    child: Text("Sudah memiliki akun ? Login sekarang",
                        style: GoogleFonts.lato(fontSize: 14)),
                    borderSide: BorderSide(color: Colors.deepPurple[900]),
                    shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    }),
              ),
              SizedBox(height: 15,),
              access_token != null
                  ? CircularProgressIndicator(
                    backgroundColor: Colors.blueAccent,
                    valueColor: AlwaysStoppedAnimation(Colors.red), 
                    strokeWidth: 10,
                  )
                  : Visibility(
                      child: Text(''),
                      visible: false,
                    ),
            ],
          ),
        ),

        // SpinKitCircle(
        //   color: Colors.blue,
        //   duration: const Duration(milliseconds: 1200),
        // ),
      ),
    );
  }
}
