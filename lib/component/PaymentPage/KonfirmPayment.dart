import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/order/order.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/OrderPage/KonfirmasiOrder.Detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class KonfirmPayment extends StatefulWidget {
  var idlokasi,
      idjenis_produk,
      idcustomer,
      keterangan,
      jumlah_sewa,
      idpayment_gateway,
      flag_selesai,
      deposit_tambah,
      deposit_pakai,
      flagasuransi,
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
      tanggal_order,
      nominal_deposit,
      keterangan_deposit,
      tanggal_akhir;
  KonfirmPayment(
      {this.idlokasi,
      this.idjenis_produk,
      this.keterangan,
      this.jumlah_sewa,
      this.flagasuransi,
      this.flagvoucher,
      this.idasuransi,
      this.nomor_polis,
      this.tanggal_berakhir_polis,
      this.idvoucher,
      this.kapasitas,
      this.harga,
      this.alamat,
      this.idpayment_gateway,
      this.flag_selesai,
      this.deposit_tambah,
      this.deposit_pakai,
      this.tanggal_mulai,
      this.tanggal_order,
      this.nominal_deposit,
      this.keterangan_deposit,
      this.keterangan_barang,
      this.nominal_barang,
      this.total_harga,
      this.tanggal_akhir});
  @override
  _KonfirmPaymentState createState() => _KonfirmPaymentState();
}

class _KonfirmPaymentState extends State<KonfirmPayment> {
  ApiService _apiService = ApiService();
  // String no_ovo;
  SharedPreferences sp;
  var access_token, refresh_token, email, nama_customer;
  var kidlokasi,
      kidjenis_produk,
      kidcustomer,
      kketerangan,
      kjumlah_sewa,
      kflagasuransi,
      kflagvoucher,
      kidasuransi,
      kidpayment_gateway,
      knomor_polis,
      ktanggal_berakhir_polis,
      kidvoucher,
      kskapasitas,
      ksharga,
      ksalamat,
      ksp,
      ksketerangan_barang,
      ksnominal_barang,
      kstotal_harga,
      kstanggal_mulai,
      kstanggal_akhir,
      kselectedValue,
      kstotallharga;
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

  @override
  void initState() {
//    if(widget.orderProduk !=null){
    kidpayment_gateway = widget.idpayment_gateway;
    kidlokasi = widget.idlokasi;
    kidjenis_produk = widget.idjenis_produk;
    kketerangan = widget.keterangan;
    kjumlah_sewa = widget.jumlah_sewa;
    ksharga = widget.harga;
    kflagvoucher = widget.flagvoucher;
    kflagasuransi = widget.flagasuransi;
    kidasuransi = widget.idasuransi;
    knomor_polis = widget.nomor_polis;
    ktanggal_berakhir_polis = widget.tanggal_berakhir_polis;
    kidvoucher = widget.idvoucher;
    kskapasitas = widget.kapasitas;
    ksalamat = widget.alamat;
    kstanggal_mulai = widget.tanggal_mulai;
    kstanggal_akhir = widget.tanggal_akhir;
    ksketerangan_barang = widget.keterangan_barang;
    ksnominal_barang = widget.nominal_barang;
    kstotal_harga = widget.total_harga;
//    }
    cekToken();
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
                Text("Masukkan nomor yang terdaftar di OVO",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _noOvo,
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
                  "1. Buka aplikasi OVO dan cek notifikasi untuk menyelesaikan pembayaran",
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
                "Bayar Sekarang" + kidpayment_gateway,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                setState(() {
                  print("Haduh : " + _noOvo.text.toString());
                  OrderProduk orderproduk = OrderProduk(
                      idjenis_produk: kidjenis_produk,
                      idlokasi: kidlokasi,
                      jumlah_sewa: kjumlah_sewa,
                      idasuransi: 1,
                      idvoucher: kidvoucher,
                      flagasuransi: kflagasuransi,
                      flagvoucher: kflagvoucher,
                      idpayment_gateway:
                          int.parse(kidpayment_gateway.toString()),
                      flag_selesai: 0,
                      total_harga: kstotal_harga,
                      harga: ksharga,
                      nominal_barang: double.parse("0.0"),
                      deposit_tambah: double.parse(ksharga.toString()),
                      deposit_pakai: double.parse(ksharga.toString()),
                      token: access_token,
                      keterangan: kketerangan,
                      nomor_polis: knomor_polis,
                      tanggal_berakhir_polis: ktanggal_berakhir_polis,
                      tanggal_mulai: kstanggal_mulai,
                      tanggal_akhir: kstanggal_akhir,
                      keterangan_barang: ksketerangan_barang,
                      tanggal_order: "DATE(NOW())",
                      keterangan_deposit: "-",
                      nominal_deposit: double.parse(ksharga.toString()),
                      no_ovo: _noOvo.text.toString());
                  print("but if you never try " + orderproduk.toString());
                  _apiService.tambahOrderProduk(orderproduk).then((idorder) {
                    if (idorder != 0) {
                      // _scaffoldState.currentState.showSnackBar(SnackBar(
                      //   content: Text("Berhasil"),
                      // ));
                      print("ID TIDAK ORDER KOSONG");
                      _apiService.listOrderSukses(access_token, idorder);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => KonfirmasiOrderDetail()));
                    } else {
                      print("gagal");
                    }
                  });
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
