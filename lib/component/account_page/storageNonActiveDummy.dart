import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:get/get.dart';
import 'package:horang/api/models/mystorage/mystorageModel.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/account_page/SearchWidget.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/reusable.class.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Sksk extends StatefulWidget {
  String token;

  Sksk({this.token});
  @override
  _SearchListViewExampleState createState() => _SearchListViewExampleState();
}

class _SearchListViewExampleState extends State<Sksk> {
  bool isLoading = false;
  SharedPreferences sp;
  ApiService _apiService = ApiService();
  bool isSuccess = false, _loading = true;
  var access_token,
      refresh_token,
      idcustomer,
      iddetail_trans,
      pin,
      nama,
      nama_customer,
      keterangan,
      noOrder,
      kode_kontainer,
      nama_kota,
      nama_lokasi,
      tanggal_order,
      hari,
      aktif;


  List<MystorageModel> storage = [];
  String query = '', token='';
  Timer debouncer;

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    idcustomer = sp.getString("idcustomer");
    nama_customer = sp.getString("nama_customer");
    pin = sp.getString("pin");
    print("tesacctoken $access_token");
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
  initState() {
    token = widget.token;
    cekToken();
    _apiService.listMystorageNew(token,query);
    init();
    print('acctoken $access_token ++ $token');
    super.initState();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  init() async {
    final storage = await _apiService.listMystorageNew(token, query);
    print('yuhu ada gak');
    setState(() => this.storage = storage);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('coba'),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            buildSearch(),
            Expanded(
              child: ListView.builder(
                itemCount: storage.length,
                itemBuilder: (context, index) {
                  final storages = storage[index];

                  return buildmyStorage(storages);
                },
              ),
            ),
          ],
        ),
      );

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Title or Author Name',
        onChanged: searchmystorage,
      );

  Future searchmystorage(String query) async => debounce(() async {
        final storage = await _apiService.listMystorageNew(token, query);
        if (!mounted) return;
        setState(() {
          this.storage = storage;
              print("Execute searcgh");
        });
      });

      Widget buildmyStorage(MystorageModel storage)=> 
      Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10),
        color: Colors.grey[100],
        child: GestureDetector(
              onTap: () {
                // setState(() => isLoading = true);
                if (idcustomer == "0") {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Anda Harus Melengkapi profile untuk melakukan transaksi!'),
                    duration: Duration(seconds: 10),
                  ));
                } else {
                  _openAlertDialog(
                    context,
                    storage.idtransaksi_detail,
                    storage.noOrder.toString(),
                    storage.kode_kontainer.toString(),
                    storage.nama_kota,
                    storage.nama,
                    storage.nama_lokasi.toString(),
                    storage.keterangan,
                    storage.tanggal_order,
                    storage.tanggal_mulai,
                    storage.tanggal_akhir,
                    storage.hari.toString(),
                  );
                }
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
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'No. Order : ',
                                      style: GoogleFonts.inter(
                                          fontSize: 14),
                                    ),
                                    Flexible(
                                      child: Text(
                                        storage.noOrder.toString(),
                                        style: GoogleFonts.inter(
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Kode Kontainer : ',
                                      style: GoogleFonts.inter(
                                          fontSize: 14),
                                    ),
                                    Text(
                                      storage.kode_kontainer,
                                      style: GoogleFonts.inter(
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Jenis Kontainer : ',
                                      style: GoogleFonts.inter(
                                          fontSize: 14),
                                    ),
                                    Text(
                                      storage.nama,
                                      style: GoogleFonts.inter(
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      // 'Lokasi : '+myStorage.idtransaksi_detail.toString(),
                                      'Lokasi : ',
                                      style: GoogleFonts.inter(
                                          fontSize: 14),
                                    ),
                                    Text(
                                      storage.idtransaksi_detail.toString(),
                                      // myStorage.nama_lokasi,
                                      style: GoogleFonts.inter(
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
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
                            // );
                            //   },
                            // ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        );

      void _openAlertDialog(
      BuildContext context,
      int idtransaksi_detail,
      String noOrder,
      kode_kontainer,
      nama_kota,
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
              height: 350.0,
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color(0xFFFFFF),
                borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
              ),
              child: new Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          Text("No. Order : " + noOrder.toString(),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Kode Kontainer : " + kode_kontainer.toString(),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Kota : " + nama_kota.toString(),
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
                              // width: 900,
                              child: Column(
                            children: [
                              Container(
                                width: 900,
                                // height: 40,
                                child: FlatButton(
                                    height: 40,
                                    color: Colors.blue,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.exit_to_app_outlined,
                                            color: Colors.white),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Kembali',
                                          style: GoogleFonts.inter(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          )),
                        ],
                      ),
                    )
                  ]),
            ),
          );
        });
  }

  void _alertOpen(
      BuildContext context,
      int idtransaksi_detail,
      String noorder,
      kode_kontainer,
      nama_kota,
      nama,
      nama_lokasi,
      keterangan,
      tanggal_order,
      tanggal_mulai,
      tanggal_akhir,
      hari) {
    // var ket = _note.text.toString();
    Widget cancelButton = FlatButton(
      child: Text("Batal"),
      onPressed: () => Navigator.pop(context),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Konfirmasi Action" + idtransaksi_detail.toString()),
            content: Text("Apakah anda ingin membuka kontainer ini ?"),
            actions: [
              FlatButton(onPressed: () {}, child: Text("Ya, Setuju")),
              cancelButton
            ],
          );
        });
  }
}

