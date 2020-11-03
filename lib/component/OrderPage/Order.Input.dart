import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/jenisproduk/jenisproduk.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/PaymentPage/Pembayaran.Input.dart';
import 'package:horang/widget/datePicker.dart';
import 'package:indonesia/indonesia.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormInputOrder extends StatefulWidget {
  JenisProduk jenisProduk;
  FormInputOrder({this.jenisProduk});

  @override
  _FormDetailOrder createState() => _FormDetailOrder();
}

class _FormDetailOrder extends State<FormInputOrder> {
  final oCcy = new NumberFormat("#,##0.00", "id_ID");
  bool isLoading = false;
  ApiService _apiService = ApiService();
  var kapasitas, harga, alamat, vKeterangan, idjenis_produk;
  var hasilperhitungan = "0", tambahasuransi = "0";
  int jumlah_sewas;
  bool asuransi = false;
  var asuransie = 0, nomasuransi = 50000;
  var Value,
      title,
      valasuransi,
      urlcomboAsuransi = "http://192.168.1.243:9992/api/asuransiaktif";
  List<dynamic> _dataAsuransi = List();

  TextEditingController _controllerIdAsuransi;
  DateTime dtAwal, dtAkhir, _date, _date2;

  var tglAwal, tglAkhir, pilihtanggal, pilihtanggal2;
  TextStyle valueTglAwal = TextStyle(fontSize: 16.0);
  TextStyle valueTglAkhir = TextStyle(fontSize: 16.0);
  Future<Null> _selectionDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030));
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
        if (_date.isAfter(_date2)) _date2 = _date.add(new Duration(days: 3));
        pilihtanggal = new DateFormat("yyyy-MM-dd 00:00:00").format(_date);
        jumlah_sewas = DateTime.parse(pilihtanggal2)
            .difference(DateTime.parse(pilihtanggal))
            .inDays;
        hasilperhitungan = hitungall(
            harga.toString(), jumlah_sewas.toString(), nomasuransi.toString());
      });
    } else {}
  }

  Future<Null> _selectionDate2(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date2,
//        firstDate: DateTime(2020),
        firstDate: DateTime(2020),
        lastDate: DateTime(2030));
    if (picked != null && picked != _date2) {
      setState(() {
        _date2 = picked;
        if (_date2.isBefore(_date)) _date2 = _date.add(new Duration(days: 3));
        pilihtanggal2 = new DateFormat("yyyy-MM-dd 00:00:00").format(_date2);
        jumlah_sewas = DateTime.parse(pilihtanggal2)
            .difference(DateTime.parse(pilihtanggal))
            .inDays;
        hasilperhitungan = hitungall(
            harga.toString(), jumlah_sewas.toString(), nomasuransi.toString());
      });
    } else {}
  }

  TextEditingController _durasiorder = TextEditingController();
  TextEditingController _note = TextEditingController();
  TextEditingController _vouchervalue = TextEditingController();
  TextEditingController _keteranganbarang = TextEditingController();
  TextEditingController _nominalbarang = TextEditingController();
  bool _fieldDurasiOrder = false,
      _fieldNote = false,
      _fieldvoucher,
      _fieldnominalbarang,
      _fieldketerangan;

  void getAsuransi() async {
    final response = await http.get(urlcomboAsuransi,
        headers: {"Authorization": "BEARER ${access_token}"});
//    var listdata = json.decode(response.body);
    setState(() {
      nomasuransi = json.decode(response.body)[0]['nilai'];
      hasilperhitungan = hitungall(
          harga.toString(),
          jumlah_sewas.toString(),
          nomasuransi
              .toString()); //      print(json.decode(response.body)[0]['nilai']);
//    print (nomasuransi.toString());
//      _dataAsuransi = listdata;
    });
  }

  SharedPreferences sp;
  bool isSuccess = false;
  var access_token,
      refresh_token,
      idcustomer,
      email,
      nama_customer,
      idlokasi = 0;

  String hitungall(String harga, String durasi, String asuransi) {
    print(((double.parse(harga) * double.parse(durasi)) *
            (1 + (double.parse(asuransi) / 100)))
        .toString());
    return ((double.parse(harga) * double.parse(durasi)) *
            (1 + (double.parse(asuransi) / 100)))
        .toString();
  }

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    idcustomer = sp.getString("idcustomer");
    email = sp.getString("email");
    nama_customer = sp.getString("nama_customer");
    print("CEKK IDCUSTOMER" + idcustomer);
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
      getAsuransi();
    }
  }

  @override
  void initState() {
    dtAwal = DateTime.now();
    dtAkhir = DateTime.now();
    _date = DateTime.now();
    _date2 = DateTime.now().add(new Duration(days: 1));
    nomasuransi = 50000;
    asuransie = 0;
    jumlah_sewas = 1;
    pilihtanggal = new DateFormat("yyyy-MM-dd 00:00:00").format(_date);
    pilihtanggal2 = new DateFormat("yyyy-MM-dd 00:00:00").format(_date2);

    if (widget.jenisProduk != null) {
      idjenis_produk = widget.jenisProduk.idjenis_produk;
      kapasitas = widget.jenisProduk.kapasitas;
      harga = widget.jenisProduk.harga;
      alamat = widget.jenisProduk.nama_lokasi;
      vKeterangan = widget.jenisProduk.keterangan;
      idlokasi = widget.jenisProduk.idlokasi;
    }
    super.initState();
    cekToken();
  }

  Future<bool> _willPopCallback() async {
    showAlertDialog(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    print("idjenis_produk : ${idjenis_produk}");

    var media = MediaQuery.of(context);
    new WillPopScope(child: new Scaffold(), onWillPop: _willPopCallback);
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          widget.jenisProduk == null ? "Parsing data kosong" : "Detail Order",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 150,
                    decoration: new BoxDecoration(
                        image: new DecorationImage(
                      image: ExactAssetImage('assets/image/container1.png'),
                      fit: BoxFit.fitHeight,
                    )),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 32, right: 32, top: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: media.size.width - 64 - 48,
                              child: Text(
                                kapasitas,
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(alamat,
                                style: TextStyle(
                                  color: Colors.grey[500],
                                ),
                                overflow: TextOverflow.ellipsis),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              //                           rupiah(History.total_harga,
                              // separator: ',', trailing: '.00'),
                              "Harga : " +
                                  rupiah(harga,
                                      separator: ',',
                                      trailing: '.00' + "/Hari"),
                              // "Harga : Rp. " + harga + "/hari",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.navigation),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(
                                    bottom: 8, left: 30, top: 8),
                                child: Text(
                                  "Durasi Sewa",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              TanggalSet(
                                labelText: tglAwal,
                                valueText:
                                    new DateFormat('dd/MM/yyyy').format(_date),
                                valueStyle: valueTglAwal,
                                onPressed: () {
                                  _selectionDate(context);
                                  dtAwal = _date;
                                },
                              ),
                              TanggalSet(
                                labelText: tglAkhir,
                                valueText:
                                    new DateFormat('dd/MM/yyyy').format(_date2),
                                valueStyle: valueTglAkhir,
                                onPressed: () {
                                  setState(() {
                                    _selectionDate2(context);
                                    dtAkhir = _date2;
                                  });
                                },
                              ),
                            ],
                          ),
//                            ],
//                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(
                                    bottom: 8, left: 36, top: 8),
                                child: Text(
                                  "Deskripsi Produk",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  new Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 38),
                              child: Text(vKeterangan),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Container(
                    padding: EdgeInsets.only(left: 30),
                    child: Row(
                      children: <Widget>[
                        Checkbox(
                          value: true,
                          onChanged: (bool depositt) {
                            setState(() {});
                          },
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Deposit terpakai " +
                            rupiah(harga, separator: ',', trailing: '.00'))
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(
                                    bottom: 3, left: 36, top: 8),
                                child: Text(
                                  "Addon Sewa",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 20, top: 5),
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                      value: asuransi,
                                      onChanged: (bool asuransii) {
                                        setState(() {
                                          asuransi = asuransii;
                                          if (asuransi == true) {
                                            asuransie = 1;

                                            // getAsuransi();
                                            hasilperhitungan = hitungall(
                                                harga.toString(),
                                                jumlah_sewas.toString(),
                                                nomasuransi.toString());
                                          } else {
                                            asuransie = 0;
                                            nomasuransi = 0;
                                            hasilperhitungan = hitungall(
                                                harga.toString(),
                                                jumlah_sewas.toString(),
                                                nomasuransi.toString());
                                          }
                                        });
                                      },
                                    ),
                                    SizedBox(width: 8.0),
                                    Text("Asuransi (Rp. 50.000)"),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 30, right: 30, top: 5),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Masukkan Keterangan Barang',
                                    border: const OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  controller: _keteranganbarang,
                                  onChanged: (value) {
                                    bool isFieldValid = value.trim().isNotEmpty;
                                    if (isFieldValid != _fieldketerangan) {
                                      setState(() =>
                                          _fieldketerangan = isFieldValid);
                                    }
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 30, right: 30, top: 5),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Masukkan Total Nominal Barang',
                                    border: const OutlineInputBorder(),
                                  ),
                                  controller: _nominalbarang,
                                  onChanged: (value) {
                                    bool isFieldValid = value.trim().isNotEmpty;
                                    if (isFieldValid != _fieldnominalbarang) {
                                      setState(() =>
                                          _fieldketerangan = isFieldValid);
                                    }
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 30, right: 30, top: 5),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Masukkan Kode Voucher Jika ada!',
                                    border: const OutlineInputBorder(),
                                  ),
                                  controller: _vouchervalue,
                                  onChanged: (value) {
                                    bool isFieldValid = value.trim().isNotEmpty;
                                    if (isFieldValid != _fieldvoucher) {
                                      setState(
                                          () => _fieldvoucher = isFieldValid);
                                    }
                                  },
                                ),
                              ),
                              SizedBox(width: 12.0),
                              Container(
                                padding: const EdgeInsets.only(left: 30),
                                child: FlatButton(
                                  color: Colors.orange,
                                  child: Text("Cek Voucher"),
                                  onPressed: () {
                                    setState(() {
                                      print("YUU" +
                                          valasuransi +
                                          " - " +
                                          harga +
                                          " - " +
                                          jumlah_sewas.toString());
//                                      int perhitungan = (harga.toString()*jumlah_sewas)*(1+(valasuransi/100));
//                                      print("BISA YOK BISA! :"+perhitungan.toString());
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
                  SizedBox(
                    height: 3,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            // padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: Column(
                    children: [
                      Text("Total Bayar",
                          style: GoogleFonts.lato(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 3,
                      ),
                      Text(hasilperhitungan)
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 200,
                  height: 60,
                  // margin: EdgeInsets.only(top: 3),
                  child: OutlineButton(
                    focusColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red)),
                    color: Colors.green,
                    onPressed: () {
                      orderConfirmation(context);
                    },
                    child: Text(
                      "Lanjutkan Pembayaran",
//                            rupiah(
//                              hasilperhitungan,
//                            ),

                      // "Bayar Rp. " + hasilperhitungan,
                      style: (TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black)),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        print("ini order input");
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

  orderConfirmation(BuildContext context) {
    var ket = _note.text.toString();
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        setState(() => isLoading = true);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return FormInputPembayaran(
              idlokasi: idlokasi,
              idjenis_produk: idjenis_produk,
              harga: harga,
              keterangan: ket,
              jumlah_sewa: jumlah_sewas,
              flagasuransi: asuransie,
              flagvoucher: 0,
              idasuransi: 1,
              nomor_polis: "XX",
              tanggal_berakhir_polis: "DATE(NOW())",
              idvoucher: 0,
              kapasitas: kapasitas,
              alamat: alamat,
              tanggal_mulai: pilihtanggal,
              tanggal_akhir: pilihtanggal2,
              keterangan_barang: _keteranganbarang.text.toString(),
              nominal_barang: _nominalbarang.text.toString(),
              total_harga: hasilperhitungan.toString());
        }));
        // _durasiorder.clear();
        // _note.clear();
      },
    );
    Widget cancelButton = FlatButton(
      child: Text("Cek Dulu"),
      onPressed: () => Navigator.pop(context),
    );
    AlertDialog alert = AlertDialog(
      title: Text("Konfirmasi Pesanan"),
      content:
          Text("Harap Cek kembali Pesanan anda, jika sudah sesuai klik OK."),
      actions: [
        okButton,
        cancelButton,
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  Widget _buildAsuransi(String idasuransi) {
    _controllerIdAsuransi = TextEditingController(text: idasuransi);
    return DropdownButtonFormField(
      hint: Text("Pilih Asuransi"),
      value: valasuransi,
      items: _dataAsuransi.map((item) {
        return DropdownMenuItem(
          // child: Text(item['nama_kota']),
          child: Text("${item['nama_asuransi']}"),
          value: item['nilai'].toString(),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          valasuransi = value.toString();
          print("damn" + value.toString());
        });
      },
    );
  }
}
