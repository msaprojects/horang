import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/order/order.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/ProdukPage/Produk.List.dart';
import 'package:horang/utils/reusable.class.dart';
import 'package:indonesia/indonesia.dart';
import 'package:horang/component/DashboardPage/home_page.dart';

import '../../widget/bottom_nav.dart';
import 'KonfirmasiOrder.Detail.dart';

class KonfirmasiPembayaran extends StatefulWidget {
  bool flagasuransi, flagvoucher;
  var token,
      idlokasi,
      idjenis_produk,
      idvoucher,
      idasuransi,
      harga_sewa,
      durasi_sewa,
      valuesewaawal,
      valuesewaakhir,
      keterangan_barang,
      nominal_barang,
      nominal_voucher,
      minimum_transaksi,
      persentase_voucher,
      total_harga,
      saldopoint,
      email_asuransi,
      tambahsaldopoint,
      persentase_asuransi,
      idpayment_gateway,
      saldodepositkurangnominaldeposit,
      no_ovo,
      minimalsewahari,
      harga_awal;

  KonfirmasiPembayaran(
      {this.token,
      this.flagasuransi,
      this.flagvoucher,
      this.idlokasi,
      this.idjenis_produk,
      this.idvoucher,
      this.idasuransi,
      this.harga_sewa,
      this.durasi_sewa,
      this.valuesewaawal,
      this.valuesewaakhir,
      this.keterangan_barang,
      this.nominal_barang,
      this.nominal_voucher,
      this.minimum_transaksi,
      this.persentase_voucher,
      this.total_harga,
      this.saldopoint,
      this.email_asuransi,
      this.tambahsaldopoint,
      this.persentase_asuransi,
      this.idpayment_gateway,
      this.saldodepositkurangnominaldeposit,
      this.no_ovo,
      this.minimalsewahari,
      this.harga_awal});
  @override
  _KonfirmasiPembayaran createState() => _KonfirmasiPembayaran();
}

ApiService _apiService = ApiService();
bool isSuccess = false;

class _KonfirmasiPembayaran extends State<KonfirmasiPembayaran> {
  bool dflagasuransi, dflagvoucher;
  var dtoken,
      didlokasi,
      didjenis_produk,
      didvoucher,
      didasuransi,
      dharga_sewa,
      ddurasi_sewa,
      dvaluesewaawal,
      dvaluesewaakhir,
      dkapasitas,
      dalamat,
      dketerangan_barang,
      dnominal_barang,
      dnominal_voucher,
      dminimum_transaksi,
      dpersentase_voucher,
      dtotal_harga,
      total_asuransi,
      dsaldopoint,
      demail_asuransi,
      dtambahsaldopoint,
      dpersentase_asuransi,
      didpayment_gateway,
      dno_ovo,
      hitungsemua,
      dminimalsewahari,
      totaldeposit,
      dharga_awal;

  void hitungsemuaFunction() async {
    setState(() {
      hitungsemua = ReusableClasses().PerhitunganOrder(
          dpersentase_asuransi.toString(),
          dminimum_transaksi.toString(),
          dflagasuransi,
          dflagvoucher,
          dnominal_voucher.toString(),
          dharga_awal.toString(),
          ddurasi_sewa.toString(),
          dnominal_barang.toString(),
          dsaldopoint.toString(),
          dminimalsewahari.toString(),
          dpersentase_asuransi.toString(),
          dharga_sewa.toString());
    });
  }

  @override
  void initState() {
    dtoken = widget.token;
    dflagasuransi = widget.flagasuransi;
    dflagvoucher = widget.flagvoucher;
    didlokasi = widget.idlokasi;
    didjenis_produk = widget.idjenis_produk;
    didvoucher = widget.idvoucher;
    didasuransi = widget.idasuransi;
    didpayment_gateway = widget.idpayment_gateway;
    dharga_sewa = widget.harga_sewa;
    ddurasi_sewa = widget.durasi_sewa;
    dvaluesewaawal = widget.valuesewaawal;
    dvaluesewaakhir = widget.valuesewaakhir;
    dketerangan_barang = widget.keterangan_barang;
    dnominal_barang = widget.nominal_barang;
    dnominal_voucher = widget.nominal_voucher;
    dminimum_transaksi = widget.minimum_transaksi;
    dpersentase_voucher = widget.persentase_voucher;
    dtotal_harga = widget.total_harga;
    dsaldopoint = widget.saldopoint; // as saldo poin terpakai
    demail_asuransi = widget.email_asuransi; // as tambah saldo poin
    dtambahsaldopoint = widget.tambahsaldopoint;
    dpersentase_asuransi = widget.persentase_asuransi;
    dno_ovo = widget.no_ovo;
    dminimalsewahari = widget.minimalsewahari;
    total_asuransi = (double.parse(dpersentase_asuransi) / 100) *
        double.parse(dnominal_barang);
    totaldeposit = (dminimalsewahari * dharga_sewa); //as nominal m
    dharga_awal = widget.harga_awal;
    hitungsemuaFunction();
    OrderProduk orderProduk = OrderProduk(
      token: dtoken,
      flagasuransi: dflagasuransi,
      flagvoucher: dflagvoucher,
      idlokasi: didlokasi,
      idjenis_produk: didjenis_produk,
      idvoucher: didvoucher,
      idasuransi: didasuransi,
      idpayment_gateway: didpayment_gateway,
      harga_sewa: dharga_sewa,
      durasi_sewa: ddurasi_sewa,
      valuesewaawal: dvaluesewaawal,
      valuesewaakhir: dvaluesewaakhir,
      keterangan_barang: dketerangan_barang,
      nominal_barang: dnominal_barang,
      nominal_voucher: dnominal_voucher,
      minimum_transaksi: dminimum_transaksi,
      persentase_voucher: dpersentase_voucher,
      total_harga: hitungsemua,
      total_asuransi: total_asuransi,
      saldopoint: dsaldopoint,
      email_asuransi: demail_asuransi,
      tambahsaldopoint: dtambahsaldopoint,
      persentase_asuransi: dpersentase_asuransi,
      no_ovo: dno_ovo,
      minimalsewahari: dminimalsewahari,
      totaldeposit: totaldeposit,
      // jenisitem: djenisitem
    );

    print("ORDER CONFIRM : " + orderProduk.toString());
    _apiService.tambahOrderProduk(orderProduk).then((idorder) {
      if (idorder > 0) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => KonfirmasiOrderDetail(
                    idorder: idorder,
                    nomVoucher: dnominal_voucher,
                    asuransi: total_asuransi)));
      } else {
        if (idorder == -1) {
          errorDialog(context,
              "Item yang anda sewa tidak tersedia, harap ubah rincian transaksi anda, terima kasih.",
              positiveText: "OK", showNeutralButton: false, positiveAction: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ProdukList()));
          });
        } else {
          errorDialog(context,
              "Maaf, transaksi anda gagal, harap ulangi kembali, terima kasih.",
              positiveText: "OK", showNeutralButton: false, positiveAction: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext context) => Home()));
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
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
                          Text(rupiah(hitungsemua),
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
                                    "Menunggu pembayaran " +
                                        rupiah(hitungsemua),
                                    style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Metode Pembayaran",
                style: GoogleFonts.inter(
                    fontSize: 14, fontWeight: FontWeight.bold),
              ),
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
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: FlatButton(
                    color: Colors.red[900],
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Home()));
                      // Navigator.pushAndRemoveUntil(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (BuildContext context) => Home()),
                      //     (Route<dynamic> route) => false);
                    },
                    child: Text(
                      'Kembali ke dashboard',
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
