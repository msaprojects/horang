import 'dart:convert';

class Logs{

  int iddetail_order;
  String token;

  Logs({
    this.iddetail_order = 0,
    this.token,
  });

  factory Logs.fromJson(Map<String, dynamic> map){
    return Logs(
      iddetail_order: map["iddetail_order"],
      token: map["token"]
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "iddetail_order": iddetail_order,
      "token": token
    };
  }

  @override
  String toString(){
    return 'log{iddetail_order: $iddetail_order, token: $token}';
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