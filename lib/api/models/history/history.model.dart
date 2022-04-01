import 'dart:convert';

class HistoryModel {
  int flag_bayar;
  num total_harga;
  num harga, jumlah_sewa;
  String no_order,
      kode_refrensi,
      kode_kontainer,
      nama_provider,
      tanggal_order,
      tanggal_mulai,
      tanggal_akhir,
      waktu_bayar,
      nama_lokasi,
      nama;

  HistoryModel(
      {
        required this.flag_bayar,
        required this.no_order,
        required this.kode_refrensi,
        required this.kode_kontainer,
        required this.nama_provider,
        required this.total_harga,
        required this.jumlah_sewa,
        required this.harga,
        required this.tanggal_order,
        required this.tanggal_mulai,
        required this.tanggal_akhir,
        required this.waktu_bayar,
        required this.nama_lokasi,
        required this.nama
      });

  factory HistoryModel.fromJson(Map<String, dynamic> map) {
    return HistoryModel(
      flag_bayar: map['flag_bayar'],
        no_order: map['no_order'],
        kode_refrensi: map['kode_refrensi'],
        kode_kontainer: map['kode_kontainer'],
        nama_provider: map['nama_provider'],
        // total_harga: parseIntFromMap(map, 'total_harga'),
        total_harga: (map['total_harga'] as num).toInt(),
        jumlah_sewa: map['jumlah_sewa'],
        harga: map['harga'],
        tanggal_order: map['tanggal_order'],
        tanggal_mulai: map['tanggal_mulai'],
        tanggal_akhir: map['tanggal_akhir'],
        waktu_bayar: map['waktu_bayar'].toString(),
        nama_lokasi: map['nama_lokasi'],
        nama: map['nama'],
        );
  }
  Map<String, dynamic> toJson() {
    return {
      "flag_bayar": flag_bayar,
      "no_order": no_order,
      "kode_refrensi": kode_refrensi,
      "kode_kontainer": kode_kontainer,
      "nama_provider": nama_provider,
      "total_harga": total_harga,
      "jumlah_sewa": jumlah_sewa,
      "harga": harga,
      "tanggal_order": tanggal_order,
      "tanggal_mulai": tanggal_mulai,
      "tanggal_akhir": tanggal_akhir,
      "waktu_bayar": waktu_bayar,
      "nama_lokasi": nama_lokasi,
      "nama": nama
    };
  }

  @override
  String toString() {
    return 'HistoryModel{flag_bayar: $flag_bayar ,no_order: $no_order, kode_refrensi: $kode_refrensi, kode_kontainer: $kode_kontainer, nama_provider: $nama_provider, total_harga: $total_harga, jumlah_sewa: $jumlah_sewa, harga: $harga, tanggal_order: $tanggal_order, tanggal_mulai: $tanggal_mulai, tanggal_akhir: $tanggal_akhir, waktu_bayar: $waktu_bayar, nama_lokasi: $nama_lokasi, nama: $nama}';
  }
}

List<HistoryModel> HistoryFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<HistoryModel>.from(
      data.map((item) => HistoryModel.fromJson(item)));
}

String HistoryToJson(HistoryModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
