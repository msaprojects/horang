import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:get/get.dart';
import 'package:horang/api/models/mystorage/mystorageModel.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/StoragePage/SearchWidget.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/reusable.class.dart';

import 'package:shared_preferences/shared_preferences.dart';

class StorageNonActive1 extends StatefulWidget {
  // String token;

  // StorageNonAktifDummy({this.token});
  @override
  _SearchListViewExampleState createState() => _SearchListViewExampleState();
}

class _SearchListViewExampleState extends State<StorageNonActive1> {
  bool isLoading = false;
  late SharedPreferences sp;
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
      jumlah_sewa,
      aktif;

  List<MystorageModel>? storage, storage1 = [];
  String query = '', token = '';
  late Timer debouncer;

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
    storage = await _apiService.listMystorageNonActive(access_token, query);
    print('yuhu ada gak $token ++ $access_token');
    setState(() => this.storage1 = storage);
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
    // debouncer?.cancel();
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
              future: _apiService.listMystorageNonActive(access_token, query),
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
                      itemCount: storage!.length,
                      itemBuilder: (context, index) {
                        print('ada ?');
                        final storages = storage![index];
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
                              "Oppss..Maaf Data yang non aktif belum ada",
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
        onChanged: searchmystorage1,
      );

      Future searchmystorage1(String query) async => debounce(() async {
        print('mystorage1 token1 $access_token');
        final storagex =
            storage1!.where((storage1) {
            final noOrderLower = storage1.noOrder.toLowerCase();
            final kodeKontainerLower = storage1.kode_kontainer.toLowerCase();
            final jenisKontainer = storage1.nama.toLowerCase();
            final lokasi = storage1.nama_lokasi.toLowerCase();
            final searchLower = query.toLowerCase();

            return noOrderLower.contains(searchLower) ||
                kodeKontainerLower.contains(searchLower) ||
                jenisKontainer.contains(searchLower) ||
                lokasi.contains(searchLower);
          })
          .where((element) => element.status == "NONAKTIF")
          .toList();
            
        if (!mounted) return;
        setState(() {
          this.storage = storagex;
          print("Execute search1");
        });
      });

  // Future searchmystorage(String query) async => debounce(() async {
  //       print('token1 $access_token');
  //       final storage =
  //           await _apiService.listMystorageNonActive(access_token, query);
  //       if (!mounted) return;
  //       setState(() {
  //         this.storage = storage;
  //         print("Execute search");
  //       });
  //     });

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
              storage.jumlah_sewa.toString(),
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
      jumlah_sewa) {
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
                          Text("Lama Order : " + jumlah_sewa.toString() + " Hari",
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
      jumlah_sewa) {
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
