import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horang/api/models/forgot/forgot.password.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:imei_plugin/imei_plugin.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class Reset extends StatefulWidget {
  var tipe;
  Forgot_Password respass, respin, resemail;
  var resetpass, resetpin, resendemail;
  Reset({this.resetpass, this.resetpin, this.resendemail, this.tipe});
  @override
  _ResetState createState() => _ResetState();
}

class _ResetState extends State<Reset> {
  bool _isLoading = false, _email, _isFieldEmail;
  String emails, tipes, judul;
  String uniqueId = "Unknown";
  TextEditingController _controlleremail = TextEditingController();
  ApiService _apiService = ApiService();

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
  void initState() {
    tipes = widget.tipe;
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    if (tipes == "ResendEmail") {
      judul = "Resend Email";
    } else if (tipes == "ResetPassword") {
      judul = "Reset Password";
    } else if (tipes == "ResetPin") {
      judul = "Reset Pin";
    } else if (tipes == "ResetDevice") {
      judul = "Lost Device";
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Reset",
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
      body: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 30),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  child: Column(
                children: <Widget>[
                  Text(
                    judul.toString(),
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Masukkan alamat email anda yang terhubung dengan akun anda !",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: _controlleremail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width,
                    height: 50,
                    child: RaisedButton(
                        color: Colors.grey,
                        child: Text(
                          'Submit',
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          setState(() => _isLoading = true);
                          Forgot_Password reset = Forgot_Password(
                              email: _controlleremail.text.toString(),
                              uuid: uniqueId);
                          print(reset.toString());
                          if (widget.respass == null) {
                            if (tipes == "ResendEmail") {
                              _apiService.ResendEmail(reset).then((isSuccess) {
                                setState(() => _isLoading = false);
                                if (isSuccess) {
                                  successDialog(context,
                                      "Resend email berhasil dilakukan, cek email anda untuk verifikasi data !",
                                      showNeutralButton: false,
                                      positiveText: "Ok", positiveAction: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()),
                                        (route) => false);
                                  });
                                } else {
                                  errorDialog(context,
                                      "Data gagal disimpan, silahkan hubungi admin !");
                                }
                              });
                            } else if (tipes == "ResetPassword") {
                              _apiService.ForgetPass(reset).then((isSuccess) {
                                setState(() => _isLoading = false);
                                if (isSuccess) {
                                  successDialog(context,
                                      "Reset password berhasil dilakukan, cek email anda untuk verifikasi data !",
                                      showNeutralButton: false,
                                      positiveText: "Ok", positiveAction: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()),
                                        (route) => false);
                                  });
                                } else {
                                  errorDialog(context,
                                      "Data gagal disimpan, silahkan hubungi admin !");
                                }
                              });
                            } else if (tipes == "ResetPin") {
                              _apiService.ForgetPin(reset).then((isSuccess) {
                                setState(() => _isLoading = false);
                                if (isSuccess) {
                                  successDialog(context,
                                      "Reset Pin berhasil dilakukan, cek email anda untuk verifikasi data !",
                                      showNeutralButton: false,
                                      positiveText: "Ok", positiveAction: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()),
                                        (route) => false);
                                  });
                                } else {
                                  errorDialog(context,
                                      "Data gagal disimpan, silahkan hubungi admin !");
                                }
                              });
                            } else if (tipes == "ResetDevice") {
                              _apiService.LostDevice(reset).then((isSuccess) {
                                setState(() => _isLoading = false);
                                if (isSuccess) {
                                  successDialog(context,
                                      "Konfirmasi Lost Device Berhasil dikirim, mohon verifikasi email anda !",
                                      showNeutralButton: false,
                                      positiveText: "OK", positiveAction: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()),
                                        (route) => false);
                                  });
                                } else {
                                  errorDialog(context,
                                      "Data gagal disimpan, silahkan hubungi admin !");
                                }
                              });
                            }
                          }
                        }),
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
