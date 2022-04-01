import 'dart:convert';

class LogOpen{

  num idtransaksi_detail;
  String token;

  LogOpen({
    this.idtransaksi_detail = 0,
    required this.token,
  });

  factory LogOpen.fromJson(Map<String, dynamic> map){
    return LogOpen(
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

List<LogOpen> LogOpenFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<LogOpen>.from(data.map((item) => LogOpen.fromJson(item)));
}

String LogOpenToJson(LogOpen data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}