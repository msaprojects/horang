import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/OrderPage/KonfirmasiPembayaran.dart';
import 'package:horang/widget/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KonfirmPayment extends StatefulWidget {
  var idlokasi,
      idjenis_produk,
      total_harga,
      deposit_tambah,
      deposit_pakai,
      deposit_minimum,
      jumlah_sewa,
      idvoucher,
      idasuransi,
      idpayment_gateway,
      nominal_barang,
      harga,
      tanggal_mulai,
      tanggal_akhir,
      keterangan_barang,
      email_asuransi;

  KonfirmPayment(
      {this.idlokasi,
      this.idjenis_produk,
      this.jumlah_sewa,
      this.idasuransi,
      this.idvoucher,
      this.harga,
      this.idpayment_gateway,
      this.deposit_tambah,
      this.deposit_pakai,
      this.deposit_minimum,
      this.tanggal_mulai,
      this.keterangan_barang,
      this.nominal_barang,
      this.total_harga,
      this.email_asuransi,
      this.tanggal_akhir});
  @override
  _KonfirmPaymentState createState() => _KonfirmPaymentState();
}

class _KonfirmPaymentState extends State<KonfirmPayment> {
  ApiService _apiService = ApiService();
  SharedPreferences sp;
  var access_token, refresh_token, email, nama_customer;

  var idlokasi,
      idjenis_produk,
      total_harga,
      deposit_tambah,
      deposit_pakai,
      deposit_minimum,
      jumlah_sewa,
      idvoucher,
      idasuransi,
      idpayment_gateway,
      nominal_barang,
      harga,
      tanggal_mulai,
      tanggal_akhir,
      keterangan_barang,
      email_asuransi;

  bool isSuccess = false;
  TextEditingController _noOvo = TextEditingController();

  cekToken() async {
    print("masuk1");
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    email = sp.getString("email");
    nama_customer = sp.getString("nama_customer");
    //checking jika token kosong maka di arahkan ke menu login jika tidak akan meng-hold token dan refresh token
    if (access_token == null) {
      print("masuk2");
      showAlertDialog(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    } else {
      print("masuk3");
      _apiService.checkingToken(access_token).then((value) => setState(() {
            isSuccess = value;
            //checking jika token expired/tidak berlaku maka akan di ambilkan dari refresh token
            if (!isSuccess) {
              print("masuk4");
              _apiService
                  .refreshToken(refresh_token)
                  .then((value) => setState(() {
                        var newtoken = value;
                        //setting access_token dari refresh_token
                        if (newtoken != "") {
                          print("masuk5");
                          sp.setString("access_token", newtoken);
                          access_token = newtoken;
                        } else {
                          print("masuk6");
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
    cekToken();
    idpayment_gateway = widget.idpayment_gateway;
    idlokasi = widget.idlokasi;
    idjenis_produk = widget.idjenis_produk;
    jumlah_sewa = widget.jumlah_sewa;
    harga = widget.harga;
    idasuransi = widget.idasuransi;
    idvoucher = widget.idvoucher;
    tanggal_mulai = widget.tanggal_mulai;
    tanggal_akhir = widget.tanggal_akhir;
    keterangan_barang = widget.keterangan_barang;
    nominal_barang = widget.nominal_barang;
    total_harga = widget.total_harga;
    deposit_tambah = widget.deposit_tambah;
    deposit_pakai = widget.deposit_pakai;
    deposit_minimum = widget.deposit_minimum;
    email_asuransi = widget.email_asuransi;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              // Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                  (Route<dynamic> route) => false);
            }),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Expanded(
                child: Column(
              children: [
                Text("Masukkan nomor yang terdaftar di OVO",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _noOvo,
                  // ignore: deprecated_member_use
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    hintText: "Ovo",
                    labelText: "Ovo",
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "1. Buka aplikasi OVO dan cek notifikasi untuk menyelesaikan pembayaran.",
                  style: GoogleFonts.inter(height: 1.5, fontSize: 14),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "2. Pastikan Anda melakukan pembayaran dalam waktu 30 detik untuk menghindari pembatalan secara otomatis.",
                  style: GoogleFonts.inter(height: 1.5, fontSize: 14),
                ),
              ],
            )),
            FlatButton(
              color: Colors.green,
              child: Text(
                "Bayar Sekarang",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                setState(() {
                  OrderConfirmation(context, _noOvo.text.toString());
                });
              },
            )
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

  OrderConfirmation(BuildContext context, String notelp) {
    infoDialog(
        context, "pastikan nomor $notelp ini sudah terdaftar di ewallet!",
        showNeutralButton: false, positiveText: "Ok", positiveAction: () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Dummy1(
                  idjenis_produk: idjenis_produk,
                  idlokasi: idlokasi,
                  jumlah_sewa: jumlah_sewa,
                  idasuransi: idasuransi,
                  idvoucher: idvoucher,
                  idpayment_gateway: idpayment_gateway,
                  total_harga: total_harga,
                  harga: harga,
                  nominal_barang: nominal_barang,
                  deposit_tambah: deposit_tambah,
                  deposit_pakai: deposit_pakai,
                  deposit_minimum: deposit_minimum,
                  token: access_token,
                  tanggal_mulai: tanggal_mulai,
                  tanggal_akhir: tanggal_akhir,
                  keterangan_barang: keterangan_barang,
                  email_asuransi: email_asuransi,
                  no_ovo: _noOvo.text.toString())));
    });
  }
}
