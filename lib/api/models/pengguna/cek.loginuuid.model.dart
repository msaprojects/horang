import 'dart:convert';

class CekLoginUUID {
  String uuid, email, status;
  
  CekLoginUUID(
      {required this.uuid,required  this.email,required  this.status});

  factory CekLoginUUID.fromJson(Map<String, dynamic> map){
    return CekLoginUUID(
      uuid: map['uuid'],
      email: map['email'],
      status: map['status']
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "uuid": uuid,
    };
  }

  @override
  String toString() {
    return 'CekLoginUUID{uuid: $uuid, email: $email, status: $status}';
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
