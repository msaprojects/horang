import 'dart:convert';

class PostProdukModel {
  int idlokasi;
  String token, tanggalawal, tanggalakhir, jenisitem;

  PostProdukModel(
      {this.token, this.tanggalawal, this.tanggalakhir, this.idlokasi = 0, this.jenisitem});

  factory PostProdukModel.fromJson(Map<String, dynamic> map) {
    return PostProdukModel(
        token: map["token"],
        tanggalawal: map['tanggal_mulai'],
        tanggalakhir: map['tanggal_akhir'],
        idlokasi: map['idlokasi'],
        jenisitem: map['jenisitem']
        );
  }

  Map<String, dynamic> toJson() {
    return {
      "token": token,
      "tanggal_mulai": tanggalawal,
      "tanggal_akhir": tanggalakhir,
      "idlokasi": idlokasi,
      "jenisitem": jenisitem,
    };
  }

  @override
  String toString() {
    return 'PostProdukModel{token: $token, tanggal_mulai: $tanggalawal, tanggal_akhir:$tanggalakhir, idlokasi:$idlokasi, jenisitem:$jenisitem}';
  }
}

List<PostProdukModel> PostProdukModelFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<PostProdukModel>.from(
      data.map((item) => PostProdukModel.fromJson(item)));
}

String PostProdukModelToJson(PostProdukModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
