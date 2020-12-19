import 'dart:convert';

class logAktifitasNotif{
  // String token;
  String keterangan;

  logAktifitasNotif({
    // this.token,
    this.keterangan,
  });

  factory logAktifitasNotif.fromJson(Map<String, dynamic> map){
    return logAktifitasNotif(
      // token: map["token"],
      keterangan: map["keterangan"]
    );
  }

  Map<String, dynamic> toJson(){
    return{
      // "token": token,
      "keterangan": keterangan,
    };
  }

  @override
  String toString(){
    return 'logaktifitas{keterangan: $keterangan}';
  }

}

List<logAktifitasNotif> logAktifitasNotifFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<logAktifitasNotif>.from(data.map((item) => logAktifitasNotif.fromJson(item)));
}

String logAktifitasNotifToJson(logAktifitasNotif data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}