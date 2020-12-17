import 'dart:convert';

class KomboKota{

  num idkota;
  String nama_kota, keterangan, provinsi;

  KomboKota({
    this.idkota = 0,
    this.provinsi,
    this.keterangan,
    this.nama_kota,
  });

  factory KomboKota.fromJson(Map<String, dynamic> map){
    return KomboKota(
      idkota: map["idkota"],
      nama_kota: map["nama_kota"],
      keterangan: map["keterangan"],
      provinsi: map["provinsi"],
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "idlokasi": idkota,
      "nama_kota": nama_kota,
      "keterangan": keterangan,
      "provinsi": provinsi
    };
  }

  @override
  String toString(){
    return 'KomboKota{idkota: $idkota, nama_kota: $nama_kota, keterangan: $keterangan, provinsi: $provinsi}';
  }

}

List<KomboKota> komboKotaFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<KomboKota>.from(data.map((item) => KomboKota.fromJson(item)));
}

String komboKotaToJson(KomboKota data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}