import 'package:commons/commons.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/pin/cek.pin.model.dart';
import 'package:horang/api/models/pin/tambah.pin.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/account_page/ubah_pin.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/widget/bottom_nav.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pinauth extends StatefulWidget {
  @override
  _PinauthState createState() => _PinauthState();
}

class _PinauthState extends State<Pinauth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Colors.deepPurple[200],
          Colors.blue[800],
        ],
        begin: Alignment.topRight,
      )),
      child: OtpScreen(),
    ));
  }
}

class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  ApiService _apiService = ApiService();
  var token = "",
      newtoken = "",
      access_token,
      refresh_token,
      token_notifikasi,
      pin;
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
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    pin = sp.getString("pin");
    if (access_token == null) {
      warningDialog(context,
          "Harap masukkan kembali email beserta nomor handphone untuk mengakses fitur di aplikasi ini.",
          title: "Sesi anda berakhir !",
          showNeutralButton: false, positiveAction: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
            (Route<dynamic> route) => false);
      }, positiveText: "Ok");
    } else {
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
                          _checkBiometric();
                          _getAvailableBiometrics();
                          _authenticate();
                        } else {
                          print("cek debug 6");
                          warningDialog(context,
                              "Harap masukkan kembali email beserta nomor handphone untuk mengakses fitur di aplikasi ini.",
                              title: "Sesi anda berakhir!",
                              showNeutralButton: false, positiveAction: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoginPage()),
                                (Route<dynamic> route) => false);
                          }, positiveText: "Ok");
                        }
                      }));
            } else {
              _checkBiometric();
              _getAvailableBiometrics();
              _authenticate();
            }
          }));
    }
  }

  @override
  void initState() {
    firebaseMessaging.getToken().then((token_notifikasi) => setState(() {
          this.token_notifikasi = token_notifikasi;
        }));
    super.initState();
    cekToken();
  }

  List<String> currentPin = ["", "", "", ""];
  TextEditingController pinsatuController = TextEditingController();
  TextEditingController pinduaController = TextEditingController();
  TextEditingController pintigaController = TextEditingController();
  TextEditingController pinempatController = TextEditingController();

  var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: Colors.transparent));
  int pinIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          buildExitButton(),
          Expanded(
              child: Container(
            alignment: Alignment(0, 0.5),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // pinIndexSetup(),
                buildSecurityText(),
                SizedBox(
                  height: 40.0,
                ),
                buildPinRow(),
              ],
            ),
          )),
          buildNumPad(),
        ],
      ),
    );
  }

  buildNumPad() {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(bottom: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KeyboardNumber(
                    n: 1,
                    onPressed: () {
                      pinIndexSetup("1");
                    },
                  ),
                  KeyboardNumber(
                    n: 2,
                    onPressed: () {
                      pinIndexSetup("2");
                    },
                  ),
                  KeyboardNumber(
                    n: 3,
                    onPressed: () {
                      pinIndexSetup("3");
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KeyboardNumber(
                    n: 4,
                    onPressed: () {
                      pinIndexSetup("4");
                    },
                  ),
                  KeyboardNumber(
                    n: 5,
                    onPressed: () {
                      pinIndexSetup("5");
                    },
                  ),
                  KeyboardNumber(
                    n: 6,
                    onPressed: () {
                      pinIndexSetup("6");
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KeyboardNumber(
                    n: 7,
                    onPressed: () {
                      pinIndexSetup("7");
                    },
                  ),
                  KeyboardNumber(
                    n: 8,
                    onPressed: () {
                      pinIndexSetup("8");
                    },
                  ),
                  KeyboardNumber(
                    n: 9,
                    onPressed: () {
                      pinIndexSetup("9");
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 60.0,
                    child: MaterialButton(
                      onPressed: null,
                      child: SizedBox(),
                    ),
                  ),
                  KeyboardNumber(
                    n: 0,
                    onPressed: () {
                      pinIndexSetup("0");
                    },
                  ),
                  Container(
                    width: 60.0,
                    child: MaterialButton(
                      height: 60.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60.0),
                      ),
                      onPressed: () {
                        clearPin();
                      },
                      child: Icon(
                        Icons.backspace_rounded,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  clearPin() {
    if (pinIndex == 0)
      pinIndex = 0;
    else if (pinIndex == 4) {
      setPin(pinIndex, "");
      currentPin[pinIndex - 1] = "";
      pinIndex--;
    } else {
      setPin(pinIndex, "");
      currentPin[pinIndex - 1] = "";
      pinIndex--;
    }
  }

  Widget pinIndexSetup(String text) {
    void Keluarr() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      cekToken();
      await preferences.clear();
      if (preferences.getString("access_token") == null) {
        print("SharePref berhasil di hapus");
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => LoginPage()));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => WelcomePage()),
            (route) => false);
      }
    }

    if (pinIndex == 0)
      pinIndex = 1;
    else if (pinIndex < 4) pinIndex++;
    setPin(pinIndex, text);
    currentPin[pinIndex - 1] = text;
    String strpin = "";
    currentPin.forEach((element) {
      strpin += element;
    });
    if (access_token == null) {
      Keluarr();
      errorDialog(context, "Sesi Anda Berakhir!, Harap Login Kembali.",
          title: "Sesi Berakhir", positiveText: "OK", positiveAction: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => WelcomePage()),
            (Route<dynamic> route) => true);
      });
    } else {
      setState(() {
        if (pin == "" || pin == null) {
          Keluarr();
          errorDialog(context, "Anda Belum membuat pin, Harap login kembali",
              title: "Pin Belum Dibuat",
              positiveText: "OK", positiveAction: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => WelcomePage()),
                (Route<dynamic> route) => true);
          });
        } else {
          Pin_Model_Cek pin_cek1 = Pin_Model_Cek(
              pin_cek: strpin,
              token_cek: access_token,
              // token_notifikasi: token_notifikasi
              );
          _apiService.CekPin(pin_cek1).then((isSuccess) {
            setState(() {
              if (isSuccess) {
                cekToken();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => Home()),
                    (Route<dynamic> route) => false);
              } else if (!isSuccess && pinIndex >= 4) {
                return showDialog(
                    context: context,
                    builder: (context) {
                      Future.delayed(Duration(milliseconds: 100), () {
                        Navigator.of(context).pop(true);
                      });
                      return AlertDialog(
                        title: Text("Pin salah"),
                      );
                    });
              }
            });
          });
        }
      });
    }
  }
  
  setPin(int n, String text) {
    switch (n) {
      case 1:
        pinsatuController.text = text;
        break;
      case 2:
        pinduaController.text = text;
        break;
      case 3:
        pintigaController.text = text;
        break;
      case 4:
        pinempatController.text = text;
        break;
    }
  }

  buildPinRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        PINnumber(
          outlineInputBorder: outlineInputBorder,
          textEditingController: pinsatuController,
        ),
        PINnumber(
          outlineInputBorder: outlineInputBorder,
          textEditingController: pinduaController,
        ),
        PINnumber(
          outlineInputBorder: outlineInputBorder,
          textEditingController: pintigaController,
        ),
        PINnumber(
          outlineInputBorder: outlineInputBorder,
          textEditingController: pinempatController,
        ),
      ],
    );
  }

  builTextTrueorFalse() {
    return Text("Pin yang anda masukkan salah, coba cek lagi !",
        style: GoogleFonts.lato(
          color: Colors.red,
          fontSize: 21.0,
          fontWeight: FontWeight.bold,
        ));
  }

  buildSecurityText() {
    return Text("Masukkan pin anda !",
        style: GoogleFonts.lato(
          color: Colors.white70,
          fontSize: 21.0,
          fontWeight: FontWeight.bold,
        ));
  }

  buildExitButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
              height: 50.0,
              minWidth: 50.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
              child: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => WelcomePage()),
                    (Route<dynamic> route) => false);
              }),
        )
      ],
    );
  }
}

class PINnumber extends StatelessWidget {
  final TextEditingController textEditingController;
  final OutlineInputBorder outlineInputBorder;
  PINnumber({this.textEditingController, this.outlineInputBorder});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,
      child: TextField(
        controller: textEditingController,
        enabled: false,
        obscureText: false,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16.0),
          border: outlineInputBorder,
          filled: true,
          fillColor: Colors.white30,
        ),
        style: GoogleFonts.lato(
          fontWeight: FontWeight.bold,
          fontSize: 21.0,
          color: Colors.white,
        ),
      ),
    );
  }
}

class KeyboardNumber extends StatelessWidget {
  final int n;
  final Function() onPressed;
  KeyboardNumber({this.n, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white30),
      alignment: Alignment.center,
      child: MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60.0),
        ),
        height: 90.0,
        child: Text(
          "$n",
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(
            fontSize: 24 * MediaQuery.of(context).textScaleFactor,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
