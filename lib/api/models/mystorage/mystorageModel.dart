import 'dart:convert';

class MystorageModel {
  int hari, idtransaksi_detail;
  String tanggal_mulai,
      tanggal_akhir,
      tanggal_order,
      kode_kontainer,
      nama,
      nama_kota,
      nama_lokasi,
      keterangan,
      status;

  MystorageModel(
      {this.hari,
      this.idtransaksi_detail,
      this.tanggal_mulai,
      this.tanggal_akhir,
      this.tanggal_order,
      this.kode_kontainer,
      this.nama,
      this.nama_kota,
      this.nama_lokasi,
      this.keterangan,
      this.status});

  factory MystorageModel.fromJson(Map<String, dynamic> map){
    return MystorageModel(
      hari: map['hari'],
      idtransaksi_detail: map['idtransaksi_detail'],
      tanggal_mulai: map['tanggal_mulai'],
      tanggal_akhir: map['tanggal_akhir'],
      tanggal_order: map['tanggal_order'],
      kode_kontainer: map['kode_kontainer'],
      nama: map['nama'],
      nama_kota: map['nama_kota'],
      nama_lokasi: map['nama_lokasi'],
      keterangan: map['keterangan'],
      status: map['status']
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "hari": hari,
      "idtransaksi_detail": idtransaksi_detail,
      "tanggal_mulai": tanggal_mulai,
      "tanggal_akhir": tanggal_akhir,
      "tanggal_order": tanggal_order,
      "kode_kontainer": kode_kontainer,
      "nama": nama,
      "nama_kota": nama_kota,
      "nama_lokasi": nama_lokasi,
      "keterangan": keterangan,
      "status": status
    };
  }

  @override
  String toString() {
    return 'MystorageModel{hari: $hari, idtransaksi_detail: $idtransaksi_detail, tanggal_mulai: $tanggal_mulai, tanggal_akhir: $tanggal_akhir, tanggal_order: $tanggal_order, kode_kontainer: $kode_kontainer, nama: $nama, nama_kota: $nama_kota, nama_lokasi: $nama_lokasi, keterangan: $keterangan, status: $status}';
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
