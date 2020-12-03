import 'dart:convert';

// int parseIntFromMap(Map map, String key, [int defVal = 0]) {
//     if (map == null) return defVal;
//     if (!map.containsKey(key)) return defVal;

//     if (map[key] is String) {
//       if (int.tryParse(map[key]) == null) {
//         if (double.tryParse(map[key]) == null) {
//           return defVal;
//         } else {
//           return double.tryParse(map[key]).toInt();
//         }
//       } else {
//         return int.tryParse(map[key]);
//       }
//     } else if (map[key] is int) {
//       return map[key];
//     } else if (map[key] is double) {
//       return map[key].toInt();
//     } else if (map[key] is bool) {
//       return map[key] ? 1 : 0;
//     }

//     return defVal;
//   }

class HistoryModel {
  // int total_harga;
  num total_harga;
  int harga, jumlah_sewa;
  String no_order,
      kode_refrensi,
      kode_kontainer,
      nama_provider,
      tanggal_order,
      tanggal_mulai,
      tanggal_akhir;

  HistoryModel(
      {this.no_order,
      this.kode_refrensi,
      this.kode_kontainer,
      this.nama_provider,
      this.total_harga,
      this.jumlah_sewa,
      this.harga,
      this.tanggal_order,
      this.tanggal_mulai,
      this.tanggal_akhir});

  factory HistoryModel.fromJson(Map<String, dynamic> map) {
    return HistoryModel(
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
        tanggal_akhir: map['tanggal_akhir']);
  }
  Map<String, dynamic> toJson() {
    return {
      "no_order": no_order,
      "kode_refrensi": kode_refrensi,
      "kode_kontainer": kode_kontainer,
      "nama_provider": nama_provider,
      "total_harga": total_harga,
      "jumlah_sewa": jumlah_sewa,
      "harga": harga,
      "tanggal_order": tanggal_order,
      "tanggal_mulai": tanggal_mulai,
      "tanggal_akhir": tanggal_akhir
    };
  }

  @override
  String toString() {
    return 'HistoryModel{no_order: $no_order, kode_refrensi: $kode_refrensi, kode_kontainer: $kode_kontainer, nama_provider: $nama_provider, total_harga: $total_harga, jumlah_sewa: $jumlah_sewa, harga: $harga, tanggal_order: $tanggal_order, tanggal_mulai: $tanggal_mulai, tanggal_akhir: $tanggal_akhir}';
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
