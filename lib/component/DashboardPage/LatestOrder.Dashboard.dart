import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/history/history.model.dart';
import 'package:horang/api/models/mystorage/mystorageModel.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/HistoryPage/historypage.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/StoragePage/StorageExpired.List.dart';
import 'package:horang/utils/constant_color.dart';
import 'package:indonesia/indonesia.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LatestOrderDashboard extends StatefulWidget {
  @override
  _LatestOrderDashboardState createState() => _LatestOrderDashboardState();
}

class _LatestOrderDashboardState extends State<LatestOrderDashboard> {
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

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    idcustomer = sp.getString("idcustomer");
    email = sp.getString("email");
    nama_customer = sp.getString("nama_customer");

    // //checking jika token kosong maka di arahkan ke menu login jika tidak akan meng-hold token dan refresh token
    if (access_token == null) {
      // showAlertDialog(context);
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
                          // showAlertDialog(context);
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
    return SafeArea(
      child: FutureBuilder(
          // future: _apiService.listJenisProduk(access_token),
          future: _apiService.listHistory(access_token),
          builder:
              // (BuildContext context, AsyncSnapshot<List<JenisProduk>> snapshot) {
              (BuildContext context,
                  AsyncSnapshot<List<HistoryModel>> snapshot) {
            print("coba cek lagi : ${snapshot.connectionState}");
            if (snapshot.hasError) {
              print(snapshot.error.toString());
              return Center(
                child: Text(
                    "1Something wrong with message ${snapshot.error.toString()}"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              List<HistoryModel> profiles = snapshot.data;
              if (profiles.isNotEmpty) {
                return Text("kosong");
              } else {
                return Text('llllama');
              }
              // return _buildlistview(profiles);
            }
          }),
    );
  }

  Widget _buildlistview(List<HistoryModel> dataIndex) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      // height: MediaQuery.of(context).size.height * 0.35,
      height: 160,
      margin: EdgeInsets.only(left: 16, right: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dataIndex.length,
        itemBuilder: (context, index) {
          HistoryModel mystorageModel = dataIndex[index];
          return GestureDetector(
            onTap: () {
              if (idcustomer == "0") {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                      'Anda Harus Melengkapi profile untuk melakukan transaksi!'),
                  duration: Duration(seconds: 10),
                ));
//                        Navigator.pop(context, false);
              } else {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => HistoryPage()));
                _openAlertDialog(
                  context,
                  mystorageModel.no_order,
                  mystorageModel.kode_refrensi,
                  mystorageModel.kode_kontainer,
                  mystorageModel.nama_provider,
                  mystorageModel.tanggal_order,
                  mystorageModel.tanggal_akhir,
                  mystorageModel.tanggal_mulai,
                  mystorageModel.total_harga,
                  mystorageModel.harga,
                  mystorageModel.jumlah_sewa,
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              margin: EdgeInsets.all(8),
              height: 64,
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                color: mFillColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: mBorderColor, width: 1),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      mystorageModel.no_order,
                      // "cek",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: mTitleColor),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      mystorageModel.kode_kontainer,
                      // "cek",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: mTitleColor),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    Text(
                      'See Details...',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: mSubtitleColor),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _openAlertDialog(
    BuildContext context,
    String no_order,
    kode_refrensi,
    kode_kontainer,
    nama_provider,
    tanggal_order,
    tanggal_mulai,
    tanggal_akhir,
    int total_harga,
    harga,
    jumlah_sewa,
  ) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Container(
              width: 260.0,
              height: 370.0,
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
                          Text("Kode kontainer : " + kode_kontainer,
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("No. Order : " + no_order,
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("No. Bayar : " + kode_refrensi,
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                              "Nominal Bayar : " +
                                  rupiah(total_harga.toString()),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                              "Jumlah Sewa : " +
                                  jumlah_sewa.toString() +
                                  " Hari",
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Harga : " + rupiah(harga.toString()),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Tgl Order : " + tanggal_order.toString(),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Tanggal Awal : " + tanggal_mulai.toString(),
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
  }
}
