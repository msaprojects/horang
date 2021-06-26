import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horang/api/models/forgot/forgot.password.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/deviceinfo.dart';
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
  ApiService _apiService = ApiService();
  bool _isLoading = false, _email, _isFieldEmail;
  String emails, tipes, judul;
  var iddevice;
  TextEditingController _controlleremail = TextEditingController();

  @override
  void initState() {
    tipes = widget.tipe;
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
    } else {
      Navigator.pop(context);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          judul.toString(),
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
                          GetDeviceID().getDeviceID(context).then((ids) {
                            setState(() {
                              iddevice = ids;
                              print("ss + $ids");
                              var getEmail = _controlleremail.text.toString();
                              if (getEmail == null || getEmail == "") {
                                warningDialog(
                                    context, "Pastikan Semua Kolom Terisi!");
                              } else {
                                Forgot_Password reset = Forgot_Password(
                                    email: _controlleremail.text.toString(),
                                    uuid: iddevice);
                                if (widget.respass == null) {
                                  if (tipes == "ResendEmail") {
                                    infoDialog(context,
                                        "Apakah Email yang anda masukkan sudah benar?",
                                        title: "Konfirmasi",
                                        showNeutralButton: false,
                                        positiveText: "Ya", positiveAction: () {
                                      _apiService.ResendEmail(reset)
                                          .then((isSuccess) {
                                        if (isSuccess && iddevice != "") {
                                          successDialog(context,
                                              "Email Berhasil dikirim, Harap verifikasi terlebih dahulu",
                                              showNeutralButton: false,
                                              positiveText: "OK",
                                              positiveAction: () {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginPage()),
                                                    (route) => false);
                                          });
                                        } else {
                                          errorDialog(context,
                                              "${_apiService.responseCode.mMessage}");
                                        }
                                      });
                                    },
                                        negativeText: "Ubah",
                                        negativeAction: () {});
                                  } else if (tipes == "ResetPassword") {
                                    infoDialog(
                                        context, "Yakin Mau Reset Password?",
                                        title: "Konfirmasi",
                                        showNeutralButton: false,
                                        positiveText: "Ya", 
                                        positiveAction: () {
                                      _apiService.ForgetPass(reset)
                                          .then((isSuccess) {
                                        setState(() => _isLoading = false);
                                        if (isSuccess) {
                                          successDialog(context,
                                              "Reset password berhasil dilakukan, cek email anda untuk verifikasi",
                                              showNeutralButton: false,
                                              positiveText: "OK",
                                              positiveAction: () {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginPage()),
                                                    (route) => false);
                                          });
                                        } else {
                                          errorDialog(context,
                                              "${_apiService.responseCode.mMessage}");
                                        }
                                      });
                                    },
                                        negativeText: "Tidak",
                                        negativeAction: () {});
                                  } else if (tipes == "ResetPin") {
                                    infoDialog(
                                        context, "Yakin Mau Mereset PIN?",
                                        title: "Konfirmasi",
                                        positiveText: "Ya", positiveAction: () {
                                      _apiService.ForgetPin(reset)
                                          .then((isSuccess) {
                                        if (isSuccess) {
                                          successDialog(context,
                                              "Reset Pin berhasil dilakukan, cek email anda untuk verifikasi data",
                                              showNeutralButton: false,
                                              positiveText: "OK",
                                              positiveAction: () {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginPage()),
                                                    (route) => false);
                                          });
                                        } else {
                                          errorDialog(context,
                                              "${_apiService.responseCode.mMessage}");
                                        }
                                      });
                                    },
                                        negativeText: "Tidak",
                                        negativeAction: () {});
                                  } else if (tipes == "ResetDevice") {
                                    infoDialog(context,
                                        "Apakah Email yang anda masukkan sudah benar?",
                                        title: "Konfirmasi",
                                        showNeutralButton: false,
                                        positiveText: "Ya", positiveAction: () {
                                      _apiService.LostDevice(reset)
                                          .then((isSuccess) {
                                        if (!isSuccess) {
                                          errorDialog(context,
                                              "${_apiService.responseCode.mMessage}");
                                        } else {
                                          successDialog(context,
                                              "Konfirmasi Lost Device Berhasil dikirim, mohon verifikasi email anda !",
                                              showNeutralButton: false,
                                              positiveText: "OK",
                                              positiveAction: () {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            WelcomePage()),
                                                    (route) => false);
                                          });
                                        }
                                      });
                                    },
                                        negativeText: "Edit",
                                        negativeAction: () {});
                                  }
                                }
                              }
                            });
                          });
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
