import 'package:flushbar/flushbar.dart';
import 'package:flutter/services.dart';
import 'package:horang/api/models/pin/cek.pin.model.dart';
import 'package:horang/api/models/pin/pin.model.dart';
import 'package:horang/api/models/pin/tambah.pin.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/account_page/reset.dart';
import 'package:horang/component/account_page/ubah_pin.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/reusable.class.dart';
import 'package:horang/widget/bottom_nav.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class Pin2 extends StatefulWidget {
  @override
  _Pin2State createState() => _Pin2State();
}

class _Pin2State extends State<Pin2> {
  SharedPreferences sp;
  LocalAuthentication auth = LocalAuthentication();
  List<BiometricType> _availableBiometrics, availableBiometrics;
  ApiService _apiService = ApiService();
  int pinLength = 4;
  bool hasError = false,
      isSuccess = true,
      _checkbio = false,
      authenticated = false,
      _canCheckBiometrics,
      canCheckBiometrics;
  var token = "",
      newtoken = "",
      access_token,
      refresh_token,
      idcustomer,
      nama_customer,
      pin,
      thisText = "";
  String autherized = "Not auth", errorMessage;
  TextEditingController controller = TextEditingController();
  ////////////////////////////////// COBA FINGER
  Future<void> _checkBiometric() async {
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
      }
    });
  }

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    idcustomer = sp.getString("idcustomer");
    nama_customer = sp.getString("nama_customer");
    pin = sp.getString("pin");
    //checking jika token kosong maka di arahkan ke menu login jika tidak akan meng-hold token dan refresh token
    if (access_token == null) {
      ReusableClasses().showAlertDialog(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => WelcomePage()),
          (Route<dynamic> route) => false);
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
                          ReusableClasses().showAlertDialog(context);
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      WelcomePage()),
                              (Route<dynamic> route) => false);
                        }
                      }));
            }
          }));
    }
  }

  @override
  void initState() {
    _checkBiometric();
    _getAvailableBiometrics();
    _authenticate();
    super.initState();
    cekToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 60.0),
                child: Text(thisText, style: Theme.of(context).textTheme.title),
              ),
              PinCodeTextField(
                autofocus: false,
                controller: controller,
                hideCharacter: true,
                highlight: true,
                highlightColor: Colors.blue,
                defaultBorderColor: Colors.black,
                hasTextBorderColor: Colors.green,
                maxLength: pinLength,
                hasError: hasError,
                maskCharacter: "*",

                onTextChanged: (text) {
                  setState(() {
                    hasError = false;
                  });
                },
                onDone: (text) {
                  if (access_token == null) {
                    setState(() {
                      this.thisText = controller.text;
                      TambahPin_model pin = TambahPin_model(
                        // pin: thisText,
                        token: access_token,
                      );
                      _apiService.TambahPin(pin).then((isSuccess) {
                        setState(() {
                          if (isSuccess) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (BuildContext context) => Home()),
                                (Route<dynamic> route) => true);
                          } else if (pin == null) {
                            // Text('Data gagal disimpan');
                            // ignore: deprecated_member_use
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                              content: Text('Anda belum memiliki pin'),
                              action: SnackBarAction(
                                label: "Set Pin",
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UbahPin()));
                                },
                              ),
                            ));
                          } else {
                            // Text('Data gagal disimpan');
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                              content: Text('Submit data failed'),
                            ));
                          }
                        });
                      });
                    });
                  } else {
                    setState(() {
                      this.thisText = controller.text;
                      Pin_Model_Cek pin_cek1 = Pin_Model_Cek(
                        pin_cek: thisText,
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
                            WidgetsBinding.instance
                                .addPostFrameCallback((timeStamp) {
                              Flushbar(
                                message: "Pin salah masku, iling iling maneh",
                                flushbarPosition: FlushbarPosition.BOTTOM,
                                icon: Icon(Icons.ac_unit),
                                flushbarStyle: FlushbarStyle.GROUNDED,
                                duration: Duration(seconds: 5),
                              )..show(_scaffoldState.currentState.context);
                            });
                          }
                        });
                      });
                    });
                  }
                  // };
                },
                // pinCodeTextFieldLayoutType: PinCodeTextFieldLayoutType.AUTO_ADJUST_WIDTH,
                keyboardType: TextInputType.number,
                wrapAlignment: WrapAlignment.start,
                pinBoxDecoration:
                    ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
                pinTextStyle: TextStyle(fontSize: 30.0),
                pinTextAnimatedSwitcherTransition:
                    ProvidedPinBoxTextAnimation.scalingTransition,
                pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
              ),
              Visibility(
                child: Text(
                  "Wrong PIN!",
                  style: TextStyle(color: Colors.red),
                ),
                visible: hasError,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Lupa Pin ? ",
                    style: TextStyle(fontSize: 16),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Reset(
                                    tipe: "ResetPin",
                                  )));
                    },
                    child: new Text(
                      " Reset Pin",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {},
    );

    AlertDialog alert = AlertDialog(
      title: Text("Data Berhasil Disimpan"),
      content: Text("dalskdlasd"),
      actions: [
        okButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}
