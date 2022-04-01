import 'dart:convert';

class JenisProduk {
  int avail, harganett, harga;
  num idlokasi, idjenis_produk, diskon, min_sewa, min_deposit;
  String kapasitas, keterangan, gambar, nama_kota, nama_lokasi;

  JenisProduk(
      {this.idlokasi = 0,
      this.idjenis_produk = 0,
      this.harga = 0,
        required  this.kapasitas,
        required this.keterangan,
        required this.nama_kota,
        required this.nama_lokasi,
        required this.gambar,
        this.avail = 0,
        required this.diskon,
        required this.harganett,
        required this.min_sewa,
        required this.min_deposit
      });

  factory JenisProduk.fromJson(Map<String, dynamic> map) {
    return JenisProduk(
        idlokasi: map["idlokasi"],
        idjenis_produk: map["idjenis_produk"],
        harga: map["harga"],
        kapasitas: map["kapasitas"].toString(),
        keterangan: map["keterangan"].toString(),
        nama_kota: map["nama_kota"].toString(),
        nama_lokasi: map["nama_lokasi"].toString(),
        gambar: map["gambar"].toString(),
        avail: map["avail"],
        diskon: map['diskon'],
        harganett: map['harganett'],
        min_sewa: map['min_sewa'],
        min_deposit: map['min_deposit']
        );
  }

  Map<String, dynamic> toJson() {
    return {
      "idlokasi": idlokasi,
      "idjenis_produk": idjenis_produk,
      "harga": harga,
      "kapasitas": kapasitas,
      "keterangan": keterangan,
      "nama_kota": nama_kota,
      "nama_lokasi": nama_lokasi,
      "gambar": gambar,
      "avail": avail,
      "diskon": diskon,
      "harganett": harganett,
      "min_sewa": min_sewa,
      "min_deposit": min_deposit
    };
  }

  @override
  String toString() {
    return 'JenisProduk{idlokasi: $idlokasi, idjenis_produk: $idjenis_produk, harga: $harga, kapasitas: $kapasitas, keterangan: $keterangan, nama_lokasi: $nama_lokasi, nama_kota: $nama_kota}, gambar: $gambar, avail: $avail, diskon: $diskon, harganett: $harganett, min_sewa: $min_sewa, min_deposit: $min_deposit}';
  }
}

List<JenisProduk> jenisprodukFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<JenisProduk>.from(data.map((item) => JenisProduk.fromJson(item)));
}

String jenisProdukToJson(JenisProduk data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
