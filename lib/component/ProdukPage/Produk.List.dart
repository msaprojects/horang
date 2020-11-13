import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:commons/commons.dart';
import 'package:connectivity/connectivity.dart';
import 'package:horang/component/Dummy/syncfusion_datepicker.dart';
import 'package:horang/component/VoucherPage/voucher.detail.dart';
import 'package:horang/widget/datePicker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/jenisproduk/jenisproduk.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/OrderPage/Order.Input.dart';
import 'package:indonesia/indonesia.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ProdukList extends StatefulWidget {
  var tanggalAwal, tanggalAkhir;
  ProdukList({this.tanggalAwal, this.tanggalAkhir});
  @override
  _ProdukList createState() => _ProdukList();
}

class _ProdukList extends State<ProdukList> {
  // StreamSubscription<DataConnectionStatus> listener;
  // var _InternetStatus = "Unknown";
  // var _ContentMessage = "Unknown";
  SharedPreferences sp;
  ApiService _apiService = ApiService();
  bool isSuccess = false;
  String urlcomboKota = "http://server.horang.id:9992/api/lokasi/", valKota;
  var access_token, refresh_token, idcustomer, email, nama_customer, nama;
  TextEditingController _controlleridkota;
  DateTime dtAwal, dtAkhir, _date, _date2;
  var ttanggalAwal='Pilih tanggal', ttanggalAkhir='Pilih Tanggal', rtanggalAwal, rtanggalAkhir;

  List<dynamic> _dataKota = List();
  void getcomboProduk() async {
    final response = await http.get(urlcomboKota,
        headers: {"Authorization": "BEARER ${access_token}"});
    var listdata = json.decode(response.body);
    setState(() {
      _dataKota = listdata;
    });
  }

  StreamSubscription connectivityStream;
  ConnectivityResult olders;

  void _cekKoneksi() async {
    connectivityStream = await Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult resnow) {
      if (resnow == ConnectivityResult.none) {
        print("No Connection");
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: new Text("Peringatan"),
                content: new Text(
                    "Jaringan anda bermasalah, periksa koneksi anda lagi!"),
                actions: <Widget>[
                  new FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: new Text("Tutup"))
                ],
              );
            });
      } else if (olders == ConnectivityResult.none) {
        print("Tersambung");
        RefreshIndicator(
          onRefresh: () async {
            this.cekToken().reset();
            await Future.value({});
          },
          child: null,
        );
        setState(() {});
      }
      olders = resnow;
    });
  }

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    idcustomer = sp.getString("idcustomer");
    email = sp.getString("email");
    nama_customer = sp.getString("nama_customer");
    //checking jika token kosong maka di arahkan ke menu login jika tidak akan meng-hold token dan refresh token
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
      getcomboProduk();
    }
  }

  @override
  void initState() {
    super.initState();
    ttanggalAwal = widget.tanggalAwal;
    ttanggalAkhir = widget.tanggalAkhir;
    print("YUhuu : "+ttanggalAwal+" - "+ttanggalAkhir);
    _cekKoneksi();
    cekToken();
  }

  @override
  void dispose() {
    super.dispose();
    connectivityStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // print(ttanggalAwal+" - "+ttanggalAkhir);
    return SafeArea(
      child: FutureBuilder(
        future: _apiService.listJenisProduk(access_token),
        builder:
            (BuildContext context, AsyncSnapshot<List<JenisProduk>> snapshot) {
          print("hmm : ${snapshot.connectionState}");
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            // List<JenisProduk> profiles = snapshot.data;
            List<JenisProduk> profiles = snapshot.data
                .where((element) => element.nama_lokasi == valKota)
                .toList();
            // print("ada gk ya ? "+_controlleridkota.toString());
            return _buildListView(profiles);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildListView(List<JenisProduk> dataIndex) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Daftar Produk",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.transparent,
            ),
            onPressed: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => VoucherDetail()));
            }),
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  color: Colors.red,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SyfusionDate()));
                    },
                    child: Text('Pilih Tanggal')),
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16),
                  child: _buildKomboProduk(valKota.toString()),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          FlatButton(
            color: Colors.blue,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SyfusionDate()));
              },
              child: Text('Cari'+ttanggalAwal)),
          Expanded(
              child: Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            color: Colors.grey[100],
            child: ListView.builder(
              itemBuilder: (context, index) {
                JenisProduk jenisProduk = dataIndex[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      if (nama_customer == "" ||
                          nama_customer == null ||
                          nama_customer == "0") {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Anda Harus Melengkapi profile untuk melakukan transaksi!'),
                          duration: Duration(seconds: 10),
                        ));
//                        Navigator.pop(context, false);
                      } else {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return FormInputOrder(
                            jenisProduk: jenisProduk,
                          );
                        }));
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Container(
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.4,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.contain,
                                          image: NetworkImage(
                                              jenisProduk.gambar))),
                                ),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  jenisProduk.kapasitas,
                                  style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  jenisProduk.nama_kota,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  rupiah(jenisProduk.harga.toString(),
                                      separator: ',', trailing: '.00'),
                                  // jenisProduk.harga.toString(),
                                  style: GoogleFonts.inter(
                                      fontSize: 15,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.fade,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 16, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.remove_red_eye,
                                    size: 12,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text("5 Viewer",
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12),
                                      overflow: TextOverflow.fade)
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.widgets,
                                    size: 12,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "2 Tersedia",
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 12),
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.local_grocery_store,
                                    size: 12,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text("Disewa 3 Kali",
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12),
                                      overflow: TextOverflow.fade)
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16,
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

  Widget _buildKomboProduk(String kotaaaa) {
    _controlleridkota = TextEditingController(text: kotaaaa);
    return DropdownButtonFormField(
      // hint: Text("Pilih Kota", style: GoogleFonts.inter(color: Colors.blueGrey)),
      hint: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Text("Pilih Kota",
            style: GoogleFonts.inter(color: Colors.grey[800], fontSize: 14)),
      ),
      value: valKota,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Colors.transparent, width: 0.0),
              borderRadius: BorderRadius.circular(5.0)),
          isDense: true,
          contentPadding:
              const EdgeInsets.only(bottom: 8.0, top: 8.0, left: 5.0)),
      items: _dataKota.map((item) {
        return DropdownMenuItem(
          // child: Text(item['nama_kota']),
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "${item['nama_kota']}, ${item['nama_lokasi']}",
              style: GoogleFonts.inter(color: Colors.grey[800], fontSize: 14),
            ),
          ),
          value: item['nama_lokasi'].toString(),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          valKota = value;
        });
      },
    );
  }

  // void _showDialog(String title, content, BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: new Text("Peringatan"),
  //           content:
  //               new Text("Koneksi anda buruk, paketane sampean ntek ta mas ?"),
  //           actions: <Widget>[
  //             new FlatButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: new Text("Tutup"))
  //           ],
  //         );
  //       });
  // }

  // cekConnection(BuildContext context) async {
  //   listener = DataConnectionChecker().onStatusChange.listen((status) {
  //     switch (status) {
  //       case DataConnectionStatus.connected:
  //         _InternetStatus = "Terkoneksi ke internet";
  //         _ContentMessage = "----------------------";
  //         _showDialog(_InternetStatus, _ContentMessage, context);
  //         break;
  //       case DataConnectionStatus.disconnected:
  //         _InternetStatus = "Koneksi anda bermasalah";
  //         _ContentMessage = "----------------------";
  //         _showDialog(_InternetStatus, _ContentMessage, context);
  //         break;
  //     }
  //   });
  //   return await DataConnectionChecker().connectionStatus;
  // }

  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        print("ini produk lis");
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
