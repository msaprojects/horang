import 'dart:convert';

class selesaiLog{

  int idorder;
  String token;

  selesaiLog({
    this.idorder = 0,
    this.token,
  });

  factory selesaiLog.fromJson(Map<String, dynamic> map){
    return selesaiLog(
      idorder: map["idorder"],
      token: map["token"]
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "idorder": idorder,
      "token": token
    };
  }

  @override
  String toString(){
    return 'log{idorder: $idorder, token: $token}';
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