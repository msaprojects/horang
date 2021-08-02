import 'dart:convert';

class MystorageModel {
  num hari, idtransaksi_detail, idtransaksi;
  int flag_selesai = 0, selesai=0;
  String tanggal_mulai,
      tanggal_akhir,
      tanggal_order,
      noOrder,
      kode_kontainer,
      nama,
      nama_kota,
      nama_lokasi,
      keterangan,
      status,
      gambar;

  MystorageModel(
      {this.hari,
      this.idtransaksi_detail,
      this.idtransaksi,
      this.tanggal_mulai,
      this.tanggal_akhir,
      this.noOrder,
      this.tanggal_order,
      this.kode_kontainer,
      this.nama,
      this.nama_kota,
      this.nama_lokasi,
      this.keterangan,
      this.status,
      this.flag_selesai,
      this.selesai,
      this.gambar
      });

  factory MystorageModel.fromJson(Map<String, dynamic> map){
    return MystorageModel(
      hari: map['hari'],
      idtransaksi: map['idtransaksi'],
      idtransaksi_detail: map['idtransaksi_detail'],
      tanggal_mulai: map['tanggal_mulai'],
      tanggal_akhir: map['tanggal_akhir'],
      tanggal_order: map['tanggal_order'],
      noOrder: map['no_order'],
      kode_kontainer: map['kode_kontainer'],
      nama: map['nama'],
      nama_kota: map['nama_kota'],
      nama_lokasi: map['nama_lokasi'],
      keterangan: map['keterangan'],
      status: map['status'],
      flag_selesai: map['flag_selesai'],
      selesai: map['selesai'],
      gambar: map['gambar']
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "hari": hari,
      "idtransaksi_detail": idtransaksi_detail,
      "idtransaksi": idtransaksi,
      "tanggal_mulai": tanggal_mulai,
      "tanggal_akhir": tanggal_akhir,
      "tanggal_order": tanggal_order,
      "no_order": noOrder,
      "kode_kontainer": kode_kontainer,
      "nama": nama,
      "nama_kota": nama_kota,
      "nama_lokasi": nama_lokasi,
      "keterangan": keterangan,
      "status": status,
      "flag_selesai": flag_selesai,
      "selesai": selesai,
      "gambar": gambar
    };
  }

  @override
  String toString() {
    return 'MystorageModel{hari: $hari, idtransaksi: $idtransaksi, idtransaksi_detail: $idtransaksi_detail, tanggal_mulai: $tanggal_mulai, tanggal_akhir: $tanggal_akhir, tanggal_order: $tanggal_order, no_order:$noOrder, kode_kontainer: $kode_kontainer, nama: $nama, nama_kota: $nama_kota, nama_lokasi: $nama_lokasi, keterangan: $keterangan, status: $status, flag_selesai: $flag_selesai, selesai: $selesai, gambar: $gambar}';
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
