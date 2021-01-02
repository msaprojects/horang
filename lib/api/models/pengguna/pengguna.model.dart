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
      {this.uuid,
      this.idpengguna = 0,
      this.status = 0,
      this.email,
      this.no_hp,
      this.password,
      this.notification_token,
      this.token_mail,
      this.keterangan});

  factory PenggunaModel.fromJson(Map<String, dynamic> map) {
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
