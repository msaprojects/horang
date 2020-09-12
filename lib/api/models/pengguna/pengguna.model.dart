import 'dart:convert';

class Pengguna{

  int idpengguna, status;
  String email, no_hp, password, notification_token, token_mail;

  Pengguna({
    this.idpengguna = 0,
    this.status = 0,
    this.email,
    this.no_hp,
    this.password,
    this.notification_token,
    this.token_mail
  });

  factory Pengguna.fromJson(Map<String, dynamic> map){
    return Pengguna(
      idpengguna: map["idpengguna"],
      status: map["status"],
      email: map["email"],
      no_hp: map["no_hp"],
      password: map["password"],
      notification_token: map["notification_token"],
      token_mail: map["token_mail"]
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "idpengguna": idpengguna,
      "status": status,
      "email": email,
      "no_hp": no_hp,
      "password": password,
      "notification_token": notification_token,
      "token_mail": token_mail
      };
  }
}

  List<Pengguna> penggunaFromJson(String jsonData){
    final data = json.decode(jsonData);
    return List<Pengguna>.from(data.map((item) => Pengguna.fromJson(item)));
  }

  String penggunaToJson(Pengguna data){
    final jsonData = data.toJson();
    return json.encode(jsonData);
  }