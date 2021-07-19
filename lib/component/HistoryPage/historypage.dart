import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/history/history.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/reusable.class.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:indonesia/indonesia.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  SharedPreferences sp;
  ApiService _apiService = ApiService();
  bool isSuccess = false;
  var access_token, refresh_token, nama_customer, idcustomer, pin;

  FlatButton getBayarBlm(int bayarbelum) {
    if (bayarbelum == 0) {
      return FlatButton(
        onPressed: () {},
        child: Text(
          'Belum Bayar',
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.red,
      );
    } else if (bayarbelum == 1) {
      return FlatButton(
        onPressed: () {},
        child: Text(
          'Terbayar',
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.green,
      );
    } else if (bayarbelum == 2) {
      return FlatButton(
        onPressed: () {},
        child: Text(
          'Expired',
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.orange,
      );
    }
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
  void dispose() {
    _apiService.client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: _apiService.listHistory(access_token),
        builder:
            (BuildContext context, AsyncSnapshot<List<HistoryModel>> snapshot) {
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
            List<HistoryModel> historyyy = snapshot.data;
            if (historyyy.isEmpty) {
              return Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/image/datanotfound.png"),
                      Text(
                        "Oppss..Maaf data history kosong.",
                        style: GoogleFonts.inter(color: Colors.grey),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              );
            } else {
              return _buildListView(historyyy);
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildListView(List<HistoryModel> dataIndex) {
    DateTime date = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "History Pembayaran",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.transparent,
          ),
          onPressed: () {},
        ),
      ),
      body: Container(
        child: Column(
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
                  HistoryModel history = dataIndex[index];
                  print("bakso urat mang ujang" + dataIndex.toString());
                  return GestureDetector(
                    onTap: () {
                      _openAlertDialogDetail(
                          context,
                          history.total_harga,
                          history.harga,
                          history.jumlah_sewa,
                          history.no_order,
                          history.kode_refrensi,
                          history.kode_kontainer,
                          history.nama_provider,
                          history.tanggal_order,
                          history.tanggal_mulai,
                          history.tanggal_akhir,
                          history.waktu_bayar,
                          history.nama_lokasi);
                    },
                    child: Card(
                      child: InkWell(
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
                                          // "No. Kontainer : " +history.kode_kontainer,
                                          history.no_order,
                                          overflow: TextOverflow.visible,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[800],
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          child:
                                              getBayarBlm(history.flag_bayar),
                                        )
                                        // Row(
                                        //   crossAxisAlignment:
                                        //       CrossAxisAlignment.start,
                                        //   children: <Widget>[
                                        //     SizedBox(
                                        //       height: 8.0,
                                        //       width: 5.0,
                                        //       child: CustomPaint(
                                        //         painter: TrianglePainter(),
                                        //       ),
                                        //     ),
                                        //     Container(
                                        //       decoration: BoxDecoration(
                                        //           color: Colors.red,
                                        //           borderRadius:
                                        //               BorderRadius.only(
                                        //                   topRight:
                                        //                       Radius.circular(
                                        //                           6.0),
                                        //                   bottomLeft:
                                        //                       Radius.circular(
                                        //                           6.0))),
                                        //       width: 120.0,
                                        //       height: 30.0,
                                        //       child: getBayarBlm(
                                        //           history.flag_bayar),
                                        //     ),
                                        //   ],
                                        // )

                                        // Container(
                                        //   child:
                                        //       getBayarBlm(history.flag_bayar),
                                        // )
                                        // FlatButton(
                                        //     color: Colors.green,
                                        //     onPressed: () {},
                                        //     child: Text(
                                        //         history.flag_bayar == 0
                                        //             ? "Terbayar"
                                        //             : "Belum Dibayar",
                                        //         style: GoogleFonts.inter(
                                        //             color: Colors.white,
                                        //             fontWeight: FontWeight.bold)))
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      // "No. Order : " + history.no_order,
                                      "No. Kontainer : " +
                                          history.kode_kontainer,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black45,
                                      ),
                                    ),
                                    Text(
                                      "No. Bayar : " + history.kode_refrensi,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black45,
                                      ),
                                    ),
                                    Text(
                                      "Nominal Bayar : " +
                                          rupiah(
                                              history.total_harga.toString()),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black45,
                                      ),
                                    ),
                                    Text(
                                      "Jumlah Sewa : " +
                                          history.jumlah_sewa.toString() +
                                          " /Hari",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black45,
                                      ),
                                    ),
                                    // Text(
                                    //   "Harga : " +
                                    //       rupiah(history.harga.toString()) +
                                    //       " /Hari",
                                    //   style: TextStyle(
                                    //     fontSize: 12,
                                    //     color: Colors.black45,
                                    //   ),
                                    // ),
                                    // Text(
                                    //   "Tgl Order : " + history.tanggal_order,
                                    //   style: TextStyle(
                                    //     fontSize: 12,
                                    //     color: Colors.black45,
                                    //   ),
                                    // ),
                                    // Text(
                                    //   "Tgl awal sewa : " + history.tanggal_mulai,
                                    //   style: TextStyle(
                                    //     fontSize: 12,
                                    //     color: Colors.black45,
                                    //   ),
                                    // ),
                                    // Text(
                                    //   "Tgl akhir sewa : " + history.tanggal_akhir,
                                    //   style: TextStyle(
                                    //     fontSize: 12,
                                    //     color: Colors.black45,
                                    //   ),
                                    // ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: dataIndex.length,
              ),
            ))
          ],
        ),
      ),
    );
  }

  void _openAlertDialogDetail(
      BuildContext context,
      num total_harga,
      harga,
      jumlah_sewa,
      String no_order,
      kode_refrensi,
      kode_kontainer,
      nama_provider,
      tanggal_order,
      tanggal_mulai,
      tanggal_akhir,
      waktu_bayar,
      nama_lokasi) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Container(
              width: 260.0,
              height: MediaQuery.of(context).size.height * 0.55,
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
                              "Detail Pembayaran...",
                              style: GoogleFonts.lato(fontSize: 12),
                            ),
                          ),
                          Divider(),
                          SizedBox(
                            height: 10,
                          ),
                          Text("No. Order : " + no_order.toString(),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Kode. Referensi : " + kode_refrensi.toString(),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Kode. Kontainer : " + kode_kontainer.toString(),
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
                          Text("Nama Lokasi : " + nama_lokasi.toString(),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Waktu Bayar : " + waktu_bayar.toString(),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Nama Provider : " + nama_provider.toString(),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Jumlah Sewa : " + jumlah_sewa.toString(),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Harga : " + harga.toString(),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Total Harga : " + total_harga.toString(),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
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

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2.0;
    Path path = Path();
    path.moveTo(0.0, size.height);
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
