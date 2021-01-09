import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/component/Dummy/dummypin.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/RegistrationPage/Registrasi.Input.dart';
import 'package:horang/component/account_page/pin2.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'background_welcome_page.dart';

class BodyWelcomePage extends StatefulWidget {
  @override
  _BodyWelcomePageState createState() => _BodyWelcomePageState();
}

class _BodyWelcomePageState extends State<BodyWelcomePage> {
  var pin;
  bool _showbutton = false;
  cekToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var access_token = sp.getString("access_token");
    pin = sp.getString("pin");
    print("PINNYA ADA NGG $pin");
    print("MASUK CEK TOKEN $access_token");
    //checking jika token kosong maka di arahkan ke menu login jika tidak akan meng-hold token dan refresh token
    if (access_token != null) {
      _showbutton = false;
      if (Platform.isIOS) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ));
      } else if (Platform.isAndroid) {
        if (pin != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Pinauth(),
              ));
        } else {
          return true;
        }
      }
    }
  }
  //   if (access_token == null) {
  //     setState(() {
  //       _showbutton = true;
  //       Timer(
  //           Duration(seconds: 4),
  //           () => Navigator.pushReplacement(
  //               context, MaterialPageRoute(builder: (context) => LoginPage())));
  //     });
  //   } else {
  //     _showbutton = false;
  //     if (Platform.isIOS) {
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => LoginPage(),
  //           ));
  //     } else if (Platform.isAndroid) {
  //       if (pin != null) {
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => Pinauth(),
  //             ));
  //       } else {
  //         return true;
  //       }
  //     }
  //   }
  // }

  @override
  void initState() {
    cekToken();
  }

  @override
  Widget build(BuildContext context) {
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
              SizedBox(
                height: 50,
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage()));
                    }),
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
