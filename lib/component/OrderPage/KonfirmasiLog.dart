import 'dart:math';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/log/Log.dart';
import 'package:horang/api/models/log/openLog.dart';
import 'package:horang/api/models/log/selesaiLog.dart';
import 'package:horang/api/models/paymentgateway/paymentgateway.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/OrderPage/ListLog.dart';
import 'package:horang/component/StoragePage/StorageActive.List.dart';
import 'package:horang/widget/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class KonfirmasiLog extends StatefulWidget {
  // MystorageModel mystorage;
  // KonfirmasiLog({this.mystorage});
  var kode_kontainer, nama_kota, idtransaksi_detail, idtransaksi, nama;
  KonfirmasiLog(
      {this.nama_kota,
      this.nama,
      this.kode_kontainer,
      this.idtransaksi_detail,
      this.idtransaksi});

  @override
  _KonfirmasiLogState createState() => _KonfirmasiLogState();
}

class _KonfirmasiLogState extends State<KonfirmasiLog> {
  SharedPreferences sp;
  bool _isLoading = false,
      isSuccess = true,
      _isFieldNoKontainer,
      _isFieldLokasi;
  ApiService _apiService = ApiService();
  PaymentGateway statussk = PaymentGateway();
  var token = "",
      newtoken = "",
      access_token,
      refresh_token,
      idcustomer,
      kode_kontainer1,
      idtransaksi_det,
      nama_kota1,
      status1,
      nama1,
      idtransaksii;
  TextEditingController _controllerNoKontainer = TextEditingController();
  TextEditingController _controllerLokasi = TextEditingController();

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    idcustomer = sp.getString("idcustomer");

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
    kode_kontainer1 = widget.kode_kontainer;
    nama_kota1 = widget.nama_kota;
    idtransaksi_det = widget.idtransaksi_detail;
    idtransaksii = widget.idtransaksi;
    nama1 = widget.nama;
    // super.initState();
    cekToken();
  }

  Future<bool> _willPopCallback() async {
    showAlertDialog(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // print(statussk.status);
    // print('pymnt :'+statussk.nama_provider);
    print("NAMAAAAAA : ${nama_kota1}");
    new WillPopScope(child: new Scaffold(), onWillPop: _willPopCallback);
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Log Konfirmasi",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Column(
        children: [
          InkWell(
            child: Container(
              margin: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(25),
                    margin: EdgeInsets.only(
                        bottom: 25, top: 25, left: 15, right: 15),
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.95,
                    decoration: BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [Colors.white, Colors.blue[300]]),
                        // color: Colors.blue[200],
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 13.0,
                            offset: Offset(0, 13),
                          )
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Kode Kontainer : " + kode_kontainer1.toString(),
                            style: GoogleFonts.lato(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 9,
                        ),
                        Text("Nama Kontainer : " + nama1.toString(),
                            style: GoogleFonts.lato(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 8,
                        ),
                        Text("Kota : " + nama_kota1.toString(),
                            style: GoogleFonts.lato(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        Text("idtransaksi : " + idtransaksii.toString() + "-" + "iddetail-transaksi" + idtransaksi_det.toString(),
                            style: GoogleFonts.lato(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5, right: 5),
            alignment: Alignment.center,
            child: Row(
              children: [
                Wrap(
                  spacing: 2.0,
                  children: [
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            // print('cekmasuk');
                            LogOpen logopen = LogOpen(
                              idtransaksi_detail: idtransaksi_det,
                              token: access_token,
                            );
                            if (widget.kode_kontainer != null ||
                                widget.nama_kota != null) {
                              _apiService.OpenLog(logopen).then((isSuccess) {
                                // print('cekmasuk2');
                                setState(() => _isLoading = false);
                                if (isSuccess) {
                                  // print('cekmasuk3');
                                  Widget okbutton = FlatButton(
                                    child: Text("Ok"),
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (BuildContext context) => Home()),
                                        ModalRoute.withName('/Home'),
                                      );
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => Home()));
                                      // Navigator.pop(context);
                                    }
                                  );
                                  AlertDialog alert = AlertDialog(
                                    title: Text("Peringatan"),
                                    content: Text("Data Berhasil disimpan"),
                                    actions: [
                                      okbutton,
                                    ],
                                  );
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return alert;
                                    },
                                  );
                                } else {
                                  // print('cekmasuk4');
                                  _scaffoldState.currentState.showSnackBar(
                                      SnackBar(
                                          content: Text("Submit data failed")));
                                }
                              });
                            }
                          });
                        },
                        child: Chip(
                          shadowColor: Colors.black,
                          avatar: CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Text(
                              'O',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          label: Text(
                            "Open",
                            style: TextStyle(color: Colors.black),
                          ),
                          backgroundColor: Colors.white70,
                        )),
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            selesaiLog selesai = selesaiLog(
                                idtransaksi: idtransaksii, token: access_token);
                            if (widget.nama_kota != null ||
                                widget.kode_kontainer != null) {
                              _apiService.SelesaiLog(selesai).then((isSuccess) {
                                setState(() => _isLoading = false);
                                if (isSuccess) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((timeStamp) {
                                    Flushbar(
                                      message: "Ok masuk",
                                      flushbarPosition: FlushbarPosition.BOTTOM,
                                      icon: Icon(Icons.ac_unit),
                                      flushbarStyle: FlushbarStyle.GROUNDED,
                                      duration: Duration(seconds: 5),
                                    )..show(
                                        _scaffoldState.currentState.context);
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              StorageActive()));
                                } else {
                                  print('cekmasuk4');
                                  _scaffoldState.currentState.showSnackBar(
                                      SnackBar(
                                          content: Text("Submit data failed")));
                                }
                              });
                            }
                          });
                        },
                        child: Chip(
                          shadowColor: Colors.black,
                          avatar: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(
                              'S',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          label: Text(
                            "Selesai",
                            style: TextStyle(color: Colors.black),
                          ),
                          backgroundColor: Colors.white70,
                        )),
                    FlatButton(
                        onPressed: () {
                          print("DETAIL ORDER MASUK : $idtransaksi_det");
                          setState(() {
                            _isLoading = true;
                            Logs log1 = Logs(
                                idtransaksi_detail: idtransaksi_det,
                                token: access_token);

                            if (widget.idtransaksi_detail != null) {
                              _apiService.Log_(log1).then((isSuccess) {
                                setState(() => _isLoading = false);
                                if (isSuccess) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((timeStamp) {
                                    Flushbar(
                                      message: "Ok masuk",
                                      flushbarPosition: FlushbarPosition.BOTTOM,
                                      icon: Icon(Icons.ac_unit),
                                      flushbarStyle: FlushbarStyle.GROUNDED,
                                      duration: Duration(seconds: 5),
                                    )..show(
                                        _scaffoldState.currentState.context);
                                  });
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ListLog(
                                      iddetail_orders: log1.idtransaksi_detail,
                                    );
                                  }));
                                } else {
                                  print('cekmasuk4');
                                  _scaffoldState.currentState.showSnackBar(
                                      SnackBar(
                                          content: Text("Submit data failed")));
                                }
                              });
                            }
                          });
                        },
                        child: Chip(
                          shadowColor: Colors.black,
                          avatar: CircleAvatar(
                            backgroundColor: Colors.orange,
                            child: Text(
                              'L',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          label: Text(
                            "Log",
                            style: TextStyle(color: Colors.black),
                          ),
                          backgroundColor: Colors.grey[300],
                        )),
                  ],
                ),
              ],
            ),
          )
        ],
      ),

/////////////////////////////

      // Container(
      //   padding: EdgeInsets.all(9.0),
      //   child: Column(
      //     children: <Widget>[
      //       Column(
      //         children: <Widget>[
      //           Container(
      //             child: Text(
      //               kode_kontainer1.toString(),
      //               style: TextStyle(fontSize: 22, color: Colors.black),
      //             ),
      //           ),
      //           Container(
      //             child: Text(
      //               nama_kota1.toString(),
      //               style: TextStyle(fontSize: 22, color: Colors.black),
      //             ),
      //           ),
      //           Container(
      //             child: Text(
      //               "idtransaksi det" + idtransaksi_det.toString(),
      //               style: TextStyle(fontSize: 22, color: Colors.black),
      //             ),
      //           ),
      //           Container(
      //             child: Text(
      //               "idtransaksi" + idtransaksii.toString(),
      //               style: TextStyle(fontSize: 22, color: Colors.black),
      //             ),
      //           ),
      //           Container(
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //               children: <Widget>[
      //                 RaisedButton(
      //                     child: Text('Open'),
      //                     onPressed: () {
      //                       setState(() {
      //                         _isLoading = true;
      //                         print('cekmasuk');
      //                         LogOpen logopen = LogOpen(
      //                           idtransaksi_detail: idtransaksi_det,
      //                           token: access_token,
      //                         );
      //                         // print(
      //                         //     "widget->kontainer" + widget.kode_kontainer);
      //                         // print("widget->namakota" + widget.nama_kota);
      //                         if (widget.kode_kontainer != null ||
      //                             widget.nama_kota != null) {
      //                           print('cekmasuk111');
      //                           _apiService.OpenLog(logopen).then((isSuccess) {
      //                             print('cekmasuk2');
      //                             setState(() => _isLoading = false);
      //                             if (isSuccess) {
      //                               print('cekmasuk3');
      //                               Widget okbutton = FlatButton(
      //                                 child: Text("Ok"),
      //                                 onPressed: () {
      //                                   Navigator.push(
      //                                       context,
      //                                       MaterialPageRoute(
      //                                           builder: (context) => Home()));
      //                                   // Navigator.pop(context);
      //                                 },
      //                               );
      //                               AlertDialog alert = AlertDialog(
      //                                 title: Text("Peringatan"),
      //                                 content: Text("Data Berhasil disimpan"),
      //                                 actions: [
      //                                   okbutton,
      //                                 ],
      //                               );
      //                               showDialog(
      //                                 context: context,
      //                                 builder: (BuildContext context) {
      //                                   return alert;
      //                                 },
      //                               );
      //                             } else {
      //                               print('cekmasuk4');
      //                               _scaffoldState.currentState.showSnackBar(
      //                                   SnackBar(
      //                                       content:
      //                                           Text("Submit data failed")));
      //                             }
      //                           });
      //                         }
      //                       });
      //                     }),
      //                 RaisedButton(
      //                     child: Text('Selesai'),
      //                     onPressed: () {
      //                       setState(() {
      //                         _isLoading = true;
      //                         selesaiLog selesai = selesaiLog(
      //                             idtransaksi: idtransaksii, token: access_token);
      //                         if (widget.nama_kota != null ||
      //                             widget.kode_kontainer != null) {
      //                           _apiService.SelesaiLog(selesai)
      //                               .then((isSuccess) {
      //                             setState(() => _isLoading = false);
      //                             if (isSuccess) {
      //                               WidgetsBinding.instance
      //                                   .addPostFrameCallback((timeStamp) {
      //                                 Flushbar(
      //                                   message: "Ok masuk",
      //                                   flushbarPosition:
      //                                       FlushbarPosition.BOTTOM,
      //                                   icon: Icon(Icons.ac_unit),
      //                                   flushbarStyle: FlushbarStyle.GROUNDED,
      //                                   duration: Duration(seconds: 5),
      //                                 )..show(
      //                                     _scaffoldState.currentState.context);
      //                               });
      //                               Navigator.push(
      //                                   context,
      //                                   MaterialPageRoute(
      //                                       builder: (context) =>
      //                                           StorageActive()));
      //                             } else {
      //                               print('cekmasuk4');
      //                               _scaffoldState.currentState.showSnackBar(
      //                                   SnackBar(
      //                                       content:
      //                                           Text("Submit data failed")));
      //                             }
      //                           });
      //                         }
      //                       }
      //                       );
      //                     }),
      //                 RaisedButton(
      //                   child: Text('Log'),
      //                   onPressed: () {
      //                     print("DETAIL ORDER MASUK : $idtransaksi_det");
      //                     setState(() {
      //                       _isLoading = true;
      //                       Logs log1 = Logs(
      //                           idtransaksi_detail: idtransaksi_det,
      //                           token: access_token);

      //                       if (widget.idtransaksi_detail != null) {
      //                         _apiService.Log_(log1).then((isSuccess) {
      //                           setState(() => _isLoading = false);
      //                           if (isSuccess) {
      //                             WidgetsBinding.instance
      //                                 .addPostFrameCallback((timeStamp) {
      //                               Flushbar(
      //                                 message: "Ok masuk",
      //                                 flushbarPosition: FlushbarPosition.BOTTOM,
      //                                 icon: Icon(Icons.ac_unit),
      //                                 flushbarStyle: FlushbarStyle.GROUNDED,
      //                                 duration: Duration(seconds: 5),
      //                               )..show(
      //                                   _scaffoldState.currentState.context);
      //                             });
      //                             Navigator.push(context,
      //                                 MaterialPageRoute(builder: (context) {
      //                                   return ListLog(
      //                                     iddetail_orders: log1.idtransaksi_detail,
      //                                   );
      //                                 }));
      //                           } else {
      //                             print('cekmasuk4');
      //                             _scaffoldState.currentState.showSnackBar(
      //                                 SnackBar(
      //                                     content: Text("Submit data failed")));
      //                           }
      //                         });
      //                       }
      //                     });
      //                   },
      //                   color: Colors.teal,
      //                 ),
      //               ],
      //             ),
      //           )
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        print("ini konfirmasi log");
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
