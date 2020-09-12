import 'dart:convert';

class OrderSukses{
  int idorder, idpembayaran, idpayment_gateway, idproduk, jumlah_sewa;
  int total_harga, nominal, harga;
  String no_order, keterangan, kode_refrensi, nama_provider, kode_kontainer;

  OrderSukses({
    this.idorder = 0,
    this.idpembayaran = 0,
    this.idpayment_gateway = 0,
    this.idproduk = 0,
    this.jumlah_sewa = 0,
    this.total_harga = 0,
    this.nominal = 0,
    this.no_order,
    this.keterangan,
    this.harga,
    this.kode_kontainer,
    this.kode_refrensi,
    this.nama_provider
  });

  factory OrderSukses.fromJson(Map<String, dynamic> map){
    return OrderSukses(
      idorder: map["idorder"],
      idpembayaran: map["idpembayaran"],
      idpayment_gateway: map["idpayment_gateway"],
      idproduk: map["idproduk"],
      jumlah_sewa: map["jumlah_sewa"],
      total_harga: map["total_harga"],
      nominal: map["nominal"],
      no_order: map["no_order"],
      keterangan: map["keterangan"],
      harga: int.parse(map["harga"]),
      kode_kontainer: map["kode_kontainer"],
      kode_refrensi: map["kode_refrensi"],
      nama_provider: map["nama_provider"]
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "idorder": idorder,
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
      "nama_provider": nama_provider
    };
  }

  @override
  String  toString(){
    return 'OrderSukses{idorder: $idorder, idpembayaran: $idpembayaran, idpayment_gateway: $idpayment_gateway, idproduk: $idproduk, jumlah_sewa: $jumlah_sewa, total_harga: $total_harga, nominal: $nominal, no_order: $no_order, keterangan: $keterangan, harga: $harga, kode_kontainer: $kode_kontainer, kode_refrensi: $kode_refrensi, nama_provider: $nama_provider}';
  }

}
//
List<OrderSukses> ordersuksesFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<OrderSukses>.from(data.map((item)=> OrderSukses.fromJson(item)));
}

String ordersuksesToJson(OrderSukses data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}