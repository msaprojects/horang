import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:horang/component/Dummy/dummypin.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/account_page/pin2.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'background_welcome_page.dart';

class BodyWelcomePage extends StatefulWidget {
  @override
  _BodyWelcomePageState createState() => _BodyWelcomePageState();
}

class _BodyWelcomePageState extends State<BodyWelcomePage> {
  bool _showbutton = false;
  cekToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var access_token = sp.getString("access_token");
    print("MASUK CEK TOKEN $access_token");
    //checking jika token kosong maka di arahkan ke menu login jika tidak akan meng-hold token dan refresh token
    if (access_token == null) {
      setState(() {
        _showbutton = true;
        Timer(
            Duration(seconds: 4),
            () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage())));
      });
    } else {
      _showbutton = false;
      if(Platform.isIOS){
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ));
      }else if (Platform.isAndroid){
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => pinauth(),
            ));
      }
    }
  }

  @override
  void initState() {
    cekToken();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.03),
            // SvgPicture.asset(
            //   "assets/svg/drawing_login1.svg",
            //   alignment: Alignment.center,
            //   fit: BoxFit.contain,
            // ),
            SizedBox(height: size.height * 0.03),
            SpinKitCircle(
              color: Colors.blue,
              duration: const Duration(milliseconds: 1200),
            ),
          ],
        ),
      ),
    );
  }
}
