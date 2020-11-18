import 'package:flutter/material.dart';
import 'package:horang/api/models/log/Log.Aktifitas.Notif.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogAktifitasNotif extends StatefulWidget {
  @override
  _LogAktifitasNotifState createState() => _LogAktifitasNotifState();
}

class _LogAktifitasNotifState extends State<LogAktifitasNotif> {
  SharedPreferences sp;
  ApiService _apiService = ApiService();
  bool isSuccess = false;
  var access_token,
      refresh_token,
      nama_customer,
      idcustomer;

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    idcustomer = sp.getString("idcustomer");
    nama_customer = sp.getString("nama_customer");
    //checking jika token kosong maka di arahkan ke menu login jika tidak akan meng-hold token dan refresh token
    if (access_token == null) {
      // showAlertDialog(context);
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
      //     (Route<dynamic> route) => false);
    } else {
      // _apiService.checkingToken(access_token).then((value) => setState(() {
      //       isSuccess = value;
      //       //checking jika token expired/tidak berlaku maka akan di ambilkan dari refresh token
      //       if (!isSuccess) {
      //         _apiService
      //             .refreshToken(refresh_token)
      //             .then((value) => setState(() {
      //                   var newtoken = value;
      //                   //setting access_token dari refresh_token
      //                   if (newtoken != "") {
      //                     sp.setString("access_token", newtoken);
      //                     access_token = newtoken;
      //                   } else {
      //                     showAlertDialog(context);
      //                     Navigator.of(context).pushAndRemoveUntil(
      //                         MaterialPageRoute(
      //                             builder: (BuildContext context) =>
      //                                 LoginPage()),
      //                         (Route<dynamic> route) => false);
      //                   }
      //                 }));
      //       }
      //     }));
    }
  }

  @override
  void initState() {
    super.initState();
    cekToken();
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
            child: FutureBuilder(
          future: _apiService.logAktifitasNotif_(access_token),
          builder:
              (BuildContext context, AsyncSnapshot<List<logAktifitasNotif>> snapshot) {
          print("hmm : ${snapshot.connectionState}");
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Center(
              child: Text(
                  "9Something wrong with message: ${snapshot.error.toString()}"),
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Notif Aktifitas",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black26,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 16, right: 16),
            child: TextField(
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300])),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[300],
                  ),
                  suffixIcon: Icon(
                    Icons.filter_list,
                    color: Colors.lightBlue,
                  ),
                  hintText: "Cari Item",
                  focusColor: Colors.blue),
            ),
          ),
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
                  // child: Column(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  child: InkWell(
                    onTap: () {
                      if (idcustomer == "0") {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Anda Harus Melengkapi profile untuk melakukan transaksi!'),
                          duration: Duration(seconds: 10),
                        ));
                        Navigator.pop(context, false);
                      } else {
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) {
                        //   return FormInputOrder(
                        //     // jenisProduk: ,
                        //   );
                        // }));
                      }
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "No. Order : " + logNotif.keterangan,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.bold),
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