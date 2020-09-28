import 'dart:convert';

class OrderProduk{
  int idjenis_produk, idlokasi, jumlah_sewa, idasuransi, idvoucher, flagvoucher, flagasuransi, idpayment_gateway, flag_selesai;
  double total_harga, harga, nominal_barang, deposit_tambah, deposit_pakai, nominal_deposit;
  String token, keterangan, nomor_polis, tanggal_berakhir_polis, tanggal_mulai, tanggal_akhir, keterangan_barang, tanggal_order, keterangan_deposit;


  OrderProduk({
    this.idjenis_produk,
    this.idlokasi,
    this.jumlah_sewa,
    this.idasuransi,
    this.idvoucher,
    this.flagvoucher,
    this.flagasuransi,
    this.idpayment_gateway,
    this.flag_selesai,
    this.total_harga,
    this.harga,
    this.nominal_barang,
    this.deposit_tambah,
    this.deposit_pakai,
    this.nominal_deposit,
    this.token,
    this.keterangan,
    this.nomor_polis,
    this.tanggal_berakhir_polis,
    this.tanggal_mulai,
    this.tanggal_akhir,
    this.keterangan_barang,
    this.tanggal_order,
    this.keterangan_deposit
  });

  factory OrderProduk.fromJson(Map<String, dynamic> map){
    return OrderProduk(
      idjenis_produk: map["idjenis_produk"],
      idlokasi: map["idlokasi"],
      jumlah_sewa: map["jumlah_sewa"],
      idasuransi: map["idasuransi"],
      idvoucher: map["idvoucher"],
      flagvoucher: map["flagvoucher"],
      flagasuransi: map["flagasuransi"],
      idpayment_gateway: map["idpayment_gateway"],
      flag_selesai: map["flag_selesai"],
      total_harga: map["total_harga"],
      harga: map["harga"],
      nominal_barang: map["nominal_barang"],
      deposit_pakai: map["deposit_pakai"],
      deposit_tambah: map["deposit_tambah"],
      nominal_deposit: map["nominal_deposit"],
      token: map["token"],
      keterangan: map["keterangan"],
      nomor_polis: map["nomor_polis"],
      tanggal_berakhir_polis: map["tanggal_berakhir_polis"],
      tanggal_mulai: map["tanggal_mulai"],
      tanggal_akhir: map["tanggal_akhir"],
      keterangan_barang: map["keterangan_barang"],
      tanggal_order: map["tanggal_order"],
      keterangan_deposit: map["keterangan_deposit"],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "idjenis_produk": idjenis_produk,
      "idlokasi": idlokasi,
      "jumlah_sewa": jumlah_sewa,
      "idasuransi": idasuransi,
      "idvoucher": idvoucher,
      "flagvoucher": flagvoucher,
      "flagasuransi": flagasuransi,
      "idpayment_gateway": idpayment_gateway,
      "flag_selesai": flag_selesai,
      "total_harga": total_harga,
      "harga": harga,
      "nominal_barang": nominal_barang,
      "deposit_pakai": deposit_pakai,
      "deposit_tambah": deposit_tambah,
      "nominal_deposit": nominal_deposit,
      "token": token,
      "keterangan": keterangan,
      "nomor_polis": nomor_polis,
      "tanggal_berakhir_polis": tanggal_berakhir_polis,
      "tanggal_mulai": tanggal_mulai,
      "tanggal_akhir": tanggal_akhir,
      "keterangan_barang": keterangan_barang,
      "tanggal_order": tanggal_order,
      "keterangan_deposit": keterangan_deposit,
    };
  }

  @override
  String toString(){
    return 'OrderProduk{'
        'idjenis_produk: $idjenis_produk,'
        'idlokasi: $idlokasi,'
        'jumlah_sewa: $jumlah_sewa,'
        'idasuransi: $idasuransi,'
        'idvoucher: $idvoucher,'
        'flagvoucher: $flagvoucher,'
        'flagasuransi: $flagasuransi,'
        'idpayment_gateway: $idpayment_gateway,'
        'flag_selesai: $flag_selesai,'
        'total_harga: $total_harga,'
        'harga: $harga,'
        'nominal_barang: $nominal_barang,'
        'deposit_pakai: $deposit_pakai,'
        'deposit_tambah: $deposit_tambah,'
        'nominal_deposit: $nominal_deposit,'
        'token: $token,'
        'keterangan: $keterangan,'
        'nomor_polis: $nomor_polis,'
        'tanggal_berakhir_polis: $tanggal_berakhir_polis,'
        'tanggal_mulai: $tanggal_mulai,'
        'tanggal_akhir: $tanggal_akhir,'
        'keterangan_barang: $keterangan_barang,'
        'tanggal_order: $tanggal_order,'
        'keterangan_deposit: $keterangan_deposit,'
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