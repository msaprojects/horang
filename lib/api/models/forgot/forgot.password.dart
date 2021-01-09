import 'dart:convert';

// ignore: camel_case_types
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

// ignore: non_constant_identifier_names
List<Forgot_Password> ForgotPassFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<Forgot_Password>.from(data.map((item) => Forgot_Password.fromJson(item)));
}

// ignore: non_constant_identifier_names
String ForgotPassToJson(Forgot_Password data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}