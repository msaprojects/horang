import 'package:flushbar/flushbar.dart';
import 'package:flutter/services.dart';
import 'package:horang/api/models/pin/cek.pin.model.dart';
import 'package:horang/api/models/pin/pin.model.dart';
import 'package:horang/api/models/pin/tambah.pin.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/account_page/reset.dart';
import 'package:horang/component/account_page/ubah_pin.dart';
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
  TextEditingController controller = TextEditingController();
  String thisText = "";
  int pinLength = 4;
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
        // print("salah bro");
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => Pin2(),
        //     ));
        // Pin_Model_Cek a1 = Pin_Model_Cek(
        //   token_cek: access_token,
        // );
        // _apiService.CekPin(a1).then((isSuccess) {
        //   setState(() {
        //     if (isSuccess) {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => Home(),
        //           ));
      } else {
        print('Moh. Salah');
        // Pin_Model_Cek a1 = Pin_Model_Cek(
        //   token_cek: access_token,
        // );
        // _apiService.CekPin(a1).then((isSuccess) {
        //   setState(() {
        //     if (isSuccess) {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => Home(),
        //           ));
        //     }
        //   });
        // });
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => Home(),
        //     ));
      }
      print(autherized);
    });
  }

  // @override
  // void initState() {
  //   _checkBiometric();
  //   _getAvailableBiometrics();
  // }
  ///////////////////////////////// TUUTP FINGER

  cekToken() async {
    print("MASUK CEK TOKEN");
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    // access_token = access_token.toString();
    // refresh_token = refresh_token.toString();
    thisText = "";
    print("Jasukeeeeeeeeeeeee $access_token");
    //checking jika token kosong maka di arahkan ke menu login jika tidak akan meng-hold token dan refresh token
    // if (access_token == null) {
    //   showAlertDialog(context);
    //   Navigator.of(context).pushAndRemoveUntil(
    //       MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
    //       (Route<dynamic> route) => true);
    // } else {
    //   _apiService.checkingToken(access_token).then((value) => setState(() {
    //         isSuccess = value;
    //         //checking jika token expired/tidak berlaku maka akan di ambilkan dari refresh token
    //         if (!isSuccess) {
    //           _apiService
    //               .refreshToken(refresh_token)
    //               .then((value) => setState(() {
    //                     var newtoken = value;
    //                     //setting access_token dari refresh_token
    //                     if (newtoken != "") {
    //                       sp.setString("access_token", newtoken);
    //                       access_token = newtoken;
    //                     } else {
    //                       showAlertDialog(context);
    //                       Navigator.of(context).pushAndRemoveUntil(
    //                           MaterialPageRoute(
    //                               builder: (BuildContext context) =>
    //                                   LoginPage()),
    //                           (Route<dynamic> route) => true);
    //                     }
    //                   }));
    //         }
    //       }));
    // }
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
                  print("DONE $text");
                  //  onPressed: () {
                  if (access_token == null) {
                    setState(() {
                      this.thisText = controller.text;
                      print("Gassskaaan ========> $thisText");
                      print("Cek pinModel: $access_token");
                      TambahPin_model pin = TambahPin_model(
                        // pin: thisText,
                        token: access_token,
                      );
                      print("Cek PIN: $pin");
                      _apiService.TambahPin(pin).then((isSuccess) {
                        setState(() {
                          if (isSuccess) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (BuildContext context) => Home()),
                                (Route<dynamic> route) => true);
                          } else if (pin == null) {
                            // Text('Data gagal disimpan');
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
                      // print("Gassskaaan ========> $thisText");
                      // print("Cek pinModel: $access_token");
                      Pin_Model_Cek pin_cek1 = Pin_Model_Cek(
                        pin_cek: thisText,
                        token_cek: access_token,
                      );
                      print("Cek PIN masuk maskuh: $pin_cek1");
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
                            print('Pin salah masku, iling iling maneh');

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
              // InkWell(
              //   onTap: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => Reset(
              //                   tipe: "ResetPin",
              //                 )));
              //   },
              //   child: new Text(
              //     "Reset Pin",
              //     style: TextStyle(
              //       fontSize: 16,
              //     ),
              //   ),
              // ),
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
