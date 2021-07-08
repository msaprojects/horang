import 'dart:convert';

class OrderProduk {
  bool flagasuransi, flagvoucher;
  num idlokasi, idjenis_produk, idvoucher, idasuransi, idpayment_gateway;
  var token,
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
      total_asuransi,
      saldopoint, // as saldo poin terpakai
      email_asuransi,
      tambahsaldopoint, // as tambah saldo poin
      persentase_asuransi,
      no_ovo,
      minimalsewahari,
      totaldeposit
      // jenisitem
      ;

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
      this.keterangan_barang,
      this.nominal_barang,
      this.nominal_voucher,
      this.minimum_transaksi,
      this.persentase_voucher,
      this.total_harga,
      this.total_asuransi,
      this.saldopoint, // as saldo poin terpakai
      this.email_asuransi,
      this.tambahsaldopoint, // as tambah saldo poin
      this.persentase_asuransi,
      this.no_ovo,
      this.minimalsewahari,
      this.totaldeposit, //as nominal minimum deposit
      // this.jenisitem
      });

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
      keterangan_barang: map["keterangan_barang"],
      nominal_barang: map["nominal_barang"],
      nominal_voucher: map["nominal_voucher"],
      minimum_transaksi: map["minimum_transaksi"],
      persentase_voucher: map["persentase_voucher"],
      total_harga: map["total_harga"],
      total_asuransi: map["total_asuransi"],
      saldopoint: map["saldopoint"], // as saldo poin terpakai
      email_asuransi: map["email_asuransi"],
      tambahsaldopoint: map["tambahsaldopoint"], // as tambah saldo poin
      persentase_asuransi: map["persentase_asuransi"],
      no_ovo: map["no_ovo"],
      minimalsewahari: map["minimalsewahari"],
      totaldeposit: map["totaldeposit"], //as nominal minimum deposit
      // jenisitem: map['jenisitem']
    );
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
      "keterangan_barang": keterangan_barang,
      "nominal_barang": nominal_barang,
      "nominal_voucher": nominal_voucher,
      "minimum_transaksi": minimum_transaksi,
      "persentase_voucher": persentase_voucher,
      "total_harga": total_harga,
      "total_asuransi": total_asuransi,
      "saldopoint": saldopoint, // as saldo poin terpakai
      "email_asuransi": email_asuransi,
      "tambahsaldopoint": tambahsaldopoint, // as tambah saldo poin
      "persentase_asuransi": persentase_asuransi,
      "no_ovo": no_ovo,
      "minimalsewahari": minimalsewahari,
      "totaldeposit": totaldeposit, //as nominal minimum deposit
      // "jenisitem": jenisitem
    };
  }

  @override
  String toString() {
    return 'OrderProduk{flagasuransi: $flagasuransi, flagvoucher: $flagvoucher, idlokasi: $idlokasi, idjenis_produk: $idjenis_produk, idvoucher: $idvoucher, idasuransi: $idasuransi, idpayment_gateway: $idpayment_gateway, token: $token, harga_sewa: $harga_sewa, durasi_sewa: $durasi_sewa, valuesewaawal: $valuesewaawal, valuesewaakhir: $valuesewaakhir, keterangan_barang: $keterangan_barang, nominal_barang: $nominal_barang, nominal_voucher: $nominal_voucher, minimum_transaksi: $minimum_transaksi, persentase_voucher: $persentase_voucher, total_harga: $total_harga, total_asuransi: $total_asuransi, saldopoint: $saldopoint, email_asuransi: $email_asuransi, tambahsaldopoint: $tambahsaldopoint, persentase_asuransi: $persentase_asuransi, no_ovo: $no_ovo, minimalsewahari: $minimalsewahari, totaldeposit: $totaldeposit}';
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
