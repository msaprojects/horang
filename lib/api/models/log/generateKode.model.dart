import 'dart:convert';

class GenerateCode {
  int idtransaksi_det;
  String token, kode_aktivasi;
  
  GenerateCode(
      {this.idtransaksi_det,this.token,this.kode_aktivasi});

  factory GenerateCode.fromJson(Map<String, dynamic> map){
    return GenerateCode(
      idtransaksi_det: map['idtransaksi_detail'],
      token: map['token'],
      kode_aktivasi: map['kode_aktivasi']
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "idtransaksi_detail": idtransaksi_det,
      "token": token,
      // "kode_aktivasi": kode_aktivasi
    };
  }

  @override
  String toString() {
    return 'GenerateCode{idtransaksi_detail: $idtransaksi_det, token: $token, kode_aktivasi: $kode_aktivasi}';
    // return 'GenerateCode{kode_aktivasi: $kode_aktivasi}';
  }
}

List<GenerateCode> generateCodeFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<GenerateCode>.from(
      data.map((item) => GenerateCode.fromJson(item)));
}

String generateCodeToJson(GenerateCode data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
