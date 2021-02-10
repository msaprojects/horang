import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/order/order.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/ProdukPage/Produk.List.dart';
import 'package:horang/utils/reusable.class.dart';
import 'package:indonesia/indonesia.dart';

import 'KonfirmasiOrder.Detail.dart';

class KonfirmasiPembayaran extends StatefulWidget {
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
      tanggal_berakhir_polis,
      nomor_polis,
      keterangan_barang,
      nominal_barang,
      nominal_voucher,
      minimum_transaksi,
      persentase_voucher,
      total_harga,
      total_asuransi,
      totalharixharga,
      totaldeposit,
      saldopoint,
      email_asuransi,
      tambahsaldopoint,
      persentase_asuransi,
      idpayment_gateway,
      saldodepositkurangnominaldeposit,
      no_ovo,
      minimalsewahari;

  KonfirmasiPembayaran(
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
      this.tanggal_berakhir_polis,
      this.nomor_polis,
      this.keterangan_barang,
      this.nominal_barang,
      this.nominal_voucher,
      this.minimum_transaksi,
      this.persentase_voucher,
      this.total_harga,
      this.total_asuransi,
      this.totalharixharga,
      this.totaldeposit,
      this.saldopoint,
      this.email_asuransi,
      this.tambahsaldopoint,
      this.persentase_asuransi,
      this.idpayment_gateway,
      this.saldodepositkurangnominaldeposit,
      this.no_ovo,
      this.minimalsewahari});
  @override
  _KonfirmasiPembayaran createState() => _KonfirmasiPembayaran();
}

ApiService _apiService = ApiService();
bool isSuccess = false;

class _KonfirmasiPembayaran extends State<KonfirmasiPembayaran> {
  var dflagasuransi,
      dflagvoucher,
      didlokasi,
      didjenis_produk,
      didvoucher,
      didasuransi,
      dharga_sewa,
      ddurasi_sewa,
      dvaluesewaawal,
      dvaluesewaakhir,
      dtanggal_berakhir_polis,
      dnomor_polis,
      dkapasitas,
      dalamat,
      dketerangan_barang,
      dnominal_barang,
      dnominal_voucher,
      dminimum_transaksi,
      dpersentase_voucher,
      dtotal_harga,
      dtotal_asuransi,
      dtotalharixharga,
      dtotaldeposit,
      dsaldopoint,
      demail_asuransi,
      dtambahsaldopoint,
      dpersentase_asuransi,
      didpayment_gateway,
      dno_ovo,
      hitungsemua,
      dminimalsewahari;

  void hitungsemuaFunction() async {
    setState(() {
      hitungsemua = ReusableClasses().PerhitunganOrder(
          dpersentase_asuransi.toString(),
          dminimum_transaksi.toString(),
          dflagvoucher,
          dflagasuransi,
          dnominal_voucher.toString(),
          dharga_sewa.toString(),
          ddurasi_sewa.toString(),
          dnominal_barang.toString(),
          dsaldopoint.toString(),
          dminimalsewahari.toString(),
          dpersentase_asuransi.toString());
    });
  }

  @override
  void initState() {
    // token = widget.token;
    dflagasuransi = widget.flagasuransi;
    dflagvoucher = widget.flagvoucher;
    didlokasi = widget.idlokasi;
    didjenis_produk = widget.idjenis_produk;
    didvoucher = widget.idvoucher;
    didasuransi = widget.idasuransi;
    dharga_sewa = widget.harga_sewa;
    ddurasi_sewa = widget.durasi_sewa;
    dvaluesewaawal = widget.valuesewaawal;
    dvaluesewaakhir = widget.valuesewaakhir;
    dtanggal_berakhir_polis = widget.tanggal_berakhir_polis;
    dnomor_polis = widget.nomor_polis;
    dketerangan_barang = widget.keterangan_barang;
    dnominal_barang = widget.nominal_barang;
    dnominal_voucher = widget.nominal_voucher;
    dminimum_transaksi = widget.minimum_transaksi;
    dpersentase_voucher = widget.persentase_voucher;
    dtotal_harga = widget.total_harga;
    dtotal_asuransi = widget.total_asuransi;
    dtotalharixharga = widget.totalharixharga;
    dtotaldeposit = widget.totaldeposit;
    dsaldopoint = widget.saldopoint;
    demail_asuransi = widget.email_asuransi;
    dtambahsaldopoint = widget.tambahsaldopoint;
    dpersentase_asuransi = widget.persentase_asuransi;
    didpayment_gateway = widget.idpayment_gateway;
    dno_ovo = widget.no_ovo;
    dminimalsewahari = widget.minimalsewahari;
    OrderProduk orderProduk = OrderProduk(
        idjenis_produk: didjenis_produk,
        idlokasi: didlokasi,
        jumlah_sewa: int.parse(ddurasi_sewa),
        idasuransi: didasuransi,
        idvoucher: didvoucher,
        idpayment_gateway: didpayment_gateway,
        total_harga: double.parse(dtotal_harga),
        harga: dharga_sewa,
        nominal_barang: double.parse(dnominal_barang),
        // deposit_tambah: double.parse(deposit_tambah),
        // deposit_pakai: double.parse(deposit_pakai),
        // deposit_minimum: double.parse(deposit_minimum),
        // token: token,
        valuesewaawal: dvaluesewaawal,
        valuesewaakhir: dvaluesewaakhir,
        keterangan_barang: dketerangan_barang,
        // no_ovo: dno_ovo,
        email_asuransi: demail_asuransi,
        flagasuransi: dflagasuransi,
        flagvoucher: dflagvoucher);
    print("SEND TO ORDER : " + orderProduk.toString());
    _apiService.tambahOrderProduk(orderProduk).then((idorder) {
      if (idorder > 0) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => KonfirmasiOrderDetail(
                    idorder: idorder,
                    nomVoucher: dnominal_voucher,
                    asuransi: dtotal_asuransi)));
      } else {
        if (idorder == -1) {
          errorDialog(context, "Kontainer tidak tersedia",
              positiveText: "OK", showNeutralButton: false, positiveAction: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ProdukList()));
          });
        } else {
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
                        Text(rupiah(dtotal_harga),
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
                                      rupiah(dtotal_harga),
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
            Text("Metode Pembayaran ",
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
