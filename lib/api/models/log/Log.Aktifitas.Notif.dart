import 'dart:convert';

class LogAktifitasNotif{
  String token;

  LogAktifitasNotif({
    this.token,
  });

  factory LogAktifitasNotif.fromJson(Map<String, dynamic> map){
    return LogAktifitasNotif(
      token: map["token"],
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "token": token,
    };
  }

  @override
  String toString(){
    return 'logaktifitas{token: $token}';
  }

}

List<LogAktifitasNotif> LogAktifitasNotifFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<LogAktifitasNotif>.from(data.map((item) => LogAktifitasNotif.fromJson(item)));
}

String LogAktifitasNotifToJson(LogAktifitasNotif data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}