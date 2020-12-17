import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/order/order.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/ProdukPage/Produk.List.dart';
import 'package:indonesia/indonesia.dart';

import 'KonfirmasiOrder.Detail.dart';

class Dummy1 extends StatefulWidget {
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
      token,
      tanggal_mulai,
      tanggal_akhir,
      keterangan_barang,
      no_ovo,
      email_asuransi;

  Dummy1(
      {this.idjenis_produk,
      this.idlokasi,
      this.jumlah_sewa,
      this.idasuransi,
      this.idvoucher,
      this.idpayment_gateway,
      this.total_harga,
      this.harga,
      this.nominal_barang,
      this.deposit_tambah,
      this.deposit_pakai,
      this.deposit_minimum,
      this.token,
      this.tanggal_mulai,
      this.tanggal_akhir,
      this.keterangan_barang,
      this.no_ovo,
      this.email_asuransi});
  @override
  _Dummy1State createState() => _Dummy1State();
}

ApiService _apiService = ApiService();
bool isSuccess = false;

class _Dummy1State extends State<Dummy1> {
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
      token,
      tanggal_mulai,
      tanggal_akhir,
      keterangan_barang,
      no_ovo,
      email_asuransi;

  @override
  void initState() {
    token = widget.token;
    tanggal_mulai = widget.tanggal_mulai;
    tanggal_akhir = widget.tanggal_akhir;
    idlokasi = widget.idlokasi;
    idjenis_produk = widget.idjenis_produk;
    idvoucher = widget.idvoucher;
    idasuransi = widget.idasuransi;
    total_harga = widget.total_harga;
    idlokasi = widget.idlokasi;
    deposit_tambah = widget.deposit_tambah;
    deposit_pakai = widget.deposit_pakai;
    deposit_minimum = widget.deposit_minimum;
    jumlah_sewa = widget.jumlah_sewa;
    idpayment_gateway = widget.idpayment_gateway;
    keterangan_barang = widget.keterangan_barang;
    nominal_barang = widget.nominal_barang;
    no_ovo = widget.no_ovo;
    harga = widget.harga;
    email_asuransi = widget.email_asuransi;

    OrderProduk orderProduk = OrderProduk(
        idjenis_produk: idjenis_produk,
        idlokasi: idlokasi,
        jumlah_sewa: int.parse(jumlah_sewa),
        idasuransi: idasuransi,
        idvoucher: idvoucher,
        idpayment_gateway: idpayment_gateway,
        total_harga: double.parse(total_harga),
        harga: harga,
        nominal_barang: double.parse(nominal_barang),
        deposit_tambah: double.parse(deposit_tambah),
        deposit_pakai: double.parse(deposit_pakai),
        deposit_minimum: double.parse(deposit_minimum),
        token: token,
        tanggal_mulai: tanggal_mulai,
        tanggal_akhir: tanggal_akhir,
        keterangan_barang: keterangan_barang,
        no_ovo: no_ovo,
        email_asuransi: email_asuransi);
    print("SEND TO ORDER : " + orderProduk.toString());
    _apiService.tambahOrderProduk(orderProduk).then((idorder) {
      if (idorder > 0) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    KonfirmasiOrderDetail(idorder: idorder)));
      } else {
        if (idorder == -1) {
          print("Container tidak tersedia");
          errorDialog(context, "Kontainer tidak tersedia",
              positiveText: "OK", showNeutralButton: false, positiveAction: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ProdukList()));
          });
        } else {
          print("Transaksi gagal !!");
          errorDialog(context, "Transaksi gagal disimpan",
              positiveText: "Ok", showNeutralButton: false, positiveAction: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ProdukList()));
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        // margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Icon(Icons.close_rounded),
            ),
            Container(
                child: Center(
              child: Image.asset(
                'assets/image/sikat_min1.gif',
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.contain,
              ),
            )),
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 2.0,
              child: Container(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Total Bayar",
                            style: GoogleFonts.inter(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(rupiah(total_harga),
                            style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                      ],
                    ),
                    Divider(
                      height: 10,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Icon(Icons.timer),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                  "Menunggu pembayaran Sebesar " +
                                      rupiah(total_harga),
                                  style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        // Text("Refresh",
                        //     style: GoogleFonts.inter(
                        //         fontSize: 14,
                        //         fontWeight: FontWeight.bold,
                        //         color: Colors.red)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text("Metode Pembayaran",
                style: GoogleFonts.inter(
                    fontSize: 14, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Text(
                    "Buka aplikasi OVO anda dan cek pemberitahuan untuk menyelesaikan proses pembayaran. Tolong lakukan dalam 50 detik.",
                    style: GoogleFonts.lato(
                        fontSize: 12, height: 1.5, color: Colors.grey),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
