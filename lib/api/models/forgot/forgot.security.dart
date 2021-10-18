import 'dart:convert';

// ignore: camel_case_types
class Forgot_Security {
  String email;

  Forgot_Security({this.email});

  factory Forgot_Security.fromJson(Map<String, dynamic> map) {
    return Forgot_Security(email: map['email']);
  }
  Map<String, dynamic> toJson() {
    return {"email": email};
  }

  @override
  String toString() {
    return 'Forgot_Password{email: $email}';
    // , uuid: $uuid}';
  }
}

// ignore: non_constant_identifier_names
List<Forgot_Security> Forgot_SecurityFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Forgot_Security>.from(
      data.map((item) => Forgot_Security.fromJson(item)));
}

// ignore: non_constant_identifier_names
String Forgot_SecurityToJson(Forgot_Security data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
