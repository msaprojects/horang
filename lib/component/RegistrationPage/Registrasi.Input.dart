import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/pengguna/pengguna.model.dart';
import 'package:horang/api/models/responsecode/responcode.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/utils/constant_color.dart';
import 'package:horang/widget/TextFieldContainer.dart';
import 'package:imei_plugin/imei_plugin.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class RegistrasiPage extends StatefulWidget {
  @override
  _RegistrasiState createState() => _RegistrasiState();
}

class _RegistrasiState extends State<RegistrasiPage> {
  bool _isLoading = false, _obsecureText = true, _obsecureText1 = true;
  ResponseCodeCustom responseCode;
  ApiService _apiService = ApiService();
  bool _fieldEmail = false,
      _fieldNo_Hp = false,
      _fieldPassword = false,
      _fieldPasswordRetype = false;
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerNohp = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  TextEditingController _controllerPasswordRetype = TextEditingController();

  String uniqueId = "Unknown";

  void _toggle() {
    setState(() {
      _obsecureText = !_obsecureText;
      _obsecureText1 = !_obsecureText1;
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformImei;
    String idunique;

    try {
      platformImei =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
      List<String> multiImei = await ImeiPlugin.getImeiMulti();
      print(multiImei);
      idunique = await ImeiPlugin.getId();
    } on PlatformException {
      uniqueId = 'gagal mendapatkan mac UUID';
    }
    if (!mounted) return;
    setState(() {
      uniqueId = idunique;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 80),
          width: double.infinity,
          height: size.height,
          key: _scaffoldState,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Registrasi",
                      style: GoogleFonts.lato(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
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
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 40),
                          onPressed: () async {
                            if (_fieldEmail == null ||
                                _fieldNo_Hp == null ||
                                _fieldPassword == null ||
                                !_fieldEmail ||
                                !_fieldNo_Hp ||
                                !_fieldPassword) {
                              _scaffoldState.currentState.showSnackBar(SnackBar(
                                  content:
                                      Text("Pastikan semua kolom terisi!")));
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
                                _scaffoldState.currentState
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      "Password dan Retyp anda tidak sama"),
                                ));
//                              return;
                              } else {
                                setState(() => _isLoading = true);
                                PenggunaModel pengguna = PenggunaModel(
                                    uuid: uniqueId,
                                    email: email,
                                    password: password,
                                    no_hp: nohp,
                                    status: 0,
                                    notification_token: "0",
                                    token_mail: "0",
                                    keterangan: "Uji Coba");
                                print("REGISTRASI : " + pengguna.toString());
                                _apiService.signup(pengguna).then((isSuccess) {
                                  if (isSuccess) {
                                    _controllerEmail.clear();
                                    _controllerNohp.clear();
                                    _controllerPassword.clear();
                                    _controllerPasswordRetype.clear();
                                    showAlertDialog(context);
                                  } else {
                                    _scaffoldState.currentState
                                        .showSnackBar(SnackBar(
                                      content:
                                          Text("${_apiService.responseCode}"),
                                    ));
                                  }
                                });
                              }
                              return;
                            }
                          },
                          child: Text(
                            "Simpan",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          color: primaryColor,
                        ),
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Anda tidak menerima email ? ",
                            style: GoogleFonts.lato(),
                          ),
                          GestureDetector(
                              onTap: () {},
                              child: Text(
                                "Kirim email ulang",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[900]),
                              ))
                        ]),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                    )
                  ],
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
        Navigator.pushReplacement(
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
