import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/DashboardPage/LatestOrder.Dashboard.dart';
import 'package:horang/component/DashboardPage/Storage.Active.dart';
import 'package:horang/component/DashboardPage/Voucher.Dashboard.dart';
import 'package:horang/component/HistoryPage/historypage.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/account_page/tambah_profile.dart';
import 'package:horang/screen/log_aktifitas.dart';
import 'package:horang/utils/constant_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class HomePage extends StatefulWidget {
  int _current = 0;
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
  var access_token, refresh_token, idcustomer, email, nama_customer, nama;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  final scaffoldState = GlobalKey<ScaffoldState>();
  final firebaseMessaging = FirebaseMessaging();
  final controllerTopic = TextEditingController();

  bool isSubscribed = false;
  String token = '';
  static String dataName = '';
  static String dataAge = '';
  var ceksaldo;

  // static Future<dynamic> onBackgroundMessage(Map<String, dynamic> message) {
  //   debugPrint('onBackgroundMessage: $message');
  //   if (message.containsKey('onMessage')) {
  //     String name = '';
  //     String age = '';
  //     if (Platform.isIOS) {
  //       name = message['title'];
  //       age = message['body'];
  //     } else if (Platform.isAndroid) {
  //       var data = message['onMessage'];
  //       name = data['title'];
  //       age = data['body'];
  //     }
  //     dataName = name;
  //     dataAge = age;
  //     debugPrint('onBackgroundMessage: title: $name & body: $age');
  //   }
  //   return null;
  // }

  getSaldo() async {
    final response = await http.get(ApiService().urlceksaldo,
        headers: {"Authorization": "BEARER ${access_token}"});
    return jsonDecode(response.body);
  }

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    idcustomer = sp.getString("idcustomer");
    email = sp.getString("email");
    nama_customer = sp.getString("nama_customer");
    // print("Hasil token from login : "+refresh_token);
    print(sp.getString("access_token") +
        " ---///--- " +
        sp.getString("refresh_token"));
    //checking jika token kosong maka di arahkan ke menu login jika tidak akan meng-hold token dan refresh token

    if (idcustomer.toString() == '0') {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Peringatan'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Data profile anda belum lengkap.'),
                    Text('Harap melengkapi data anda terlebih dahulu !'),
                  ],
                ),
              ),
              actions: <Widget>[
                Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text("Lengkapi"),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    TambahProfile()),
                            (Route<dynamic> route) => false);
                      },
                    ),
                    FlatButton(
                      child: Text("Batalkan"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            );
          });
    }

    if (access_token == null) {
      showAlertDialog(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
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
                                      LoginPage()),
                              (Route<dynamic> route) => false);
                        }
                      }));
            }
          }));
      getSaldo();
    }
  }

  @override
  void initState() {
    getSaldo();
    // firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     debugPrint('onMessage: $message');
    //     getDataFcm(message);
    //   },
    //   onBackgroundMessage: onBackgroundMessage,
    //   onResume: (Map<String, dynamic> message) async {
    //     debugPrint('onResume: $message');
    //     getDataFcm(message);
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     debugPrint('onLaunch: $message');
    //     getDataFcm(message);
    //   },
    // );
    // firebaseMessaging.requestNotificationPermissions(
    //   const IosNotificationSettings(
    //       sound: true, badge: true, alert: true, provisional: true),
    // );
    // firebaseMessaging.onIosSettingsRegistered.listen((settings) {
    //   debugPrint('Settings registered: $settings');
    // });
    cekToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(true),
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
                                      // ucapan(),
                                      style: GoogleFonts.inter(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ),
                                  IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  LogAktifitasNotif()));
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
                                      future: getSaldo(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          print("masuk pak eko" +
                                              snapshot.data.toString());
                                          var saldoadatidak =
                                              snapshot.data[0]['saldo'];
                                          print(
                                              "ada saldonya tha $saldoadatidak");
                                          if (snapshot.data[0]['saldo'] ==
                                              null) {
                                            return Text(
                                              "Kosong",
                                              style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold),
                                            );
                                          } else {
                                            return Text(
                                              saldoadatidak.toString(),
                                              style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontSize: 35,
                                                  fontWeight: FontWeight.bold),
                                            );
                                          }
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
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      }),
                                  // Text(
                                  //   ceksaldo.toString(),
                                  //   style: GoogleFonts.inter(
                                  //       color: Colors.white,
                                  //       fontSize: 35,
                                  //       fontWeight: FontWeight.bold),
                                  // ),
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
                        margin: EdgeInsets.only(top: 200, left: 20, right: 20),
                        height: 100,
                        width: MediaQuery.of(context).size.width * 2.0,
                        // width: MediaQuery.of(context).size.width * 0.8,
                        child: Center(
                          child: Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                            getSaldo();
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
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 16, top: 24, bottom: 10),
                    child: Text(
                      'Kontainer Aktif',
                      style: mTitleStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 160, top: 24, bottom: 10),
                    child: SelectableText(
                      "",
                      // "See All...",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StorageActive()));
                      },
                    ),
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
            ////////////////// SESI PRODUK ////////////////////////
            // Container(
            //   child: Row(
            //     children: <Widget>[
            //       Padding(
            //         padding: EdgeInsets.only(left: 16, top: 24, bottom: 10),
            //         child: Text(
            //           'Pilihan Produk',
            //           style: mTitleStyle,
            //         ),
            //       ),
            //       Padding(
            //         padding: EdgeInsets.only(left: 160, top: 24, bottom: 10),
            //         child: SelectableText(
            //           "See All...",
            //           style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            //           onTap: () {
            //             Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                     builder: (context) => ProdukList()));
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // ProdukDashboard(),
            ////////////////// END SESI PRODUK ////////////////////////

            /////////////////// SESI LATEST ORDER ////////////////////
            Container(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 16, top: 24),
                    child: Text(
                      'Latest Order',
                      style: mTitleStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 160, top: 24),
                    child: SelectableText(
                      "See All...",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    // StorageHandler(
                                    //       initialIndex: 2,
                                    //     )
                                    HistoryPage()
                                    ));
                      },
                    ),
                  ),
                ],
              ),
            ),
            LatestOrderDashboard()
            ////////////////// END SESI LATEST ORDER ////////////////////////
          ],
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

  String ucapan() {
    var jam = DateTime.now().hour;
    if (jam <= 12) {
      return 'Pagi kak';
    } else if ((jam > 12) && (jam <= 15)) {
      return 'Siang kak';
    } else if ((jam > 15) && (jam < 20)) {
      return 'Sore kak';
    } else {
      return 'Malam kak';
    }
  }

  void getDataFcm(Map<String, dynamic> message) {
    String name = '';
    String age = '';
    if (Platform.isIOS) {
      name = message['name'];
      age = message['age'];
    } else if (Platform.isAndroid) {
      var data = message['data'];
      name = data['name'];
      age = data['age'];
    }
    if (name.isNotEmpty && age.isNotEmpty) {
      setState(() {
        dataName = name;
        dataAge = age;
      });
    }
    debugPrint('getDataFcm: name: $name & age: $age');
  }
}
