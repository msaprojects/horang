import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/DashboardPage/LatestOrder.Dashboard.dart';
import 'package:horang/component/DashboardPage/Produk.Dashboard.dart';
import 'package:horang/component/DashboardPage/Voucher.Dashboard.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/ProdukPage/Produk.List.dart';
import 'package:horang/component/StoragePage/StorageExpired.List.dart';
import 'package:horang/component/account_page/tambah_profile.dart';
import 'package:horang/utils/constant_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    idcustomer = sp.getString("idcustomer");
    email = sp.getString("email");
    nama_customer = sp.getString("nama_customer");
//    print("Hasil token from login : "+refresh_token);
//    print(sp.getString("access_token")+" ---///--- "+sp.getString("refresh_token"));
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
    }
  }

  @override
  void initState() {
    super.initState();
    cekToken();
  }

  @override
  Widget build(BuildContext context) {
    //print("idcustomernya adalah : " + idcustomer);

    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: <Widget>[
          VoucherDashboard(),
          SizedBox(
            height: 18,
          ),

          ////////////////// SESI PRODUK ////////////////////////
          Container(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16, top: 24, bottom: 10),
                  child: Text(
                    'Pilihan Produk',
                    style: mTitleStyle,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 160, top: 24, bottom: 10),
                  child: SelectableText(
                    "See All...",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProdukList()));
                    },
                  ),
                ),
              ],
            ),
          ),
          ProdukDashboard(),
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
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StorageExpired()));
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
    );
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
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
