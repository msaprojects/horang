import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/pengguna/pengguna.model.dart';
import 'package:horang/api/models/responsecode/responcode.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/account_page/reset.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/constant_color.dart';
import 'package:horang/utils/deviceinfo.dart';
import 'package:horang/widget/TextFieldContainer.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class RegistrasiPage extends StatefulWidget {
  @override
  _RegistrasiState createState() => _RegistrasiState();
}

class _RegistrasiState extends State<RegistrasiPage> {
  bool _isLoading = false,
      _obsecureTextpass = true,
      _obsecureTextpass1 = true,
      _obsecureTextpassretype = true,
      _obsecureTextpassretype1 = true,
      boolsk = false;
  int ssk;
  var buttonVisible = false.obs;
  ApiService _apiService = ApiService();
  bool _fieldEmail = false,
      _fieldNo_Hp = false,
      _fieldPassword = false,
      _fieldPasswordRetype = false;
  var iddevice;
  var sk;
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerNohp = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  TextEditingController _controllerPasswordRetype = TextEditingController();
  final scrollController = ScrollController();

  void _toggle() {
    setState(() {
      _obsecureTextpass = !_obsecureTextpass;
      _obsecureTextpass1 = !_obsecureTextpass1;
    });
  }

  void _toggle1() {
    setState(() {
      _obsecureTextpassretype = !_obsecureTextpassretype;
      _obsecureTextpassretype1 = !_obsecureTextpassretype1;
    });
  }

  String data = '';
  fetchFileData() async {
    String responseText;
    responseText =
        await rootBundle.loadString('assets/res/syaratketentuan.txt');
  }

  Future<String> _ambildataSK() async {
    http.Response response = await http.get(
        Uri.encodeFull('https://dev.horang.id/adminmaster/skregistrasi.txt'));
    // .get(Uri.encodeFull('https://server.horang.id/adminmaster/skorder.txt'));
    return sk = response.body;
  }

  @override
  void initState() {
    GetDeviceID().getDeviceID(context).then((ids) {
      setState(() {
        iddevice = ids;
      });
    });
    super.initState();
    _ambildataSK();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(15.0),
                // color: Colors.red,
              ),
              Container(
                // padding: EdgeInsets.only(top: 50),
                width: double.infinity,
                height: size.height,
                key: _scaffoldState,
                child: Container(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(15.0),
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
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: boolsk,
                                    onChanged: (bool syaratketentuan) {
                                      setState(() {
                                        boolsk = syaratketentuan;
                                        if (boolsk == true) {
                                          ssk = 1;
                                          buttonVisible.value = false;
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) =>
                                                  WillPopScope(
                                                    onWillPop: () async =>
                                                        false,
                                                    child: AlertDialog(
                                                      title: Text(
                                                          'Syarat dan Ketentuan'),
                                                      content:
                                                          SingleChildScrollView(
                                                        controller:
                                                            scrollController,
                                                        child: Text('$sk'),
                                                      ),
                                                      actions: [
                                                        ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                Text('Setuju'))
                                                        // Obx(() => Visibility(
                                                        //     visible:
                                                        //         buttonVisible.value,
                                                        //     child: ElevatedButton(
                                                        //       child: Text("Setuju"),
                                                        //       onPressed: () {
                                                        //         ssk = 1;
                                                        //         Navigator.pop(
                                                        //             context);
                                                        //         print('$boolsk');
                                                        //       },
                                                        //     )))
                                                      ],
                                                    ),
                                                  ));
                                          print("ssk $ssk");
                                        } else {
                                          ssk = 0;
                                          print("ssk1 $ssk");
                                        }
                                      });
                                    },
                                  ),
                                  Text("Syarat & ketentuan")
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 0),
                              width: size.width * 0.8,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(29),
                                // ignore: deprecated_member_use
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
                                      warningDialog(context,
                                          "Pastikan Semua Kolom Terisi!");
                                      return;
                                    } else {
                                      String email =
                                          _controllerEmail.text.toString();
                                      String nohp =
                                          _controllerNohp.text.toString();
                                      String password =
                                          _controllerPassword.text.toString();
                                      String retypepassword =
                                          _controllerPasswordRetype.text
                                              .toString();
                                      //IF (TRUE) STATEMENT1 -> FALSE STATEMENT2
                                      if (password != retypepassword) {
                                        warningDialog(context,
                                            "Pastikan Password yang anda masukkan sama");
                                      } else if (ssk == null) {
                                        warningDialog(context,
                                            'Pastikan Syarat dan ketentuan sudah dibaca dan disetujui !');
                                      } else {
                                        // setState(() {
                                        //   _isLoading = true;
                                        infoDialog(context,
                                            "Data yang anda masukkan sudah benar ?",
                                            showNeutralButton: false,
                                            negativeText: "Batal",
                                            negativeAction: () {},
                                            positiveText: "Ya",
                                            positiveAction: () {
                                          GetDeviceID()
                                              .getDeviceID(context)
                                              .then((ids) {
                                            setState(() {
                                              iddevice = ids;
                                              PenggunaModel pengguna =
                                                  PenggunaModel(
                                                      uuid: iddevice,
                                                      email: email,
                                                      password: password,
                                                      no_hp: nohp,
                                                      status: 0,
                                                      notification_token: "0",
                                                      token_mail: "0",
                                                      keterangan: "Uji Coba");
                                              print("Registrasi Value : " +
                                                  pengguna.toString());
                                              _apiService
                                                  .signup(pengguna)
                                                  .then((isSuccess) {
                                                if (isSuccess) {
                                                  _controllerEmail.clear();
                                                  _controllerNohp.clear();
                                                  _controllerPassword.clear();
                                                  _controllerPasswordRetype
                                                      .clear();
                                                  successDialog(context,
                                                      "Harap konfirmasi Email anda terlebih dahulu sebelum melakukan login.",
                                                      showNeutralButton: false,
                                                      positiveText: "OK",
                                                      positiveAction: () {
                                                    Navigator.of(context)
                                                        .pushAndRemoveUntil(
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    // LoginPage()
                                                                    WelcomePage()),
                                                            (route) => false);
                                                  });
                                                } else {
                                                  errorDialog(context,
                                                      "${_apiService.responseCode.mMessage}");
                                                }
                                              });
                                            });
                                          });
                                          // print("IDDEVICE : " + iddevice.toString());
                                          // });
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
                            //UPDATE PERUBAHAN DIGANTI DI HALAAMAN WELCOMEPAGE (req.sahrul 30/08/21)
                            // Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: <Widget>[
                            //       Text(
                            //         "Anda tidak menerima email ? ",
                            //         style: GoogleFonts.lato(),
                            //       ),
                            //       GestureDetector(
                            //           onTap: () {},
                            //           child: GestureDetector(
                            //             onTap: () {
                            //               Navigator.push(
                            //                   context,
                            //                   MaterialPageRoute(
                            //                       builder: (context) => Reset(
                            //                             tipe: "ResendEmail",
                            //                           )));
                            //             },
                            //             child: Text(
                            //               "Kirim email ulang",
                            //               style: TextStyle(
                            //                   fontWeight: FontWeight.bold,
                            //                   color: Colors.blue[900]),
                            //             ),
                            //           ))
                            //     ]),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 8.0),
                            // )
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldEmail() {
    return TextFieldContainer(
      child: Form(
        autovalidate: true,
        child: TextFormField(
          validator: (mail) => mail.isEmpty || !mail.contains("@")
              ? "Masukkan email yang valid"
              : null,
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
        obscureText: _obsecureTextpass,
        decoration: InputDecoration(
          icon: Icon(Icons.lock),
          suffixIcon: IconButton(
            onPressed: _toggle,
            icon: new Icon(_obsecureTextpass
                ? Icons.remove_red_eye
                : Icons.visibility_off),
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
        obscureText: _obsecureTextpassretype,
        decoration: InputDecoration(
          icon: Icon(Icons.lock),
          suffixIcon: IconButton(
            onPressed: _toggle1,
            icon: new Icon(_obsecureTextpassretype
                ? Icons.remove_red_eye
                : Icons.visibility_off),
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
}
