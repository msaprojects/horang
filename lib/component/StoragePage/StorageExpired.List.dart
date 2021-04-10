import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/mystorage/mystorageModel.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/reusable.class.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/models/log/selesaiLog.dart';
import '../DashboardPage/home_page.dart';

// ignore: must_be_immutable
class StorageExpired1 extends StatefulWidget {
  final TabController tabController;
  var nama_kota, kode_kontainer;

  StorageExpired1(
      {Key key, this.tabController, this.nama_kota, this.kode_kontainer})
      : super(key: key);
  @override
  _StorageExpired createState() => _StorageExpired();
}

class _StorageExpired extends State<StorageExpired1> {
  SharedPreferences sp;
  ApiService _apiService = ApiService();
  bool isSuccess = false;
  bool _isLoading = false;
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
      aktif,
      pin,
      idtransaksii,
      noted;
  Color flag_noted;

  accbayar(int accbyr, idtr, idtrd, String nam_kotaa, kod_kontanr) {
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
      return FlatButton(
          color: Colors.green,
          onPressed: () {
            infoDialog(context,
                "Apakah anda yakin ingin menyelesaikan transaksi ini ? $nam_kotaa, $kod_kontanr",
                // $idtr, $idtrd, $access_token",
                showNeutralButton: false, positiveAction: () {
              setState(() {
                _isLoading = true;
                selesaiLog selesai =
                    selesaiLog(idtransaksi: idtr, token: access_token);
                if (nam_kotaa != null || kod_kontanr != null) {
                  _apiService.SelesaiLog(selesai).then((isSuccess) {
                    setState(() => _isLoading = false);
                    if (isSuccess) {
                      successDialog(context, "Berhasil",
                          showNeutralButton: false, positiveAction: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            // builder: (context) => HomePage()));
                            builder: (context) => HomePage(
                                  initialindex: 0,
                                )));
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

  FlatButton getBayarBlm(int fselesai, selesai) {
    if (fselesai == 0 && selesai == 0) {
      noted = "Harap Konfirmasi Selesai";
      flag_noted = Colors.red[600];
    } else if (fselesai == 1 && selesai == 0) {
      noted = "Menunggu Konfirmasi";
      flag_noted = Colors.indigo;
    } else if (fselesai == 1 && selesai == 1) {
      noted = "Berhasil Dikonfirmasi";
      flag_noted = Colors.green;
    } else {
      noted = "-";
    }
    return FlatButton(
      height: MediaQuery.of(context).size.height * 0.06,
      onPressed: () {},
      child: Text(
        noted,
        style: TextStyle(color: Colors.white),
      ),
      color: flag_noted,
    );
  }

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
    super.initState();
    cekToken();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
          future: _apiService.listMystorage(access_token),
          builder: (BuildContext context,
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
                      myStorage.idtransaksi,
                      myStorage.idtransaksi_detail,
                      myStorage.nama_kota.toString(),
                      myStorage.kode_kontainer.toString(),
                      myStorage.nama.toString(),
                      myStorage.nama_lokasi.toString(),
                      myStorage.keterangan,
                      myStorage.tanggal_order,
                      myStorage.tanggal_mulai,
                      myStorage.tanggal_akhir,
                      myStorage.hari.toString(),
                      myStorage.flag_selesai,
                      myStorage.selesai);
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
                                    'No. Order : ' + myStorage.noOrder,
                                    style: GoogleFonts.inter(fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
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
                                  SizedBox(
                                    height: 5,
                                  ),
                                  getBayarBlm(myStorage.flag_selesai,
                                      myStorage.selesai),
                                  SizedBox(
                                    height: 5,
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
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
      hari,
      int flagselesaii,
      selesaiz) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Container(
              width: 260.0,
              // height: 300.0,
              height: MediaQuery.of(context).size.height * 0.5,
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
                          Row(
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
                              child: accbayar(
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
