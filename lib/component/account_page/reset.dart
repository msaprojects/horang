import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:horang/api/models/forgot/forgot.password.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';

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
  TextEditingController _controlleremail = TextEditingController();
  ApiService _apiService = ApiService();

  @override
  void initState() {
    // if (widget.respass != null) {
    //   _isFieldEmail = true;
    //   _controlleremail.text = widget.respass.email;
    // }
    print("Yuhuuu : " + widget.tipe);
    tipes = widget.tipe;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (tipes == "ResendEmail") {
      judul = "Resend Email";
    } else if (tipes == "ResetPassword") {
      judul = "Reset Password";
    } else if (tipes == "ResetPin") {
      judul = "Reset Pin";
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
                              email: _controlleremail.text.toString());

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
                                  errorDialog(context, "Data gagal disimpan, silahkan hubungi admin !");
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
                                  errorDialog(context, "Data gagal disimpan, silahkan hubungi admin !");
                                  // print('gagal');
                                  // _scaffoldState.currentState.showSnackBar(
                                  //     SnackBar(
                                  //         content: Text("Submit data gagal")));
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
                                  errorDialog(context, "Data gagal disimpan, silahkan hubungi admin !");
                                  // _scaffoldState.currentState.showSnackBar(
                                  //     SnackBar(
                                  //         content: Text("Submit data gagal")));
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
