import 'dart:convert';

import 'package:horang/api/models/order/order.sukses.model.dart';

class OrderProduk {
  bool flagasuransi, flagvoucher;
  num idlokasi, idjenis_produk, idvoucher, idasuransi, idpayment_gateway;
  var token,
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
      totalpointdeposit,
      email_asuransi,
      deposit,
      persentase_asuransi,
      saldodepositkurangnominaldeposit,
      no_ovo;

  OrderProduk(
      {this.token,
      this.flagasuransi,
      this.flagvoucher,
      this.idlokasi,
      this.idjenis_produk,
      this.idvoucher,
      this.idasuransi,
      this.idpayment_gateway,
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
      this.totaldeposit,//minimum nominal deposit
      this.email_asuransi,
      this.deposit,
      this.persentase_asuransi,
      this.saldodepositkurangnominaldeposit,
      this.no_ovo});

  factory OrderProduk.fromJson(Map<String, dynamic> map) {
    return OrderProduk(
        token: map["token"],
        flagasuransi: map["flagasuransi"],
        flagvoucher: map["flagvoucher"],
        idlokasi: map["idlokasi"],
        idjenis_produk: map["idjenis_produk"],
        idvoucher: map["idvoucher"],
        idasuransi: map["idasuransi"],
        idpayment_gateway: map["idpayment_gateway"],
        harga_sewa: map["harga_sewa"],
        durasi_sewa: map["durasi_sewa"],
        valuesewaawal: map["valuesewaawal"],
        valuesewaakhir: map["valuesewaakhir"],
        tanggal_berakhir_polis: map["tanggal_berakhir_polis"],
        nomor_polis: map["nomor_polis"],
        keterangan_barang: map["keterangan_barang"],
        nominal_barang: map["nominal_barang"],
        nominal_voucher: map["nominal_voucher"],
        minimum_transaksi: map["minimum_transaksi"],
        persentase_voucher: map["persentase_voucher"],
        total_harga: map["total_harga"],
        total_asuransi: map["total_asuransi"],
        totaldeposit: map["totaldeposit"],
        email_asuransi: map["email_asuransi"],
        deposit: map["deposit"],
        persentase_asuransi: map["persentase_asuransi"],
        saldodepositkurangnominaldeposit:
            map["saldodepositkurangnominaldeposit"],
        no_ovo: map["no_ovo"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "token": token,
      "flagasuransi": flagasuransi,
      "flagvoucher": flagvoucher,
      "idlokasi": idlokasi,
      "idjenis_produk": idjenis_produk,
      "idvoucher": idvoucher,
      "idasuransi": idasuransi,
      "idpayment_gateway": idpayment_gateway,
      "harga_sewa": harga_sewa,
      "durasi_sewa": durasi_sewa,
      "valuesewaawal": valuesewaawal,
      "valuesewaakhir": valuesewaakhir,
      "tanggal_berakhir_polis": tanggal_berakhir_polis,
      "nomor_polis": nomor_polis,
      "keterangan_barang": keterangan_barang,
      "nominal_barang": nominal_barang,
      "nominal_voucher": nominal_voucher,
      "minimum_transaksi": minimum_transaksi,
      "persentase_voucher": persentase_voucher,
      "total_harga": total_harga,
      "total_asuransi": total_asuransi,
      "totalharixharga": totalharixharga,
      "totaldeposit": totaldeposit,
      "totalpointdeposit": totalpointdeposit,
      "email_asuransi": email_asuransi,
      "deposit": deposit,
      "persentase_asuransi": persentase_asuransi,
      "saldodepositkurangnominaldeposit": saldodepositkurangnominaldeposit,
      "no_ovo": no_ovo,
    };
  }

  @override
  String toString() {
    return 'OrderProduk{token: $token, flagasuransi: $flagasuransi, flagvoucher: $flagvoucher, idlokasi: $idlokasi, idjenis_produk: $idjenis_produk, idvoucher: $idvoucher, idasuransi: $idasuransi, idpayment_gateway: $idpayment_gateway, harga_sewa: $harga_sewa, durasi_sewa: $durasi_sewa, valuesewaawal: $valuesewaawal, valuesewaakhir: $valuesewaakhir, tanggal_berakhir_polis: $tanggal_berakhir_polis, nomor_polis: $nomor_polis, keterangan_barang: $keterangan_barang, nominal_barang: $nominal_barang, nominal_voucher: $nominal_voucher, minimum_transaksi: $minimum_transaksi, persentase_voucher: $persentase_voucher, total_harga: $total_harga, total_asuransi: $total_asuransi, totalharixharga: $totalharixharga, totaldeposit: $totaldeposit, totalpointdeposit: $totalpointdeposit, email_asuransi: $email_asuransi, deposit: $deposit, persentase_asuransi: $persentase_asuransi, saldodepositkurangnominaldeposit: $saldodepositkurangnominaldeposit, no_ovo: $no_ovo}';
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
