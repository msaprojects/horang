import 'dart:ui';

import 'package:flutter/material.dart';
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
//  OrderProduk orderProduk;
//  BodyPembayaran({this.orderProduk});
  bool warna;
  var idlokasi,
      idjenis_produk,
      idcustomer,
      keterangan,
      jumlah_sewa,
      flagasuransi,
      idpayment_gateway,
      flagvoucher,
      idasuransi,
      nomor_polis,
      tanggal_berakhir_polis,
      idvoucher,
      kapasitas,
      harga,
      alamat,
      tanggal_mulai,
      keterangan_barang,
      nominal_barang,
      total_harga,
      tanggal_akhir;
  FormInputPembayaran(
      {this.idlokasi,
      this.idjenis_produk,
      this.keterangan,
      this.jumlah_sewa,
      this.flagasuransi,
      this.flagvoucher,
      this.idasuransi,
      this.idpayment_gateway,
      this.nomor_polis,
      this.tanggal_berakhir_polis,
      this.idvoucher,
      this.kapasitas,
      this.harga,
      this.alamat,
      this.tanggal_mulai,
      this.keterangan_barang,
      this.nominal_barang,
      this.total_harga,
      this.tanggal_akhir});

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
      idvoucher,
      skapasitas,
      sharga,
      salamat,
      sketerangan_barang,
      snominal_barang,
      stotal_harga,
      stanggal_mulai,
      stanggal_akhir,
      selectedValue,
      totallharga;

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
    idpayment_gateway = widget.idpayment_gateway;
    idlokasi = widget.idlokasi;
    idjenis_produk = widget.idjenis_produk;
    keterangan = widget.keterangan;
    jumlah_sewa = widget.jumlah_sewa;
    sharga = widget.harga;
    flagvoucher = widget.flagvoucher;
    flagasuransi = widget.flagasuransi;
    idasuransi = widget.idasuransi;
    nomor_polis = widget.nomor_polis;
    tanggal_berakhir_polis = widget.tanggal_berakhir_polis;
    idvoucher = widget.idvoucher;
    skapasitas = widget.kapasitas;
    salamat = widget.alamat;
    stanggal_mulai = widget.tanggal_mulai;
    stanggal_akhir = widget.tanggal_akhir;
    sketerangan_barang = widget.keterangan_barang;
    snominal_barang = widget.nominal_barang;
    stotal_harga = widget.total_harga;
    print("Cek IDJENIS ${idjenis_produk}");
//    }
    cekToken();
  }

  @override
  Widget build(BuildContext context) {
    var asuransitxt, vouchertxt;
    if (flagasuransi == 1) {
      asuransitxt = "Ya";
    } else {
      asuransitxt = "Tidak";
    }
    totallharga = double.parse(stotal_harga) +
        50000.00 +
        double.parse(sharga.toString()) -
        double.parse(sharga.toString());
    var media = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rincian Pesanan Anda",
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
                          padding: const EdgeInsets.only(left: 50, bottom: 15),
                          child: Row(
                            children: <Widget>[
                              Text("Detail Pesanan",
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 50),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Durasi Sewa :"),
                                  Text("Tanggal Mulai :"),
                                  Text("Tanggal Berakhir :"),
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
                                    jumlah_sewa.toString() + " Hari",
                                  ),
                                  Text(
                                    stanggal_mulai,
                                  ),
                                  Text(
                                    stanggal_akhir,
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
                              padding: const EdgeInsets.only(left: 50),
                              child: Row(
                                children: <Widget>[Text("Nominal Barang :")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Text(
                                rupiah(snominal_barang,
                                    separator: ',', trailing: '.00'),
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
                          padding: const EdgeInsets.only(left: 50, bottom: 15),
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
                              padding: const EdgeInsets.only(left: 50),
                              child: Row(
                                children: <Widget>[Text("Harga Sewa :")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Text(
                                rupiah(sharga,
                                    separator: ',', trailing: '.00' + "/hari"),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 50),
                              child: Row(
                                children: <Widget>[Text("Subtotal :")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Text(
                                "+" +
                                    rupiah(stotal_harga,
                                        separator: ',', trailing: '.00'),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 50),
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
                              padding: const EdgeInsets.only(left: 50),
                              child: Row(
                                children: <Widget>[Text("Nominal Asuransi :")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Text(
                                "+Rp. 50000.00",
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 50),
                              child: Row(
                                children: <Widget>[Text("Deposit :")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Text(
                                "+" +
                                    rupiah(sharga,
                                        separator: ',', trailing: '.00'),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 50),
                              child: Row(
                                children: <Widget>[Text("Deposit Terpakai :")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Text(
                                "-" +
                                    rupiah(sharga,
                                        separator: ',', trailing: '.00'),
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
                              padding: const EdgeInsets.only(left: 50),
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
                                rupiah(totallharga,
                                    separator: ',', trailing: '.00'),
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
                          context, pymentgtwy.idpayment_gateway);
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

  void _tripModalBottomSheet(context, int idpayment) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * .70,
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
                        child: Text("Konfirmasi" + idpayment.toString(),
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
                        Icon(
                          Icons.payment,
                          color: Colors.red,
                          size: 100,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text(
                              "Anda akan melakukan pembayaran menggunakan ...",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                                "Dengan ini Saya menyatakan persetujuan kepada Horang Apps untuk memperoleh dan menggunakan kontainer yang sudah saya pesan sesuai kebijakan yang berlaku",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.inter(
                                    height: 1.5, fontSize: 14))),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RaisedButton(
                                color: Colors.green,
                                child: Text(
                                  "Lanjutkan" + idpayment.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  setState(() {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                          return KonfirmPayment(
                                            idjenis_produk: idjenis_produk,
                                            idlokasi: idlokasi,
                                            jumlah_sewa: jumlah_sewa,
                                            idasuransi: 1,
                                            idvoucher: idvoucher,
                                            flagvoucher: flagvoucher,
                                            flagasuransi: flagasuransi,
                                            idpayment_gateway: idpayment.toString(),
                                            flag_selesai: 0,
                                            harga: double.parse(sharga.toString()),
                                            total_harga:
                                            double.parse(totallharga.toString()),
                                            deposit_tambah:
                                            double.parse(sharga.toString()),
                                            deposit_pakai:
                                            double.parse(sharga.toString()),
                                            keterangan: keterangan.toString(),
                                            nomor_polis: nomor_polis,
                                            tanggal_berakhir_polis:
                                            tanggal_berakhir_polis,
                                            tanggal_mulai: stanggal_mulai,
                                            tanggal_akhir: stanggal_akhir,
                                            nominal_barang: double.parse("0.0"),
                                            keterangan_barang: sketerangan_barang,
                                            tanggal_order: "DATE(NOW())",
                                            nominal_deposit:
                                            double.parse(sharga.toString()),
                                            keterangan_deposit: "-",
                                          );
                                        }));
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
