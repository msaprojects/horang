import 'dart:convert';

class MystorageModel {
  int idtransaksi, idtransaksi_detail;
  var hari, jumlah_sewa;
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
      {
        required this.hari,
        required this.idtransaksi_detail,
        required this.idtransaksi,
        required this.tanggal_mulai,
        required this.tanggal_akhir,
        required this.noOrder,
        required this.tanggal_order,
        required this.kode_kontainer,
        required this.nama,
        required this.nama_kota,
        required this.nama_lokasi,
        required this.keterangan,
        required this.jumlah_sewa,
        required this.status,
        required this.flag_selesai,
        required this.selesai,
        required this.gambar
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
      jumlah_sewa: map['jumlah_sewa'],
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
      "jumlah_sewa": jumlah_sewa,
      "status": status,
      "flag_selesai": flag_selesai,
      "selesai": selesai,
      "gambar": gambar
    };
  }

  @override
  String toString() {
    return 'MystorageModel{hari: $hari, idtransaksi: $idtransaksi, idtransaksi_detail: $idtransaksi_detail, tanggal_mulai: $tanggal_mulai, tanggal_akhir: $tanggal_akhir, tanggal_order: $tanggal_order, no_order:$noOrder, kode_kontainer: $kode_kontainer, nama: $nama, nama_kota: $nama_kota, nama_lokasi: $nama_lokasi, keterangan: $keterangan, jumlah_sewa: $jumlah_sewa, status: $status, flag_selesai: $flag_selesai, selesai: $selesai, gambar: $gambar}';
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
