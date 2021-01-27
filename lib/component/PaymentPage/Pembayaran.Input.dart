import 'dart:ui';
import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/order/order.model.dart';
import 'package:horang/api/models/paymentgateway/paymentgateway.model.dart';
import 'package:horang/api/models/token/token.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/OrderPage/KonfirmasiOrder.Detail.dart';
import 'package:horang/component/PaymentPage/KonfirmPayment.dart';
import 'package:indonesia/indonesia.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormInputPembayaran extends StatefulWidget {
  bool warna;
  var flagasuransi,
      flagvoucher,
      idlokasi,
      idjenis_produk,
      idvoucher,
      idasuransi,
      harga,
      jumlah_sewa,
      tanggal_mulai,
      tanggal_akhir,
      tanggal_berakhir_polis,
      nomor_polis,
      kapasitas,
      alamat,
      keterangan_barang,
      nominal_voucher,
      kodvoucher,
      nominal_barang,
      total_harga,
      total_asuransi,
      totalharixharga,
      totaldeposit,
      totalpointdeposit,
      deposit,
      email_asuransi;
  FormInputPembayaran(
      {this.flagasuransi,
      this.flagvoucher,
      this.idlokasi,
      this.idjenis_produk,
      this.idvoucher,
      this.idasuransi,
      this.harga,
      this.jumlah_sewa,
      this.tanggal_mulai,
      this.tanggal_akhir,
      this.tanggal_berakhir_polis,
      this.nomor_polis,
      this.kapasitas,
      this.alamat,
      this.keterangan_barang,
      this.nominal_voucher,
      this.kodvoucher,
      this.nominal_barang,
      this.total_harga,
      this.total_asuransi,
      this.totalharixharga,
      this.totaldeposit,
      this.totalpointdeposit,
      this.deposit,
      this.email_asuransi});

  @override
  _FormInputPembayaran createState() => _FormInputPembayaran();
}

class _FormInputPembayaran extends State<FormInputPembayaran> {
  ApiService _apiService = ApiService();
  int grup = 1;
  var rgIndex = 1;
  int rgID = 1;
  int _currentIndex = 1;
  String rgValue = "";
  bool _sel = false, isEnabled = true;
  bool asuransi = false;
  String formatedate, formatedate2;
  SharedPreferences sp;
  bool isSuccess = false;
  int idorder = 0;
  var access_token, refresh_token, email, nama_customer;
  var idlokasi,
      idjenis_produk,
      idcustomer,
      keterangan,
      jumlah_sewa,
      flagasuransi,
      flagvoucher,
      idasuransi,
      idpayment_gateway,
      nomor_polis,
      tanggal_berakhir_polis,
      idvouchers,
      skapasitas,
      sharga,
      salamat,
      sketerangan_barang,
      snomvoucher,
      skodevoucher,
      snominal_barang,
      stotal_harga,
      stanggal_mulai,
      stanggal_akhir,
      selectedValue,
      totallharga,
      stotal_asuransi,
      stotalharixharga,
      stotaldeposit,
      stotalpointdeposit,
      sdeposit,
      email_asuransi;

  var hasilperhitungan;

  enableButton() {
    setState(() {
      isEnabled = true;
    });
  }

  disableButton() {
    setState(() {
      isEnabled = false;
    });
  }

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
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
    }
  }

  @override
  void initState() {
//    if(widget.orderProduk !=null){
    idlokasi = widget.idlokasi;
    idjenis_produk = widget.idjenis_produk;
    jumlah_sewa = widget.jumlah_sewa;
    sharga = widget.harga;
    flagvoucher = widget.flagvoucher;
    flagasuransi = widget.flagasuransi;
    idasuransi = widget.idasuransi;
    nomor_polis = widget.nomor_polis;
    tanggal_berakhir_polis = widget.tanggal_berakhir_polis;
    idvouchers = widget.idvoucher;
    skapasitas = widget.kapasitas;
    salamat = widget.alamat;
    stanggal_mulai = widget.tanggal_mulai;
    stanggal_akhir = widget.tanggal_akhir;
    sketerangan_barang = widget.keterangan_barang;
    snomvoucher = widget.nominal_voucher;
    skodevoucher = widget.kodvoucher;
    snominal_barang = widget.nominal_barang;
    stotal_harga = widget.total_harga;
    stotal_asuransi = widget.total_asuransi;
    stotalharixharga = widget.totalharixharga;
    stotaldeposit = widget.totaldeposit;
    stotalpointdeposit = widget.totalpointdeposit;
    sdeposit = widget.deposit;
    email_asuransi = widget.email_asuransi;
//    }
    cekToken();
    hitungall(
        sharga.toString(),
        jumlah_sewa,
        flagasuransi,
        double.parse(stotal_asuransi),
        snominal_barang,
        stotaldeposit,
        stotalpointdeposit,
        snomvoucher);
  }

  String hitungall(
      String harga,
      String durasi,
      int boolasuransi,
      double asuransi,
      String nominalbaranginput,
      String nomdeposit,
      String ceksaldopoint,
      String nomAsuransi) {
    if (boolasuransi == 0) asuransi = 0;
    hasilperhitungan = ((double.parse(harga) * double.parse(durasi)) +
        ((asuransi / 100) * double.parse(nominalbaranginput)) +
        double.parse(nomdeposit) * double.parse(harga));
    return ((double.parse(harga) * double.parse(durasi)) +
            ((asuransi / 100) * double.parse(nominalbaranginput)) +
            double.parse(nomdeposit) * double.parse(harga) -
            double.parse(ceksaldopoint) -
            double.parse(nomAsuransi))
        .toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    var asuransitxt, vouchertxt;
    if (flagasuransi == 1) {
      asuransitxt = "Ya";
    } else {
      asuransitxt = "Tidak";
    }
    var media = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rincian Data Sewa",
          style: TextStyle(color: Colors.black),
        ),
        //Blocking Back
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    child: new Column(
                      children: <Widget>[
                        new ListTile(
                          leading: Icon(Icons.insert_drive_file),
                          title: new Text(
                            skapasitas,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: new Text(
                            salamat,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8, left: 36, top: 8),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 30, bottom: 15),
                          child: Row(
                            children: <Widget>[
                              Text("Detail Pesanan ",
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Tanggal Mulai :"),
                                  Text("Tanggal Berakhir :"),
                                  Text("Durasi Sewa :"),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stanggal_mulai,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(stanggal_akhir,
                                      overflow: TextOverflow.ellipsis),
                                  Text(
                                    jumlah_sewa.toString() + " Hari",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 30),
                              child: Row(
                                children: <Widget>[Text("Harga Sewa :")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Text(
                                rupiah(sharga,
                                    separator: ',', trailing: " /hari"),
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 30),
                              child: Row(
                                children: <Widget>[Text("Asuransi :")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Text(
                                asuransitxt,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 30),
                              child: Row(
                                children: <Widget>[Text("Kode Voucher : ")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Text(
                                skodevoucher,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 30),
                              child: Row(
                                children: <Widget>[Text("Keterangan Barang :")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Text(
                                sketerangan_barang,
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
                        Container(
                          padding: const EdgeInsets.only(left: 30, bottom: 15),
                          child: Row(
                            children: <Widget>[
                              Text("Detail Pembayaran",
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 30),
                              child: Row(
                                children: <Widget>[Text("Subtotal :")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Text(
                                rupiah(stotalharixharga, separator: ','),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 30),
                              child: Row(
                                children: <Widget>[Text("Minimum Deposit :")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Text(
                                rupiah(stotaldeposit, separator: ','),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 30),
                              child: Row(
                                children: <Widget>[
                                  Text("Point Deposit Anda : ")
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Text(
                                "-" +
                                    rupiah(stotalpointdeposit, separator: ','),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 30),
                              child: Row(
                                children: <Widget>[Text("Nominal Voucher :")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Text(
                                "-" + rupiah(snomvoucher),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 30),
                              child: Row(
                                children: <Widget>[Text("Nominal Asuransi :")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Flexible(
                                child: Text(
                                  rupiah(stotal_asuransi, separator: ','),
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 30),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "( Nominal Barang : " +
                                    rupiah(snominal_barang + " )"),
                                style: TextStyle(fontStyle: FontStyle.italic),
                              )
                            ],
                          ),
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
                              padding: const EdgeInsets.only(left: 30),
                              child: Row(
                                children: <Widget>[
                                  Text("Total :",
                                      style: (TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)))
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(right: 60),
                              child: Text(
                                rupiah(stotal_harga),
                                style: (TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: SingleChildScrollView(
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
                                    "Pilih Metode Pembayaran : ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SafeArea(
                                  child: FutureBuilder(
                                      future: _apiService
                                          .listPaymentGateway(access_token),
                                      builder: (context,
                                          AsyncSnapshot<List<PaymentGateway>>
                                              snapshot) {
                                        if (snapshot.hasError) {
                                          print(snapshot.error.toString());
                                          return Center(
                                            child: Text(
                                                "Something wrong with message: ${snapshot.error.toString()}"),
                                          );
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          List<PaymentGateway> payment =
                                              snapshot.data;
                                          return _listPaymentGateway(payment);
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      }),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listPaymentGateway(List<PaymentGateway> dataIndex) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      child: Column(
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: ListView.builder(
              itemBuilder: (context, index) {
                PaymentGateway pymentgtwy = dataIndex[index];
                // print("data index $dataIndex");
                return Card(
                  child: InkWell(
                    onTap: () {
                      _tripModalBottomSheet(
                          context,
                          pymentgtwy.idpayment_gateway,
                          pymentgtwy.nama_provider);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ListTile(
                          selected: true,
                          leading: Text("gambar"),
                          title: Text(
                            pymentgtwy.nama_provider,
                            style: GoogleFonts.inter(
                                fontSize: 15, color: Colors.black26),
                          ),
                          trailing: Icon(Icons.keyboard_arrow_right),
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: dataIndex.length,
            ),
          )),
          // Text("Kamu memilih Pembayaran menggunakan : $rgValue")
        ],
      ),
    );
  }

  void _tripModalBottomSheet(context, int idpayment, String namaprovider) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * 100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text("Konfirmasi",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      Spacer(),
                      IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () {
                            Navigator.of(context).pop();
                          })
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Icon(
                        //   Icons.payment,
                        //   color: Colors.red,
                        //   size: 100,
                        // ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        // Center(
                        //   child: Text(
                        //       "Anda akan melakukan pembayaran menggunakan $namaprovider $snomvoucher $idvouchers",
                        //       textAlign: TextAlign.center,
                        //       style: GoogleFonts.inter(
                        //           fontSize: 16, fontWeight: FontWeight.bold)),
                        // ),
                        // SizedBox(
                        //   height: 5,
                        // ),
                        // Padding(
                        //     padding: EdgeInsets.only(left: 10, right: 10),
                        //     child: Text(
                        //         "Dengan ini Saya menyatakan persetujuan kepada Horang Apps untuk memperoleh dan menggunakan kontainer yang sudah saya pesan sesuai kebijakan yang berlaku $stotal_asuransi",
                        //         textAlign: TextAlign.left,
                        //         style: GoogleFonts.inter(
                        //             height: 1.5, fontSize: 14))),
                        // SizedBox(
                        //   height: 5,
                        // ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RaisedButton(
                                color: Colors.green,
                                child: Text(
                                  "Lanjutkan Pembayaran $idvouchers",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  setState(() {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                KonfirmPayment(
                                                    flagasuransi: flagasuransi,
                                                    flagvoucher: flagvoucher,
                                                    idjenis_produk:
                                                        idjenis_produk,
                                                    idlokasi: idlokasi,
                                                    jumlah_sewa: jumlah_sewa,
                                                    idasuransi: idasuransi,
                                                    nominal_asuransi:
                                                        stotal_asuransi,
                                                    idvoucher: idvouchers,
                                                    idpayment_gateway:
                                                        idpayment,
                                                    harga: sharga,
                                                    nomvoucher: snomvoucher,
                                                    kodevoucher: skodevoucher,
                                                    total_harga: stotal_harga,
                                                    deposit_tambah: sdeposit,
                                                    deposit_pakai:
                                                        stotalpointdeposit,
                                                    deposit_minimum:
                                                        stotaldeposit,
                                                    tanggal_mulai:
                                                        stanggal_mulai,
                                                    tanggal_akhir:
                                                        stanggal_akhir,
                                                    nominal_barang:
                                                        snominal_barang,
                                                    keterangan_barang:
                                                        sketerangan_barang,
                                                    email_asuransi:
                                                        email_asuransi)));
                                  });
                                })
                          ],
                        ),
                        // _buttonDisable()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        print("ini pembayaran input");
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
