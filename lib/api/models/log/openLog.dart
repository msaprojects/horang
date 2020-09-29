import 'dart:convert';

class LogOpen{

  int iddetail_order;
  String token;

  LogOpen({
    this.iddetail_order = 0,
    this.token,
  });

  factory LogOpen.fromJson(Map<String, dynamic> map){
    return LogOpen(
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

List<LogOpen> LogOpenFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<LogOpen>.from(data.map((item) => LogOpen.fromJson(item)));
}

String LogOpenToJson(LogOpen data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}