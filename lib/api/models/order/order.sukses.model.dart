import 'dart:convert';

class OrderSukses{
  num idtransaksi, idpembayaran, idpayment_gateway, idproduk, jumlah_sewa;
  // int total_harga, nominal, harga;
  num total_harga, nominal, harga;
  String no_order, keterangan, kode_refrensi, nama_provider, kode_kontainer,tanggal_order, tanggal_mulai, tanggal_akhir;

  OrderSukses({
    this.idtransaksi = 0,
    this.idpembayaran = 0,
    this.idpayment_gateway = 0,
    this.idproduk = 0,
    required this.no_order,
    this.total_harga = 0,
    required this.keterangan,
    this.jumlah_sewa = 0,
    required this.harga,
    required this.kode_refrensi,
    this.nominal = 0,
    required this.nama_provider,
    required this.kode_kontainer,
    required this.tanggal_akhir,
    required this.tanggal_mulai,
    required this.tanggal_order
  });

  factory OrderSukses.fromJson(Map<String, dynamic> map){
    return OrderSukses(
      idtransaksi: map["idtransaksi"],
      idpembayaran: map["idpembayaran"],
      idpayment_gateway: map["idpayment_gateway"],
      idproduk: map["idproduk"],
      jumlah_sewa: map["jumlah_sewa"],
      total_harga: map["total_harga"],
      nominal: map["nominal"],
      no_order: map["no_order"],
      keterangan: map["keterangan"],
      harga: map["harga"],
      kode_kontainer: map["kode_kontainer"],
      kode_refrensi: map["kode_refrensi"],
      nama_provider: map["nama_provider"],
      tanggal_mulai: map["tanggal_mulai"],
      tanggal_akhir: map["tanggal_akhir"],
      tanggal_order: map["tanggal_order"],
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "idtransaksi": idtransaksi,
      "idpembayaran": idpembayaran,
      "idpayment_gateway": idpayment_gateway,
      "idproduk": idproduk,
      "jumlah_sewa": jumlah_sewa,
      "total_harga": total_harga,
      "nominal": nominal,
      "no_order": no_order,
      "keterangan": keterangan,
      "harga": harga,
      "kode_kontainer": kode_kontainer,
      "kode_refrensi": kode_refrensi,
      "nama_provider": nama_provider,
      "tanggal_mulai": tanggal_mulai,
      "tanggal_akhir": tanggal_akhir,
      "tanggal_order": tanggal_order,
    };
  }

  @override
  String  toString(){
    print("order sukses1 $idtransaksi");
    return 'OrderSukses{idtransaksi: $idtransaksi, idpembayaran: $idpembayaran, idpayment_gateway: $idpayment_gateway, idproduk: $idproduk, jumlah_sewa: $jumlah_sewa, total_harga: $total_harga, nominal: $nominal, no_order: $no_order, keterangan: $keterangan, harga: $harga, kode_kontainer: $kode_kontainer, kode_refrensi: $kode_refrensi, nama_provider: $nama_provider, tanggal_mulai: $tanggal_mulai, tanggal_akhir: $tanggal_akhir, tanggal_order: $tanggal_order}';
  }

}
//
List<OrderSukses> ordersuksesFromJson(String jsonData){
  print("order sukses 2");
  final data = json.decode(jsonData);
  return List<OrderSukses>.from(data.map((item)=> OrderSukses.fromJson(item)));
}

String ordersuksesToJson(OrderSukses data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}