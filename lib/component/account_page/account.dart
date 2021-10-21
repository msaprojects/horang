import 'dart:convert';
import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/account_page/syaratKetentuanApp.dart';
import 'package:horang/component/account_page/tambah_profile.dart';
import 'package:horang/component/account_page/ubah_password.dart';
import 'package:horang/component/account_page/ubah_pin.dart';
import 'package:horang/component/account_page/ubah_profile.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/reusable.class.dart';
// import 'package:horang/widget/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Account extends StatefulWidget {
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  SharedPreferences sp;
  ApiService _apiService = ApiService();
  bool isSuccess = false;
  String _projectVersion = '';
  String _platformVersion = 'Unknown';
  String _projectCode = '';
  String _projectAppID = '';
  String _projectName = '';
  var access_token,
      sk,
      refresh_token,
      idcustomer,
      pin,
      nama_customer,
      idpengguna,
      routing,
      nmcust,
      alamat,
      noktp,
      idkotas;

  Future<String> _ambildataSK() async {
    http.Response response = await http.get(
        Uri.encodeFull('https://dev.horang.id/adminmaster/skaplikasi.txt'));
        // Uri.encodeFull('https://server.horang.id/adminmaster/skaplikasi.txt'));
    return sk = response.body;
  }

  initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await GetVersion.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    String projectVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectVersion = await GetVersion.projectVersion;
    } on PlatformException {
      projectVersion = 'Failed to get project version.';
    }

    String projectCode;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectCode = await GetVersion.projectCode;
    } on PlatformException {
      projectCode = 'Failed to get build number.';
    }

    String projectAppID;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectAppID = await GetVersion.appID;
    } on PlatformException {
      projectAppID = 'Failed to get app ID.';
    }

    String projectName;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectName = await GetVersion.appName;
    } on PlatformException {
      projectName = 'Failed to get app name.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _projectVersion = projectVersion;
      _platformVersion = platformVersion;
      _projectCode = projectCode;
      _projectAppID = projectAppID;
      _projectName = projectName;
    });
  }

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
    initPlatformState();
    _ambildataSK();
  }

  @override
  void initState() {
    super.initState();
    cekToken();
  }

  @override
  void dispose() {
    cekToken();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    void Keluarr() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      cekToken();
      _apiService.logout(access_token).then((value) => setState(() {
            isSuccess = value;
            if (isSuccess) {
              preferences.clear();
              if (preferences.getString("access_token") == null) {
                print("SharePref berhasil di hapus");
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => WelcomePage()),
                    (route) => false);
              }
            }
          }));
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Akun",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.transparent,
              ),
              onPressed: () {}),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 12, right: 12, bottom: 10),
              height: MediaQuery.of(context).size.height * 0.110,
              color: Colors.white,
              child: Container(
                margin: EdgeInsets.all(15),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.person_pin,
                      size: 50,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      nama_customer.toString().toUpperCase(),
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text(
                    "Lengkapi Profile ",
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  //onTap: () {routing();}),
                  onTap: () {
                    if (idcustomer == "0") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TambahProfile()));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UbahProfile()));
                    }
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text("Pin",
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UbahPin()));
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.phonelink_lock),
                  title: Text("Ubah Kata Sandi",
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UbahPass()));
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.event_note),
                  title: Text("Syarat dan Ketentuan",
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SyaratKetentuan(
                                  skk: sk,
                                )));
                    // infoDialog(context,
                    //     "Maaf, fitur masih dalam proses pengembangan !");
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.loop),
                  title: Text("Keluar",
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    print('keluar');
                    Keluarr();
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: Text("Version $_projectVersion"),
            )
          ],
        ));
  }
}
