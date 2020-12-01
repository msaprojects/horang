import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/mystorage/mystorageModel.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'StorageHandler.dart';

class StorageExpired1 extends StatefulWidget {
  final TabController tabController;

  const StorageExpired1({Key key, this.tabController}) : super(key: key);
  @override
  _StorageExpired createState() => _StorageExpired();
}

class _StorageExpired extends State<StorageExpired1> {
  SharedPreferences sp;
  ApiService _apiService = ApiService();
  bool isSuccess = false;
  var access_token,
      refresh_token,
      idcustomer,
      email,
      nama,
      nama_customer,
      keterangan,
      kode_kontainer,
      nama_kota,
      nama_lokasi,
      tanggal_order,
      hari,
      aktif;
  // final String aktif = "";

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    idcustomer = sp.getString("idcustomer");
    email = sp.getString("email");
    nama_customer = sp.getString("nama_customer");

    // //checking jika token kosong maka di arahkan ke menu login jika tidak akan meng-hold token dan refresh token
    if (access_token == null) {
      showAlertDialog(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    } else {
      _apiService.checkingToken(access_token).then((value) => setState(() {
            isSuccess = value;
            // checking jika token expired/tidak berlaku maka akan di ambilkan dari refresh token
            if (!isSuccess) {
              _apiService
                  .refreshToken(refresh_token)
                  .then((value) => setState(() {
                        var newtoken = value;
                        // setting access_token dari refresh_token
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

// class OnGoing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
          // future: _apiService.listJenisProduk(access_token),
          future: _apiService.listMystorage(access_token),
          builder:
              // (BuildContext context, AsyncSnapshot<List<JenisProduk>> snapshot) {
              (BuildContext context,
                  AsyncSnapshot<List<MystorageModel>> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                    "10Something wrong with message ${snapshot.error.toString()}"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              List<MystorageModel> profiles =
                  snapshot.data.where((i) => i.status == "EXPIRED").toList();
              if (profiles.isNotEmpty) {
                return _buildListview(profiles);
              } else {
                return Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/image/datanotfound.png"),
                        Text(
                          "Oppss..Maaf data kontainer expired kosong.",
                          style: GoogleFonts.inter(color: Colors.grey),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Widget _buildListview(List<MystorageModel> dataIndex) {
    return Scaffold(
      body: Container(
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 30),
          color: Colors.grey[100],
          child: (ListView.builder(
            itemCount: dataIndex == null ? 0 : dataIndex.length,
            itemBuilder: (BuildContext context, int index) {
              MystorageModel myStorage = dataIndex[index];
              return GestureDetector(
                onTap: () {
                  _openAlertDialog(
                    context,
                    myStorage.kode_kontainer.toString(),
                    myStorage.nama.toString(),
                    myStorage.nama_lokasi.toString(),
                    myStorage.keterangan,
                    myStorage.tanggal_order,
                    myStorage.tanggal_mulai,
                    myStorage.tanggal_akhir,
                    myStorage.hari.toString(),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Card(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Kode Kontainer : ' +
                                        myStorage.kode_kontainer,
                                    style: GoogleFonts.inter(fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text('Jenis Kontainer : ' + myStorage.nama,
                                      style: GoogleFonts.inter(fontSize: 14)),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text('Lokasi : ' + myStorage.nama_lokasi,
                                      style: GoogleFonts.inter(fontSize: 14)),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.start,
                                  //   children: <Widget>[
                                  //     Text(
                                  //       'Kode Kontainer : ',
                                  //       style: TextStyle(
                                  //           fontSize: 16, color: Colors.black),
                                  //     ),
                                  //     Text(
                                  //       myStorage.kode_kontainer,
                                  //       style: TextStyle(
                                  //           fontSize: 16, color: Colors.black),
                                  //     ),
                                  //   ],
                                  // ),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.start,
                                  //   children: <Widget>[
                                  //     Text(
                                  //       'Jenis Kontainer : ',
                                  //       style: TextStyle(
                                  //           fontSize: 16, color: Colors.black),
                                  //     ),
                                  //     Text(
                                  //       myStorage.nama,
                                  //       style: TextStyle(
                                  //           fontSize: 16, color: Colors.black),
                                  //     ),
                                  //   ],
                                  // ),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.start,
                                  //   children: <Widget>[
                                  //     Text(
                                  //       'Lokasi : ',
                                  //       style: TextStyle(
                                  //           fontSize: 16, color: Colors.black),
                                  //     ),
                                  //     Text(
                                  //       myStorage.nama_lokasi,
                                  //       style: TextStyle(
                                  //           fontSize: 16, color: Colors.black),
                                  //     ),
                                  //   ],
                                  // ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      "Ketuk untuk detail...",
                                      style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Divider(
                    //   height: 10,
                    // )
                  ],
                ),
              );
            },
            // separatorBuilder: (context, index) => Divider(),
            // itemCount: dataIndex.length,
          )),
        ),
      ),
    );
  }

  void _openAlertDialog(
      BuildContext context,
      String kode_kontainer,
      nama,
      nama_lokasi,
      keterangan,
      tanggal_order,
      tanggal_mulai,
      tanggal_akhir,
      hari) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Container(
              width: 260.0,
              height: 300.0,
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color(0xFFFFFF),
                borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
              ),
              child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              "Detail Pesanan...",
                              style: GoogleFonts.lato(fontSize: 12),
                            ),
                          ),
                          Divider(),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Kode Kontainer : " + kode_kontainer.toString(),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Jenis : " + nama.toString(),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Nama Lokasi : " + nama_lokasi.toString(),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Keterangan : " + keterangan.toString(),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Lama Order : " + hari.toString() + " Hari",
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Tanggal Order : " + tanggal_order.toString(),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Tanggal Mulai : " + tanggal_mulai.toString(),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Tanggal Akhir : " + tanggal_akhir.toString(),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              width: 900,
                              child: FlatButton(
                                  color: Colors.blue,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Ok',
                                    style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ))),
                        ],
                      ),
                    )
                  ]),
            ),
          );
        });
    // showDialog(context: context, child: dialog);
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

  AccountValidation(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Lengkapi Profile anda"),
      content: Text("Anda harus melengkapi akun sebelum melakukan transaksi!"),
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
