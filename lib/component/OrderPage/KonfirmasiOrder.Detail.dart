import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/order/order.sukses.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/widget/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class KonfirmasiOrderDetail extends StatefulWidget {
  int idorder;
  KonfirmasiOrderDetail({this.idorder});
  @override
  _KonfirmasiOrderDetail createState() => _KonfirmasiOrderDetail();
}

class _KonfirmasiOrderDetail extends State<KonfirmasiOrderDetail> {
  ApiService _apiService = ApiService();
  SharedPreferences sp;
  bool isSuccess = false;
  var access_token,
      refresh_token,
      email,
      nama_customer,
      idcustomer,
      idorders = 0;

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    idcustomer = sp.getString("idcustomer");
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
    }
  }

  @override
  void initState() {
    idorders = widget.idorder;
    cekToken();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: _apiService.listOrderSukses(access_token, idorders),
        builder:
            (BuildContext context, AsyncSnapshot<List<OrderSukses>> snapshot) {
          print("hmm : ${snapshot.connectionState}");
          if (snapshot.hasError) {
            print("coba aja" + snapshot.error.toString());
            return Center(
              child: Text(
                  "5Something wrong with message: ${snapshot.error.toString()}"),
            );
          }
          // else if (snapshot.connectionState == ConnectionState.waiting) {
          //   print("koneksi waiting");
          //   // return Center(
          //   //   child: CircularProgressIndicator(),
          //   // );
          // }
          else if (snapshot.connectionState == ConnectionState.done) {
            print("snapssss" + snapshot.toString());
            List<OrderSukses> orderstatuss = snapshot.data;
            print("iknow ${snapshot.data}");
            return _designForm(orderstatuss);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  // Widget _designForm1(List<OrderSukses> dataIndex){
  //   return Scaffold(
  //     body: Card(
  //       margin: EdgeInsets.all(16),
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(
  //               topRight: Radius.circular(20), topLeft: Radius.circular(20))),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           SizedBox(
  //             height: 100,
  //           ),
  //           Container(
  //             width: double.infinity,
  //             // height: double.infinity,
  //             decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.only(
  //                     topLeft: Radius.circular(20),
  //                     topRight: Radius.circular(20))),
  //             child: Container(
  //               padding: EdgeInsets.all(16),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.only(top: 10, bottom: 10),
  //                     child: Text(
  //                       "ORDER NUMBER: 1109928129819282",
  //                       style:
  //                           GoogleFonts.lato(color: Colors.grey, fontSize: 12),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           Container(
  //             child: ListView.builder(
  //               itemBuilder: (context, index){
  //                 OrderSukses os = dataIndex[index];
  //                 print("KOREF"+os.kode_refrensi);
  //                 return Card(
  //                   child: new Column(
  //                     children: <Widget>[
  //                       SizedBox(
  //                         height: 30,
  //                       ),
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: <Widget>[
  //                           Container(
  //                             padding: const EdgeInsets.only(left: 20),
  //                             child: Row(
  //                               children: <Widget>[Text("No. Order :", style: TextStyle(fontWeight: FontWeight.bold),)],
  //                             ),
  //                           ),
  //                           Container(
  //                             padding:
  //                             const EdgeInsets.only(top: 0.0, right: 20),
  //                             child: Text(
  //                               os.no_order, style: TextStyle(fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: <Widget>[
  //                           Container(
  //                             padding: const EdgeInsets.only(left: 20),
  //                             child: Row(
  //                               children: <Widget>[Text("Nomor Kontainer :")],
  //                             ),
  //                           ),
  //                           Container(
  //                             padding:
  //                             const EdgeInsets.only(top: 0.0, right: 20),
  //                             child: Text(
  //                               os.kode_kontainer, style: TextStyle(fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: <Widget>[
  //                           Container(
  //                             padding: const EdgeInsets.only(left: 20),
  //                             child: Row(
  //                               children: <Widget>[Text("Durasi :")],
  //                             ),
  //                           ),
  //                           Container(
  //                             padding:
  //                             const EdgeInsets.only(top: 0.0, right: 20),
  //                             child: Text(
  //                               os.jumlah_sewa.toString(), style: TextStyle(fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: <Widget>[
  //                           Container(
  //                             padding: const EdgeInsets.only(left: 20),
  //                             child: Row(
  //                               children: <Widget>[Text("Asuransi :")],
  //                             ),
  //                           ),
  //                           Container(
  //                             padding:
  //                             const EdgeInsets.only(top: 0.0, right: 20),
  //                             child: Text(
  //                               'Ya, Rp. 50.000',
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: <Widget>[
  //                           Container(
  //                             padding: const EdgeInsets.only(left: 20),
  //                             child: Row(
  //                               children: <Widget>[Text("Voucher :")],
  //                             ),
  //                           ),
  //                           Container(
  //                             padding:
  //                             const EdgeInsets.only(top: 0.0, right: 20),
  //                             child: Text(
  //                               'Tidak, Rp. 0',
  //                             ),
  //                           ),
  //                         ],
  //                       ),Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: <Widget>[
  //                           Container(
  //                             padding: const EdgeInsets.only(left: 20),
  //                             child: Row(
  //                               children: <Widget>[Text("Harga Sewa :")],
  //                             ),
  //                           ),
  //                           Container(
  //                             padding:
  //                             const EdgeInsets.only(top: 0.0, right: 20),
  //                             child: Text(
  //                               os.harga.toString(),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       SizedBox(
  //                         height: 8,
  //                       ),
  //                       Divider(
  //                         height: 16,
  //                       ),
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: <Widget>[
  //                           Container(
  //                             padding: const EdgeInsets.only(left: 20),
  //                             child: Row(
  //                               children: <Widget>[Text("No. Pembayaran :", style: TextStyle(fontWeight: FontWeight.bold),)],
  //                             ),
  //                           ),
  //                           Container(
  //                             padding:
  //                             const EdgeInsets.only(top: 0.0, right: 20),
  //                             child: Text(
  //                               os.kode_refrensi,style: TextStyle(fontWeight: FontWeight.bold),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: <Widget>[
  //                           Container(
  //                             padding: const EdgeInsets.only(left: 20),
  //                             child: Row(
  //                               children: <Widget>[Text("Pembayaran")],
  //                             ),
  //                           ),
  //                           Container(
  //                             padding: const EdgeInsets.only(right: 20),
  //                             child: Text(
  //                               os.nama_provider,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: <Widget>[
  //                           Container(
  //                             padding: const EdgeInsets.only(left: 20),
  //                             child: Row(
  //                               children: <Widget>[Text("Status Pembayaran")],
  //                             ),
  //                           ),
  //                           Container(
  //                             padding: const EdgeInsets.only(right: 20),
  //                             child: Text(
  //                               'Berhasil',
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: <Widget>[
  //                           Container(
  //                             padding: const EdgeInsets.only(left: 20),
  //                             child: Row(
  //                               children: <Widget>[Text("Total Pembayaran")],
  //                             ),
  //                           ),
  //                           Container(
  //                             padding: const EdgeInsets.only(right: 20),
  //                             child: Text(
  //                               os.total_harga.toString(),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       SizedBox(
  //                         height: 10,
  //                       ),
  //                       Container(
  //                         width: MediaQuery.of(context).size.width / 1,
  //                         height: 60,
  //                         padding: EdgeInsets.only(left: 10, right: 10),
  //                         margin: EdgeInsets.only(top: 3),
  //                         child: RaisedButton(
  //                           color: Colors.blue[300],
  //                           onPressed: () {
  //                             Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                     builder: (context) => Home()));
  //                           },
  //                           child: Text(
  //                             "OK",
  //                             style: (TextStyle(
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 16,
  //                                 color: Colors.white)),
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 10,
  //                       ),
  //                     ],
  //                   ),
  //                 );
  //               },
  //               itemCount: dataIndex.length,
  //               ),
  //           ),
  //           Container(
  //             height: 10,
  //             decoration: BoxDecoration(
  //                 image: DecorationImage(
  //                     image: AssetImage("assets/image/paper_gold.png"),
  //                     fit: BoxFit.fill)),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _designForm(List<OrderSukses> dataIndex) {
    OrderSukses orders;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Pesanan Anda",
          style: TextStyle(color: Colors.white),
        ),
        //Blocking Back
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                left: 5,
                right: 5,
              ),
              color: Colors.grey[100],
              child: ListView.builder(
                itemBuilder: (context, index) {
                  OrderSukses os = dataIndex[index];
                  print("KOREF" + os.kode_refrensi);
                  return Card(
                    child: new Column(
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "No. Order :",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 20),
                              child: Text(
                                os.no_order,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(children: <Widget>[
                                Text("Nomor Kontainer :")
                              ]),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 20),
                              child: Text(
                                os.kode_kontainer,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: <Widget>[Text("Durasi :")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 20),
                              child: Text(
                                os.jumlah_sewa.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: <Widget>[Text("Asuransi :")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 20),
                              child: Text(
                                'Ya, Rp. 50.000',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: <Widget>[Text("Voucher :")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 20),
                              child: Text(
                                'Tidak, Rp. 0',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: <Widget>[Text("Harga Sewa :")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 20),
                              child: Text(
                                os.harga.toString(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Divider(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "No. Pembayaran :",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 20),
                              child: Text(
                                os.kode_refrensi,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: <Widget>[Text("Pembayaran")],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(right: 20),
                              child: Text(
                                os.nama_provider,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: <Widget>[Text("Status Pembayaran")],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(right: 20),
                              child: Text(
                                'Berhasil',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: <Widget>[Text("Total Pembayaran")],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(right: 20),
                              child: Text(
                                os.total_harga.toString(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1,
                          height: 60,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          margin: EdgeInsets.only(top: 3),
                          child: RaisedButton(
                            color: Colors.blue[300],
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home()));
                            },
                            child: Text(
                              "OK",
                              style: (TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  );
                },
                itemCount: dataIndex.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        print("ini konfirmasi order detail");
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
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    Path path = Path();

    path.lineTo(0, size.height);
    var radius = 10.0;
    int jumlahreg = (size.width / (radius * 2)).toInt();
    if (jumlahreg % 6 == 0) jumlahreg--;
    path.lineTo((size.width - 2 * radius * jumlahreg) / 2, size.height);
    for (int i = 0; i < jumlahreg; i++)
      if (i % 2 == 0) {
        path.relativeArcToPoint(Offset(2.0 * radius * 1.3, 0),
            radius: Radius.circular(radius), clockwise: true);
      } else {
        path.relativeLineTo(2 * radius * 0.7, 0);
      }
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
    // path.lineTo(size.width, size.height);
    // path.lineTo(size.width, 0.0);

    // path.addOval(Rect.fromCircle(
    //   center: Offset(0.0, size.height / 2), radius: 20.0
    // ));
    // path.addOval(Rect.fromCircle(
    //   center: Offset(size.width, size.height / 2), radius: 20.0
    // ));

    // return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
