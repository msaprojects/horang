import 'dart:convert';

class history{  
  String token, nama_customer, no_order, total_harga, jumlah_sewa;

  history({
    this.nama_customer,
    this.no_order,
    this.total_harga,
    this.jumlah_sewa,
    this.token
  });

  factory history.fromJson(Map<String, dynamic> map){
    return history(
      nama_customer: map['nama_customer'],
      no_order: map['no_order'],
      total_harga: map['total_harga'].toString(),
      jumlah_sewa: map['jumlah_sewa'].toString(),
      token: map['token'],
    );
  }
  Map<String, dynamic> toJson(){
    return{    
      "nama_customer": nama_customer,
      "no_order": no_order,
      "total_harga": total_harga,
      "jumlah_sewa": jumlah_sewa,
      "token": token
    };
  }

  @override
  String toString(){
    return 'history{nama_customer: $nama_customer, no_order: $no_order, total_harga: $total_harga, token: $token, jumlah_sewa: $jumlah_sewa}';
  }

}

List<history> HistoryFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<history>.from(data.map((item) => history.fromJson(item)));
}

String HistoryToJson(history data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}