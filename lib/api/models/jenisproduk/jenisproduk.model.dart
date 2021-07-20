import 'dart:convert';

class JenisProduk {
  num idlokasi, idjenis_produk, harga, avail, diskon, harganett, min_sewa;
  String kapasitas, keterangan, gambar, nama_kota, nama_lokasi;

  JenisProduk(
      {this.idlokasi = 0,
      this.idjenis_produk = 0,
      this.harga = 0,
      this.kapasitas,
      this.keterangan,
      this.nama_kota,
      this.nama_lokasi,
      this.gambar,
      this.avail = 0,
      this.diskon,
      this.harganett,
      this.min_sewa});

  factory JenisProduk.fromJson(Map<String, dynamic> map) {
    return JenisProduk(
        idlokasi: map["idlokasi"],
        idjenis_produk: map["idjenis_produk"],
        harga: map["harga"],
        kapasitas: map["kapasitas"],
        keterangan: map["keterangan"],
        nama_kota: map["nama_kota"],
        nama_lokasi: map["nama_lokasi"],
        gambar: map["gambar"],
        avail: map["avail"],
        diskon: map['diskon'],
        harganett: map['harganett'],
        min_sewa: map['min_sewa']);
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
      "min_sewa": min_sewa
    };
  }

  @override
  String toString() {
    return 'JenisProduk{idlokasi: $idlokasi, idjenis_produk: $idjenis_produk, harga: $harga, kapasitas: $kapasitas, keterangan: $keterangan, nama_lokasi: $nama_lokasi, nama_kota: $nama_kota}, gambar: $gambar, avail: $avail, diskon: $diskon, harganett: $harganett, min_sewa: $min_sewa}';
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
