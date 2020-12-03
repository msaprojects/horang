import 'package:commons/commons.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/pin/cek.pin.model.dart';
import 'package:horang/api/models/pin/tambah.pin.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/account_page/ubah_pin.dart';
import 'package:horang/widget/bottom_nav.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class pinauth extends StatefulWidget {
  @override
  _pinauthState createState() => _pinauthState();
}

class _pinauthState extends State<pinauth> {
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
    if (pinIndex == 0)
      pinIndex = 1;
    else if (pinIndex < 4) pinIndex++;
    setPin(pinIndex, text);
    currentPin[pinIndex - 1] = text;
    String strpin = "";
    currentPin.forEach((element) {
      strpin += element;
    });
    if (pinIndex == 4) print("joss" + strpin);
    if (access_token == null) {
      print("Cek pinModel: $access_token");
      TambahPin_model pin = TambahPin_model(
        // pin: thisText,
        token: access_token,
      );
      _apiService.TambahPin(pin).then((isSuccess) {
        setState(() {
          if (isSuccess) {
            {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (BuildContext context) => Home()),
                  (Route<dynamic> route) => true);
            }
          } else if (pin == null) {
            errorDialog(context, "Anda belum memiliki pin",
                showNeutralButton: false,
                positiveText: "Set Sekarang", positiveAction: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => UbahPin()),
                  (Route<dynamic> route) => false);
            });
          } else {
            errorDialog(
              context,
              "Maaf, sistem mendeteksi anda belum pernah login",
              positiveAction: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()),
                    (Route<dynamic> route) => false);
              },
              positiveText: "Login Sekarang",
              showNeutralButton: false,
            );
          }
        });
      });
    } else {
      setState(() {
        // this.thisText = controller.text;
        // print("Gassskaaan ========> $thisText");
        print("Cek pin: $strpin");
        Pin_Model_Cek pin_cek1 = Pin_Model_Cek(
          pin_cek: strpin,
          token_cek: access_token,
        );
        print("Cek PIN masuk maskuh: $pin_cek1");
        _apiService.CekPin(pin_cek1).then((isSuccess) {
          setState(() {
            if (isSuccess && pinIndex ==4) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ));
              // Navigator.pop(
              //     _scaffoldState.currentState.context);
              // Text("data berhasil disimpam");
            } else if (!isSuccess && pinIndex>=4) {
              print('Pin salah masku, iling iling maneh');
              errorDialog(
                context,
                "Pin yang anda masukkan salah",
              );
            }
          });
        });
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
              onPressed: () {}),
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
