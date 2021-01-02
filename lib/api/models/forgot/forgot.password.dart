import 'dart:convert';

class Forgot_Password{
  String email, uuid;

  Forgot_Password({
    this.email,
    this.uuid
  });

  factory Forgot_Password.fromJson(Map<String, dynamic> map){
    return Forgot_Password(
      email: map['email'],
        uuid: map['uuid']
    );
  }
  Map<String, dynamic> toJson(){
    return{
      "email": email,
      "uuid": uuid
    };
  }
  @override
  String toString() {
    return 'Forgot_Password{email: $email, uuid: $uuid}';
  }
}

List<Forgot_Password> ForgotPassFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<Forgot_Password>.from(data.map((item) => Forgot_Password.fromJson(item)));
}

String ForgotPassToJson(Forgot_Password data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}