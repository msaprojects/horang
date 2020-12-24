import 'dart:convert';

class AsuransiModel {
  num idasuransi, status;
  num nilai;
  String namaasuransi, perusahaan, alamat;

  AsuransiModel(
      {this.idasuransi,
      this.status,
      this.nilai,
      this.namaasuransi,
      this.perusahaan,
      this.alamat});

  factory AsuransiModel.fromJson(Map<String, dynamic> map){
    return AsuransiModel(
      idasuransi: map['idasuransi'],
      nilai: map['nilai'],
      namaasuransi: map['nama_asuransi'],
      perusahaan: map['perusahaan'],
      alamat: map['alamat'],
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
