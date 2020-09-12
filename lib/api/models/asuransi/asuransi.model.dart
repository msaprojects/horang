import 'dart:convert';

class AsuransiModel {
  int idasuransi, status;
  double nilai;
  String nama_asuransi, perusahaan, alamat;

  AsuransiModel(
      {this.idasuransi,
      this.status,
      this.nilai,
      this.nama_asuransi,
      this.perusahaan,
      this.alamat});

  factory AsuransiModel.fromJson(Map<String, dynamic> map){
    return AsuransiModel(
      idasuransi: map['idasuransi'],
      nilai: map['nilai'],
      nama_asuransi: map['nama_asuransi'],
      perusahaan: map['perusahaan'],
      alamat: map['alamat'],
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "idasuransi": idasuransi,
      "nilai": nilai,
      "nama_asuransi": nama_asuransi,
      "perusahaan": perusahaan,
      "alamat": alamat,
    };
  }

  @override
  String toString() {
    return 'AsuransiModel{idasuransi: $idasuransi, status: $status, nilai: $nilai, nama_asuransi: $nama_asuransi, perusahaan: $perusahaan, alamat: $alamat}';
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
