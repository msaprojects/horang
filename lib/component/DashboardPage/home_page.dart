import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:commons/commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/DashboardPage/LatestOrder.Dashboard.dart';
import 'package:horang/component/DashboardPage/Storage.Active.dart';
import 'package:horang/component/DashboardPage/Voucher.Dashboard.dart';
import 'package:horang/component/Dummy/cobakeyboard.dart';
import 'package:horang/component/HistoryPage/historypage.dart';
import 'package:horang/component/LogPage/log_aktifitas.dart';
import 'package:horang/component/LogPage/log_handler.dart';
import 'package:horang/component/account_page/ubah_pin.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/constant_style.dart';
import 'package:horang/utils/reusable.class.dart';
import 'package:new_version/new_version.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:indonesia/indonesia.dart';
import 'package:http/http.dart' as http;

import '../../widget/bottom_nav.dart';
import '../StoragePage/StorageHandler.dart';

class HomePage extends StatefulWidget {
  int _current = 0;
  final initialindex;
  HomePage({Key key, this.initialindex}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<int> numbers = [1, 2, 3, 5, 8, 13, 21, 34, 55];
  int _current = 0;
  Widget currentScreen = HomePage();
  SharedPreferences sp;
  ApiService _apiService = ApiService();
  bool isSuccess = false;
  var access_token,
      refresh_token,
      idcustomer,
      email,
      nama_customer,
      nama,
      pin,
      ceksaldo,
      sk;
  String token = '';
  final scaffoldState = GlobalKey<ScaffoldState>();
  final controllerTopic = TextEditingController();

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  // Future<String> _ambildataSK() async {
  //   http.Response response = await http
  //       .get(Uri.encodeFull('https://server.horang.id/adminmaster/sk.txt'));
  //   print("mmzzzrr" + response.body);
  //   return sk = response.body;
  // }

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    idcustomer = sp.getString("idcustomer");
    nama_customer = sp.getString("nama_customer");
    pin = sp.getString("pin");
    print("cek tokennya gais $access_token" + "--------*****----------" + pin);
    //checking jika token kosong maka di arahkan ke menu login jika tidak akan meng-hold token dan refresh token
    if (pin == '0') {
      // print("your eyes broke");
      infoDialog(context,
          "Pin anda belum disetting, setting sekarang untuk menambah proteksi akun anda.",
          showNeutralButton: false,
          negativeAction: () {},
          negativeText: "Nanti saja",
          positiveText: "Setting sekarang", positiveAction: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => UbahPin()));
      });
    }
    if (access_token == null) {
      showAlertDialog(context);
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
                          showAlertDialog(context);
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
    NewVersion(
      androidId: 'com.cvdtc.horang',
      // iOSId: ,
      context: context,
    ).showAlertIfNecessary();
    // newVersion.showUpdateDialog(VersionStatus());
    String hai = new HttpClient()
        .getUrl(Uri.parse('https://server.horang.id/adminmaster/sk.txt'))
        .then((HttpClientRequest request) => request.close())
        .then((HttpClientResponse response) =>
            response.transform(new Utf8Decoder()).listen(print))
        .toString();
    print("IYUH : " + hai.toString());
    cekToken();
    ReusableClasses().getSaldo(access_token);
    super.initState();
    // _ambildataSK();
    // ReusableClasses().sk();
  }

  Future refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      ReusableClasses().getSaldo(access_token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: RefreshIndicator(
        onRefresh: refreshData,
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: <Widget>[
              Container(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(40),
                          constraints: BoxConstraints.expand(height: 250),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [Colors.purple, Colors.blue],
                            ),
                            // color: Colors.blue[400]
                          ),
                          child: Column(
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "${ucapan()}, $nama_customer",
                                        style: GoogleFonts.inter(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ),
                                    IconButton(
                                      color: Colors.white,
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    // LogAktifitasNotif()));
                                                    LogHandler()));
                                      },
                                      icon: (Icon(Icons.notifications)),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text('SALDO POINT',
                                        style: GoogleFonts.inter(
                                            fontSize: 14, color: Colors.white)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    FutureBuilder(
                                        future: ReusableClasses()
                                            .getSaldo(access_token),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            var saldoadatidak =
                                                snapshot.data[0]['saldo'];
                                            return Text(
                                              rupiah(saldoadatidak.toString()),
                                              style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontSize: 35,
                                                  fontWeight: FontWeight.bold),
                                            );
                                          } else if (snapshot == null) {
                                            print("tidak ada data");
                                            return Container(
                                                child: Text(
                                              "Saldo Kosong",
                                              style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            ));
                                          } else {
                                            return Container(
                                              height: 50,
                                              width: 50,
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        }),
                                    SizedBox(
                                      height: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 50, right: 50),
                          alignment: Alignment.center,
                          margin:
                              EdgeInsets.only(top: 200, left: 20, right: 20),
                          height: 100,
                          width: MediaQuery.of(context).size.width * 2.0,
                          child: Center(
                            child: Card(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.refresh_rounded,
                                              size: 30),
                                          onPressed: () {
                                            setState(() {
                                              ReusableClasses()
                                                  .getSaldo(access_token);
                                            });
                                          }),
                                      Text(
                                        "Refresh",
                                        style: GoogleFonts.inter(
                                            fontSize: 14, color: Colors.black),
                                      )
                                    ],
                                  ),
                                  VerticalDivider(
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.history, size: 30),
                                          onPressed: () {
                                            // print(_ambildataSK());
                                            // popUpsk(context);
                                            Scaffold.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Fitur ini masih dalam proses pengembangan"),
                                              duration: Duration(seconds: 5),
                                            ));
                                          }),
                                      Text(
                                        "Histori",
                                        style: GoogleFonts.inter(
                                            fontSize: 14, color: Colors.black),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),

              // VoucherDashboard(),
              SizedBox(
                height: 18,
              ),

              Container(
                padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Kontainer Aktif',
                      style: mTitleStyle,
                    ),
                    SelectableText(
                      "See All...",
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StorageActive()));
                      },
                    ),
                  ],
                ),
              ),
              StorageActive(),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 10,
                color: Colors.grey[300],
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: VoucherDashboard(),
              ),
              Container(
                height: 10,
                color: Colors.grey[300],
              ),
              /////////////////// SESI LATEST ORDER ////////////////////
              Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Latest Order',
                      style: mTitleStyle,
                    ),
                    SelectableText(
                      "See All...",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StorageHandler(
                                      initialIndex: 2,
                                    )
                                // HistoryPage()
                                ));
                      },
                    ),
                  ],
                ),
              ),
              LatestOrderDashboard()
              ////////////////// END SESI LATEST ORDER ////////////////////////
            ],
          ),
        ),
      ),
    );
  }

  Future showAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Sesi Anda Berakhir!"),
            content: Text(
                "Harap masukkan kembali email beserta nomor handphone untuk mengakses fitur di aplikasi ini."),
            actions: [
              FlatButton(
                  color: Colors.red,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Ok"))
            ],
          );
        });
  }

  Future popUpsk(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Sesi Anda Berakhir!"),
            // content: Text("$sk"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      // height: 200,
                      // width: 400,
                      child: Text("$sk")),
                ],
              ),
            ),
            actions: [
              FlatButton(
                  color: Colors.red,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Ok"))
            ],
          );
        });
  }

  String ucapan() {
    var jam = DateTime.now().hour;
    if (jam <= 12) {
      return 'Selamat Pagi ';
    } else if ((jam > 12) && (jam <= 15)) {
      return 'Selamat Siang ';
    } else if ((jam > 15) && (jam < 20)) {
      return 'Selamat Sore ';
    } else {
      return 'Selamat Malam ';
    }
  }
}
