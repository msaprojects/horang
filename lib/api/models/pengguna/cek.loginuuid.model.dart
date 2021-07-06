import 'dart:convert';

class CekLoginUUID {
  String uuid, email;
  
  CekLoginUUID(
      {this.uuid, this.email});

  factory CekLoginUUID.fromJson(Map<String, dynamic> map){
    return CekLoginUUID(
      uuid: map['uuid'],
      email: map['email']
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "uuid": uuid,
    };
  }

  @override
  String toString() {
    return 'CekLoginUUID{uuid: $uuid, email: $email}';
  }
}

List<CekLoginUUID> cekLoginUUIDFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<CekLoginUUID>.from(
      data.map((item) => CekLoginUUID.fromJson(item)));
}

String cekLoginUUIDCodeToJson(CekLoginUUID data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
