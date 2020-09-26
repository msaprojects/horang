import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/account_page/pin2.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'background_welcome_page.dart';

class BodyWelcomePage extends StatefulWidget {
  @override
  _BodyWelcomePageState createState() => _BodyWelcomePageState();
}

class _BodyWelcomePageState extends State<BodyWelcomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/svg/drawing_login1.svg",
              alignment: Alignment.center,
              fit: BoxFit.contain,
            ),
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
