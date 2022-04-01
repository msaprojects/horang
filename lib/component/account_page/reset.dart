import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:horang/api/models/forgot/forgot.security.dart';
import 'package:horang/api/models/forgot/lost.device.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/deviceinfo.dart';

import '../../utils/dialog.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class Reset extends StatefulWidget {
  var tipe;
  late Forgot_Security respass, respin, resemail;
  var resetpass, resetpin, resendemail;
  Reset(
      {required this.resetpass,
      required this.resetpin,
      required this.resendemail,
      required this.tipe});
  @override
  _ResetState createState() => _ResetState();
}

class _ResetState extends State<Reset> {
  ApiService _apiService = ApiService();
  late bool _isLoading = false, _email, _isFieldEmail;
  late String emails, tipes, judul, uuid;
  var iddevice, icone;
  TextEditingController _controlleremail = TextEditingController();

  @override
  void initState() {
    tipes = widget.tipe;
    print("Tipe?" + tipes.toString());
    if (tipes == "ResendEmail") {
      judul = "Resend Email";
      icone = Icon(Icons.send_to_mobile);
    } else if (tipes == "ResetPassword") {
      judul = "Reset Password";
      icone = Icon(Icons.lock_open_rounded);
    } else if (tipes == "ResetPin") {
      judul = "Reset Pin";
      icone = Icon(Icons.password_rounded);
    } else if (tipes == "ResetDevice") {
      judul = "Ganti Perangkat";
      icone = Icon(Icons.switch_left_rounded);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  icone,
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
                        color: Colors.blueAccent,
                        child: Text(
                          'Simpan',
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          print("Tipe2?");
                          ResetClick();
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

  ResetClick() {
    GetDeviceID().getDeviceID(context).then((value) {
      setState(() {
        uuid = value!;
        print("UUID? " + value);
        print("Tipe3? " + tipes + "UUID? " + uuid.toString());
        LostDevices gantiperangkat = LostDevices(
            email: _controlleremail.text.toString(), uuid: uuid.toString());
        Forgot_Security maintenSecure =
            Forgot_Security(email: _controlleremail.text.toString());
        if (_controlleremail.text.toString() == "" ||
            uuid.toString() == "0" ||
            uuid.toString() == "") {
          AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              animType: AnimType.RIGHSLIDE,
              headerAnimationLoop: true,
              title: 'Error',
              desc: 'Harap isi email anda terlebih dahulu',
              btnOkOnPress: () {},
              btnOkIcon: Icons.cancel,
              btnOkColor: Colors.red)
            ..show();
          // errorDialog(context, "Harap isi email anda terlebih dahulu");
        } else {
          print("Model Reset" + maintenSecure.toString());
          AwesomeDialog(
            context: context,
            keyboardAware: true,
            dismissOnBackKeyPress: false,
            dialogType: DialogType.WARNING,
            animType: AnimType.BOTTOMSLIDE,
            btnCancelText: "Periksa kembali",
            btnOkText: "Benar",
            title: 'Konfirmasi',
            // padding: const EdgeInsets.all(5.0),
            desc: 'Email sudah benar?',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
              if (tipes == "ResendEmail") {
                print('tes resend $maintenSecure');
                _apiService.ResendEmail(maintenSecure).then((isSuccess) {
                  print('suksesnya $isSuccess $maintenSecure');
                  setState(() => _isLoading = false);
                  if (!isSuccess) {
                    Fluttertoast.showToast(
                        msg: "${_apiService.responseCode.mMessage}",
                        // msg: "Account has been ready !",
                        backgroundColor: Colors.black,
                        textColor: Colors.white);
                    // errorDialog(context, "${_apiService.responseCode.mMessage}");
                  } else {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.LEFTSLIDE,
                      headerAnimationLoop: false,
                      dialogType: DialogType.SUCCES,
                      showCloseIcon: true,
                      title: 'Success',
                      desc: '${_apiService.responseCode.mMessage}',
                      btnOkOnPress: () {
                        Navigator.pop(context, true);
                      },
                      btnOkText: "Ok",
                      btnOkIcon: Icons.check_circle,
                    )..show();
                    // successDialog(
                    //     context,
                    //     "${_apiService.responseCode.mMessage}",
                    //     showNeutralButton: false,
                    //     positiveText: "OK", positiveAction: () {
                    //   Navigator.pop(context, true);
                    // });
                  }
                });
              } else if (tipes == "ResetPassword") {
                _apiService.ForgetPass(maintenSecure).then((isSuccess) {
                  setState(() => _isLoading = false);
                  print('damn! ini reset password');
                  if (!isSuccess) {
                    Fluttertoast.showToast(
                        msg:
                            "Gagal reset password ${_apiService.responseCode.mMessage}",
                        // msg: "Account has been ready !",
                        backgroundColor: Colors.black,
                        textColor: Colors.white);
                    // print('gagal! reset password');
                    // return errorDialog(
                    //     context, "${_apiService.responseCode.mMessage}");
                    // errorDialog(context, "Maaf, Email gagal dikirim !");
                  } else {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.LEFTSLIDE,
                      headerAnimationLoop: false,
                      dialogType: DialogType.SUCCES,
                      showCloseIcon: true,
                      title: 'Success',
                      desc:
                          'Reset password berhasil dilakukan, cek email anda untuk verifikasi',
                      btnOkOnPress: () {
                        Navigator.pop(context, true);
                      },
                      btnOkIcon: Icons.check_circle,
                    )..show();
                    // return successDialog(context,
                    //     "Reset password berhasil dilakukan, cek email anda untuk verifikasi",
                    //     showNeutralButton: false,
                    //     positiveText: "OK", positiveAction: () {
                    //   Navigator.pop(context, true);
                    // });
                  }
                });
              } else if (tipes == "ResetPin") {
                _apiService.ForgetPin(maintenSecure).then((isSuccess) {
                  if (!isSuccess) {
                    Fluttertoast.showToast(
                        msg: "${_apiService.responseCode.mMessage}",
                        // msg: "Account has been ready !",
                        backgroundColor: Colors.black,
                        textColor: Colors.white);
                    // errorDialog(context, "${_apiService.responseCode.mMessage}");
                  } else {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.LEFTSLIDE,
                      headerAnimationLoop: false,
                      dialogType: DialogType.SUCCES,
                      showCloseIcon: true,
                      title: 'Success',
                      desc:
                          'Konfirmasi Ganti Pin Berhasil dikirim, mohon verifikasi email anda !',
                      btnOkOnPress: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => WelcomePage()),
                            (route) => false);
                      },
                      btnOkIcon: Icons.check_circle,
                    )..show();
                    // successDialog(context,
                    //     "Konfirmasi Ganti Pin Berhasil dikirim, mohon verifikasi email anda !",
                    //     showNeutralButton: false,
                    //     positiveText: "OK", positiveAction: () {
                    // Navigator.of(context).pushAndRemoveUntil(
                    //     MaterialPageRoute(builder: (context) => WelcomePage()),
                    //     (route) => false);
                    // });
                  }
                });
              } else if (tipes == "ResetDevice") {
                _apiService.LostDevice(gantiperangkat).then((isSuccess) {
                  print('gantiperangkat $gantiperangkat');
                  if (!isSuccess) {
                    Fluttertoast.showToast(
                        msg: "${_apiService.responseCode.mMessage}",
                        // msg: "Account has been ready !",
                        backgroundColor: Colors.black,
                        textColor: Colors.white);
                    // errorDialog(context, "${_apiService.responseCode.mMessage}");
                  } else {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.LEFTSLIDE,
                      headerAnimationLoop: false,
                      dialogType: DialogType.SUCCES,
                      showCloseIcon: true,
                      title: 'Success',
                      desc:
                          'Konfirmasi Ganti Perangkat Berhasil dikirim, mohon verifikasi email anda !',
                      btnOkOnPress: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => WelcomePage()),
                            (route) => false);
                      },
                      btnOkIcon: Icons.check_circle,
                    )..show();
                    // successDialog(context,
                    //     "Konfirmasi Ganti Perangkat Berhasil dikirim, mohon verifikasi email anda !",
                    //     showNeutralButton: false,
                    //     positiveText: "OK", positiveAction: () {
                    // Navigator.of(context).pushAndRemoveUntil(
                    //     MaterialPageRoute(builder: (context) => WelcomePage()),
                    //     (route) => false);
                    // });
                  }
                });
              }
            },
          ).show();
        }
      });
    });
  }
}
