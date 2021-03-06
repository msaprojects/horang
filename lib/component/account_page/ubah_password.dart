import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:horang/api/models/pin/edit.password.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/reusable.class.dart';
import 'package:horang/widget/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
RegExp regx = RegExp(r"^[a-z0-9_]*$", caseSensitive: false);

class UbahPass extends StatefulWidget {
  Password password;
  UbahPass({this.password});

  @override
  _UbahPassState createState() => _UbahPassState();
}

class _UbahPassState extends State<UbahPass> {
  SharedPreferences sp;
  ApiService _apiService = ApiService();
  bool _isLoading = false,
      _obsecureText = true,
      _obsecureText1 = true,
      _isFieldpassLama,
      _isFieldpassBaru,
      _isFieldpassRetype,
      isSuccess = true;
  var token = "",
      newtoken = "",
      access_token,
      refresh_token,
      idcustomer = "",
      nama_customer,
      pin;
  var tekan1x = true;
  String passlama, passbaru, retypepass;

  TextEditingController _controllerPasslama = TextEditingController();
  TextEditingController _controllerPassbaru = TextEditingController();
  TextEditingController _controllerPassretype = TextEditingController();

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
    if (widget.password != null) {
      _isFieldpassLama = true;
      _controllerPasslama.text = widget.password.passwordlama;

      _isFieldpassBaru = true;
      _controllerPassbaru.text = widget.password.passwordbaru;
    }
    super.initState();
    cekToken();
  }

  void _toggle() {
    setState(() {
      _obsecureText = !_obsecureText;
      _obsecureText1 = !_obsecureText1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Ubah Password",
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
                  child: RaisedButton(
                    child: Text("simpan"),
                    onPressed: () {
                      if (!tekan1x) {
                        // return warningDialog(context, "tekan lebih 1x");
                        return true;
                      }
                      tekan1x = false;
                      // warningDialog(context, "tes aja");
                      if (_isFieldpassLama == null ||
                          _isFieldpassBaru == null ||
                          !_isFieldpassLama ||
                          !_isFieldpassBaru) {
                        _scaffoldState.currentState.showSnackBar(SnackBar(
                          content: Text("Please Fill all field"),
                        ));
                        return;
                      }
                      setState(() => _isLoading = true);
                      Password password = Password(
                          passwordlama: _controllerPasslama.text.toString(),
                          passwordbaru: _controllerPassbaru.text.toString(),
                          token: access_token);
                      if (_controllerPassbaru.text !=
                          _controllerPassretype.text) {
                        return warningDialog(context,
                            "Password baru tidak sama dengan retype password");
                      } else {
                        _apiService.UbahPassword(password).then((isSuccess) {
                          setState(() => _isLoading = false);
                          print("dede ${_apiService.responseCode}");
                          if (isSuccess) {
                            print("sukses");
                            successDialog(
                                context, "Ubah password berhasil disimpan",
                                showNeutralButton: false,
                                positiveText: "Okeh", positiveAction: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) => Home(
                                            initIndexHome: 0,
                                          )),
                                  (Route<dynamic> route) => false);
                            });
                          } else {
                            if (_apiService.responseCode == "401") {
                              errorDialog(context,
                                  "Password lama yang anda masukkan salah.");
                            }
                            errorDialog(context,
                                "Ubah Password gagal disimpan, silahkan dicek ulang");
                          }
                        });
                      }
                    },
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
      obscureText: _obsecureText,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: _toggle,
          icon: new Icon(
              _obsecureText ? Icons.remove_red_eye : Icons.visibility_off),
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
      obscureText: _obsecureText,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: _toggle,
            icon: new Icon(
                _obsecureText ? Icons.remove_red_eye : Icons.visibility_off),
          ),
          labelText: "Password baru",
          errorText: _isFieldpassBaru == null || _isFieldpassBaru
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
      obscureText: _obsecureText,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: _toggle,
          icon: new Icon(
              _obsecureText ? Icons.remove_red_eye : Icons.visibility_off),
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
          _scaffoldState.currentState
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
