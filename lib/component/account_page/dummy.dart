import 'package:flutter/material.dart';
import 'package:horang/screen/welcome_page.dart';

class dummy extends StatefulWidget {
  @override
  _dummyState createState() => _dummyState();
}

class _dummyState extends State<dummy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        alignment: Alignment.bottomCenter,
        child: RaisedButton(
        child: Text("pindah"),
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => WelcomePage()),
              (Route<dynamic> route) => false);
        },
      ),
      )
    );
  }
}
