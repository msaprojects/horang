import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/order/order.model.dart';
import 'package:horang/api/models/token/token.model.dart';
import 'package:horang/api/utils/apiService.dart';

import 'OrderPage/KonfirmasiOrder.Detail.dart';

class Dummy1 extends StatefulWidget {
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
      token,
      no_ovo,
      namaprovider,
      tanggal_akhir;
  Dummy1(
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
      this.token,
      this.no_ovo,
      this.namaprovider,
      this.tanggal_akhir});
  @override
  _Dummy1State createState() => _Dummy1State();
}

ApiService _apiService = ApiService();
bool isSuccess = false;

class _Dummy1State extends State<Dummy1> {
  var kidlokasi,
      knamaprovider,
      kidjenis_produk,
      kidcustomer,
      kketerangan,
      kjumlah_sewa,
      kflagasuransi,
      kflag_selesai,
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
      kdeposit_tambah,
      kdeposit_pakai,
      kkapasitas,
      kharga,
      ktanggal_mulai,
      kketerangan_barang,
      knominal_barang,
      ktotal_harga,
      ktanggal_order,
      knominal_deposit,
      kketerangan_deposit,
      ktoken,
      kno_ovo,
      ktanggal_akhir,
      kstotallharga;

  @override
  void initState() {
    knamaprovider = widget.namaprovider;
    kidlokasi = widget.idlokasi;
    kidjenis_produk = widget.idlokasi;
    kidcustomer = widget.idcustomer;
    kketerangan = widget.keterangan;
    kjumlah_sewa = widget.jumlah_sewa;
    kidpayment_gateway = widget.idpayment_gateway;
    kflag_selesai = widget.flag_selesai;
    kdeposit_tambah = widget.deposit_tambah;
    kdeposit_pakai = widget.deposit_pakai;
    kflagasuransi = widget.flagasuransi;
    kflagvoucher = widget.flagvoucher;
    kidasuransi = widget.idasuransi;
    knomor_polis = widget.nomor_polis;
    ktanggal_berakhir_polis = widget.tanggal_berakhir_polis;
    kidvoucher = widget.idvoucher;
    kkapasitas = widget.kapasitas;
    kharga = widget.harga;
    ksalamat = widget.alamat;
    ktanggal_mulai = widget.tanggal_mulai;
    kketerangan_barang = widget.keterangan_barang;
    knominal_barang = widget.nominal_barang;
    ktotal_harga = widget.total_harga;
    ktanggal_order = widget.tanggal_order;
    knominal_deposit = widget.nominal_deposit;
    kketerangan_deposit = widget.keterangan_deposit;
    ktoken = widget.token;
    kno_ovo = widget.no_ovo;
    ktanggal_akhir = widget.tanggal_akhir;
    print("object" + kdeposit_tambah.toString());

    OrderProduk orderProduk = OrderProduk(
        idjenis_produk: kidjenis_produk,
        idlokasi: kidlokasi,
        jumlah_sewa: kjumlah_sewa,
        idasuransi: 1,
        idvoucher: kidvoucher,
        flagasuransi: kflagasuransi,
        flagvoucher: kflagvoucher,
        idpayment_gateway: kidpayment_gateway,
        flag_selesai: 0,
        total_harga: ktotal_harga,
        harga: kharga,
        nominal_barang: double.parse("0.0"),
        deposit_tambah: kdeposit_tambah,
        deposit_pakai: kdeposit_pakai,
        token: ktoken,
        keterangan: kketerangan,
        nomor_polis: knomor_polis,
        tanggal_berakhir_polis: ktanggal_berakhir_polis,
        tanggal_mulai: ktanggal_mulai,
        tanggal_akhir: ktanggal_akhir,
        keterangan_barang: kketerangan_barang,
        tanggal_order: "DATE(NOW())",
        keterangan_deposit: "-",
        nominal_deposit: ksharga,
        no_ovo: kno_ovo.toString());
    print("MODELLLL : " + orderProduk.toString());
    _apiService.tambahOrderProduk(orderProduk).then((idorder) {
      if (idorder > 0) {
        print("masuk9");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => KonfirmasiOrderDetail(
                      idorder: idorder,
                    )));
      } else {
        if (idorder == -1) {
          print("Container tidak tersedia");
          // AsyncSnapshot.waiting().connectionState == ConnectionState.waiting;
          errorDialog(
            context,
            "Kontainer tidak tersedia",
          );
        } else {
          print("Transaksi gagal !!");
          errorDialog(
            context,
            "Transaksi gagal disimpan",
          );
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
                        Text("Rp. " + ktotal_harga.toString(),
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
                              Text("Menunggu pembayaran",
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
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 2.0,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20, right: 20),
                height: 50,
                child: Text(knamaprovider.toString()),
              ),
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
