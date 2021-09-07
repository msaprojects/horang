import 'package:commons/commons.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/log/Log.dart';
import 'package:horang/api/models/log/generateKode.model.dart';
import 'package:horang/api/models/log/openLog.dart';
import 'package:horang/api/models/log/selesaiLog.dart';
import 'package:horang/api/models/paymentgateway/paymentgateway.model.dart';
import 'package:horang/api/models/pin/cek.pin.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/DashboardPage/home_page.dart';
import 'package:horang/component/Key/DummyCode.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/OrderPage/ListLog.dart';
import 'package:horang/component/StoragePage/StorageActive.List.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/reusable.class.dart';
import 'package:horang/widget/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class KonfirmasiLog extends StatefulWidget {
  var kode_kontainer,
      nama_kota,
      flag_selesai,
      selesai,
      idtransaksi_detail,
      nama,
      idtransaksi,
      noOrder,
      tglmulai,
      tglakhir,
      tglorder,
      keterangan,
      gambar;
  KonfirmasiLog(
      {this.nama_kota,
      this.idtransaksi,
      this.nama,
      this.kode_kontainer,
      this.noOrder,
      this.tglmulai,
      this.tglakhir,
      this.tglorder,
      this.keterangan,
      this.idtransaksi_detail,
      this.flag_selesai,
      this.selesai,
      this.gambar});

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
      code,
      access_token,
      refresh_token,
      idcustomer,
      kode_kontainer1,
      gambar1,
      idtransaksi_det,
      nama_kota1,
      status1,
      nama1,
      noOrder1,
      tglmulai,
      tglakhir,
      tglorder,
      keterangan,
      idtransaksii,
      nama_customer,
      flag_selesai,
      selesai,
      pin;
  TextEditingController _controllerNoKontainer = TextEditingController();
  TextEditingController _controllerLokasi = TextEditingController();
  TextEditingController _inputPin = TextEditingController();

  Future<void> _tampilInputPin(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Konfirmasi Open"),
            content: SingleChildScrollView(
              child: TextField(
                maxLength: 4,
                onChanged: (values) {
                  print('ada nggk ya valuenya $values');
                },
                controller: _inputPin,
                decoration: InputDecoration(hintText: 'Masukkan PIN anda !'),
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'.toUpperCase()),
              ),
              FlatButton(
                onPressed: () {
                  print('mmass $_inputPin');
                  Pin_Model_Cek pin_cek1 = Pin_Model_Cek(
                    pin_cek: _inputPin.text,
                    token_cek: access_token,
                    // token_notifikasi: token_notifikasi
                  );
                  if (widget.nama
                      .toString()
                      .toLowerCase()
                      .contains('forklift')) {
                    print("ini area forklift");
                    _apiService.CekPin(pin_cek1).then((isSuccess) {
                      _isLoading = true;
                      print("ezz0 $idtransaksi_det, $access_token");
                      GenerateCode gcodezzzz = GenerateCode(
                          idtransaksi_det: idtransaksi_det,
                          token: access_token);
                      if (isSuccess) {
                        //  return successDialog(context, "KOde aktivasine ${gcodezzzz.kode_aktivasi}");
                        //  return buildCode(context);

                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          Flushbar(
                            message: "Ok masuk",
                            flushbarPosition: FlushbarPosition.BOTTOM,
                            icon: Icon(Icons.ac_unit),
                            flushbarStyle: FlushbarStyle.GROUNDED,
                            duration: Duration(seconds: 5),
                          )..show(_scaffoldState.currentState.context);
                        });
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return DummyCode(
                            iddetail_orders: gcodezzzz.idtransaksi_det,
                          );
                        }));
                      } else {
                        return errorDialog(context, 'Open gagal dilakukan');
                      }
                    });
                  } else {
                    _apiService.CekPin(pin_cek1).then((isSuccess) {
                      setState(() {
                        if (isSuccess) {
                          setState(() {
                            _isLoading = true;
                            LogOpen logopen = LogOpen(
                              idtransaksi_detail: idtransaksi_det,
                              token: access_token,
                            );
                            if (widget.kode_kontainer != null ||
                                widget.nama_kota != null) {
                              _apiService.OpenLog(logopen).then((isSuccess) {
                                setState(() => _isLoading = false);
                                if (isSuccess) {
                                  successDialog(context, "",
                                      title:
                                          "Permintaan open berhasil dilakukan !",
                                      closeOnBackPress: false,
                                      showNeutralButton: false,
                                      positiveAction: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Home()),
                                        (Route<dynamic> route) => false);
                                  }, positiveText: 'OK');
                                } else {
                                  errorDialog(context,
                                      "Open kontainer $kode_kontainer1 gagal dilakukan !");
                                }
                              });
                            }
                          });
                        } else if (!isSuccess) {
                          print('Pin salah masku');
                          return errorDialog(
                              context, 'Pin yang anda masukkan salah');
                          // return showDialog(
                          //     context: context,
                          //     builder: (context) {
                          //       Future.delayed(Duration(milliseconds: 100), () {
                          //         Navigator.of(context).pop(true);
                          //       });
                          //       return AlertDialog(
                          //         title: Text("Pin salah"),
                          //       );
                          //     });
                        }
                      });
                    });
                  }
                },
                child: Text('OK'.toUpperCase()),
              ),
            ],
          );
        });
  }

  Widget buildCode(BuildContext context) {
    print("optimus prime1");
    return SafeArea(
      child: FutureBuilder(
          future: _apiService.generateCode(access_token, idtransaksi_det),
          builder: (BuildContext context,
              AsyncSnapshot<List<GenerateCode>> snapshot) {
            if (snapshot.hasError) {
              print("optimus prime2");
              return Center(
                child: Text(
                    "zzSomething wrong with message ${snapshot.error.toString()}"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              print("optimus prime3");
              List<GenerateCode> zcode = snapshot.data;
              // print(snapshot.data);
              print("iamcannor ${snapshot.data}");
              return _designviewCode(zcode);
            } else {
              print("optimus prime4");
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Widget _designviewCode(List<GenerateCode> dataIndex) {
    print("optimus prime");
    return ListView.builder(
        itemCount: dataIndex == null ? 0 : dataIndex.length,
        itemBuilder: (BuildContext context, int index) {
          GenerateCode gCode2 = dataIndex[index];
          return successDialog(
              context, "Kode Aktivasi anda ${gCode2.kode_aktivasi}");
        });
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
    gambar1 = widget.gambar;
    kode_kontainer1 = widget.kode_kontainer;
    nama_kota1 = widget.nama_kota;
    idtransaksi_det = widget.idtransaksi_detail;
    idtransaksii = widget.idtransaksi;
    nama1 = widget.nama;
    noOrder1 = widget.noOrder;
    tglmulai = widget.tglmulai;
    tglorder = widget.tglorder;
    tglakhir = widget.tglakhir;
    keterangan = widget.keterangan;
    flag_selesai = widget.flag_selesai;
    selesai = widget.selesai;
    print("Gambar? " + gambar1);
    super.initState();
    cekToken();
  }

  @override
  void dispose() {
    _apiService.client.close();
    super.dispose();
  }

  Future<bool> _willPopCallback() async {
    ReusableClasses().showAlertDialog(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 0, left: 5, right: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.only(left: 10.0),
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: new BoxDecoration(
                        image: new DecorationImage(
                      // image: new AssetImage("assets/image/container1.png"),
                      image: NetworkImage(gambar1),
                      fit: BoxFit.cover,
                    )),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text(noOrder1.toString(),
                      style: GoogleFonts.inter(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 3,
                  ),
                  Text(nama1.toString(),
                      style: GoogleFonts.inter(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 3,
                  ),
                  Text(kode_kontainer1.toString(),
                      style:
                          GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 5,
                    width: 50,
                    color: Colors.redAccent,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Kota",
                      style:
                          GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                  Text(nama_kota1.toString(),
                      style: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Tanggal Mulai",
                      style:
                          GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                  Text(tglmulai.toString(),
                      style: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Tanggal Akhir",
                      style:
                          GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                  Text(tglakhir.toString(),
                      style: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      print("woyy $access_token");
                    },
                    child: Text("Keterangan",
                        style: GoogleFonts.inter(
                            fontSize: 12, color: Colors.grey)),
                  ),
                  Text(keterangan.toString(),
                      style: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              // padding: EdgeInsets.only(left: 15, right: 15),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 80,
                    height: 70,
                    child: FlatButton(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_open_outlined),
                          // Text("Open $idtransaksi_det",
                          Text(
                              nama_kota1
                                      .toString()
                                      .toLowerCase()
                                      .contains('forklift')
                                  ? "Aktivasi"
                                  : "Open",
                              style: GoogleFonts.inter(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      color: Colors.orange,
                      onPressed: () {
                        _tampilInputPin(context);
                        // warningDialog(context,
                        //     "Apakah anda ingin membuka kode kontainer $kode_kontainer1 ini ?",
                        //     positiveText: "Ya",
                        //     negativeText: "Batal",
                        //     showNeutralButton: false, positiveAction: () {
                        // setState(() {
                        //   _isLoading = true;
                        //   LogOpen logopen = LogOpen(
                        //     idtransaksi_detail: idtransaksi_det,
                        //     token: access_token,
                        //   );
                        //   if (widget.kode_kontainer != null ||
                        //       widget.nama_kota != null) {
                        //     _apiService.OpenLog(logopen).then((isSuccess) {
                        //       setState(() => _isLoading = false);
                        //       if (isSuccess) {
                        //         successDialog(
                        //           context,
                        //           "Permintaan open berhasil dilakukan !",
                        //           closeOnBackPress: true,
                        //         );
                        //       } else {
                        //         errorDialog(context,
                        //             "Open kontainer $kode_kontainer1 gagal dilakukan !");
                        //       }
                        //     });
                        //   }
                        // });
                        // }, negativeAction: () {});
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 90,
                    height: 70,
                    child: FlatButton(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_rounded),
                          SizedBox(
                            width: 30,
                          ),
                          Text("Selesai",
                              style: GoogleFonts.inter(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      color: Colors.lightBlue,
                      onPressed: () {
                        warningDialog(context,
                            "Apakah anda ingin menyelesaikan transaksi ini ?",
                            showNeutralButton: false, positiveAction: () {
                          setState(() {
                            _isLoading = true;
                            selesaiLog selesai = selesaiLog(
                                idtransaksi: idtransaksii, token: access_token);
                            if (widget.nama_kota != null ||
                                widget.kode_kontainer != null) {
                              _apiService.SelesaiLog(selesai).then((isSuccess) {
                                setState(() => _isLoading = false);
                                if (isSuccess) {
                                  successDialog(context, "Berhasil",
                                      showNeutralButton: false,
                                      positiveAction: () {
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                            // builder: (context) => HomePage()));
                                            builder: (context) => HomePage()));
                                  }, positiveText: "Ok");
                                } else {
                                  errorDialog(
                                      context, "Transaksi gagal dilakukan !");
                                }
                              });
                            }
                          });
                        },
                            positiveText: "Ya",
                            negativeText: "Tidak",
                            negativeAction: () {});
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 80,
                    height: 70,
                    child: FlatButton(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sticky_note_2_sharp),
                          SizedBox(
                            width: 30,
                          ),
                          Text("Log",
                              style: GoogleFonts.inter(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      color: Colors.green,
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
                                  )..show(_scaffoldState.currentState.context);
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
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
