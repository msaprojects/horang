import 'dart:io';
import 'dart:ui';
import 'package:commons/commons.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/pengguna/pengguna.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/RegistrationPage/Registrasi.Input.dart';
import 'package:horang/component/account_page/AccountChecker.dart';
import 'package:horang/component/account_page/reset.dart';
import 'package:horang/utils/constant_color.dart';
import 'package:horang/widget/TextFieldContainer.dart';
import 'package:horang/widget/bottom_nav.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:local_auth/local_auth.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String uniqueId = "Unknown";
  String deviceId = "";

  LocalAuthentication _auth = LocalAuthentication();
  bool _isLoading = false, _obsecureText = true, _checkbio = false;
  ApiService _apiService = ApiService();
  bool _fieldEmail, _fieldPassword;
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  void _toggle() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  final scaffoldState = GlobalKey<ScaffoldState>();
  final controllerTopic = TextEditingController();
  bool isSubscribed = false;
  String token;
  static String dataName = '';
  static String dataAge = '';

  //FIREBASE
  final firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    firebaseMessaging.getToken().then((token) => setState(() {
          this.token = token;
        }));
    super.initState();
    print("jackmac111");
    initPlatformState();
  }

  // Future<void> initPlatformState() async {
    Future initPlatformState() async {
    String platformImei;
    String idunique;

    // try {
    //   platformImei =
    //       await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
    //   List<String> multiImei = await ImeiPlugin.getImeiMulti();
    //   print(multiImei);
    //   idunique = await ImeiPlugin.getId();
    // } on PlatformException {
    //   uniqueId = 'gagal mendapatkan mac UUID';
    // }
    DeviceInfoPlugin deviceinfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceinfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceinfo.androidInfo;
      return androidDeviceInfo.androidId;
    }
    if (!mounted) return;
    setState(() {
      uniqueId = idunique;
    });
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
  //END FIREBASE

  @override
  Widget build(BuildContext context) {
    print("UUID : " + uniqueId);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          key: _scaffoldState,
          width: double.infinity,
          height: size.height,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Login",
                      style: GoogleFonts.lato(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    // Image.asset(
                    //   "assets/image/logogudang.png",
                    //   height: 150,
                    //   width: 150,
                    // ),
                    _buildTextFieldEmail(), //textbox username (email / no hp)
                    _buildTextFieldPassword(),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      width: size.width * 0.8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(29),
                        child: FlatButton(
                          child: Text(uniqueId), // button login
                          textColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 40),
                          color: primaryColor,
                          onPressed: () {
                            if (_fieldEmail == null ||
                                _fieldPassword == null ||
                                !_fieldEmail ||
                                !_fieldPassword) {
                              _scaffoldState.currentState.showSnackBar(SnackBar(
                                content: Text("Harap isi Semua Kolom"),
                              ));
//                            return;
                            }
                            setState(() => _isLoading = true);
                            String email = _controllerEmail.text.toString();
                            String password =
                                _controllerPassword.text.toString();
                            print("///---///" + email + "///---///" + password);
                            PenggunaModel pengguna = PenggunaModel(
                                uuid: uniqueId,
                                email: email,
                                password: password,
                                status: 0,
                                notification_token: token,
                                token_mail: "0",
                                keterangan: "Uji Coba");
                            print("Post to Pengguna : " + pengguna.toString());
                            _apiService.xenditUrl();
                            _apiService.loginIn(pengguna).then((isSuccess) {
                              setState(() => _isLoading = false);
                              if (isSuccess) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()));
                              } else {
                                print("Login Gagal");
                                errorDialog(context,
                                    "Periksa kembali username dan password anda",
                                    title: "Login Gagal");
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    Text(
                      '$deviceId',
                      // ignore: deprecated_member_use
                      style: Theme.of(context).textTheme.display1,
                    ),
                    FlatButton(
                        onPressed: () {
                          initPlatformState().then((ids) {
                            setState(() {
                              deviceId = ids;
                            });
                          });
                        },
                        child: Text("Tekan disini aja UUID nya")),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Ada masalah login ? ",
                          style: GoogleFonts.lato(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        GestureDetector(
                          onTap: () {
                            _popUpTroble(context);
                          },
                          child: Text(
                            "Klik disini",
                            style: GoogleFonts.lato(
                                fontSize: 14, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(children: <Widget>[
                      Expanded(
                          child: Divider(
                        thickness: 1,
                        indent: 30,
                        endIndent: 12,
                      )),
                      Text(
                        "Atau",
                        style: GoogleFonts.lato(),
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 1,
                        indent: 12,
                        endIndent: 30,
                      )),
                    ]),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Container(
                    //       width: 100,
                    //       height: 70,
                    //       child: FlatButton(
                    //         height: 50,
                    //         child: Flexible(child: Text("Ganti Perangkat")),
                    //         color: Colors.deepPurpleAccent,
                    //         textColor: Colors.white,
                    //         onPressed: () {
                    //           Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) => Reset(
                    //                         tipe: "ResetDevice",
                    //                       )));
                    //         },
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: 3,
                    //     ),
                    //     Container(
                    //       width: 100,
                    //       height: 70,
                    //       child: FlatButton(
                    //         child:
                    //             Flexible(child: Text("Kirim Email Validasi")),
                    //         color: Colors.deepPurpleAccent,
                    //         textColor: Colors.white,
                    //         onPressed: () {
                    //           Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) => Reset(
                    //                         tipe: "ResendEmail",
                    //                       )));
                    //         },
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: 3,
                    //     ),
                    //     Container(
                    //       width: 100,
                    //       height: 70,
                    //       child: FlatButton(
                    //         child: Flexible(child: Text("Reset Password")),
                    //         color: Colors.deepPurpleAccent,
                    //         textColor: Colors.white,
                    //         onPressed: () {
                    //           Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) => Reset(
                    //                         // resetpass: Forgot_Password,
                    //                         tipe: "ResetPassword",
                    //                       )));
                    //         },
                    //       ),
                    //     ),
                    //     // ClipRRect(
                    //     //   borderRadius: BorderRadius.circular(29),
                    //     //   child: FlatButton(
                    //     //     onPressed: () {
                    //     //       Navigator.push(
                    //     //           context,
                    //     //           MaterialPageRoute(
                    //     //               builder: (context) => Reset(
                    //     //                     tipe: "ResendEmail",
                    //     //                     // resendemail: Forgot_Password,
                    //     //                   )));
                    //     //     },
                    //     //     child: Text(
                    //     //       "RESEND EMAIL",
                    //     //       style: GoogleFonts.lato(
                    //     //           fontSize: 12,
                    //     //           fontWeight: FontWeight.bold,
                    //     //           color: Colors.white),
                    //     //     ),
                    //     //     color: Colors.purple[100],
                    //     //     padding: EdgeInsets.symmetric(
                    //     //         vertical: 20, horizontal: 30),
                    //     //   ),
                    //     // ),
                    //     // SizedBox(
                    //     //   width: 10,
                    //     // ),
                    //     // ClipRRect(
                    //     //   borderRadius: BorderRadius.circular(29),
                    //     //   child: FlatButton(
                    //     //     onPressed: () {
                    //     //       Navigator.push(
                    //     //           context,
                    //     //           MaterialPageRoute(
                    //     //               builder: (context) => Reset(
                    //     //                     // resetpass: Forgot_Password,
                    //     //                     tipe: "ResetPassword",
                    //     //                   )));
                    //     //     },
                    //     //     child: Text("L",
                    //     //         style: GoogleFonts.lato(
                    //     //             fontSize: 12,
                    //     //             fontWeight: FontWeight.bold,
                    //     //             color: Colors.white)),
                    //     //     color: Colors.purple[100],
                    //     //     padding: EdgeInsets.symmetric(
                    //     //         vertical: 20, horizontal: 25),
                    //     //   ),
                    //     // )
                    //   ],
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    AccountChecker(
                      press: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return RegistrasiPage();
                            },
                          ),
                        );
                      },
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
}

void _popUpTroble(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Container(
            width: 250,
            height: 350,
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
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Opsi Pilihan...",
                              style: GoogleFonts.lato(fontSize: 14),
                            ),
                            IconButton(
                                iconSize: 14,
                                icon: Icon(
                                  Icons.close_outlined,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Lost Device",
                          style: GoogleFonts.lato(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                          "Lost Device digunakan ketika anda menginstall ulang aplikasi atau ganti perangkat.",
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
                                'Lost Device',
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
