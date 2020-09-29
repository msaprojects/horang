import 'dart:convert';

class LogList{
  String token, timestamp, status, iddetail_order;

  LogList({
    this.timestamp,
    this.status,
    // this.token,
    // this.iddetail_order
  });

  factory LogList.fromJson(Map<String, dynamic> map){
    return LogList(
      timestamp: map["timestamp"],
      status: map["status"],
      // token: map["token"],
      // iddetail_order: map["iddetail_order"]
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "timestamp": timestamp,
      "status": status,
      // "token": token,
      // "iddetail_order": iddetail_order
    };
  }

  @override
  String toString(){
    // return 'log{timestamp: $timestamp, status: $status, token: $token, iddetail_order: $iddetail_order}';
    return 'log{timestamp: $timestamp, status: $status}';
  }

}

List<LogList> LoglistFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<LogList>.from(data.map((item) => LogList.fromJson(item)));
}

String LoglistToJson(LogList data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}