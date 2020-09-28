import 'dart:convert';

class OrderProduk{
  int idjenis_produk, idlokasi, idcustomer, jumlah_sewa, idasuransi, idvoucher, flagvoucher, flagasuransi, idpayment_gateway;
  double total_harga, harga, nominal_barang;
  String token, keterangan, nomor_polis, tanggal_berakhir_polis, tanggal_mulai, tanggal_akhir, keterangan_barang;

  OrderProduk({
    this.idjenis_produk = 0,
    this.idlokasi = 0,
    this.idcustomer = 0,
    this.jumlah_sewa = 0,
    this.idasuransi = 0,
    this.idvoucher = 0,
    this.flagvoucher = 0,
    this.flagasuransi = 0,
    this.total_harga = 0,
    this.harga = 0,
    this.idpayment_gateway=0,
    this.token,
    this.keterangan,
    this.nomor_polis,
    this.tanggal_berakhir_polis,
    this.tanggal_mulai,
    this.tanggal_akhir,
    this.nominal_barang,
    this.keterangan_barang
  });

  factory OrderProduk.fromJson(Map<String, dynamic> map){
    return OrderProduk(
      idjenis_produk: map["idjenis_produk"],
      idlokasi: map["idlokasi"],
      idcustomer: map["idcustomer"],
      jumlah_sewa: map["jumlah_sewa"],
      idasuransi: map["idasuransi"],
      idvoucher: map["idvoucher"],
      flagvoucher: map["flagvoucher"],
      flagasuransi: map["flagasuransi"],
      total_harga: map["total_harga"],
      harga: map["harga"],
      token: map["token"],
      keterangan: map["keterangan"],
      nomor_polis: map["nomor_polis"],
      tanggal_berakhir_polis: map["tanggal_berakhir_polis"],
      idpayment_gateway: map["idpayment_gateway"],
      tanggal_mulai: map["tanggal_mulai"],
      tanggal_akhir: map["tanggal_akhir"],
      nominal_barang: map["nominal_barang"],
      keterangan_barang: map["keterangan_barang"],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "idjenis_produk": idjenis_produk,
      "idlokasi": idlokasi,
      "idcustomer": idcustomer,
      "jumlah_sewa": jumlah_sewa,
      "idasuransi": idasuransi,
      "idvoucher": idvoucher,
      "flagvoucher": flagvoucher,
      "flagasuransi": flagasuransi,
      "total_harga": total_harga,
      "harga": harga,
      "token": token,
      "keterangan": keterangan,
      "nomor_polis": nomor_polis,
      "tanggal_berakhir_polis": tanggal_berakhir_polis,
      "idpayment_gateway": idpayment_gateway,
      "tanggal_mulai": tanggal_mulai,
      "tanggal_akhir": tanggal_akhir,
      "nominal_barang": nominal_barang,
      "keterangan_barang": keterangan_barang,
    };
  }

  @override
  String toString(){
    return 'OrderProduk{'
        'idcustomer: $idcustomer,'
        'idjenis_produk: $idjenis_produk,'
        'idlokasi: $idlokasi,'
        'jumlah_sewa: $jumlah_sewa,'
        'idasuransi: $idasuransi,'
        'idvoucher: $idvoucher,'
        'flagvoucher: $flagvoucher,'
        'flagasuransi: $flagasuransi,'
        'total_harga: $total_harga,'
        'harga: $harga,'
        'token: $token,'
        'keterangan: $keterangan,'
        'nomor_polis: $nomor_polis,'
        'tanggal_berakhir_polis: $tanggal_berakhir_polis,'
        'idpayment_gateway: $idpayment_gateway,'
        'tanggal_mulai: $tanggal_mulai,'
        'tanggal_akhir: $tanggal_akhir,'
        'nominal_barang: $nominal_barang,'
        'keterangan_barang: $keterangan_barang,'
        '}';
  }

}

List<OrderProduk> orderprodukFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<OrderProduk>.from(data.map((item)=> OrderProduk.fromJson(item)));
}

String orderprodukToJson(OrderProduk data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}