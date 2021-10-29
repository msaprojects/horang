import 'dart:async';
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
      // emaile,
      namae = "";
  Timer timer;
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  void _toggle() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  Future refreshLogin() async {
    await Future.delayed(Duration(seconds: 15));
    print('masuk1');
    if (this.mounted) {
      setState(() {
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        print('masuk3');
        GetDeviceID().getDeviceID(context).then((cekuuids) {
          print('masuk4');
          uuidAnyar = cekuuids;
          CekLoginUUID uuid = CekLoginUUID(uuid: uuidAnyar);
          _apiService.cekLoginUUID(uuid).then((value) => setState(() {
                print("HEM : " + value);
                if (value == "") {
                  email = "";
                  print('masuk2');
                } else {
                  print('masuk5');
                  email = value.split(":")[0].toString();
                  namae = value.split(":")[1].toString();
                  // return value;
                  // return email.toString();
                }
              }));
        });
        // });
      });
    }
  }

  //FIREBASE
  @override
  void initState() {
    namae = widget.nama;
    uuidAnyar = widget.cekUUID;
    // emaile = widget.email;
    email = widget.email;
    print("flo $email");
    timer = Timer.periodic(Duration(seconds: 15), (Timer t) => refreshLogin());
    // if (emaile == "") {

    // } else {
    // if(emaile != ""){

    // }
    // }
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
      // if (emaile == "") {
      if (email == "") {
        emailaccountselection = _controllerEmail.text.toString();
      } else {
        // emailaccountselection = emaile.toString();
        emailaccountselection = email.toString();
        print('cektes $emailaccountselection');
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
                    // filter jika profile belum lengkap maka ketika login user harus masuk dengan mengetikkan email secara manual
                    // emaile == ""
                    email == ""
                        ? _buildTextFieldEmail()
                        : Padding(
                            padding: EdgeInsets.only(left: 50),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Halo,",
                                      style: GoogleFonts.lato(fontSize: 16)),
                                  Text(namae,
                                      style: GoogleFonts.lato(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  // Text(emaile,
                                  Text(email,
                                      style: GoogleFonts.lato(fontSize: 12)),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                ],
                              ),
                            ),
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
                            LoginClick();
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
                        Column(
                          children: [
                            Text(
                              "Ada masalah login ?",
                              style: GoogleFonts.lato(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ],
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

  LoginClick() {
    //checking if email or password empty
    // if (!_fieldEmail || !_fieldPassword) {
    //   warningDialog(context, "Pastikan Semua Kolom Terisi!");
    // } else {
    //getting uuid for validation
    GetDeviceID().getDeviceID(context).then((ids) {
      setState(() {
        // set variable
        iddevice = ids;
        _isLoading = true;
        String email1 = _controllerEmail.text.toString();
        String password1 = _controllerPassword.text.toString();
        print('tescek1 $email ~ $email1 ~ $emailaccountselection');
        // set model value for json
        PenggunaModel pengguna = PenggunaModel(
            uuid: iddevice,
            email: emailaccountselection != "" ? email : emailaccountselection,
            password: password1,
            status: 0,
            notification_token: token,
            token_mail: "0",
            keterangan: "Login");

        //execute sending json to api url
        print("LOGIN? : " + pengguna.toString());
        _apiService.loginIn(pengguna).then((isSuccess) {
          setState(() => _isLoading = false);
          // if login success page will be route to home page
          if (isSuccess) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Home()));
          } else {
            // if login failed will be show message json from api url
            print('${_apiService.responseCode.mMessage}');
            if (_apiService.responseCode.mMessage ==
                "Email atau Password anda Salah!") {
              warningDialog(context, "${_apiService.responseCode.mMessage}",
                  title: "Warning!");
            } else if (_apiService.responseCode.mMessage ==
                "Akun masih aktif di device lain!") {
              warningDialog(context,
                  "${_apiService.responseCode.mMessage}, Anda harus melakukan aksi ganti perangkat terlebih dahulu.",
                  showNeutralButton: false,
                  positiveText: "Oke",
                  positiveAction: () {},
                  title: "Pemberitahuan!");
            }
          }
        });
      });
    });
  }
  // }
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
