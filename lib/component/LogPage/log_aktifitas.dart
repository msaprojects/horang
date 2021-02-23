import 'package:flutter/material.dart';
import 'package:horang/api/models/log/Log.Aktifitas.Notif.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/reusable.class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogAktifitasNotif extends StatefulWidget {
  @override
  _LogAktifitasNotifState createState() => _LogAktifitasNotifState();
}

class _LogAktifitasNotifState extends State<LogAktifitasNotif> {
  SharedPreferences sp;
  ApiService _apiService = ApiService();
  bool isSuccess = false;
  var access_token, refresh_token, nama_customer, idcustomer, pin;

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
  }

  @override
  void initState() {
    cekToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Log Transaksi Aplikasi"),
      ),
      body: FutureBuilder(
        future: _apiService.logAktifitasNotif_(access_token),
        builder: (BuildContext context,
            AsyncSnapshot<List<logAktifitasNotif>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<logAktifitasNotif> logaktifitas1 = snapshot.data;
            return _buildListView(logaktifitas1);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildListView(List<logAktifitasNotif> dataIndex) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
              child: Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            color: Colors.grey[100],
            child: ListView.builder(
              itemBuilder: (context, index) {
                logAktifitasNotif logNotif = dataIndex[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      // if (idcustomer == "0") {
                      //   Scaffold.of(context).showSnackBar(SnackBar(
                      //     content: Text(
                      //         'Anda Harus Melengkapi profile untuk melakukan transaksi!'),
                      //     duration: Duration(seconds: 10),
                      //   ));
                      //   Navigator.pop(context, false);
                      // } else {
                      //   // Navigator.push(context,
                      //   //     MaterialPageRoute(builder: (context) {
                      //   //   return FormInputOrder(
                      //   //     // jenisProduk: ,
                      //   //   );
                      //   // }));
                      // }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(left: 20)),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Timestamp : " + logNotif.timestamp),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "No. Order : " + logNotif.keterangan_user,
                                    ),
                                    // Text(
                                    //   tanggal(date, shortMonth: true),
                                    //   style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    // )
                                  ],
                                ),
                              ],
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: dataIndex.length,
            ),
          ))
        ],
      ),
    );
  }
}
