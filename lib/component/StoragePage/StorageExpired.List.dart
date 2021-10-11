import 'dart:async';

import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/log/selesaiLog.dart';
import 'package:horang/api/models/mystorage/mystorageModel.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/StoragePage/SearchWidget.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/constant_color.dart';
import 'package:horang/utils/reusable.class.dart';

import 'package:shared_preferences/shared_preferences.dart';

class StorageExpired1 extends StatefulWidget {
  @override
  _SearchListViewExampleState createState() => _SearchListViewExampleState();
}

class _SearchListViewExampleState extends State<StorageExpired1>
//  with AutomaticKeepAliveClientMixin<StorageExpired1>
{
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
      jumlah_sewa,
      aktif,
      flag_noted,
      noted;

  List<MystorageModel> storage, storage1 = []; //jian tambah ini
  String query = '', token = '';
  Timer debouncer;

  Widget accbayar(BuildContext context, int accbyr, idtr, idtrd,
      String nam_kotaa, kod_kontanr) {
    if (accbyr == 1) {
      return Visibility(
        child: FlatButton(
            color: Colors.green,
            onPressed: () {
              infoDialog(context,
                  "Apakah anda yakin ingin menyelesaikan transaksi ini ?",
                  showNeutralButton: false,
                  positiveAction: () {},
                  positiveText: "Lanjutkan",
                  negativeAction: () {},
                  negativeText: "Batal");
            },
            child: Text(
              'Selesai',
              style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )),
        visible: false,
      );
    } else {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.green),
          onPressed: () {
            infoDialog(context,
                "Apakah anda yakin ingin menyelesaikan transaksi ini ? $nam_kotaa, $kod_kontanr",
                showNeutralButton: false, positiveAction: () {
              setState(() {
                isLoading = true;
                selesaiLog selesai =
                    selesaiLog(idtransaksi: idtr, token: access_token);
                if (nam_kotaa != null || kod_kontanr != null) {
                  _apiService.SelesaiLog(selesai).then((isSuccess) {
                    setState(() => isLoading = false);
                    if (isSuccess) {
                      //  final storage2 = await _apiService.listMystorageExpired(access_token, query);
                      _apiService
                          .listMystorageExpired(access_token, query)
                          .then((value) {
                        setState(() {
                          this.storage = value;
                        });
                      });
                      successDialog(context, "Berhasil",
                          showNeutralButton: false, positiveAction: () {
                        Navigator.pop(context, true);
                      }, positiveText: "Ok");
                    } else {
                      errorDialog(context, "Transaksi gagal dilakukan !");
                    }
                  });
                }
              });
            },
                positiveText: "Lanjutkan",
                negativeAction: () {},
                negativeText: "Batal");
          },
          child: Text(
            'Selesai',
            style: GoogleFonts.inter(
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
          ));
    }
  }

  Container getBayarBlm(int fselesai, selesai) {
    if (fselesai == 0 && selesai == 0) {
      noted = "Harap Konfirmasi Selesai";
      flag_noted = Colors.red[600];
    } else if (fselesai == 0 && selesai == 1) { // untuk perintah selesai mobile jika dibagian web sudah diselesaikan
      noted = "Harap Konfirmasi Selesai";
      flag_noted = Colors.indigo;
    } else if (fselesai == 1 && selesai == 0) { // untuk perintah selesai bagian web jika dibagian mobile sudah diselesaikan
      noted = "Menunggu Konfirmasi";
      flag_noted = Colors.indigo;
    } else if (fselesai == 1 && selesai == 1) { // untuk mengetahui jika bagian web dan bagian mobile sudah dislesaikan 2-2nya
      noted = "Berhasil Dikonfirmasi";
      flag_noted = Colors.green;
    } else {
      noted = "-";
    }
    return Container(
      child: Row(
        children: [
          Text(
            "Status Deposit : ",
          ),
          Text(
            noted,
            style: TextStyle(color: flag_noted, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      color: Colors.transparent,
    );
  }

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
    storage = await _apiService.listMystorageExpired(access_token, query);
    // storage1 = await _apiService.listMystorageExpired(access_token, query);
    print('yuhu ada gak $token ++ $access_token');
    setState(() => this.storage1 = storage); //jian tambah ini
    setState(() => this.storage = storage);
  }

  // @override
  // bool get wantKeepAlive => false;

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
              future: _apiService.listMystorageExpired(access_token, query),
              builder: (BuildContext context, index) {
                print('sini ?x $access_token $index');
                if (index.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (index.hasData) {
                  // print('jaxx $storage');
                  if (storage.toString() != "[]") {
                    print("true");
                    return ListView.builder(
                      itemCount: storage.length,
                      itemBuilder: (context, index) {
                        print('ada yang?');
                        final storages = storage[index];
                        print('soto expired $storage');
                        // print('SOTO $storages $index');
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
                              "Oppss..Maaf Data yang sudah Selesai belum ada",
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
        // onChanged: searchmystorage,
        onChanged: searchmystorage1, //jian tambah ini
      );

  //jian tambah ini
  Future searchmystorage1(String query) async => debounce(() async {
        print('mystorage1 token1 $access_token');
        final storagex = storage1
            .where((storage1) {
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
            .where((element) => element.status == "EXPIRED")
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
  //           await _apiService.listMystorageExpired(access_token, query);

  //       if (!mounted) return;
  //       setState(() {
  //         this.storage = storage;
  //         print("Execute search");
  //       });
  //     });

  Widget buildmyStorage(MystorageModel storage) {
    // print('masuk sini xx $storage');
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 10),
      color: Colors.grey[100],
      // child: GestureDetector(
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
                storage.idtransaksi,
                storage.idtransaksi_detail,
                storage.nama_kota,
                storage.kode_kontainer,
                storage.nama,
                storage.nama_lokasi,
                storage.keterangan,
                storage.tanggal_order,
                storage.tanggal_mulai,
                storage.tanggal_akhir,
                storage.jumlah_sewa,
                storage.flag_selesai,
                storage.selesai);
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
                          Text(
                            'No. Order : ' + storage.noOrder,
                            style: GoogleFonts.inter(fontSize: 14),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            'Kode Kontainer : ' + storage.kode_kontainer,
                            style: GoogleFonts.inter(fontSize: 14),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text('Jenis Kontainer : ' + storage.nama,
                              style: GoogleFonts.inter(fontSize: 14)),
                          SizedBox(
                            height: 3,
                          ),
                          Text('Lokasi : ' + storage.nama_lokasi,
                              style: GoogleFonts.inter(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          getBayarBlm(storage.flag_selesai, storage.selesai),
                          SizedBox(
                            height: 5,
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
      int idtransaksiz,
      idtransaksi_detailz,
      String nama_kota,
      kode_kontainer,
      nama,
      nama_lokasi,
      keterangan,
      tanggal_order,
      tanggal_mulai,
      tanggal_akhir,
      jumlah_sewa,
      int flagselesaii,
      selesaiz) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                child: Text(
                                  "Detail Pesanan...",
                                  style: GoogleFonts.lato(fontSize: 12),
                                ),
                              ),
                              // getBayarBlm(flagselesaii, selesaiz)
                            ],
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
                          Row(
                            children: [
                              Text("Lama Order : " + jumlah_sewa.toString(),
                                  style: GoogleFonts.lato(fontSize: 14)),
                              Text((nama.toLowerCase().contains('forklift')
                                  ? " Jam"
                                  : " Hari"))
                            ],
                          ),
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
                              child: accbayar(
                                  context,
                                  flagselesaii,
                                  idtransaksiz,
                                  idtransaksi_detailz,
                                  nama_kota,
                                  kode_kontainer)),
                          SizedBox(
                            height: 3,
                          ),
                          Container(
                              width: 900,
                              height: 50,
                              child: FlatButton(
                                  color: Colors.blue,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Tutup',
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
  }
}
