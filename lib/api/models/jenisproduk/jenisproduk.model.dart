import 'dart:convert';

class JenisProduk{

  int idlokasi, idjenis_produk, harga;
  String kapasitas, keterangan, gambar, nama_kota, nama_lokasi;

  JenisProduk({
    this.idlokasi = 0,
    this.idjenis_produk = 0,
    this.harga = 0,
    this.kapasitas,
    this.keterangan,
    this.nama_kota,
    this.nama_lokasi
  });

  factory JenisProduk.fromJson(Map<String, dynamic> map){
    return JenisProduk(
      idlokasi: map["idlokasi"],
      idjenis_produk: map["idjenis_produk"],
      harga: map["harga"],
      kapasitas: map["kapasitas"],
      keterangan: map["keterangan"],
      nama_kota: map["nama_kota"],
      nama_lokasi: map["nama_lokasi"]
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "idlokasi": idlokasi,
      "idjenis_produk": idjenis_produk,
      "harga": harga,
      "kapasitas": kapasitas,
      "keterangan": keterangan,
      "nama_kota": nama_kota,
      "nama_lokasi": nama_lokasi
    };
  }

  @override
  String toString(){
    return 'JenisProduk{idlokasi: $idlokasi, idjenis_produk: $idjenis_produk, harga: $harga, kapasitas: $kapasitas, keterangan: $keterangan, nama_lokasi: $nama_lokasi, nama_kota: $nama_kota}';
  }

}

List<JenisProduk> jenisprodukFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<JenisProduk>.from(data.map((item) => JenisProduk.fromJson(item)));
}

String jenisProdukToJson(JenisProduk data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}