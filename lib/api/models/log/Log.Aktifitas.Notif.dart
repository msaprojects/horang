import 'dart:convert';

class logAktifitasNotif {
  String keterangan_user, timestamp;

  logAktifitasNotif({this.keterangan_user, this.timestamp});

  factory logAktifitasNotif.fromJson(Map<String, dynamic> map) {
    return logAktifitasNotif(
        keterangan_user: map["keterangan_user"], timestamp: map["timestamp"]);
  }

  Map<String, dynamic> toJson() {
    return {"keterangan_user": keterangan_user, "timestamp": timestamp};
  }

  @override
  String toString() {
    return 'logaktifitas{keterangan_user: $keterangan_user, timestamp: $timestamp}';
  }
}

List<logAktifitasNotif> logAktifitasNotifFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<logAktifitasNotif>.from(
      data.map((item) => logAktifitasNotif.fromJson(item)));
}

String logAktifitasNotifToJson(logAktifitasNotif data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
