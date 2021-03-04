import 'dart:convert';

class logAktifitasNotif {
  String keterangan_user, timestamp, timestamp_group;

  logAktifitasNotif({this.keterangan_user, this.timestamp, this.timestamp_group});

  factory logAktifitasNotif.fromJson(Map<String, dynamic> map) {
    return logAktifitasNotif(
        keterangan_user: map["keterangan_user"], timestamp: map["timestamp"], timestamp_group: map["timestamp_group"]);
  }

  Map<String, dynamic> toJson() {
    return {"keterangan_user": keterangan_user, "timestamp": timestamp, "timestamp_group": timestamp_group};
  }


  @override
  String toString() {
    return 'logaktifitas{keterangan_user: $keterangan_user, timestamp: $timestamp. timestamp: $timestamp_group}';
  }
}

List<logAktifitasNotif> logAktifitasNotifFromJson(String jsonData) {
  final data = json.decode(jsonData);
  // return List<logAktifitasNotif>.from(
  //     data.map((item) => logAktifitasNotif.fromJson(item)));
  return List<logAktifitasNotif>.from(
      data.map((item) => logAktifitasNotif.fromJson(item)));
}

List logaktifitasnotifToList(String jsonData){
  return json.decode(jsonData);

}


String logAktifitasNotifToJson(logAktifitasNotif data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
