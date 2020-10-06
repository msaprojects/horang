import 'dart:convert';

class selesaiLog{

  int idtransaksi;
  String token;

  selesaiLog({
    this.idtransaksi = 0,
    this.token,
  });

  factory selesaiLog.fromJson(Map<String, dynamic> map){
    return selesaiLog(
      idtransaksi: map["idtransaksi"],
      token: map["token"]
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "idtransaksi": idtransaksi,
      "token": token
    };
  }

  @override
  String toString(){
    return 'log{idorder: $idtransaksi, token: $token}';
  }

}

List<selesaiLog> selesaiLogFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<selesaiLog>.from(data.map((item) => selesaiLog.fromJson(item)));
}

String selesaiLogToJson(selesaiLog data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}