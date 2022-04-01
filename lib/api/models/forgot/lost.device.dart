import 'dart:convert';

// ignore: camel_case_types
class LostDevices{
  String email, uuid;

  LostDevices({
    required this.email,
    required this.uuid
  });

  factory LostDevices.fromJson(Map<dynamic, dynamic> map){
    return LostDevices(
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
    return 'Forgot_Password{email: $email , uuid: $uuid}';
  }
}

List<LostDevices> LostDeviceFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<LostDevices>.from(data.map((item) => LostDevices.fromJson(item)));
}

// ignore: non_constant_identifier_names
String LostDeviceToJson(LostDevices data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}