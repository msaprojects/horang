import 'dart:io';
import 'dart:ui';
import 'package:commons/commons.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/pengguna/cek.loginuuid.model.dart';
import 'package:horang/api/models/pengguna/pengguna.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/OrderPage/KonfirmasiPembayaran.dart';
import 'package:horang/component/account_page/reset.dart';
import 'package:horang/utils/constant_color.dart';
import 'package:horang/utils/deviceinfo.dart';
import 'package:horang/widget/TextFieldContainer.dart';
import 'package:horang/widget/bottom_nav.dart';
import 'package:minimize_app/minimize_app.dart';

class LoginPage extends StatefulWidget {
  var cekUUID, email, nama;
  LoginPage({this.cekUUID, this.email, this.nama});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future futures;
  ApiService _apiService = ApiService();
  final firebaseMessaging = FirebaseMessaging();
  bool _fieldEmail,
      _fieldPassword,
      _isLoading = false,
      _obsecureText = true,
      _checkbio = false;
  String token = "";
  var iddevice = "",
      uuidAnyar = "",
      email = "",
      emailaccountselection = "",
      emaile,
      namae = "";
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  void _toggle() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  //FIREBASE
  @override
  void initState() {
    namae = widget.nama;
    uuidAnyar = widget.cekUUID;
    emaile = widget.email;

    print("askj : " + emailaccountselection.toString());
    firebaseMessaging.getToken().then((token) => setState(() {
          this.token = token;
        }));
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        debugPrint('onMessage: $message');
        if (Platform.isIOS) {
          successDialog(context, message['alert']['body'],
              title: message['alert']['title']);
        } else if (Platform.isAndroid) {
          successDialog(context, message['notification']['body'],
              title: message['notification']['title']);
        }
      },
      // onBackgroundMessage: onBackgroundMessage,
      onResume: (Map<String, dynamic> message) async {
        debugPrint('onResume: $message');
        getDataFcm(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        debugPrint('onLaunch: $message');
        getDataFcm(message);
      },
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: false));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    super.initState();
    setState(() {
      if (emaile == "") {
        emailaccountselection = _controllerEmail.text.toString();
      } else {
        emailaccountselection = emaile.toString();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void closeApp() {
    if (Platform.isAndroid) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } else {
      MinimizeApp.minimizeApp();
    }
  }

  void getDataFcm(Map<String, dynamic> message) {
    String name = '';
    String age = '';
    if (Platform.isIOS) {
      name = message['title'];
      age = message['body'];
    } else if (Platform.isAndroid) {
      var data = message['notification'];
      name = data['title'];
      age = data['body'];
    }
    debugPrint('getDataFcm: name: $name & age: $age');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: size.height,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Text(emaile + "-" +namae),
                    Text(
                      "Login",
                      style: GoogleFonts.lato(fontSize: 18),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    emaile == ""
                        ? _buildTextFieldEmail()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Halo,",
                                  style: GoogleFonts.lato(fontSize: 16)),
                              Text(namae,
                                  style: GoogleFonts.lato(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              Text(emaile,
                                  style: GoogleFonts.lato(fontSize: 12)),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                            ],
                          ),
                    _buildTextFieldPassword(),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      width: size.width * 0.8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(29),
                        child: FlatButton(
                          child: Text(
                            "LOGIN",
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ), // button login
                          textColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 40),
                          color: primaryColor,
                          onPressed: () {
                            GetDeviceID().getDeviceID(context).then((ids) {
                              setState(() {
                                iddevice = ids;
                                print(
                                    'cek uudi $iddevice - $emailaccountselection');
                                // if (emailaccountselection == null ||
                                //     emailaccountselection == "" ||
                                if (_controllerEmail == null ||
                                    _fieldPassword == null ||
                                    !_fieldPassword) {
                                  warningDialog(
                                      context, "Pastikan Semua Kolom Terisi!");
                                } else {
                                  setState(() {
                                    print("IDDEVICE : " +
                                        iddevice.toString() +
                                        "--- $emailaccountselection");
                                    _isLoading = true;
                                  });
                                  String emailz =
                                      _controllerEmail.text.toString();
                                  String password =
                                      _controllerPassword.text.toString();
                                  PenggunaModel pengguna = PenggunaModel(
                                      uuid: iddevice,
                                      email: emailaccountselection != ""
                                          ? emailaccountselection
                                          : emailz,
                                      password: password,
                                      status: 0,
                                      notification_token: token,
                                      token_mail: "0",
                                      keterangan: "Uji Coba");
                                  print("LOGIN? : " + pengguna.toString());
                                  _apiService
                                      .loginIn(pengguna)
                                      .then((isSuccess) {
                                    setState(() => _isLoading = false);
                                    if (isSuccess) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Home()));
                                    } else {
                                      warningDialog(context,
                                          "${_apiService.responseCode.mMessage} ,Tutup dan buka aplikasi anda terlebih dahulu !",
                                          showNeutralButton: false,
                                          positiveText: "Oke",
                                          positiveAction: () {
                                        closeApp();
                                      }, title: "Warning!");
                                    }
                                  });
                                }
                              });
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Ada masalah login ?",
                          style: GoogleFonts.lato(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            _popUpTroble(context);
                          },
                          child: Text(
                            "Klik disini",
                            style: GoogleFonts.lato(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  "assets/image/main_top.png",
                  width: size.width * 0.35,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  "assets/image/login_bottom.png",
                  width: size.width * 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldEmail() {
    return TextFieldContainer(
      child: TextField(
        // enabled: uuidAnyar != "" ? false : true,
        controller: _controllerEmail,
        decoration: InputDecoration(
          icon: Icon(
            Icons.mail,
            color: primaryColor,
          ),
          hintText: "Email",
          fillColor: primaryColor,
          border: InputBorder.none,
          errorText:
              _fieldEmail == null || _fieldEmail ? null : "Email Harus Diisi!",
        ),
        onChanged: (value) {
          bool isFieldValid = value.trim().isNotEmpty;
          print("JUJUJUJ : " + value.toString());
          if (isFieldValid != _fieldEmail) {
            setState(() => _fieldEmail = isFieldValid);
          }
        },
      ),
    );
  }

  Widget _buildTextFieldPassword() {
    return TextFieldContainer(
      child: TextField(
        controller: _controllerPassword,
        keyboardType: TextInputType.text,
        obscureText: _obsecureText,
        decoration: InputDecoration(
          icon: Icon(
            Icons.lock,
            color: primaryColor,
          ),
          suffixIcon: IconButton(
            onPressed: _toggle,
            icon: new Icon(
                _obsecureText ? Icons.remove_red_eye : Icons.visibility_off),
          ),
          hintText: "Password",
          fillColor: primaryColor,
          border: InputBorder.none,
          errorText: _fieldPassword == null || _fieldPassword
              ? null
              : "Password Harus Diisi!",
        ),
        onChanged: (value) {
          bool isFieldValid = value.trim().isNotEmpty;
          if (isFieldValid != _fieldPassword) {
            setState(() => _fieldPassword = isFieldValid);
          }
        },
      ),
    );
  }
}

void _popUpTroble(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Container(
            width: 250,
            height: 270,
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              color: const Color(0xFFFFFF),
              borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          height: 18.0,
                          width: 18.0,
                          color: Colors.red,
                          child: new IconButton(
                              padding: new EdgeInsets.all(0.0),
                              icon: new Icon(
                                Icons.close_rounded,
                                size: 18,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ),
                      ),
                      Row(
                        children: [
                          Text("Ganti Perangkat",
                              style: GoogleFonts.lato(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                          "Ganti Perangkat digunakan ketika anda menginstall ulang aplikasi atau ganti perangkat.",
                          style: GoogleFonts.lato(fontSize: 12)),
                      Container(
                          width: 900,
                          child: FlatButton(
                              color: Colors.red[900],
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Reset(
                                              tipe: "ResetDevice",
                                            )));
                              },
                              child: Text(
                                'Ganti Perangkat',
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ))),
                      SizedBox(
                        height: 15,
                      ),
                      Text("Reset Password",
                          style: GoogleFonts.lato(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                          "Reset Password digunakan ketika anda lupa password ataupun ingin mengubah password yang sudah diset.",
                          style: GoogleFonts.lato(fontSize: 12)),
                      Container(
                          width: 900,
                          child: FlatButton(
                              color: Colors.blue,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Reset(
                                              // resetpass: Forgot_Password,
                                              tipe: "ResetPassword",
                                            )));
                              },
                              child: Text(
                                'Reset Password',
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ))),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      });
}
