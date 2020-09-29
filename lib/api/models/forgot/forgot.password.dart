import 'dart:convert';

class Forgot_Password{
  String email;

  Forgot_Password({
    this.email
  });

  factory Forgot_Password.fromJson(Map<String, dynamic> map){
    return Forgot_Password(
      email: map['email']
    );
  }
  Map<String, dynamic> toJson(){
    return{
      "email": email
    };
  }

  @override
  String toString(){
    return 'Pengguna{email: $email}';
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