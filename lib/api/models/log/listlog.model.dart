import 'dart:convert';

class LogList{
  late String token, timestamp, status, idtransaksi_detail;

  LogList({
    required this.timestamp,
    required this.status,
    // this.token,
    // this.idtransaksi_detail
  });

  factory LogList.fromJson(Map<String, dynamic> map){
    return LogList(
      timestamp: map["timestamp"],
      status: map["status"],
      // token: map["token"],
      // idtransaksi_detail: map["idtransaksi_detail"]
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "timestamp": timestamp,
      "status": status,
      // "token": token,
      // "idtransaksi_detail": idtransaksi_detail
    };
  }

  @override
  String toString(){
    // return 'log{timestamp: $timestamp, status: $status, token: $token, idtransaksi_detail: $idtransaksi_detail}';
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