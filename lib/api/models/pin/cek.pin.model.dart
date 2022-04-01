import 'dart:convert';

class Pin_Model_Cek{
  String pin_cek, token_cek, notifikasi_token;

  Pin_Model_Cek({
    // this.pin,
    required this.notifikasi_token,
    required this.token_cek,
    required this.pin_cek
  });

  factory Pin_Model_Cek.fromJson(Map<String, dynamic> map){
    return Pin_Model_Cek(
      // pin: map['pin'],   
      notifikasi_token: map['notifikasi_token'],
      token_cek: map['token'],
      pin_cek: map['pin']
    );
  }
  Map<String, dynamic> toJson(){
    return{
      "notifikasi_token": notifikasi_token,
      "pin": pin_cek,
      "token": token_cek
    };
  }

  @override
  String toString(){
    // return 'Pengguna{pin: $pin, token: $token, pinlama: $pinlama, pinbaru: $pinbaru}';
    return 'Pengguna{token: $token_cek, pin: $pin_cek, notifikasi_token: $notifikasi_token}';
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