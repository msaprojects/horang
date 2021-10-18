import 'dart:convert';

class GenerateCode {
  var kode_aktivasi;
  
  GenerateCode(
      {this.kode_aktivasi});
  factory GenerateCode.fromJson(Map<String, dynamic> map){
    return GenerateCode(
      kode_aktivasi: map['kode_aktivasi']
    );
  }

  @override
  String toString() {
    // return 'Generatekode_aktivasi: $kode_aktivasi';
    return 'GenerateCode{kode_aktivasi: $kode_aktivasi}';
  }
}

List<GenerateCode> generateCodeFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<GenerateCode>.from(data.map((item) => GenerateCode.fromJson(item)));
  // return List<GenerateCode>.from(data);
}