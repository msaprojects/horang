import 'dart:convert';

class MystorageModel {
  int hari;
  String kode_kontainer, nama, nama_kota, tanggal_order, aktif;

  MystorageModel(
      {this.kode_kontainer,
      this.nama,
      this.nama_kota,
      this.tanggal_order,
      this.hari,
      this.aktif});

  factory MystorageModel.fromJson(Map<String, dynamic> map) {
    return MystorageModel(
        kode_kontainer: map["kode_kontainer"],
        nama: map["nama"],
        nama_kota: map["nama_kota"],
        tanggal_order: map["tanggal_order"],
        hari: map["hari"],
        aktif: map["AKTIF"]);
  }
  Map<String, dynamic> toJson() {
    return {
      "kode_kontainer": kode_kontainer,
      "nama": nama,
      "nama_kota": nama_kota,
      "tanggal_order": tanggal_order,
      "hari": hari,
      "AKTIF": aktif
    };
  }

  @override
  String toString() {
    return 'Mystorage{kode_kontainer: $kode_kontainer,'
        'nama: $nama,'
        'nama_kota: $nama_kota,'
        'tanggal_order: $tanggal_order,'
        'hari: $hari,'
        'AKTIF: $aktif}';
  }
}

List<MystorageModel> mystorageFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<MystorageModel>.from(
      data.map((item) => MystorageModel.fromJson(item)));
}

String mystorageToJson(MystorageModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
