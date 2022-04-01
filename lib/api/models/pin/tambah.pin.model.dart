import 'dart:convert';

class TambahPin_model{
  String pin, token;

  TambahPin_model({
    required this.pin,
    required this.token,
  });

  factory TambahPin_model.fromJson(Map<String, dynamic> map){
    return TambahPin_model(
      pin: map['pin'],   
      token: map['token'],
    );
  }
  Map<String, dynamic> toJson(){
    return{
      "pin": pin,
      "token": token
    };
  }

  @override
  String toString(){
    return 'Pengguna{pin: $pin, token: $token}';
  }

}

List<TambahPin_model> TambahPinFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<TambahPin_model>.from(data.map((item) => TambahPin_model.fromJson(item)));
}

String TambahPinToJson(TambahPin_model data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}