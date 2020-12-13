import 'dart:convert';

class Pin_Model_Cek{
  String pin_cek, token_cek, token_notifikasi;

  Pin_Model_Cek({
    // this.pin,
    this.token_notifikasi,
    this.token_cek,
    this.pin_cek
  });

  factory Pin_Model_Cek.fromJson(Map<String, dynamic> map){
    return Pin_Model_Cek(
      // pin: map['pin'],   
      token_notifikasi: map['token_notifikasi'],
      token_cek: map['token'],
      pin_cek: map['pin']
    );
  }
  Map<String, dynamic> toJson(){
    return{
      "token_notifikasi": token_notifikasi,
      "pin": pin_cek,
      "token": token_cek
    };
  }

  @override
  String toString(){
    // return 'Pengguna{pin: $pin, token: $token, pinlama: $pinlama, pinbaru: $pinbaru}';
    return 'Pengguna{token: $token_cek, pin: $pin_cek, token_notifikasi: $token_notifikasi}';
  }

}

List<Pin_Model_Cek> PinCekFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<Pin_Model_Cek>.from(data.map((item) => Pin_Model_Cek.fromJson(item)));
}

String PinCekToJson(Pin_Model_Cek data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}