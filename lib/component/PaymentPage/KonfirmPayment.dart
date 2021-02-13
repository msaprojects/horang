import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/OrderPage/KonfirmasiPembayaran.dart';
import 'package:horang/utils/reusable.class.dart';
import 'package:horang/widget/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KonfirmPayment extends StatefulWidget {
  var flagasuransi,
      flagvoucher,
      idlokasi,
      idjenis_produk,
      idvoucher,
      idasuransi,
      harga_sewa,
      durasi_sewa,
      valuesewaawal,
      valuesewaakhir,
      kapasitas,
      alamat,
      keterangan_barang,
      nominal_barang,
      nominal_voucher,
      minimum_transaksi,
      persentase_voucher,
      totalharixharga,
      saldopoint,
      email_asuransi,
      tambahsaldopoint,
      persentase_asuransi,
      idpayment_gateway,
      minimalsewahari;

  KonfirmPayment(
      {this.flagasuransi,
      this.flagvoucher,
      this.idlokasi,
      this.idjenis_produk,
      this.idvoucher,
      this.idasuransi,
      this.harga_sewa,
      this.durasi_sewa,
      this.valuesewaawal,
      this.valuesewaakhir,
      this.kapasitas,
      this.alamat,
      this.keterangan_barang,
      this.nominal_barang,
      this.nominal_voucher,
      this.minimum_transaksi,
      this.persentase_voucher,
      this.totalharixharga,
      this.saldopoint,
      this.email_asuransi,
      this.tambahsaldopoint,
      this.persentase_asuransi,
      this.idpayment_gateway,
      this.minimalsewahari});
  @override
  _KonfirmPaymentState createState() => _KonfirmPaymentState();
}

class _KonfirmPaymentState extends State<KonfirmPayment> {
  ApiService _apiService = ApiService();
  SharedPreferences sp;
  var access_token, refresh_token, email, nama_customer;

  var kflagasuransi,
      kflagvoucher,
      kidlokasi,
      kidjenis_produk,
      kidvoucher,
      kidasuransi,
      kharga_sewa,
      kdurasi_sewa,
      kvaluesewaawal,
      kvaluesewaakhir,
      kkapasitas,
      kalamat,
      kketerangan_barang,
      knominal_barang,
      knominal_voucher,
      kminimum_transaksi,
      kpersentase_voucher,
      total_asuransi,
      ktotalharixharga,
      totaldeposit,
      ksaldopoint,
      kemail_asuransi,
      ktambahsaldopoint,
      kpersentase_asuransi,
      kidpayment_gateway,
      hitungsemua,
      kminimalsewahari;

  bool isSuccess = false;
  TextEditingController _noOvo = TextEditingController();

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

  void hitungsemuaFunction() async {
    setState(() {
      hitungsemua = ReusableClasses().PerhitunganOrder(
          kpersentase_voucher.toString(),
          kminimum_transaksi.toString(),
          kflagvoucher,
          kflagasuransi,
          knominal_voucher.toString(),
          kharga_sewa.toString(),
          kdurasi_sewa.toString(),
          knominal_barang.toString(),
          ksaldopoint.toString(),
          kminimalsewahari.toString(),
          kpersentase_asuransi.toString());
    });
  }

  @override
  void initState() {
    kflagasuransi = widget.flagasuransi;
    kflagvoucher = widget.flagvoucher;
    kidlokasi = widget.idlokasi;
    kidjenis_produk = widget.idjenis_produk;
    kidvoucher = widget.idvoucher;
    kidasuransi = widget.idasuransi;
    kharga_sewa = widget.harga_sewa;
    kdurasi_sewa = widget.durasi_sewa;
    kvaluesewaawal = widget.valuesewaawal;
    kvaluesewaakhir = widget.valuesewaakhir;
    kkapasitas = widget.kapasitas;
    kalamat = widget.alamat;
    kketerangan_barang = widget.keterangan_barang;
    knominal_barang = widget.nominal_barang;
    knominal_voucher = widget.nominal_voucher;
    kminimum_transaksi = widget.minimum_transaksi;
    kpersentase_voucher = widget.persentase_voucher;
    ktotalharixharga = widget.totalharixharga;
    ksaldopoint = widget.saldopoint;
    kemail_asuransi = widget.email_asuransi;
    ktambahsaldopoint = widget.tambahsaldopoint;
    kpersentase_asuransi = widget.persentase_asuransi;
    kidpayment_gateway = widget.idpayment_gateway;
    kminimalsewahari = widget.minimalsewahari;
    total_asuransi = (double.parse(kpersentase_asuransi) * kharga_sewa);
    totaldeposit = (kminimalsewahari * kharga_sewa);
    cekToken();
    hitungsemuaFunction();
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
              Navigator.pop(context);
            }),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Expanded(
                child: Column(
              children: [
                Text("Masukkan nomor yang terdaftar di OVO ",
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
    // print("cek1");
    // print(notelp);
    if (notelp == "") {
      print("cek2");
      return infoDialog(context, "Masukkan Nomer HP anda terlebih dahulu !");
    } else {
      // print("cek3");
      return infoDialog(
          context, "pastikan nomor $notelp ini sudah terdaftar di ewallet !",
          showNeutralButton: false,
          negativeAction: () {},
          negativeText: "Batal",
          positiveText: "Ok", positiveAction: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => KonfirmasiPembayaran(
                    token: access_token,
                    flagasuransi: kflagasuransi,
                    flagvoucher: kflagvoucher,
                    idlokasi: kidlokasi,
                    idjenis_produk: kidjenis_produk,
                    idvoucher: kidvoucher,
                    idasuransi: kidasuransi,
                    harga_sewa: kharga_sewa,
                    durasi_sewa: kdurasi_sewa,
                    valuesewaawal: kvaluesewaawal,
                    valuesewaakhir: kvaluesewaakhir,
                    keterangan_barang: kketerangan_barang,
                    nominal_barang: knominal_barang,
                    nominal_voucher: knominal_voucher,
                    minimum_transaksi: kminimum_transaksi,
                    persentase_voucher: kpersentase_voucher,
                    saldopoint: ksaldopoint,
                    email_asuransi: kemail_asuransi,
                    tambahsaldopoint: ksaldopoint,
                    persentase_asuransi: kpersentase_asuransi,
                    idpayment_gateway: kidpayment_gateway,
                    no_ovo: _noOvo.text.toString(),
                    minimalsewahari: kminimalsewahari)));
      });
    }
  }
}
