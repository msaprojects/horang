import 'dart:convert';

class OrderProduk {
  num idlokasi,
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
      flagasuransi,
      flagvoucher;

  String token,
      tanggal_mulai,
      tanggal_akhir,
      keterangan_barang,
      no_ovo,
      email_asuransi;

  OrderProduk(
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
      this.email_asuransi,
      this.flagasuransi,
      this.flagvoucher});

  factory OrderProduk.fromJson(Map<String, dynamic> map) {
    return OrderProduk(
        idjenis_produk: map["idjenis_produk"],
        idlokasi: map["idlokasi"],
        jumlah_sewa: map["jumlah_sewa"],
        idasuransi: map["idasuransi"],
        idvoucher: map["idvoucher"],
        idpayment_gateway: map["idpayment_gateway"],
        total_harga: map["total_harga"],
        harga: map["harga"],
        nominal_barang: map["nominal_barang"],
        deposit_pakai: map["deposit_pakai"],
        deposit_tambah: map["deposit_tambah"],
        deposit_minimum: map["deposit_minimum"],
        token: map["token"],
        tanggal_mulai: map["tanggal_mulai"],
        tanggal_akhir: map["tanggal_akhir"],
        keterangan_barang: map["keterangan_barang"],
        no_ovo: map["no_ovo"],
        email_asuransi: map["email_asuransi"],
        flagasuransi: map['flagasuransi'],
        flagvoucher: map['flagvoucher']);
  }

  Map<String, dynamic> toJson() {
    return {
      "idjenis_produk": idjenis_produk,
      "idlokasi": idlokasi,
      "jumlah_sewa": jumlah_sewa,
      "idasuransi": idasuransi,
      "idvoucher": idvoucher,
      "idpayment_gateway": idpayment_gateway,
      "total_harga": total_harga,
      "harga": harga,
      "nominal_barang": nominal_barang,
      "deposit_pakai": deposit_pakai,
      "deposit_tambah": deposit_tambah,
      "deposit_minimum": deposit_minimum,
      "token": token,
      "tanggal_mulai": tanggal_mulai,
      "tanggal_akhir": tanggal_akhir,
      "keterangan_barang": keterangan_barang,
      "no_ovo": no_ovo,
      "email_asuransi": email_asuransi,
      "flagasuransi": flagasuransi,
      "flagvoucher": flagvoucher,
    };
  }

  @override
  String toString() {
    return 'OrderProduk{'
        'idjenis_produk: $idjenis_produk,'
        'idlokasi: $idlokasi,'
        'jumlah_sewa: $jumlah_sewa,'
        'idasuransi: $idasuransi,'
        'idvoucher: $idvoucher,'
        'idpayment_gateway: $idpayment_gateway,'
        'total_harga: $total_harga,'
        'harga: $harga,'
        'nominal_barang: $nominal_barang,'
        'deposit_pakai: $deposit_pakai,'
        'deposit_tambah: $deposit_tambah,'
        'deposit_minimum: $deposit_minimum,'
        'token: $token,'
        'tanggal_mulai: $tanggal_mulai,'
        'tanggal_akhir: $tanggal_akhir,'
        'keterangan_barang: $keterangan_barang,'
        'no_ovo: $no_ovo,'
        'email_asuransi: $email_asuransi,'
        'flagasuransi: $flagasuransi,'
        'flagvoucher: $flagvoucher,'
        '}';
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
