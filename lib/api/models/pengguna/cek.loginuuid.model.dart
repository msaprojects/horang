import 'dart:convert';

class CekLoginUUID {
  String uuid;
  
  CekLoginUUID(
      {this.uuid});

  factory CekLoginUUID.fromJson(Map<String, dynamic> map){
    return CekLoginUUID(
      uuid: map['uuid'],
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "uuid": uuid,
    };
  }

  @override
  String toString() {
    return 'CekLoginUUID{uuid: $uuid}';
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
