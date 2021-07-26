import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:commons/commons.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:horang/api/models/produk/produk.model.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/reusable.class.dart';
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
import 'package:time_picker_widget/time_picker_widget.dart';

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
  bool showHidetanggalKontainer = false;
  DateTime dtAwal, dtAkhir, _date1, _date2;
  String mText = DateTime.now().toString();
  String aText = DateTime.now().add(Duration(days: 5)).toString();

  String tMulaiForklift = DateFormat('yyyy-MM-dd').format(DateTime.now());
  var formatTglForklift = DateFormat('yyyy-MM-dd'),
      selectedWaktu = TimeOfDay.now();

  SharedPreferences sp;
  ApiService _apiService = ApiService();
  DateTime selectedDate = DateTime.now();
  List<int> _availableHoursAwal = [6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
  List<int> _availableMenitAwal = [0];
  List<int> _availableHoursSelesai = [9, 10, 11, 12, 13, 14, 15, 16, 17, 18];
  List<int> _availableMenitSelesai = [0];
  bool isSuccess = false;
  int valKota, pilihProduk, valuehasilperhitungandurasi = 0;
  var access_token,
      refresh_token,
      idcustomer,
      email,
      nama_customer,
      nama,
      ttanggalAwal = 'Pilih tanggal',
      ttanggalAkhir = 'Pilih Tanggal',
      rtanggalAwal,
      rtanggalAkhir,
      pin,
      defaultProduk = '',
      timehourawal,
      timehourselesai;
  String _selectedDate,
      _dateCount,
      _range,
      _rangeCount,
      _tanggalAwal,
      _tanggalAkhir,
      _pTanggalAkhir = "",
      setTime = "",
      setTimeSelesai = "",
      setDate = "",
      hour = "",
      minutes = "",
      timeawal = "",
      timeselesai = "",
      dateTime,
      pilihproduks = '',
      cektanggal = '',
      timestart = '',
      timefinish = '',
      valueawalperhitungandurasi = "",
      valueakhirperhitungandurasi = "",
      satuan = "";
  double height, width;
  var formatter = new DateFormat('yyyy-MM-dd'),
      selectedTimeAwal = TimeOfDay.now(),
      selectedTimeSelesai =
          TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 180))),
      durasiforklift = DateTime.now().add(new Duration(minutes: 180));

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController timeControllerSelesai = TextEditingController();

  Future<Null> selectDate(BuildContext context) async {
    // cobaJamAwal = DateFormat.Hm().format(DateTime.now());
    final DateTime picked = await showDatePicker(
        context: context,
        // initialDate: selectedDate,
        initialDate: DateTime.parse(tMulaiForklift),
        firstDate: DateTime.parse(tMulaiForklift),
        lastDate: DateTime(2900));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
        // print('selectedtimer $jAwal + $jAkhir + $tMulaiForklift');
      });
  }

  String jAwal = DateFormat.Hm().format(DateTime.now());
  String jAkhir = DateFormat.Hm().format(DateTime.now());

  Future selectTimeAwal(BuildContext context) async {
    final TimeOfDay pick = await showCustomTimePicker(
        context: context,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        },
        onFailValidation: (context) =>
            errorDialog(context, 'Format Tanggal Salah'),
        initialTime: selectedWaktu.replacing(
            hour: _availableHoursAwal.first, minute: _availableMenitAwal.first),
        selectableTimePredicate: (time) =>
            _availableHoursAwal.indexOf(time.hour) != -1 &&
            _availableMenitAwal.indexOf(time.minute) !=
                -1).then((value) => value);
    if (pick != null) {
      setState(() {
        timeawal = pick?.format(context);
        timeController.text = timeawal;
        print('hey look at me $selectedWaktu ++ $timeawal ++ $pick');
      });
    }
  }

  Future selectTimeSelesai(BuildContext context) async {
    final TimeOfDay pick1 = await showCustomTimePicker(
        context: context,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        },
        onFailValidation: (context) =>
            errorDialog(context, 'Format Tanggal Salah'),
        initialTime: selectedWaktu.replacing(
            hour: _availableHoursSelesai.first,
            minute: _availableMenitSelesai.first),
        selectableTimePredicate: (time) =>
            _availableHoursSelesai.indexOf(time.hour) != -1 &&
            _availableMenitSelesai.indexOf(time.minute) !=
                -1).then((value) => value);
    if (pick1 != null) {
      setState(() {
        timeselesai = pick1?.format(context);
        timeControllerSelesai.text = timeselesai;
        print(
            'hey look at me ke2 $selectedTimeSelesai ++ $timeselesai ++ $pick1');
      });
    }
  }

  Future<List<JenisProduk>> url;
  DateTime sekarang = new DateTime.now();

  String mmtext = DateFormat.yMMMd().format(DateTime.now());
  String aatext =
      DateFormat.yMMMd().format(DateTime.now().add(Duration(days: 5)));
  var FlagCari = 0;

  List<dynamic> _dataKota = List();
  void getcomboKota() async {
    final response = await http.get(ApiService().urllokasi,
        headers: {"Authorization": "BEARER ${access_token}"});
    var listdata = json.decode(response.body);
    setState(() {
      _dataKota = listdata;
    });
  }

  var dataProduk = ['kontainer', 'forklift'];

  StreamSubscription connectivityStream;
  ConnectivityResult olders;

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

  int diffInTime(tglAwal, tglAkhir) {
    return ((Duration(hours: tglAkhir.hour) - Duration(hours: tglAwal.hour))
            .inHours)
        // .inMinutes)
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
          showHidetanggalKontainer = false;
          initializeDateFormatting("id_ID", null).then((_) {
            mmtext = DateFormat.yMMMEd("id_ID").format(_date1);
            aatext = DateFormat.yMMMEd("id_ID").format(_date2);
          });
        }
        if (diffInDays(
                DateTime.parse(_tanggalAkhir), DateTime.parse(_tanggalAwal)) <
            5) {
          _date2 = _date1.add(Duration(days: 5));
          _tanggalAwal = DateFormat('yyyy-MM-dd').format(_date1).toString();
          _tanggalAkhir =
              DateFormat('yyyy-MM-dd').format(_date2 ?? _date1).toString();

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

  adaDiskonGak(num diskonn, harganettz, hargaa) {
    if (diskonn != 0) {
      return Column(
        children: [
          Row(
            children: [
              Text(
                rupiah(hargaa.toString(), separator: ',', trailing: '.00'),
                // jenisProduk.harga.toString(),
                style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.lineThrough),
                overflow: TextOverflow.fade,
              ),
              Text(' ($diskonn%)',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ))
            ],
          ),
          Text(
            rupiah(harganettz.toString(), separator: ',', trailing: '.00'),
            // jenisProduk.harga.toString(),
            style: GoogleFonts.inter(
              fontSize: 15,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.fade,
          ),
        ],
      );
    } else {
      return Text(
        rupiah(hargaa.toString(), separator: ',', trailing: '.00'),
        // jenisProduk.harga.toString(),
        style: GoogleFonts.inter(
          fontSize: 15,
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
        overflow: TextOverflow.fade,
      );
      // Text(harganettz.toString()),

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
      getcomboKota();
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

    _date1 = DateTime.parse(tMulaiForklift);

    // defaultProduk = dataProduk[0];
    defaultProduk = '-';
    print('tanggalawalnya $_tanggalAwal ++ $_tanggalAkhir ++ $defaultProduk');

    _buildKomboProduk(pilihproduks);
    setState(() {
      if (pilihproduks == 'forklift') {
        return cektanggal = '0';
      } else {
        return cektanggal = '1';
      }
    });
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

    timeController.text = '-';
    timeControllerSelesai.text = '-';
    _cekKoneksi();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    connectivityStream.cancel();
  }

  void _visibilitymethod() {
    setState(() {
      if (showHidetanggalKontainer) {
        showHidetanggalKontainer = false;
      } else {
        showHidetanggalKontainer = true;
      }
    });
  }

  //DITUTUP KARENA PERUBAHAN FORKLIFT DIPISAH JAM DAN TANGGALNYA
  // Future _popUpTroble(BuildContext context, var jenispro) {
  //   dateTime = DateFormat.yMd().format(DateTime.now());
  //   height = MediaQuery.of(context).size.height;
  //   width = MediaQuery.of(context).size.width;
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //             title: Column(
  //               children: [
  //                 Container(
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text("Pilih Tanggal dan Durasi Sewa",
  //                           style: GoogleFonts.lato(
  //                               fontSize: 13, fontWeight: FontWeight.bold)),
  //                       IconButton(
  //                           iconSize: 14,
  //                           icon: Icon(
  //                             Icons.close_outlined,
  //                           ),
  //                           onPressed: () {
  //                             Navigator.pop(context);
  //                           }),
  //                     ],
  //                   ),
  //                 ),
  //                 Divider(
  //                   thickness: 1,
  //                 ),
  //                 SizedBox(
  //                   height: 7,
  //                 ),
  //                 Text(
  //                     "Pilih tanggal dan jam sewa terlebih dahulu sebelum anda melakukan sewa Forklift ini.",
  //                     style: GoogleFonts.lato(fontSize: 12)),
  //               ],
  //             ),
  //             content: StatefulBuilder(
  //               builder: (BuildContext context, StateSetter setState) {
  //                 return Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Align(
  //                         alignment: Alignment.topLeft,
  //                         child: Text(
  //                           "Tanggal Sewa : ",
  //                           style: GoogleFonts.lato(fontSize: 14),
  //                           textAlign: TextAlign.left,
  //                         )),
  //                     SizedBox(
  //                       height: 7,
  //                     ),
  //                     InkWell(
  //                       onTap: () {
  //                         selectDate(context);
  //                       },
  //                       child: Container(
  //                         width: width / 1.5,
  //                         height: height / 14,
  //                         decoration: BoxDecoration(color: Colors.grey[200]),
  //                         child: TextFormField(
  //                           style: TextStyle(
  //                               fontSize: 20, fontWeight: FontWeight.bold),
  //                           textAlign: TextAlign.center,
  //                           enabled: false,
  //                           keyboardType: TextInputType.text,
  //                           controller: dateController,
  //                           onSaved: (String val) {
  //                             setDate = val;
  //                           },
  //                           decoration: InputDecoration(
  //                               disabledBorder: UnderlineInputBorder(
  //                                   borderSide: BorderSide.none),
  //                               contentPadding: EdgeInsets.only(top: 0.0)),
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 10,
  //                     ),
  //                     Column(
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                           children: [
  //                             Align(
  //                                 alignment: Alignment.topLeft,
  //                                 child: Text(
  //                                   "Jam Mulai : ",
  //                                   style: GoogleFonts.lato(fontSize: 14),
  //                                   textAlign: TextAlign.left,
  //                                 )),
  //                             Align(
  //                                 alignment: Alignment.topLeft,
  //                                 child: Text(
  //                                   "Jam Selesai : ",
  //                                   style: GoogleFonts.lato(fontSize: 14),
  //                                   textAlign: TextAlign.left,
  //                                 )),
  //                           ],
  //                         ),
  //                         SizedBox(
  //                           height: 7,
  //                         ),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             InkWell(
  //                               onTap: () {
  //                                 selectTime(context);
  //                               },
  //                               child: Container(
  //                                 width: width / 3.2,
  //                                 height: height / 14,
  //                                 alignment: Alignment.center,
  //                                 decoration:
  //                                     BoxDecoration(color: Colors.grey[200]),
  //                                 child: TextFormField(
  //                                   style: TextStyle(
  //                                       fontSize: 20,
  //                                       fontWeight: FontWeight.bold),
  //                                   textAlign: TextAlign.center,
  //                                   onSaved: (String val) {
  //                                     setTime = val;
  //                                     // print("jam awalnya -> " + setTime);
  //                                   },
  //                                   enabled: false,
  //                                   keyboardType: TextInputType.text,
  //                                   controller: timeController,
  //                                   decoration: InputDecoration(
  //                                       disabledBorder: UnderlineInputBorder(
  //                                           borderSide: BorderSide.none),
  //                                       // labelText: 'Time',
  //                                       contentPadding: EdgeInsets.all(5)),
  //                                 ),
  //                               ),
  //                             ),
  //                             InkWell(
  //                               onTap: () {
  //                                 selectTimeSelesai(context);
  //                               },
  //                               child: Container(
  //                                 width: width / 3.2,
  //                                 height: height / 14,
  //                                 alignment: Alignment.center,
  //                                 decoration:
  //                                     BoxDecoration(color: Colors.grey[200]),
  //                                 child: TextFormField(
  //                                   style: TextStyle(
  //                                       fontSize: 20,
  //                                       fontWeight: FontWeight.bold),
  //                                   textAlign: TextAlign.center,
  //                                   onSaved: (String val1) {
  //                                     setTimeSelesai = val1;
  //                                     print("jam selesainya -> " +
  //                                         setTimeSelesai);
  //                                   },
  //                                   enabled: false,
  //                                   keyboardType: TextInputType.text,
  //                                   controller: timeControllerSelesai,
  //                                   decoration: InputDecoration(
  //                                       disabledBorder: UnderlineInputBorder(
  //                                           borderSide: BorderSide.none),
  //                                       // labelText: 'Time',
  //                                       contentPadding: EdgeInsets.all(5)),
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(
  //                       height: 10,
  //                     ),
  //                     Container(
  //                         width: 900,
  //                         child: FlatButton(
  //                             color: Colors.red[900],
  //                             onPressed: () {
  //                               Navigator.pushReplacement(context,
  //                                   MaterialPageRoute(builder: (context) {
  //                                 return FormInputOrder(
  //                                   jenisProduk: jenispro,
  //                                   tglawalforklift: selectedDate
  //                                       .format(format: 'yyyy-MM-dd')
  //                                       .toString(),
  //                                   jamawal: selectedTime.format(context),
  //                                   jamakhir:
  //                                       selectedTimeSelesai.format(context),
  //                                 );
  //                               }));
  //                             },
  //                             child: Text(
  //                               'Lanjutkan',
  //                               style: GoogleFonts.inter(
  //                                   fontSize: 14,
  //                                   color: Colors.white,
  //                                   fontWeight: FontWeight.bold),
  //                             ))),
  //                   ],
  //                 );
  //               },
  //             ));
  //       });
  // }

  @override
  Widget build(BuildContext context) {
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
                    Container(
                      margin: EdgeInsets.only(left: 16, right: 16),
                      child: _buildKomboProduk(pilihproduks),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16, right: 16),
                      child: _buildKombokota(valKota),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    cektanggal == '1'
                        ? _buildTanggal()
                        : _buildTanggalFokrlift()
                  ],
                ),
              ),
              FlatButton(
                  minWidth: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() {
                      FlagCari = 1;
                      _search(context, pilihproduks);
                    });
                  },
                  child: Text('Cari')),
              FlagCari == 1
                  ? _search(context, pilihproduks)
                  : Text("Harap Pilih Tanggal dan Kota")
            ],
          ),
        ),
      ),
    );
  }

  Widget _search(BuildContext context, String jenisproduk) {
    if (jenisproduk == 'kontainer') {
      // if (cektanggal == '1') {
      // 1 untuk filter kontainer
      valueawalperhitungandurasi = _tanggalAwal;
      valueakhirperhitungandurasi = _tanggalAkhir;
    } else if (jenisproduk == 'forklift') {
      // } else if (cektanggal == '0') {
      // 0 untuk filter forklift
      print("Search filter forklift");
      if (timeawal.toString() == '' || timeselesai.toString() == '') {
        Fluttertoast.showToast(
            msg: "Pastikan jam awal dan jam selesai sudah terisi !",
            fontSize: 16,
            // gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      } else {
        valueawalperhitungandurasi =
            formatTglForklift.format(selectedDate) + " " + timeawal;
        valueakhirperhitungandurasi =
            formatTglForklift.format(selectedDate) + " " + timeselesai;
        print("INVALID?2 " +
            valueawalperhitungandurasi +
            " ~ " +
            valueakhirperhitungandurasi);
        valuehasilperhitungandurasi = diffInTime(
            DateTime.parse(valueawalperhitungandurasi),
            DateTime.parse(valueakhirperhitungandurasi));

        print("Hasil perhitungan : " + valueakhirperhitungandurasi.toString());
        if (valuehasilperhitungandurasi < 1) {
          Fluttertoast.showToast(
              msg:
                  "tanggal awal tidak boleh lebih kecil atau sama dengan tanggal akhir",
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.black,
              textColor: Colors.white);
        }
      }
    } else {
      Fluttertoast.showToast(
          msg: "Pilih JENIS PRODUK tidak boleh kosong!",
          backgroundColor: Colors.black,
          textColor: Colors.white);
      if (valKota == null ) {
        Fluttertoast.showToast(
            msg: "Pilih KOTA tidak boleh kosong!",
            backgroundColor: Colors.black,
            textColor: Colors.white);
      }
    }
    PostProdukModel data = PostProdukModel(
      token: access_token,
      tanggalawal: valueawalperhitungandurasi,
      tanggalakhir: valueakhirperhitungandurasi,
      idlokasi: valKota,
      jenisitem: jenisproduk,
    );
    // PostProdukModel data = PostProdukModel(
    //   token: access_token,
    //   tanggalawal: cektanggal == '0'
    //       ? '${formatTglForklift.format(selectedDate)} $timeawal'
    //       : _tanggalAwal,
    //   tanggalakhir: cektanggal == '0'
    //       ? '${formatTglForklift.format(selectedDate)} $timeselesai'
    //       : _tanggalAkhir,
    //   idlokasi: valKota,
    //   jenisitem: pilihproduks == '' ? defaultProduk : pilihproduks,
    // );
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
              FlagCari = 0;
              print('flagcari $FlagCari');
              return _buildListView(profiles);
            } else {
              print('masuk sini2');
              FlagCari = 0;
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

  Widget _buildTanggalFokrlift() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height / 8.5,
              margin: EdgeInsets.only(left: 16, right: 16),
              child: FlatButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5)),
                color: Colors.grey[200],
                // onPressed: _visibilitymethod,
                onPressed: () {
                  selectDate(context);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Pilih Tanggal",
                      style: GoogleFonts.lato(
                          fontSize: 12, color: Colors.grey[800]),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: TextFormField(
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              enabled: false,
                              keyboardType: TextInputType.text,
                              controller: dateController,
                              onSaved: (String val) {
                                setDate = val;
                                print('tanggalforklift $val');
                              },
                              decoration: InputDecoration(
                                  disabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  contentPadding: EdgeInsets.only(top: 0.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5)),
                    color: Colors.grey[200],
                    onPressed: () {
                      // selectTime(context);
                      selectTimeAwal(context);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Jam Mulai",
                          style: GoogleFonts.lato(
                              fontSize: 12, color: Colors.grey[800]),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: TextFormField(
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                                onSaved: (String val) {
                                  setTime = val;
                                },
                                enabled: false,
                                keyboardType: TextInputType.text,
                                controller: timeController,
                                decoration: InputDecoration(
                                    isDense: true,
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    // labelText: 'Time',
                                    contentPadding: EdgeInsets.zero),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5)),
                    color: Colors.grey[200],
                    onPressed: () {
                      selectTimeSelesai(context);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Jam Selesai",
                          style: GoogleFonts.lato(
                              fontSize: 12, color: Colors.grey[800]),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: TextFormField(
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                                onSaved: (String val1) {
                                  setTimeSelesai = val1;
                                },
                                enabled: false,
                                keyboardType: TextInputType.text,
                                controller: timeControllerSelesai,
                                decoration: InputDecoration(
                                    isDense: true,
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    contentPadding: EdgeInsets.zero),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        )
      ],
    );
  }

  Widget _buildTanggal() {
    return Column(
      children: [
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: Text(
                        mmtext,
                        style: GoogleFonts.lato(
                            fontSize: 15,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Icon(Icons.arrow_forward_rounded),
                    Flexible(
                      child: Text(
                        aatext,
                        style: GoogleFonts.lato(
                            fontSize: 15,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold),
                      ),
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
        showHidetanggalKontainer == true
            ? new Container(
                child: Column(
                children: [
                  SfDateRangePicker(
                    minDate:
                        DateTime(sekarang.year, sekarang.month, sekarang.day),
                    onSelectionChanged: _onSelectionChanged,
                    selectionMode: DateRangePickerSelectionMode.range,
                    initialSelectedRange: PickerDateRange(_date1, _date2),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 16, left: 16, bottom: 16),
                    alignment: Alignment.topRight,
                    child: Text(
                      'Note : Minimum Pesanan 5 Hari',
                      style: GoogleFonts.inter(
                          fontSize: 12, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.end,
                    ),
                  )
                ],
              ))
            : new Container(),
      ],
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
                                          itemClicked(
                                              context,
                                              jenisProduk.avail,
                                              jenisProduk.kapasitas,
                                              jenisProduk.idlokasi,
                                              jenisProduk.idjenis_produk,
                                              jenisProduk.harga,
                                              jenisProduk.diskon,
                                              jenisProduk.harganett,
                                              jenisProduk.keterangan,
                                              jenisProduk.gambar,
                                              jenisProduk.nama_kota,
                                              jenisProduk.nama_lokasi,
                                              jenisProduk.min_sewa,
                                              jenisProduk.min_deposit);
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
                                                    adaDiskonGak(
                                                        jenisProduk.diskon,
                                                        jenisProduk.harganett,
                                                        jenisProduk.harga)
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

  Widget _buildKombokota(int kotaaaa) {
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

  Widget _buildKomboProduk(String produks) {
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
              Text("$defaultProduk",
                  textAlign: TextAlign.end,
                  style:
                      GoogleFonts.inter(color: Colors.grey[800], fontSize: 14)),
            ],
          )),
      value: pilihProduk == null ? null : dataProduk.join("$pilihproduks"),
      // value: pilihproduks,
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
      items: dataProduk.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: new Text(value,
                style:
                    GoogleFonts.inter(color: Colors.grey[800], fontSize: 14)),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          print('object value $value');
          pilihproduks = value;
          if (value == null) {
            // return defaultProduk;
            return null;
          } else if (pilihproduks == 'forklift') {
            print('hey');
            return cektanggal = '0';
          } else if (pilihproduks == 'kontainer') {
            print('hey123');
            return cektanggal = '1';
          }
        });
      },
    );
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

  itemClicked(
      context,
      int available,
      String jenisproduk,
      num idlokasi,
      num idjenis_produk,
      num harga,
      num diskon,
      num harganett,
      String keterangan,
      String gambar,
      String nama_kota,
      String nama_lokasi,
      num min_sewa,
      num min_deposit) {
    if (idcustomer == "" || idcustomer == null || idcustomer == "0") {
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
            Text('Anda Harus Melengkapi profile untuk melakukan transaksi!'),
        duration: Duration(seconds: 10),
      ));
    } else {
      if (available == 0) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
              'Unit saat ini belum tersedia!, silahkan pilih tanggal dan kota yang lain'),
          duration: Duration(seconds: 3),
        ));
      } else {
        print("masuk filter avail?");
        if (jenisproduk.toLowerCase().contains('forklift')) {
          valueawalperhitungandurasi =
              formatTglForklift.format(selectedDate).toString() +
                  " " +
                  timeawal;
          valueakhirperhitungandurasi =
              formatTglForklift.format(selectedDate).toString() +
                  " " +
                  timeselesai;
          valuehasilperhitungandurasi = diffInTime(
              DateTime.parse(valueawalperhitungandurasi),
              DateTime.parse(valueakhirperhitungandurasi));
          satuan = "/jam";
        } else {
          valueawalperhitungandurasi = _tanggalAwal;
          valueakhirperhitungandurasi = _tanggalAkhir;
          valuehasilperhitungandurasi = diffInDays(
              DateTime.parse(valueakhirperhitungandurasi),
              DateTime.parse(valueawalperhitungandurasi));
          satuan = "/hari";
        }
        print("CHEKING TGL $jenisproduk : " +
            valueawalperhitungandurasi +
            " ~ " +
            valueakhirperhitungandurasi +
            " ~ " +
            valuehasilperhitungandurasi.toString());
        if (valuehasilperhitungandurasi < min_sewa) {
          errorDialog(
              context,
              "Minimal sewa " +
                  jenisproduk +
                  " " +
                  min_sewa.toString() +
                  " " +
                  satuan);
        } else {
          print("VALUE PARAMETER? : " +
              valueawalperhitungandurasi +
              " ~ " +
              valueakhirperhitungandurasi +
              " ~ " +
              idlokasi.toString() +
              " ~ " +
              idjenis_produk.toString() +
              " ~ " +
              harga.toString() +
              " ~ " +
              available.toString() +
              " ~ " +
              diskon.toString() +
              " ~ " +
              harganett.toString() +
              " ~ " +
              min_sewa.toString() +
              " ~ " +
              jenisproduk +
              " ~ " +
              keterangan +
              " ~ " +
              gambar +
              " ~ " +
              nama_kota +
              " ~ " +
              nama_lokasi +
              " ~ " +
              min_deposit.toString());
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormInputOrder(
              tanggaljamawal: valueawalperhitungandurasi,
              tanggaljamakhir: valueakhirperhitungandurasi,
              idlokasi: idlokasi,
              idjenis_produk: idjenis_produk,
              harga: harga,
              avail: available,
              diskon: diskon,
              harganett: harganett,
              min_sewa: min_sewa,
              kapasitas: jenisproduk,
              keterangan: keterangan,
              gambar: gambar,
              nama_kota: nama_kota,
              nama_lokasi: nama_lokasi,
              min_deposit: min_deposit,
            );
          }));
        }
      }
    }
  }
}
