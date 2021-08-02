import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:get/get.dart';
import 'package:horang/api/models/mystorage/mystorageModel.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/Key/KonfirmasiLog.dart';
import 'package:horang/component/StoragePage/SearchWidget.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/reusable.class.dart';

import 'package:shared_preferences/shared_preferences.dart';

class StorageActive1 extends StatefulWidget {
  // String token;

  // StorageNonAktifDummy({this.token});
  @override
  _SearchListViewExampleState createState() => _SearchListViewExampleState();
}

class _SearchListViewExampleState extends State<StorageActive1> {
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
  String query = '', token = '';
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
    storage = await _apiService.listMystorageActive(access_token, query);
    print('yuhu ada gak $token ++ $access_token');
    setState(() => this.storage = storage);
  }

  @override
  initState() {
    // token = widget.token;
    cekToken();
    print('acctokenya $access_token ++ $token');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          buildSearch(),
          Expanded(
            child: FutureBuilder(
              future: _apiService.listMystorageActive(access_token, query),
              builder: (BuildContext context, index) {
                print('sini ?x $access_token $index');
                if (index.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (index.hasData) {
                  print('jaxx $storage');
                  if (storage.toString() != "[]") {
                    print("true");
                    return ListView.builder(
                      itemCount: storage.length,
                      itemBuilder: (context, index) {
                        print('ada ?');
                        final storages = storage[index];
                        print('SOTO $storages $index');
                        return buildmyStorage(storages);
                      },
                    );
                  } else {
                    print('masuk sini!');
                     return Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/image/datanotfound.png"),
                      Text(
                        "Oppss..Maaf Data yang sedang berjalan belum ada",
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
                    child: Text('KOSONG'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Cari...',
        onChanged: searchmystorage,
      );

  Future searchmystorage(String query) async => debounce(() async {
        print('token1 $access_token');
        final storage =
            await _apiService.listMystorageActive(access_token, query);
        if (!mounted) return;
        setState(() {
          this.storage = storage;
          print("Execute search");
        });
      });

  Widget buildmyStorage(MystorageModel storage) {
    print('masuk sini xx $storage');
    return Container(
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
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => KonfirmasiLog(
                      gambar: storage.gambar,
                      kode_kontainer: storage.kode_kontainer,
                      nama_kota: storage.nama_kota,
                      noOrder: storage.noOrder,
                      // idtransaksi_detail: ,
                      idtransaksi_detail: storage.idtransaksi_detail,
                      idtransaksi: storage.idtransaksi,
                      nama: storage.nama,
                      tglmulai: storage.tanggal_mulai,
                      tglakhir: storage.tanggal_akhir,
                      tglorder: storage.tanggal_order,
                      keterangan: storage.keterangan,
                      flag_selesai: storage.flag_selesai,
                      selesai: storage.selesai,
                    )));
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'No. Order : ',
                                style: GoogleFonts.inter(fontSize: 14),
                              ),
                              Flexible(
                                child: Text(
                                  storage.noOrder.toString(),
                                  style: GoogleFonts.inter(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Kode Kontainer : ',
                                style: GoogleFonts.inter(fontSize: 14),
                              ),
                              Text(
                                storage.kode_kontainer,
                                style: GoogleFonts.inter(fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Jenis Kontainer : ',
                                style: GoogleFonts.inter(fontSize: 14),
                              ),
                              Text(
                                storage.nama,
                                style: GoogleFonts.inter(fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                // 'Lokasi : '+myStorage.idtransaksi_detail.toString(),
                                'Lokasi : ',
                                style: GoogleFonts.inter(fontSize: 14),
                              ),
                              Text(
                                storage.nama_lokasi.toString(),
                                // myStorage.nama_lokasi,
                                style: GoogleFonts.inter(fontSize: 14),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "Ketuk untuk detail...",
                              style: GoogleFonts.lato(
                                  fontSize: 12, fontStyle: FontStyle.italic),
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
  }
}
