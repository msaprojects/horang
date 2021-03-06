import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/component/Dummy/dummypin2.dart';
import 'package:horang/component/Dummy/cobakeyboard.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/RegistrationPage/Registrasi.Input.dart';
import 'package:horang/component/account_page/ubah_pin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'background_welcome_page.dart';

class BodyWelcomePage extends StatefulWidget {
  @override
  _BodyWelcomePageState createState() => _BodyWelcomePageState();
}

class _BodyWelcomePageState extends State<BodyWelcomePage> {
  var pin = '';
  var access_token = '';
  bool _showbutton = false;

  cekToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    pin = sp.getString("pin");
    print("pinnya adalah $pin" );
    //checking jika token kosong maka di arahkan ke menu login jika tidak akan meng-hold token dan refresh token
    if (access_token == null) {
      return false;
    // } else if (pin == '0' && access_token != null) {
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> UbahPin()));
    } else {
      if (Platform.isIOS) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ));
      } else if (Platform.isAndroid && access_token != null) {
        if (access_token != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Pinauth(),
                // builder: (context) => CobaKeyboard(),
              ));
        }
      }
    }
  }

  @override
  void initState() {
    cekToken();
    print("cek pin ada nggk yazzz $pin");
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
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
