import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/HistoryPage/historypage.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/ProdukPage/Produk.List.dart';
import 'package:horang/component/StoragePage/StorageHandler.dart';
import 'package:horang/component/account_page/account.dart';
import 'package:horang/component/DashboardPage/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../component/ProdukPage/Produk.List.dart';
import '../component/StoragePage/StorageHandler.dart';

class Home extends StatefulWidget {
  final int initIndexHome;
  PageController pages = PageController(initialPage: 0);
  Home({Key key, this.initIndexHome, this.pages}) : super(key: key);
  
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController _myPage = PageController(initialPage: 0);
  var initIndex;
   DateTime backbuttonpressedtime;
  int currentTab = 0;
  List<Widget> screen = [HomePage()];
  Widget currentScreen = HomePage();
  final PageStorageBucket bucket = PageStorageBucket();
  SharedPreferences sp;
  ApiService _apiService = ApiService();
  bool isSuccess = false;

  // ignore: non_constant_identifier_names
  var access_token, refresh_token, idcustomer, pin, nama_customer;

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    pin = sp.getString("pin");
    idcustomer = sp.getString("idcustomer");
    nama_customer = sp.getString("nama_customer");
    //checking jika token kosong maka di arahkan ke menu login jika tidak akan meng-hold token dan refresh token
    
    if (access_token == null) {
      // showAlertDialog(context);
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
                          // showAlertDialog(context);
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LoginPage()),
                              (Route<dynamic> route) => false);
                        }
                      }));
            }
          }));
    }
  }

  @override
  void initState() {
    currentTab = widget.initIndexHome ?? 0;    
    super.initState();
    cekToken();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: PageStorage(
          bucket: bucket,
          child: currentScreen,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.shopping_basket),
          backgroundColor: Colors.blue[300],
          onPressed: () {
            setState(() {
              currentScreen = StorageHandler();
              currentTab = 4;
            });
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            child: Container(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 30,
                    onPressed: () {
                      setState(() {
                        currentScreen = HomePage();
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.home,
                          color: currentTab == 0
                              ? Colors.blue[300]
                              : Colors.grey[400],
                        ),
                        Text(
                          'Home',
                          style: TextStyle(
                            color: currentTab == 0
                                ? Colors.blue[300]
                                : Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 30,
                    onPressed: () {
                      setState(() {
                        currentScreen = ProdukList();
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.shopping_cart,
                          color: currentTab == 1
                              ? Colors.blue[300]
                              : Colors.grey[400],
                        ),
                        Text(
                          'My Order',
                          style: TextStyle(
                            color: currentTab == 1
                                ? Colors.blue[300]
                                : Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 30,
                    onPressed: () {
                      setState(() {
                        currentScreen = HistoryPage();
                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.history,
                          color: currentTab == 2
                              ? Colors.blue[300]
                              : Colors.grey[400],
                        ),
                        Text(
                          'History',
                          style: TextStyle(
                            color: currentTab == 2
                                ? Colors.blue[300]
                                : Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 30,
                    onPressed: () {
                      setState(() {
                        currentScreen = Account();
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.account_circle,
                          color: currentTab == 3
                              ? Colors.blue[300]
                              : Colors.grey[400],
                        ),
                        Text(
                          'Profil',
                          style: TextStyle(
                            color: currentTab == 3
                                ? Colors.blue[300]
                                : Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

   Future<bool> _onBackPressed() async {
    DateTime currenttime = DateTime.now();
    bool backbutton = backbuttonpressedtime == null ||
        currenttime.difference(backbuttonpressedtime) > Duration(seconds: 3);

    if (backbutton) {
      backbuttonpressedtime = currenttime;
      Fluttertoast.showToast(
          msg: "Klik 2x untuk keluar aplikasi",
          backgroundColor: Colors.black,
          textColor: Colors.white);
      return false;
    }
    return true;
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        print("ini bottom nav");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Sesi Anda Berakhir!"),
      content: Text(
          "Harap masukkan kembali email beserta nomor handphone untuk mengakses fitur di aplikasi ini."),
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
