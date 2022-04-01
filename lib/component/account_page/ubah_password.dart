import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:horang/api/models/pin/edit.password.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/DashboardPage/home_page.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/reusable.class.dart';
import 'package:horang/widget/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/dialog.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
RegExp regx = RegExp(r"^[a-z0-9_]*$", caseSensitive: false);

class UbahPass extends StatefulWidget {
  // Password password;
  // UbahPass({required this.password});

  @override
  _UbahPassState createState() => _UbahPassState();
}

class _UbahPassState extends State<UbahPass> {
  SharedPreferences? sp;
  ApiService _apiService = ApiService();
  late bool _isLoading = false,
      _obsecureTextpasslama = true,
      _obsecureTextpaslama = true,
      _obsecureTextpassbaru = true,
      _obsecureTextpasbaru = true,
      _obsecureTextpassretype = true,
      _obsecureTextpasretype = true,
      _isFieldpassLama = false,
      _isFieldpassBaru = false,
      _isFieldpassRetype = false,
      isSuccess = true;
  late var token = "",
      newtoken = "",
      access_token,
      refresh_token,
      idcustomer = "",
      nama_customer,
      pin;
  var tekan1x = true;
  late String passlama, passbaru, retypepass;

  TextEditingController _controllerPasslama = TextEditingController();
  TextEditingController _controllerPassbaru = TextEditingController();
  TextEditingController _controllerPassretype = TextEditingController();

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp!.getString("access_token");
    refresh_token = sp!.getString("refresh_token");
    // idcustomer = sp!.getString("idcustomer");
    nama_customer = sp!.getString("nama_customer");
    pin = sp!.getString("pin");
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
                          sp!.setString("access_token", newtoken);
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
    // if (widget.password != null) {
    //   _isFieldpassLama = true;
    //   _controllerPasslama.text = widget.password.passwordlama;
    //
    //   _isFieldpassBaru = true;
    //   _controllerPassbaru.text = widget.password.passwordbaru;
    // }
    super.initState();
    cekToken();
  }

  void _togglepasslama() {
    setState(() {
      _obsecureTextpasslama = !_obsecureTextpasslama;
      _obsecureTextpaslama = !_obsecureTextpaslama;
    });
  }

  //tambahan toogle untuk show/hiden text (req. 30/08/21 by sahrul)
  void _togglepassbaru() {
    setState(() {
      _obsecureTextpassbaru = !_obsecureTextpassbaru;
      _obsecureTextpasbaru = !_obsecureTextpasbaru;
    });
  }

  void _toggleretype() {
    setState(() {
      _obsecureTextpassretype = !_obsecureTextpassretype;
      _obsecureTextpasretype = !_obsecureTextpasretype;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Ubah Kata Sandi",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildTextFieldPassLama(),
                _buildTextFieldPassBaru(),
                _buildTextFieldRetypePassBaru(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width,
                    height: 50,
                    child: RaisedButton(
                      child: Text("Simpan"),
                      onPressed: () {
                        print(
                            'tessuhu ${_controllerPasslama.text} 9$_isFieldpassLama 9');
                        // if (!tekan1x) {
                        // return warningDialog(context, "tekan lebih 1x");
                        //   return true;
                        // }
                        // tekan1x = false;
                        // warningDialog(context, "tes aja");
                        if (_isFieldpassLama == null ||
                            _isFieldpassBaru == null ||
                            !_isFieldpassLama ||
                            !_isFieldpassBaru) {
                          Fluttertoast.showToast(
                              msg: "Pastikan semua kolom terisi !",
                              // msg: "Account has been ready !",
                              backgroundColor: Colors.black,
                              textColor: Colors.white);
                          // warningDialog(
                          //     context, "Pastikan semua kolom terisi !");
                          // return;
                        } else {
                          setState(() => _isLoading = true);
                          Password password = Password(
                              passwordlama: _controllerPasslama.text.toString(),
                              passwordbaru: _controllerPassbaru.text.toString(),
                              token: access_token);
                          print("MUI $password ${_apiService.responseCode.sStatusCode}");
                          if (_controllerPassbaru.text !=
                              _controllerPassretype.text) {
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.LEFTSLIDE,
                              headerAnimationLoop: false,
                              dialogType: DialogType.WARNING,
                              showCloseIcon: true,
                              title: 'Warning',
                              desc:
                                  'Password baru tidak sama dengan retype password',
                              btnOkOnPress: () {},
                              btnOkIcon: Icons.check_circle,
                            )..show();
                            // warningDialog(context,
                            //     "Password baru tidak sama dengan retype password",
                            //     showNeutralButton: false,
                            //     positiveText: 'Ok',
                            //     positiveAction: () {});
                          } else {
                            _apiService.UbahPassword(password)
                                .then((isSuccess) {
                              setState(() => _isLoading = false);
                              // print("dede ${_apiService.responseCode}");
                              if (isSuccess) {
                                print("sukses");
                                AwesomeDialog(
                                  context: context,
                                  animType: AnimType.LEFTSLIDE,
                                  headerAnimationLoop: false,
                                  dialogType: DialogType.SUCCES,
                                  showCloseIcon: true,
                                  title: 'Success',
                                  desc: 'Ubah password berhasil disimpan',
                                  btnOkOnPress: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Home(
                                                  initIndexHome: 0,
                                                  callpage: HomePage(),
                                                )),
                                        (Route<dynamic> route) => false);
                                  },
                                  btnOkIcon: Icons.check_circle,
                                )..show();
                                // successDialog(
                                //     context, "Ubah password berhasil disimpan",
                                //     showNeutralButton: false,
                                //     positiveText: "Okeh", positiveAction: () {
                                // Navigator.pushAndRemoveUntil(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (BuildContext context) =>
                                //             Home(
                                //               initIndexHome: 0,
                                //               callpage: HomePage(),
                                //             )),
                                //     (Route<dynamic> route) => false);
                                // });
                              } else {
                                if (_apiService.responseCode == "401") {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Password lama yang anda masukkan salah.",
                                      // msg: "Account has been ready !",
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white);
                                  // errorDialog(context,
                                  //     "Password lama yang anda masukkan salah.");
                                }
                                Fluttertoast.showToast(
                                    msg:
                                        "Ubah Password gagal disimpan, silahkan dicek ulang.",
                                    // msg: "Account has been ready !",
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white);
                                // errorDialog(context,
                                //     "Ubah Password gagal disimpan, silahkan dicek ulang");
                              }
                            });
                          }
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextFieldPassLama() {
    return TextField(
      controller: _controllerPasslama,
      keyboardType: TextInputType.text,
      obscureText: _obsecureTextpasslama,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: _togglepasslama,
          icon: new Icon(_obsecureTextpasslama
              ? Icons.remove_red_eye
              : Icons.visibility_off),
        ),
        labelText: "Password lama",
        errorText: _isFieldpassLama == null || _isFieldpassLama
            ? null
            : "Password is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldpassLama) {
          setState(() => _isFieldpassLama = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldPassBaru() {
    return TextFormField(
      controller: _controllerPassbaru,
      obscureText: _obsecureTextpassbaru,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: _togglepassbaru,
            icon: new Icon(_obsecureTextpassbaru
                ? Icons.remove_red_eye
                : Icons.visibility_off),
          ),
          labelText: "Password baru",
          errorText: _isFieldpassBaru == true || _isFieldpassBaru
              ? null
              : "Password is required"),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldpassBaru) {
          setState(() => _isFieldpassBaru = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldRetypePassBaru() {
    return TextFormField(
      controller: _controllerPassretype,
      keyboardType: TextInputType.text,
      obscureText: _obsecureTextpassretype,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: _toggleretype,
          icon: new Icon(_obsecureTextpassretype
              ? Icons.remove_red_eye
              : Icons.visibility_off),
        ),
        labelText: "Retype Password",
        errorText: _isFieldpassRetype == null || _isFieldpassRetype
            ? null
            : "Retype Password is required",
      ),
      onChanged: (value) {
        // bool isFieldValid = value.trim().isNotEmpty;
        if (value != _controllerPassbaru.text) {
          print("Password tidak sama1");
          _scaffoldState.currentState!
              .showSnackBar(SnackBar(content: Text("Password tidak sama")));
        }
      },
    );
  }

  void showDefaultSnackbar(BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Hello from the default snackbar'),
        action: SnackBarAction(
          label: 'Click Me',
          onPressed: () {},
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
