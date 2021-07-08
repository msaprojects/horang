import 'package:commons/commons.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horang/api/models/pin/cek.pin.model.dart';
import 'package:horang/api/models/pin/tambah.pin.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/widget/bottom_nav.dart';
import 'package:local_auth/local_auth.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:pin_code_view/pin_code_view.dart';

class CobaKeyboard extends StatefulWidget {
  @override
  _CobaKeyboardState createState() => _CobaKeyboardState();
}

class _CobaKeyboardState extends State<CobaKeyboard> {

  ApiService _apiService = ApiService();
  var token = "", newtoken = "", access_token, refresh_token, token_notifikasi, codes;
  bool hasError = false,
      isSuccess = true,
      _checkbio = false,
      _canCheckBiometrics;
  String errorMessage;
  SharedPreferences sp;
  final firebaseMessaging = FirebaseMessaging();

  LocalAuthentication auth = LocalAuthentication();
  List<BiometricType> _availableBiometrics;
  String autherized = "Not auth";

  ////////////////////////////////// COBA FINGER
  Future<void> _checkBiometric() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted)
      return {
        setState(() {
          _canCheckBiometrics = canCheckBiometrics;
        })
      };
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: "Scan jari anda untuk konfirmasi",
          useErrorDialogs: true,
          stickyAuth: false);
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      autherized = authenticated ? "Auth sukses" : "gagal konfirm";
      if (access_token != "" && authenticated) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ));
      } else {
        print('Moh. Salah');
      }
      print(autherized);
    });
  }

  cekToken() async {
    print("MASUK CEK TOKEN");
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    print("Jasukeeeeeeeeeeeee $access_token");

    if (access_token == null) {
      print("cek debug 1");
      warningDialog(context,
          "Harap masukkan kembali email beserta nomor handphone untuk mengakses fitur di aplikasi ini.",
          title: "Sesi anda berakhir !",
          showNeutralButton: false, positiveAction: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
            (Route<dynamic> route) => false);
      }, positiveText: "Ok");
    } else {
      print("cek debug 2");
      _apiService.checkingToken(access_token).then((value) => setState(() {
            print("cek debug 3");
            isSuccess = value;
            //checking jika token expired/tidak berlaku maka akan di ambilkan dari refresh token
            if (!isSuccess) {
              print("cek debug 4");
              _apiService
                  .refreshToken(refresh_token)
                  .then((value) => setState(() {
                        var newtoken = value;
                        //setting access_token dari refresh_token
                        if (newtoken != "") {
                          print("cek new tokennya ${newtoken.toString()}");
                          print("cek debug 5");
                          sp.setString("access_token", newtoken);
                          access_token = newtoken;
                          // infoDialog(context, "hei 1");
                          _checkBiometric();
                          _getAvailableBiometrics();
                          _authenticate();
                        } else {
                          print("cek debug 6 ${newtoken.toString()}");
                          warningDialog(context,
                              "Harap masukkan kembali email beserta nomor handphone untuk mengakses fitur di aplikasi ini.",
                              title: "Sesi anda berakhir 1!",
                              showNeutralButton: false, positiveAction: () {
                            // _deleteAppDir();
                            // _deleteCacheDir();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoginPage()));
                                // (Route<dynamic> route) => false);
                          }, positiveText: "Ok");
                        }
                      }));
            } else {
              print("cek debug 7");
              // infoDialog(context, "hei");
              // print(access_token);
              // print(refresh_token);
              _checkBiometric();
              _getAvailableBiometrics();
              _authenticate();
              // buildlist__();
            }
          }));
    }
  }

  cek(){
    print(codes+"adalah");
  if (access_token == null) {
    setState(() {
      Pin_Model_Cek pin_cek1 = Pin_Model_Cek(
                        pin_cek: codes,
                        token_cek: access_token,
                      );
      _apiService.CekPin(pin_cek1).then((isSuccess) {
                        setState(() {
                          if (isSuccess) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Home(),
                                ));
                            // Navigator.pop(
                            //     _scaffoldState.currentState.context);
                            // Text("data berhasil disimpam");
                          } else {
                            errorDialog(context, "salah");
                          }
                        });
                      });
    });
  }
}

  @override
  void initState() {
    firebaseMessaging.getToken().then((token_notifikasi) => setState(() {
          this.token_notifikasi = token_notifikasi;
        }));
    print("token 2 " + token_notifikasi.toString());
    print("Toookeeeeennnnn $access_token");
    // _checkBiometric();
    // _getAvailableBiometrics();
    // _authenticate();
    super.initState();
    cekToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PinCode(
        backgroundColor: Colors.blueAccent[700],
        codeLength: 4,
        keyTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 30.0
        ),
        // correctPin: '1234',
        codeTextStyle: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold
        ),
        title: Text('Welcome', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
        subTitle: Text('Fadil anggara'),
        obscurePin: false,
        onCodeSuccess: (codes){
          print("mm"+codes);
          confirmationDialog(
            context, 
            "Sukses"+codes);
        },
        onCodeFail: (codes){
          errorDialog(context, "Gagal"+codes);
        },
        correctPin: cek(),
      )
    );
  }
}