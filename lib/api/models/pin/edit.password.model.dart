import 'dart:convert';

class Password{
  String token, passwordlama, passwordbaru;

  Password({
    // this.pin,
    this.token,
    this.passwordlama,
    this.passwordbaru
  });

  factory Password.fromJson(Map<String, dynamic> map){
    return Password(
      // pin: map['pin'],   
      token: map['token'],
      passwordlama: map['passwordlama'],
      passwordbaru: map['passwordbaru']
    );
  }
  Map<String, dynamic> toJson(){
    return{
      "token": token,
      "passwordlama": passwordlama,
      "passwordbaru": passwordbaru
    };
  }

  @override
  String toString(){
    return 'Pengguna{token: $token, passwordlama: $passwordlama, passwordbaru: $passwordbaru}';
  }

}

List<Password> PasswordFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<Password>.from(data.map((item) => Password.fromJson(item)));
}

String PasswordToJson(Password data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}