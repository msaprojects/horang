import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lock_screen/flutter_lock_screen.dart';
import 'package:horang/api/models/pin/cek.pin.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/DashboardPage/home_page.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/account_page/ubah_pin.dart';
import 'package:horang/widget/bottom_nav.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PassScreen extends StatefulWidget {
  PassScreen({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _PassScreenState createState() => _PassScreenState();
}

class _PassScreenState extends State<PassScreen> {
  ApiService _apiService = ApiService();
  var token = "", newtoken = "", access_token, refresh_token;
  bool hasError = false,
      isSuccess = true,
      _checkbio = false,
      _canCheckBiometrics;
  String errorMessage;
  SharedPreferences sp;

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
          localizedReason: "Scan jari anda untuk konfirmasi mas",
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
    // print("Jasukeeeeeeeeeeeee $access_token");
    if (access_token == null) {
      warningDialog(context,
          "Harap masukkan kembali email beserta nomor handphone untuk mengakses fitur di aplikasi ini.",
          title: "Sesi anda berakhir",
          showNeutralButton: false,
          positiveText: "Ok", positiveAction: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
            (Route<dynamic> route) => false);
      });
    } else {
      _apiService.checkingToken(access_token).then((value) => setState(() {
            isSuccess = value;
            //checking jika token expired/tidak berlaku maka akan di ambilkan dari refresh token
            if (!isSuccess) {
              _apiService
                  .refreshToken(refresh_token)
                  .then((value) => setState(() {
                        var newtoken = value;
                        //setting access_token dari refresh_token
                        if (newtoken != "") {
                          sp.setString("access_token", newtoken);
                          access_token = newtoken;
                        } else {
                          warningDialog(context,
                              "Harap masukkan kembali email beserta nomor handphone untuk mengakses fitur di aplikasi ini.",
                              title: "Sesi anda berakhir",
                              showNeutralButton: false,
                              positiveText: "Ok", positiveAction: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoginPage()),
                                (Route<dynamic> route) => false);
                          });
                        }
                      }));
            }
          }));
    }
  }

  @override
  void initState() {
    print("Toookeeeeennnnn $access_token");
    _checkBiometric();
    _getAvailableBiometrics();
    _authenticate();
    super.initState();
    cekToken();
  }

  @override
  Widget build(BuildContext context) {
    // var myPass = 4;
    return LockScreen(
        title: "This is Screet ",
        passLength: 4,
        bgImage: "images/pass_code_bg.jpg",
        fingerPrintImage: "images/fingerprint.png",
        showFingerPass: true,
        // fingerFunction: biometrics,
        // fingerVerify: isFingerprint,
        borderColor: Colors.red,
        showWrongPassDialog: true,
        wrongPassContent: "Wrong pass please try again.",
        wrongPassTitle: "Opps!",
        wrongPassCancelButtonText: "Cancel",
        passCodeVerify: (passcode) async {
          Pin_Model_Cek pincek = Pin_Model_Cek(
              pin_cek: passcode.toString(), token_cek: access_token);
          print("pir $passcode");
          for (int i = 0; i < pincek.toString().length; i++) {
            print("$pincek $passcode");
            if (passcode[i] != pincek.toString()) {
              // return false;
              print('Pin salah masku, iling iling maneh');
              errorDialog(
                context,
                "Pin yang anda masukkan salah",
              );
            } else {
              toast("dude0");
              return _apiService.CekPin(pincek).then((isSuccess) {
                setState(() {
                  Navigator.of(context).pushReplacement(
                      new MaterialPageRoute(builder: (BuildContext context) {
                    return HomePage();
                  }));
                });
              });
            }
          }
          toast("dude");
          return true;
        },
        onSuccess: () {
          toast("dude2");
          Navigator.of(context).pushReplacement(
              new MaterialPageRoute(builder: (BuildContext context) {
            return HomePage();
          }));
        });
  }
}
