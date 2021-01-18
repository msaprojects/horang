import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:commons/commons.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:horang/api/models/produk/produk.model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/jenisproduk/jenisproduk.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/OrderPage/Order.Input.dart';
import 'package:indonesia/indonesia.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/date_symbol_data_local.dart';

class ProdukList extends StatefulWidget {
  var tanggalAwal, tanggalAkhir;
  ProdukList({this.tanggalAwal, this.tanggalAkhir});
  @override
  _ProdukList createState() => _ProdukList();
}

class MyHttpOverride extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    // TODO: implement createHttpClient
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class _ProdukList extends State<ProdukList> {
  bool a = false;
  DateTime dtAwal, dtAkhir, _date1, _date2;
  String mText = DateTime.now().toString();
  String aText = DateTime.now().add(Duration(days: 5)).toString();
  String string = DateFormat.yMMMd().add_Hm().format(DateTime.now());

  SharedPreferences sp;
  ApiService _apiService = ApiService();
  bool isSuccess = false;
  int valKota;
  var access_token, refresh_token, idcustomer, email, nama_customer, nama;
  TextEditingController _controlleridkota;
  var ttanggalAwal = 'Pilih tanggal',
      ttanggalAkhir = 'Pilih Tanggal',
      rtanggalAwal,
      rtanggalAkhir;
  String _selectedDate;
  String _dateCount;
  String _range;
  String _rangeCount;
  String _tanggalAwal, _tanggalAkhir;
  String _pTanggalAkhir = "";
  String _date = "Not set";
  String _time = "Not set";

  Future<List<JenisProduk>> url;
  DateTime sekarang = new DateTime.now();

  String mmtext = DateFormat.yMMMd().format(DateTime.now());
  String aatext =
  DateFormat.yMMMd().format(DateTime.now().add(Duration(days: 5)));
  var FlagCari = 0;

  List<dynamic> _dataKota = List();
  void getcomboProduk() async {
    final response = await http.get(ApiService().urllokasi,
        headers: {"Authorization": "BEARER ${access_token}"});
    var listdata = json.decode(response.body);
    setState(() {
      _dataKota = listdata;
    });
  }

  StreamSubscription connectivityStream;
  ConnectivityResult olders;

  Future _popUpTroble(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Sesi Anda Berakhir!"),
            content: Text(
                "Harap masukkan kembali email beserta nomor handphone untuk mengakses fitur di aplikasi ini."),
            actions: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          theme: DatePickerTheme(containerHeight: 210.0),
                          showTitleActions: true,
                          minTime: DateTime.now(),
                          maxTime: DateTime(2099, 12, 31), onConfirm: (date) {
                            print('confirm $date');
                            _date = '${date.year} - ${date.month} - ${date.day}';
                            setState(() {});
                          }, currentTime: DateTime.now(), locale: LocaleType.id);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.date_range,
                                  size: 18.0,
                                  color: Colors.teal,
                                ),
                                Text(
                                  "$_date",
                                  style: GoogleFonts.lato(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "  Change",
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                    color: Colors.white10,
                  ),
                ],
              ),
            ],
          );
        });
  }

  Widget getDateRangePicker() {
    return Container(
        height: 250,
        child: Card(
            child: SfDateRangePicker(
              view: DateRangePickerView.month,
              selectionMode: DateRangePickerSelectionMode.single,
              onSelectionChanged: selectionChanged,
            )));
  }

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    _selectedDate = DateFormat('dd MMMM, yyyy').format(args.value);

    SchedulerBinding.instance.addPostFrameCallback((duration) {
      setState(() {});
    });
  }

  // Future _popUpTroble(BuildContext context) {
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           content: new Container(
  //             width: 250,
  //             height: 350,
  //             decoration: new BoxDecoration(
  //               shape: BoxShape.rectangle,
  //               color: const Color(0xFFFFFF),
  //               borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
  //             ),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.stretch,
  //               children: [
  //                 Container(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Container(
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Text(
  //                               "Opsi Pilihan...",
  //                               style: GoogleFonts.lato(fontSize: 14),
  //                             ),
  //                             IconButton(
  //                                 iconSize: 14,
  //                                 icon: Icon(
  //                                   Icons.close_outlined,
  //                                 ),
  //                                 onPressed: () {
  //                                   Navigator.pop(context);
  //                                 }),
  //                           ],
  //                         ),
  //                       ),
  //                       Divider(
  //                         thickness: 1,
  //                       ),
  //                       SizedBox(
  //                         height: 10,
  //                       ),
  //                       Text("Pilih Tanggal",
  //                           style: GoogleFonts.lato(
  //                               fontSize: 14, fontWeight: FontWeight.bold)),
  //                       SizedBox(
  //                         height: 5,
  //                       ),
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                         children: <Widget>[
  //                           InkWell(
  //                             child: Text(selectedTgl,
  //                                 textAlign: TextAlign.center,
  //                                 style: TextStyle(color: Color(0xFF000000))),
  //                             onTap: () {
  //                               selectTanggal(context);
  //                             },
  //                           ),
  //                           IconButton(
  //                             icon: Icon(Icons.calendar_today),
  //                             tooltip: 'Tap to open date picker',
  //                             onPressed: () {
  //                               selectTanggal(context);
  //                             },
  //                           ),
  //                         ],
  //                       ),
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                         children: <Widget>[
  //                           IconButton(
  //                             icon: Icon(Icons.calendar_today),
  //                             tooltip: 'Tap to open date picker',
  //                             onPressed: () {
  //                               selectTanggal(context);
  //                             },
  //                           ),
  //                         ],
  //                       ),
  //                       Container(
  //                           width: 900,
  //                           child: FlatButton(
  //                               color: Colors.red[900],
  //                               onPressed: () {},
  //                               child: Text(
  //                                 'Lost Device',
  //                                 style: GoogleFonts.inter(
  //                                     fontSize: 14,
  //                                     color: Colors.white,
  //                                     fontWeight: FontWeight.bold),
  //                               ))),
  //                     ],
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  void _cekKoneksi() async {
    connectivityStream = await Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult resnow) {
      if (resnow == ConnectivityResult.none) {
        print("No Connection");
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: new Text("Peringatan"),
                content: new Text(
                    "Jaringan anda bermasalah, periksa koneksi anda lagi!"),
                actions: <Widget>[
                  new FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: new Text("Tutup"))
                ],
              );
            });
      } else if (olders == ConnectivityResult.none) {
        print("Tersambung");
        RefreshIndicator(
          onRefresh: () async {
            this.cekToken().reset();
            await Future.value({});
          },
          child: null,
        );
        setState(() {});
      }
      olders = resnow;
    });
  }

  int diffInDays(DateTime akhir, DateTime awal) {
    return ((akhir.difference(awal) -
        Duration(hours: akhir.hour) +
        Duration(hours: awal.hour))
        .inHours /
        24)
        .round();
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _date1 = args.value.startDate;
        _date2 = args.value.endDate;
        _range = DateFormat('yyyy-MM-dd').format(_date1).toString() +
            ' - ' +
            DateFormat('yyyy-MM-dd').format(_date2 ?? _date1).toString();
        _tanggalAwal = DateFormat('yyyy-MM-dd').format(_date1).toString();
        _tanggalAkhir =
            DateFormat('yyyy-MM-dd').format(_date2 ?? _date1).toString();
        if (_date2.isAfter(_date1)) {
          a = false;
          initializeDateFormatting("id_ID", null).then((_) {
            mmtext = DateFormat.yMMMEd("id_ID").format(_date1);
            aatext = DateFormat.yMMMEd("id_ID").format(_date2);
          });
        }

        if (diffInDays(
            DateTime.parse(_tanggalAkhir), DateTime.parse(_tanggalAwal)) <
            5) {
          // dateValidation(context, _date2 = _date1.add(Duration(days: 5)));
          warningDialog(
            context,
            "Mohon maaf pesanan harus minimum 5 hari, tanggal yang anda pilih akan secara otomatis di bulatkan menjadi 5 hari dari tanggal awal yang anda pilih, Setuju?",
            title: "minimal sewa 5 hari",
            positiveAction: () {},
          );
        }
      } else if (args.value is DateTime) {
        _selectedDate = args.value;
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    idcustomer = sp.getString("idcustomer");
    email = sp.getString("email");
    nama_customer = sp.getString("nama_customer");
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
      getcomboProduk();
    }
  }

  @override
  void initState() {
    initializeDateFormatting("id_ID", null).then((_) {
      mmtext = DateFormat.yMMMEd("id_ID").format(DateTime.now());
      aatext = DateFormat.yMMMEd("id_ID")
          .format(DateTime.now().add(Duration(days: 5)));
    });
    cekToken();
    _date1 = DateTime.now();
    _date2 = DateTime.now().add(Duration(days: 5));
    _tanggalAwal = _date1.toString();
    _tanggalAkhir = _date2.toString();
    // ttanggalAwal = widget.tanggalAwal;
    // ttanggalAkhir = widget.tanggalAkhir;
    print("HMMM : $access_token");
    _cekKoneksi();
    super.initState();
    // print("Hasil Val Kota"+valKota);
  }

  @override
  void dispose() {
    super.dispose();
    connectivityStream.cancel();
  }

  void _visibilitymethod() {
    setState(() {
      if (a) {
        a = false;
      } else {
        a = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // print("ttawalakhir ${_tanggalAwal + _tanggalAkhir}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Halaman Order",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.transparent,
            ),
            onPressed: () {
              // Navigator.pop(context);
            }),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.1,
                      margin: EdgeInsets.only(left: 16, right: 16),
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5)),
                        color: Colors.grey[200],
                        onPressed: _visibilitymethod,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Mulai",
                                  style: GoogleFonts.lato(
                                      fontSize: 12, color: Colors.grey[800]),
                                ),
                                Text(
                                  "Akhir",
                                  style: GoogleFonts.lato(
                                      fontSize: 12, color: Colors.grey[800]),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            // Text(
                            //   string,
                            //   mText,
                            //   style: GoogleFonts.inter(
                            //     color: Colors.grey[800],
                            //     fontSize: 18,
                            //   ),
                            //   textAlign: TextAlign.left,
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  // string,
                                  // sDate.toString(),
                                  mmtext,
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(Icons.arrow_forward_rounded),
                                Text(
                                  // fDate.toString(),
                                  aatext,
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    a == true
                        ? new Container(
                        child: Column(
                          children: [
                            SfDateRangePicker(
                              minDate: DateTime(sekarang.year, sekarang.month,
                                  sekarang.day),
                              onSelectionChanged: _onSelectionChanged,
                              selectionMode:
                              DateRangePickerSelectionMode.range,
                              initialSelectedRange:
                              PickerDateRange(_date1, _date2),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  right: 16, left: 16, bottom: 16),
                              alignment: Alignment.topRight,
                              child: Text(
                                'Note : Minimum Pesanan 5 Hari',
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic),
                                textAlign: TextAlign.end,
                              ),
                            )
                          ],
                        ))
                        : new Container(),
                    Container(
                      margin: EdgeInsets.only(left: 16, right: 16),
                      child: _buildKomboProduk(valKota),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FlatButton(
                  minWidth: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() {
                      FlagCari = 1;
                      _search(context);
                    });
                  },
                  child: Text('Cari')),
              FlagCari == 1
                  ? _search(context)
                  : Text("Harap Pilih Tanggal dan Kota")
            ],
          ),
        ),
      ),
    );
  }

  Widget _search(BuildContext context) {
    PostProdukModel data = PostProdukModel(
        token: access_token,
        tanggalawal: _tanggalAwal,
        tanggalakhir: _tanggalAkhir,
        idlokasi: valKota);
    print("PRODUK DATA : "+data.toString());
    return SafeArea(
      child: FutureBuilder(
        future: _apiService.listProduk(data),
        builder:
            (BuildContext context, AsyncSnapshot<List<JenisProduk>> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Center(
              child: Text(
                // "8Something wrong with message: ${snapshot.error.toString()}"
                  "Harap pilih tanggal dan kota yang ingin anda sewa"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<JenisProduk> profiles = snapshot.data;
            if (profiles != null) {
              return _buildListView(profiles);
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
                        "Oppss..Maaf Jenis Container yang anda cari tidak ditemukan, pilih tanggal dan kota lainya.",
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
        },
      ),
    );
  }

  Widget _buildListView(List<JenisProduk> dataIndex) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.55,
                  child: Column(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(
                              left: 15,
                              right: 15,
                            ),
                            color: Colors.grey[100],
                            child: Scrollbar(
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  JenisProduk jenisProduk = dataIndex[index];
                                  return Container(
                                    child: Card(
                                      child: InkWell(
                                        onTap: () {
                                          // print("idjenis produknya adalah");
                                          // print(jenisProduk.idjenis_produk);
                                          if (nama_customer == "" ||
                                              nama_customer == null ||
                                              nama_customer == "0") {
                                            Scaffold.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Anda Harus Melengkapi profile untuk melakukan transaksi!'),
                                              duration: Duration(seconds: 10),
                                            ));
//                        Navigator.pop(context, false);
                                          } else if (jenisProduk.avail == 0) {
                                            Scaffold.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Unit saat ini belum tersedia!, silahkan pilih tanggal dan kota yang lain'),
                                              duration: Duration(seconds: 3),
                                            ));
                                          } else {
                                            if (jenisProduk.kapasitas
                                                .toString()
                                                .toLowerCase()
                                                .contains('forklift')) {
                                              // return print("hello mama");
                                              _popUpTroble(context);
                                            } else {
                                              // print("zzzz ${jenisProduk.kapasitas}");
                                              // print("my mom is hero ${jenisProduk.kapasitas.toString().toLowerCase().indexOf("forklift")>0}");
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                        return FormInputOrder(
                                                          jenisProduk: jenisProduk,
                                                          tglawal12: _tanggalAwal,
                                                          tglakhir12: _tanggalAkhir,
                                                        );
                                                      }));
                                            }
                                          }
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10, right: 10),
                                                  child: Container(
                                                    child: Container(
                                                      height:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.4,
                                                      width:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.4,
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              fit: BoxFit
                                                                  .contain,
                                                              image: NetworkImage(
                                                                  jenisProduk
                                                                      .gambar))),
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  children: <Widget>[
                                                    Text(
                                                      jenisProduk.kapasitas,
                                                      style: GoogleFonts.inter(
                                                          fontSize: 14,
                                                          color:
                                                          Colors.grey[800],
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      jenisProduk.nama_kota,
                                                      style: GoogleFonts.inter(
                                                        fontSize: 12,
                                                        color: Colors.grey[500],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      rupiah(
                                                          jenisProduk.harga
                                                              .toString(),
                                                          separator: ',',
                                                          trailing: '.00'),
                                                      // jenisProduk.harga.toString(),
                                                      style: GoogleFonts.inter(
                                                          fontSize: 15,
                                                          color: Colors.green,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                      overflow:
                                                      TextOverflow.fade,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 16, right: 16),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.widgets,
                                                        size: 12,
                                                        color: Colors.grey[600],
                                                      ),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        "Tersedia " +
                                                            jenisProduk.avail
                                                                .toString() +
                                                            " Unit",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[600],
                                                            fontSize: 12),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: dataIndex.length,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildKomboProduk(int kotaaaa) {
    return DropdownButtonFormField(
      hint: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Row(
            children: [
              Icon(
                Icons.search,
              ),
              SizedBox(
                width: 7,
              ),
              Text("Pilih Kota",
                  textAlign: TextAlign.end,
                  style:
                  GoogleFonts.inter(color: Colors.grey[800], fontSize: 14)),
            ],
          )),
      value: valKota,
      decoration: InputDecoration(
          fillColor: Colors.grey[200],
          filled: true,
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
              borderSide:
              const BorderSide(color: Colors.transparent, width: 0.0),
              borderRadius: BorderRadius.circular(5.0)),
          isDense: true,
          contentPadding:
          const EdgeInsets.only(bottom: 8.0, top: 8.0, left: 5.0)),
      items: _dataKota.map((item) {
        return DropdownMenuItem(
          // child: Text(item['nama_kota']),
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "${item['nama_kota']}, ${item['nama_lokasi']}",
              style: GoogleFonts.inter(color: Colors.grey[800], fontSize: 14),
            ),
          ),
          value: item['idlokasi'],
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          valKota = value;
        });
      },
    );
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        print("ini produk lis");
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

  Widget dateValidation(BuildContext context, kondisi) {
    Widget okButton = FlatButton(
        child: Text("Iya"),
        onPressed: () {
          Navigator.pop(context);
        });
    AlertDialog alert = AlertDialog(
      title: Text("Minimum sewa 5 Hari"),
      content: Text(
          "Mohon maaf pesanan harus minimum 5 hari, tanggal yang anda pilih akan secara otomatis di bulatkan menjadi 5 hari dari tanggal awal yang anda pilih, Setuju?"),
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