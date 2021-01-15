import 'dart:convert';
import 'package:commons/commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/jenisproduk/jenisproduk.model.dart';
import 'package:horang/api/models/voucher/voucher.controller.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/PaymentPage/Pembayaran.Input.dart';
import 'package:indonesia/indonesia.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormInputOrder extends StatefulWidget {
  JenisProduk jenisProduk;
  var tglawal12, tglakhir12;
  FormInputOrder({this.jenisProduk, this.tglawal12, this.tglakhir12});

  @override
  _FormDetailOrder createState() => _FormDetailOrder();
}

class _FormDetailOrder extends State<FormInputOrder> {
  // final oCcy = new NumberFormat("#,##0.00", "id_ID");
  bool isLoading = false;
  ApiService _apiService = ApiService();
  var kapasitas,
      harga,
      alamat,
      vKeterangan,
      idjenis_produk,
      gambar1,
      idvouchers;
  var hasilperhitungan = "0", tambahasuransi = "0";
  int jumlah_sewas;
  bool asuransi = true;
  int flagsuransi = 0;
  int asuransie = 1;
  int minimaldeposit = 3; //query dari setting minimal hari deposit
  num nomasuransi;

  var email_asuransi;
  double nomdeclarebarang = 0.00;

  var Value, title, valasuransi;
  List<dynamic> _dataAsuransi = List();

  TextEditingController _controllerIdAsuransi;
  String getVoucher = "Pilih Voucher", voucherKode = "", idvcr;
  DateTime dtAwal, dtAkhir, _date, _date2;
  var tglAwal,
      tglAkhir,
      total_asuransi,
      totalhariharga,
      totaldeposit,
      idasuransi,
      ceksaldo = 0,
      kondisisaldo,
      hargaxhari,
      saldodepositkurangnominaldeposit,
      nominalvoucher = "0",
      kodevvoucher;
  TextStyle valueTglAwal = TextStyle(fontSize: 16.0);
  TextStyle valueTglAkhir = TextStyle(fontSize: 16.0);

  void getSaldo() async {
    final response = await http.get(ApiService().urlceksaldo,
        headers: {"Authorization": "BEARER ${access_token}"});
    ceksaldo = json.decode(response.body)[0]['saldo'];
  }

  bool tekanvoucher = false;

  int diffInDays(tglAwal, tglAkhir) {
    return ((tglAkhir.difference(tglAwal) -
                    Duration(hours: tglAwal.hour) +
                    Duration(hours: tglAkhir.hour))
                .inHours /
            24)
        .round();
  }

  TextEditingController _durasiorder = TextEditingController();
  TextEditingController _vouchervalue = TextEditingController();
  TextEditingController _keteranganbarang = TextEditingController();
  TextEditingController _nominalbarang = TextEditingController();
  // final currency = NumberFormat("#,##0","id");
  // final _nominalbarang = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  bool _fieldDurasiOrder = false,
      _fieldNote = false,
      _fieldvoucher,
      _fieldnominalbarang,
      _fieldketerangan;

  cleartextinputnominal(){
    _nominalbarang.clear();
  }

  void getAsuransi() async {
    final response = await http.get(ApiService().urlasuransi,
        headers: {"Authorization": "BEARER ${access_token}"});
    print("Get Id asuransi : " + response.body);
    // setState(() {
    nomasuransi = json.decode(response.body)[0]['nilai'];
    email_asuransi = json.decode(response.body)[0]['email_asuransi'];
    idasuransi = json.decode(response.body)[0]['idasuransi'];
    hasilperhitungan = hitungall(
        harga.toString(),
        jumlah_sewas.toString(),
        asuransie,
        nomasuransi,
        _nominalbarang.text.toString(),
        ceksaldo.toString(),
        nominalvoucher);
    // });
  }

  SharedPreferences sp;
  bool isSuccess = false;
  var access_token, refresh_token, idcustomer, nama_customer, idlokasi = 0;

  String hitungall(String harga, String durasi, int boolasuransi, num asuransi,
      String nominalbaranginput, String ceksaldopoint, String NominalVoucher) {
    if (boolasuransi == 0) asuransi = 0;

    total_asuransi = (asuransi / 100) * double.parse(nominalbaranginput);
    totalhariharga = (int.parse(harga) * int.parse(durasi));
    totaldeposit = minimaldeposit * int.parse(harga);

    return ((double.parse(harga) * double.parse(durasi)) +
            ((asuransi / 100) * double.parse(nominalbaranginput)) +
            minimaldeposit * double.parse(harga) -
            double.parse(ceksaldopoint) -
            double.parse(NominalVoucher))
        .toStringAsFixed(2);
  }

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    idcustomer = sp.getString("idcustomer");
    nama_customer = sp.getString("nama_customer");

    // print("CEKK IDCUSTOMER" + idcustomer);
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
      getSaldo();
    }
  }

  @override
  void initState() {
    tekanvoucher = !tekanvoucher;
    nomasuransi = 0.0;
    asuransie = 1;
    if (_nominalbarang.text == "") _nominalbarang.text = "0";
    getAsuransi();
    getSaldo();
    if (widget.jenisProduk != null) {
      idjenis_produk = widget.jenisProduk.idjenis_produk;
      kapasitas = widget.jenisProduk.kapasitas;
      harga = widget.jenisProduk.harga;
      alamat = widget.jenisProduk.nama_lokasi;
      vKeterangan = widget.jenisProduk.keterangan;
      idlokasi = widget.jenisProduk.idlokasi;
      gambar1 = widget.jenisProduk.gambar;
    }
    tglAwal = widget.tglawal12.toString();
    tglAkhir = widget.tglakhir12.toString();
    jumlah_sewas =
        diffInDays(DateTime.parse(tglAwal), DateTime.parse(tglAkhir));
    hasilperhitungan = hitungall(
        harga.toString(),
        jumlah_sewas.toString(),
        asuransie,
        nomasuransi,
        _nominalbarang.text.toString(),
        ceksaldo.toString(),
        nominalvoucher);
    _nominalbarang.addListener(() {
      setState(() {
        getAsuransi();
        getSaldo();
        print("Nominal Point : " + ceksaldo.toString());
        if (_nominalbarang.text == "")
          hasilperhitungan = hitungall(
              harga.toString(),
              jumlah_sewas.toString(),
              asuransie,
              nomasuransi,
              "0",
              ceksaldo.toString(),
              nominalvoucher);
        else
          hasilperhitungan = hitungall(
              harga.toString(),
              jumlah_sewas.toString(),
              asuransie,
              nomasuransi,
              _nominalbarang.text.toString(),
              ceksaldo.toString(),
              nominalvoucher);
      });
    });
    super.initState();
    cekToken();
  }

  Future<bool> _willPopCallback() async {
    showAlertDialog(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    nominalvoucher = getVoucher.toString();
    kodevvoucher = voucherKode.toString();
    idvcr = idvouchers.toString();
    // print("kopiapi $nominalvoucher" + "$kodevvoucher --" + "$idvcr");
    // print("IDASURANSI : " + idasuransi.toString() + email_asuransi.toString());
    var media = MediaQuery.of(context);
    getSaldo();
    new WillPopScope(child: new Scaffold(), onWillPop: _willPopCallback);
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Isi Data Sewa",
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
                      // image: ExactAssetImage('assets/image/container1.png'),
                      image: NetworkImage(gambar1),
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
                              "Harga : " +
                                  rupiah(harga,
                                      separator: '.',
                                      trailing: ',00' + "/Hari"),
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
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(tglAwal,
                                        style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("s/d",
                                        style: GoogleFonts.inter(fontSize: 14)),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(tglAkhir,
                                        style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                                      fontSize: 16),
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
                                            hasilperhitungan = hitungall(
                                                harga.toString(),
                                                jumlah_sewas.toString(),
                                                asuransie,
                                                nomasuransi,
                                                _nominalbarang.text.toString(),
                                                ceksaldo.toString(),
                                                nominalvoucher);
                                          } else {
                                            asuransie = 0;
                                            hasilperhitungan = hitungall(
                                                harga.toString(),
                                                jumlah_sewas.toString(),
                                                asuransie,
                                                nomasuransi,
                                                _nominalbarang.text.toString(),
                                                ceksaldo.toString(),
                                                nominalvoucher);
                                          }
                                        });
                                      },
                                    ),
                                    SizedBox(width: 8.0),
                                    Text("Asuransi (" +
                                        nomasuransi.toString() +
                                        "%)"),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  print("vamossss!!!");
                                  setState(() {});
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.50,
                                          decoration: new BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: new BorderRadius.only(
                                              topLeft:
                                                  const Radius.circular(25.0),
                                              topRight:
                                                  const Radius.circular(25.0),
                                            ),
                                          ),
                                          child: SafeArea(
                                              child: FutureBuilder(
                                                  future:
                                                      _apiService.listVoucher(
                                                          access_token),
                                                  builder: (context,
                                                      AsyncSnapshot<
                                                              List<Voucher>>
                                                          snapshot) {
                                                    if (snapshot.hasError) {
                                                      return Center(
                                                        child: Text(
                                                            "Something wrong with message: ${snapshot.error.toString()}"),
                                                      );
                                                    } else if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    } else if (snapshot
                                                            .connectionState ==
                                                        ConnectionState.done) {
                                                      List<Voucher> vclist =
                                                          snapshot.data;
                                                      print(
                                                          "datavvvoucher : ${snapshot.data}");
                                                      return _buildListvoucher(
                                                          vclist);
                                                    }
                                                  }))));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 30, right: 30, top: 5),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      enabled: false,
                                      hintText: "$getVoucher - $voucherKode",
                                      border: const OutlineInputBorder(),
                                    ),
                                    // controller: _keteranganbarang,
                                    // onChanged: (value) {
                                    //   print("tes nom barang sss " +
                                    //       _nominalbarang.toString());
                                    //   bool isFieldValid =
                                    //       value.trim().isNotEmpty;
                                    //   if (isFieldValid != _fieldnominalbarang) {
                                    //     setState(() =>
                                    //         _fieldnominalbarang = isFieldValid);
                                    //   }
                                    // },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 30, right: 30, top: 5),
                                child: TextFormField(
                                  onTap: (){
                                    if (_nominalbarang.text == "0") {
                                      cleartextinputnominal();
                                    }
                                  },
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  decoration: InputDecoration(
                                    labelText: 'Total Nominal Barang',
                                    hintText: 'Masukkan Total Nominal Barang',
                                    border: const OutlineInputBorder(),
                                  ),
                                  controller: _nominalbarang,
                                  inputFormatters: <TextInputFormatter>[
                                    // ignore: deprecated_member_use
                                    WhitelistingTextInputFormatter.digitsOnly,
                                  ],
                                  onChanged: (value) {
                                    print("tes nom barang sssk " +
                                        _nominalbarang.toString());
                                    bool isFieldValid = value.trim().isNotEmpty;
                                    if (isFieldValid != _fieldnominalbarang) {
                                      setState(() =>
                                          _fieldnominalbarang = isFieldValid);
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 30, right: 30, top: 5),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Keterangan',
                                    hintText: 'Masukkan Keterangan Barang',
                                    border: const OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 3,
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
                              // Container(
                              //   padding: const EdgeInsets.only(left: 30),
                              //   child: Row(
                              //     children: [
                              //       FlatButton(
                              //         color: Colors.orange,
                              //         child: Text("Cek Voucher"),
                              //         onPressed: () {
                              //           setState(() {});
                              //           showModalBottomSheet(
                              //               context: context,
                              //               isScrollControlled: true,
                              //               backgroundColor: Colors.transparent,
                              //               builder: (context) => Container(
                              //                   height: MediaQuery.of(context)
                              //                           .size
                              //                           .height *
                              //                       0.50,
                              //                   decoration: new BoxDecoration(
                              //                     color: Colors.white,
                              //                     borderRadius:
                              //                         new BorderRadius.only(
                              //                       topLeft:
                              //                           const Radius.circular(
                              //                               25.0),
                              //                       topRight:
                              //                           const Radius.circular(
                              //                               25.0),
                              //                     ),
                              //                   ),
                              //                   child: SafeArea(
                              //                       child: FutureBuilder(
                              //                           future: _apiService
                              //                               .listVoucher(
                              //                                   access_token),
                              //                           builder: (context,
                              //                               AsyncSnapshot<
                              //                                       List<
                              //                                           Voucher>>
                              //                                   snapshot) {
                              //                             if (snapshot
                              //                                 .hasError) {
                              //                               return Center(
                              //                                 child: Text(
                              //                                     "Something wrong with message: ${snapshot.error.toString()}"),
                              //                               );
                              //                             } else if (snapshot
                              //                                     .connectionState ==
                              //                                 ConnectionState
                              //                                     .waiting) {
                              //                               return Center(
                              //                                   child:
                              //                                       CircularProgressIndicator());
                              //                             } else if (snapshot
                              //                                     .connectionState ==
                              //                                 ConnectionState
                              //                                     .done) {
                              //                               List<Voucher>
                              //                                   vclist =
                              //                                   snapshot.data;
                              //                               return _buildListvoucher(
                              //                                   vclist);
                              //                             }
                              //                           }))));
                              //           // setState(() {
                              //           //   print("YUU" +
                              //           //       valasuransi +
                              //           //       " - " +
                              //           //       harga +
                              //           //       " - " +
                              //           //       jumlah_sewas.toString());
                              //           //                                      int perhitungan = (harga.toString()*jumlah_sewas)*(1+(valasuransi/100));
                              //           //                                      print("BISA YOK BISA! :"+perhitungan.toString());
                              //           // }
                              //           // );
                              //         },
                              //       ),
                              //       SizedBox(
                              //         width: 50,
                              //       ),
                              //       Text(getVoucher,
                              //           style: GoogleFonts.lato(
                              //               fontSize: 14,
                              //               fontWeight: FontWeight.bold))
                              //     ],
                              //   ),
                              // ),
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
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: Column(
                    children: [
                      Text("Total (+ deposit 3 hari)",
                          style: GoogleFonts.lato(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 3,
                      ),
                      Text(rupiah(hasilperhitungan),
                          style: GoogleFonts.lato(
                              fontSize: 18, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  alignment: Alignment.center,
                  width: 160,
                  height: 100,
                  // margin: EdgeInsets.only(top: 3),
                  child: OutlineButton(
                    borderSide: BorderSide(color: Colors.green, width: 2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    color: Colors.green,
                    onPressed: () {
                      _nominalbarang.text.toString() == "0" ||
                              _keteranganbarang.text.toString() == ""
                          ? errorDialog(context,
                              "Nominal Barang Tidak boleh 0 atau kurang, karena nominal barang menentukan nominal klaim garansi jika ada hal yang tidak kita inginkan bersama, pastikan juga keterangan barang sudah terisi.")
                          : setState(() {
                              if (asuransi == true) {
                                asuransie = 1;
                                hasilperhitungan = hitungall(
                                    harga.toString(),
                                    jumlah_sewas.toString(),
                                    asuransie,
                                    nomasuransi,
                                    _nominalbarang.text.toString(),
                                    ceksaldo.toString(),
                                    nominalvoucher);
                              } else {
                                asuransie = 0;
                                nomasuransi = 0;
                                hasilperhitungan = hitungall(
                                    harga.toString(),
                                    jumlah_sewas.toString(),
                                    asuransie,
                                    nomasuransi,
                                    _nominalbarang.text.toString(),
                                    ceksaldo.toString(),
                                    nominalvoucher);
                              }
                              getSaldo();
                              // if (ceksaldo == null) {
                              //   ceksaldo = 0;
                              // }
                              hargaxhari = harga * 3;
                              if (ceksaldo >= hargaxhari) {
                                saldodepositkurangnominaldeposit = 0;
                                kondisisaldo = "";
                                orderConfirmation(context);
                              } else {
                                saldodepositkurangnominaldeposit =
                                    hargaxhari - ceksaldo;
                                kondisisaldo =
                                    "Saldo anda sekarang $ceksaldo minimum deposit $hargaxhari, kurang " +
                                        saldodepositkurangnominaldeposit
                                            .toString();
                                cekDeposit(context);
                              }
                            });
                    },
                    child: Text(
                      "Lanjutkan Pembayaran",
                      textAlign: TextAlign.center,
                      style: (TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black)),
                    ),
                  ),
                ),
              ],
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

  cekDeposit(BuildContext context) {
    infoDialog(context,
        "Hai, maaf $kondisisaldo, apakah anda setuju menambah nominal deposit?",
        showNeutralButton: false, positiveText: "Ok", positiveAction: () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return FormInputPembayaran(
            flagasuransi: asuransie,
            flagvoucher: flagsuransi,
            idlokasi: idlokasi,
            idjenis_produk: idjenis_produk,
            idvoucher: idvcr,
            idasuransi: idasuransi,
            harga: harga,
            jumlah_sewa: jumlah_sewas.toString(),
            tanggal_mulai: tglAwal,
            tanggal_akhir: tglAkhir,
            tanggal_berakhir_polis: "DATE(NOW())",
            nomor_polis: "Belum Diisi",
            kapasitas: kapasitas,
            alamat: alamat,
            keterangan_barang: _keteranganbarang.text.toString(),
            nominal_barang: _nominalbarang.text.toString(),
            nominal_voucher: nominalvoucher,
            kodvoucher: kodevvoucher,
            total_harga: hasilperhitungan.toString(),
            total_asuransi: total_asuransi.toString(),
            totalharixharga: totalhariharga.toString(),
            totaldeposit: totaldeposit.toString(),
            totalpointdeposit: ceksaldo.toString(),
            email_asuransi: email_asuransi.toString(),
            deposit: saldodepositkurangnominaldeposit.toString());
      }));
    });
  }

  orderConfirmation(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cek Dulu"),
      onPressed: () => Navigator.pop(context),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Konfirmasi Pesanan " + rupiah(hasilperhitungan)),
            content: Text(
                "Harap Cek kembali Pesanan anda, jika sudah sesuai klik OK."),
            actions: [
              FlatButton(
                  color: Colors.red,
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (context) {
                      return FormInputPembayaran(
                          flagasuransi: asuransie,
                          flagvoucher: 0,
                          idlokasi: idlokasi,
                          idjenis_produk: idjenis_produk,
                          idvoucher: 0,
                          idasuransi: idasuransi,
                          nominal_voucher: nominalvoucher.toString(),
                          harga: harga,
                          jumlah_sewa: jumlah_sewas.toString(),
                          tanggal_mulai: tglAwal,
                          tanggal_akhir: tglAkhir,
                          tanggal_berakhir_polis: "DATE(NOW())",
                          nomor_polis: "Belum Diisi",
                          kapasitas: kapasitas,
                          alamat: alamat,
                          keterangan_barang: _keteranganbarang.text.toString(),
                          nominal_barang: _nominalbarang.text.toString(),
                          total_harga: hasilperhitungan.toString(),
                          total_asuransi: total_asuransi.toString(),
                          totalharixharga: totalhariharga.toString(),
                          totaldeposit: totaldeposit.toString(),
                          totalpointdeposit: ceksaldo.toString(),
                          email_asuransi: email_asuransi.toString(),
                          deposit: saldodepositkurangnominaldeposit.toString());
                    }));
                  },
                  child: Text("Ok")),
              cancelButton
            ],
          );
        });
  }

  Widget _buildListvoucher(List<Voucher> dataIndex) {
    return Container(
      height: 50,
      margin: EdgeInsets.only(left: 8, right: 8),
      child: ListView.builder(
          // scrollDirection: Axis.horizontal,
          itemCount: dataIndex.length,
          itemBuilder: (context, index) {
            Voucher voucherlist = dataIndex[index];
            return GestureDetector(
              onTap: () {
                if (idcustomer == "0") {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Anda Harus Melengkapi profile untuk melakukan transaksi!'),
                    duration: Duration(seconds: 5),
                  ));
//                        Navigator.pop(context, false);
                } else {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => FormInputOrder()),
                      (route) => false);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: EdgeInsets.all(8),
                height: 70,
                width: MediaQuery.of(context).size.width * 0.5,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (tekanvoucher) {
                        getVoucher = voucherlist.nominal.toString();
                        voucherKode = voucherlist.kode_voucher.toString();
                        idvouchers = voucherlist.idvoucher;
                        flagsuransi = 1;
                        print("adalah $flagsuransi");
                        // print("kang ndut ${voucherlist.nominal}");
                        // print("kang ndut ${voucherlist.kode_voucher}");
                        Navigator.pop(context);
                      }
                    });
                  },
                  // onTap: () {
                  //   print("coba");
                  // },
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Container(
                              width: 50,
                              height: 100,
                              child: Image.network(voucherlist.gambar)),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              Text(voucherlist.kode_voucher.toString()),
                              Text(voucherlist.nominal.toString()),
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          IconButton(
                              icon: Icon(Icons.info_outline), onPressed: () {})
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class CurrencyFormat extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // TODO: implement formatEditUpdate
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    double value = double.parse(newValue.text);
    final money = NumberFormat("#.###.###,00", "id");
    // final money = NumberFormat.currency(locale: 'id',symbol: 'Rp. ', decimalDigits: 0);
    String newText = money.format(value);

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}
