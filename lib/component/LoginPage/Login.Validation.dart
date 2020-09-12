import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:horang/api/models/pengguna/pengguna.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/RegistrationPage/Registrasi.Input.dart';
import 'package:horang/component/account_page/AccountChecker.dart';
import 'package:horang/utils/constant_color.dart';
import 'package:horang/widget/TextFieldContainer.dart';
import 'package:horang/widget/bottom_nav.dart';
import 'package:local_auth/local_auth.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
  
  @override
  Widget build(BuildContext context) {
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "LOGIN",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  // SvgPicture.asset(
                  //   "assets/svg/logo_gudang.svg",
                  //   height: 150,
                  //   width: 150,
                  // ),
                  _buildTextFieldEmail(), //textbox username (email / no hp)
                  _buildTextFieldPassword(), //textbox password
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: size.width * 0.8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(29),
                      child: FlatButton(
                        child: Text("LOGIN"), // button login
                        textColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 40),
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
                          String password = _controllerPassword.text.toString();
                          print("///---///" + email + "///---///" + password);
                          Pengguna pengguna = Pengguna(
                              email: email,
                              password: password,
                              status: 0,
                              notification_token: "0",
                              token_mail: "0");
                          _apiService.loginIn(pengguna).then((isSuccess) {
                            setState(() => _isLoading = false);
                            if (isSuccess) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home()));
                            } else {
                              print("Login Gagal");
//                              _scaffoldState.currentState.showSnackBar(SnackBar(
//                                content: Text("${_apiService.responseCode.mMessage}"),
//                              ));
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  AccountChecker(
                    press: () {
                      Navigator.push(
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
