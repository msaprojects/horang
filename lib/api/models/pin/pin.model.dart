import 'dart:convert';

class Pin_Model{
  late String pin, token, pinlama, pinbaru;

  Pin_Model({
    // this.pin,
    required this.token,
    required this.pinlama,
    required this.pinbaru
  });

  factory Pin_Model.fromJson(Map<String, dynamic> map){
    return Pin_Model(
      // pin: map['pin'],   
      token: map['token'],
      pinlama: map['pinlama'],
      pinbaru: map['pinbaru']
    );
  }
  Map<String, dynamic> toJson(){
    return{
      // "pin": pin,
      "token": token,
      "pinlama": pinlama,
      "pinbaru": pinbaru
    };
  }

  @override
  String toString(){
    // return 'Pengguna{pin: $pin, token: $token, pinlama: $pinlama, pinbaru: $pinbaru}';
    return 'Pengguna{token: $token, pinlama: $pinlama, pinbaru: $pinbaru}';
  }

}

List<Pin_Model> PinFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<Pin_Model>.from(data.map((item) => Pin_Model.fromJson(item)));
}

String PinToJson(Pin_Model data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}