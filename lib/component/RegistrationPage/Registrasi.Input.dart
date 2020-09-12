import 'package:flutter/material.dart';
import 'package:horang/api/models/pengguna/pengguna.model.dart';
import 'package:horang/api/models/responsecode/responcode.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/widget/TextFieldContainer.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class RegistrasiPage extends StatefulWidget {
  @override
  _RegistrasiState createState() => _RegistrasiState();
}

class _RegistrasiState extends State<RegistrasiPage> {
  bool _isLoading = false, _obsecureText = true, _obsecureText1 = true;
  ResponseCode responseCode;
  ApiService _apiService = ApiService();
  bool _fieldEmail = false,
      _fieldNo_Hp = false,
      _fieldPassword = false,
      _fieldPasswordRetype = false;
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerNohp = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  TextEditingController _controllerPasswordRetype = TextEditingController();

  void _toggle() {
    setState(() {
      _obsecureText = !_obsecureText;
      _obsecureText1 = !_obsecureText1;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        iconTheme: IconThemeData(color: Colors.grey),
        title: Text(
          "Registrasi",
          style: TextStyle(color: Colors.grey),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildTextFieldEmail(),
                  _buildTextFieldNoHp(),
                  _buildTextFieldPassword(),
                  _buildTextFieldPasswordRetype(),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: size.width * 0.8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(29),
                      child: FlatButton(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                        onPressed: () async {
                          if (_fieldEmail == null ||
                              _fieldNo_Hp == null ||
                              _fieldPassword == null ||
                              !_fieldEmail ||
                              !_fieldNo_Hp ||
                              !_fieldPassword) {
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                                content: Text("Pastikan semua kolom terisi!")));
                            return;
                          } else {
                            String email = _controllerEmail.text.toString();
                            String nohp = _controllerNohp.text.toString();
                            String password =
                                _controllerPassword.text.toString();
                            String retypepassword =
                                _controllerPasswordRetype.text.toString();
                            //IF (TRUE) STATEMENT1 -> FALSE STATEMENT2
                            if (password != retypepassword) {
                              _scaffoldState.currentState.showSnackBar(SnackBar(
                                content:
                                    Text("Password dan Retyp anda tidak sama"),
                              ));
//                              return;
                            } else {
                              setState(() => _isLoading = true);
                              Pengguna pengguna = Pengguna(
                                  email: email,
                                  no_hp: nohp,
                                  password: password,
                                  status: 0,
                                  notification_token: "0",
                                  token_mail: "0");
                              _apiService.signup(pengguna).then((isSuccess) {
                                if (isSuccess) {
                                  _controllerEmail.clear();
                                  _controllerNohp.clear();
                                  _controllerPassword.clear();
                                  _controllerPasswordRetype.clear();
                                  showAlertDialog(context);
                                  // _scaffoldState.currentState
                                  //     .showSnackBar(SnackBar(
                                  //   content: Text(
                                  //       "${_apiService.responseCode.mMessage}"),
                                  // ));
                                } else {
                                  _scaffoldState.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        "${_apiService.responseCode.mMessage}"),
                                  ));
                                }
                              });
                            }
                            return;
                          }
                        },
                        child: Text(
                          "Simpan".toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        color: Colors.orange[600],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded buildDivider() {
    return Expanded(
      child: Divider(
        color: Colors.black,
        height: 30,
      ),
    );
  }

  Widget _buildTextFieldEmail() {
    return TextFieldContainer(
      child: TextField(
        controller: _controllerEmail,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          icon: Icon(Icons.mail),
          hintText: "Email",
          border: InputBorder.none,
          errorText: _fieldEmail == null || _fieldEmail
              ? null
              : "Isi Email terlebih dahulu!",
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

  Widget _buildTextFieldNoHp() {
    return TextFieldContainer(
      child: TextField(
        controller: _controllerNohp,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          icon: Icon(Icons.phone),
          hintText: "No. Handphone",
          border: InputBorder.none,
          errorText: _fieldNo_Hp == null || _fieldNo_Hp
              ? null
              : "Nomor Handphone Harus Diisi!",
        ),
        onChanged: (value) {
          bool isFieldValid = value.trim().isNotEmpty;
          if (isFieldValid != _fieldNo_Hp) {
            setState(() => _fieldNo_Hp = isFieldValid);
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
          icon: Icon(Icons.lock),
          suffixIcon: IconButton(
            onPressed: _toggle,
            icon: new Icon(
                _obsecureText ? Icons.remove_red_eye : Icons.visibility_off),
          ),
          hintText: "Password",
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

  Widget _buildTextFieldPasswordRetype() {
    return TextFieldContainer(
      child: TextField(
        controller: _controllerPasswordRetype,
        keyboardType: TextInputType.text,
        obscureText: _obsecureText1,
        decoration: InputDecoration(
          icon: Icon(Icons.lock),
          suffixIcon: IconButton(
            onPressed: _toggle,
            icon: new Icon(
                _obsecureText1 ? Icons.remove_red_eye : Icons.visibility_off),
          ),
          hintText: "Retype Password",
          border: InputBorder.none,
          errorText: _fieldPasswordRetype == null || _fieldPasswordRetype
              ? null
              : "Retype Password Harus Diisi!",
        ),
        onChanged: (value) {
          bool isFieldValid = value.trim().isNotEmpty;
          if (isFieldValid != _fieldPasswordRetype) {
            setState(() => _fieldPasswordRetype = isFieldValid);
          }
        },
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Registrasi Berhasil!"),
      content: Text(
          "Harap konfirmasi Email anda terlebih dahulu sebelum melakukan login."),
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
