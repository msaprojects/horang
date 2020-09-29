import 'dart:math';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
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
  var kode_kontainer, nama_kota, iddetail_order, idorder;
  KonfirmasiLog(
      {this.nama_kota, this.kode_kontainer, this.iddetail_order, this.idorder});

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
      iddetail_order1,
      nama_kota1,
      status1,
      idorders;
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
    iddetail_order1 = widget.iddetail_order;
    idorders = widget.idorder;
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
      body: Container(
        padding: EdgeInsets.all(9.0),
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  child: Text(
                    kode_kontainer1.toString(),
                    style: TextStyle(fontSize: 22, color: Colors.black),
                  ),
                ),
                Container(
                  child: Text(
                    nama_kota1.toString(),
                    style: TextStyle(fontSize: 22, color: Colors.black),
                  ),
                ),
                Container(
                  child: Text(
                    "iddetail_order" + iddetail_order1.toString(),
                    style: TextStyle(fontSize: 22, color: Colors.black),
                  ),
                ),
                Container(
                  child: Text(
                    "idorder" + idorders.toString(),
                    style: TextStyle(fontSize: 22, color: Colors.black),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                          child: Text('Open'),
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                              print('cekmasuk');
                              LogOpen logopen = LogOpen(
                                iddetail_order: iddetail_order1,
                                token: access_token,
                              );
                              print(
                                  "widget->kontainer" + widget.kode_kontainer);
                              print("widget->namakota" + widget.nama_kota);
                              if (widget.kode_kontainer != null ||
                                  widget.nama_kota != null) {
                                print('cekmasuk111');
                                _apiService.OpenLog(logopen).then((isSuccess) {
                                  print('cekmasuk2');
                                  setState(() => _isLoading = false);
                                  if (isSuccess) {
                                    print('cekmasuk3');
                                    Widget okbutton = FlatButton(
                                      child: Text("Ok"),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Home()));
                                        // Navigator.pop(context);
                                      },
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
                                    print('cekmasuk4');
                                    _scaffoldState.currentState.showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("Submit data failed")));
                                  }
                                });
                              }
                            });
                          }),
                      RaisedButton(
                          child: Text('Selesai'),
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                              selesaiLog selesai = selesaiLog(
                                  idorder: idorders, token: access_token);
                              if (widget.nama_kota != null ||
                                  widget.kode_kontainer != null) {
                                _apiService.SelesaiLog(selesai)
                                    .then((isSuccess) {
                                  setState(() => _isLoading = false);
                                  if (isSuccess) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((timeStamp) {
                                      Flushbar(
                                        message: "Ok masuk",
                                        flushbarPosition:
                                            FlushbarPosition.BOTTOM,
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
                                            content:
                                                Text("Submit data failed")));
                                  }
                                });
                              }
                            });
                          }),
                      RaisedButton(
                        child: Text('Log'),
                        onPressed: () {
                          print("DETAIL ORDER MASUK : $iddetail_order1");
                          setState(() {
                            _isLoading = true;
                            Logs log1 = Logs(
                                iddetail_order: iddetail_order1,
                                token: access_token);

                            if (widget.iddetail_order != null) {
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
                                          iddetail_orders: log1.iddetail_order,
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
                        color: Colors.teal,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
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
