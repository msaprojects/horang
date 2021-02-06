import 'dart:convert';

import 'package:horang/api/models/order/order.sukses.model.dart';

class OrderProduk {
bool flagasuransi,
      flagvoucher;
   num   idlokasi,
      idjenis_produk,
      idvoucher,
      idasuransi,idpayment_gateway;
var      harga,
      jumlah_sewa,
      valuesewaawal,
      valuesewaakhir,
      tanggal_berakhir_polis,
      nomor_polis,
      kapasitas,
      alamat,
      keterangan_barang,
      nominal_barang,
      nominal_voucher,
      minimum_transaksi,
      persentase_voucher,
      total_harga,
      total_asuransi,
      totalharixharga,
      totaldeposit,
      totalpointdeposit,
      email_asuransi,
      deposit,
      persentase_asuransi, saldodepositkurangnominaldeposit;

OrderProduk({
      this.flagasuransi,
      this.flagvoucher,
      this.idlokasi,
      this.idjenis_produk,
      this.idvoucher,
      this.idasuransi,
      this.idpayment_gateway,
      this.harga,
      this.jumlah_sewa,
      this.valuesewaawal,
      this.valuesewaakhir,
      this.tanggal_berakhir_polis,
      this.nomor_polis,
      this.kapasitas,
      this.alamat,
      this.keterangan_barang,
      this.nominal_barang,
      this.nominal_voucher,
      this.minimum_transaksi,
      this.persentase_voucher,
      this.total_harga,
      this.total_asuransi,
      this.totalharixharga,
      this.totaldeposit,
      this.totalpointdeposit,
      this.email_asuransi,
      this.deposit,
      this.persentase_asuransi,
      this.saldodepositkurangnominaldeposit});

factory OrderProduk.fromJson(Map<String, dynamic> map){
  return OrderProduk(
    flagasuransi: map["flagasuransi"],
  );
}

Map<String, dynamic> toJson(){
  return{

  };
}


@override
  String toString() {
    return 'OrderProduk{flagasuransi: $flagasuransi, flagvoucher: $flagvoucher, idlokasi: $idlokasi, idjenis_produk: $idjenis_produk, idvoucher: $idvoucher, idasuransi: $idasuransi, idpayment_gateway: $idpayment_gateway, harga: $harga, jumlah_sewa: $jumlah_sewa, valuesewaawal: $valuesewaawal, valuesewaakhir: $valuesewaakhir, tanggal_berakhir_polis: $tanggal_berakhir_polis, nomor_polis: $nomor_polis, kapasitas: $kapasitas, alamat: $alamat, keterangan_barang: $keterangan_barang, nominal_barang: $nominal_barang, nominal_voucher: $nominal_voucher, minimum_transaksi: $minimum_transaksi, persentase_voucher: $persentase_voucher, total_harga: $total_harga, total_asuransi: $total_asuransi, totalharixharga: $totalharixharga, totaldeposit: $totaldeposit, totalpointdeposit: $totalpointdeposit, email_asuransi: $email_asuransi, deposit: $deposit, persentase_asuransi: $persentase_asuransi, saldodepositkurangnominaldeposit: $saldodepositkurangnominaldeposit}';
  }
}

List<OrderProduk> orderprodukFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<OrderProduk>.from(data.map((item) => OrderProduk.fromJson(item)));
}

String orderprodukToJson(OrderProduk data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
