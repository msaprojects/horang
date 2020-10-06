import 'dart:convert';

class Logs{

  int idtransaksi_detail;
  String token;

  Logs({
    this.idtransaksi_detail = 0,
    this.token,
  });

  factory Logs.fromJson(Map<String, dynamic> map){
    return Logs(
      idtransaksi_detail: map["idtransaksi_detail"],
      token: map["token"]
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "idtransaksi_detail": idtransaksi_detail,
      "token": token
    };
  }

  @override
  String toString(){
    return 'log{idtransaksi_detail: $idtransaksi_detail, token: $token}';
  }

}

List<Logs> LogsFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<Logs>.from(data.map((item) => Logs.fromJson(item)));
}

String LogsToJson(Logs data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}