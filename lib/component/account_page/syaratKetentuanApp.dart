import 'package:flutter/material.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/reusable.class.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SyaratKetentuan extends StatefulWidget {
  var skk;
  SyaratKetentuan({this.skk});

  @override
  _SyaratKetentuanState createState() => _SyaratKetentuanState();
}

class _SyaratKetentuanState extends State<SyaratKetentuan> {
  SharedPreferences? sp;
  ApiService _apiService = ApiService();
  var accesstoken, refreshtoken, idcustomer, namacustomer, pin, sk;
  bool isSuccess = false;

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    accesstoken = sp!.getString("access_token");
    refreshtoken = sp!.getString("refresh_token");
    idcustomer = sp!.getString("idcustomer");
    namacustomer = sp!.getString("nama_customer");
    pin = sp!.getString("pin");
    print("Order: " + accesstoken);
    //checking jika token kosong maka di arahkan ke menu login jika tidak akan meng-hold token dan refresh token
    if (accesstoken == null) {
      ReusableClasses().showAlertDialog(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => WelcomePage()),
          (Route<dynamic> route) => false);
    } else {
      _apiService.checkingToken(accesstoken).then((value) => setState(() {
            isSuccess = value;
            //checking jika token expired/tidak berlaku maka akan di ambilkan dari refresh token
            if (!isSuccess) {
              _apiService
                  .refreshToken(refreshtoken)
                  .then((value) => setState(() {
                        var newtoken = value;
                        //setting access_token dari refresh_token
                        if (newtoken != "") {
                          sp!.setString("access_token", newtoken);
                          accesstoken = newtoken;
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
    cekToken();
    sk = widget.skk;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Syarat Ketentuan",
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Text('$sk'),
        ),
      ),
    );
  }
}
