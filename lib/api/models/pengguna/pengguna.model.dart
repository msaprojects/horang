import 'dart:convert';

class PenggunaModel {
  int idpengguna, status;
  String uuid,
      email,
      no_hp,
      password,
      notification_token,
      token_mail,
      keterangan;

  PenggunaModel(
      {required this.uuid,
      this.idpengguna = 0,
      this.status = 0,
        required this.email,
        required this.no_hp,
        required this.password,
        required this.notification_token,
        required this.token_mail,
        required this.keterangan});

  factory PenggunaModel.fromJson(Map<dynamic, dynamic> map) {
    return PenggunaModel(
        idpengguna: map["idpengguna"],
        uuid: map["uuid"],
        status: map["status"],
        email: map["email"],
        no_hp: map["no_hp"],
        password: map["password"],
        notification_token: map["notification_token"],
        token_mail: map["token_mail"],
        keterangan: map["keterangan"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "idpengguna": idpengguna,
      "uuid": uuid,
      "status": status,
      "email": email,
      "no_hp": no_hp,
      "password": password,
      "notification_token": notification_token,
      "token_mail": token_mail,
      "keterangan": keterangan,
    };
  }

  @override
  String toString() {
    return 'PenggunaModel{idpengguna: $idpengguna, status: $status, uuid: $uuid, email: $email, no_hp: $no_hp, password: $password, notification_token: $notification_token, token_mail: $token_mail, keterangan: $keterangan}';
  }
}

List<PenggunaModel> penggunaFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<PenggunaModel>.from(
      data.map((item) => PenggunaModel.fromJson(item)));
}

String penggunaToJson(PenggunaModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
