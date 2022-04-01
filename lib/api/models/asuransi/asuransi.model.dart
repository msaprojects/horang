import 'dart:convert';

class AsuransiModel {
  num idasuransi=0, status=0;
  num nilai;
  String namaasuransi, perusahaan, alamat;

  AsuransiModel(
      {
        required this.idasuransi,
      required this.status,
      required this.nilai,
      required this.namaasuransi,
      required this.perusahaan,
      required this.alamat});

  factory AsuransiModel.fromJson(Map<String, dynamic> map){
    return AsuransiModel(
      idasuransi: map['idasuransi'],
      nilai: map['nilai'],
      namaasuransi: map['nama_asuransi'],
      perusahaan: map['perusahaan'],
      alamat: map['alamat'], status: map['status'],
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "idasuransi": idasuransi,
      "nilai": nilai,
      "nama_asuransi": namaasuransi,
      "perusahaan": perusahaan,
      "alamat": alamat,
    };
  }

  @override
  String toString() {
    return 'AsuransiModel{idasuransi: $idasuransi, status: $status, nilai: $nilai, nama_asuransi: $namaasuransi, perusahaan: $perusahaan, alamat: $alamat}';
  }
}


List<AsuransiModel> asuransiFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<AsuransiModel>.from(data.map((item) => AsuransiModel.fromJson(item)));
}

String asuransiToJson(AsuransiModel data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
