import 'dart:convert';

class Customers{
  int idkota;
  String idcustomer;
  String token, namacustomer, alamat, noktp, blacklist, email, nohp, namakota;

  Customers({
    required this.idcustomer,
    required this.namacustomer,
    required this.alamat,
    required this.noktp,
    required this.blacklist,
    required this.idkota,
    required this.token,
    required this.email,
    required this.nohp,
    required this.namakota
  });

  factory Customers.fromJson(Map<String, dynamic> map){
    return Customers(
      idcustomer: map['idcustomer'].toString(),
      namacustomer: map['nama_customer'].toString(),
      alamat: map['alamat'].toString(),
      noktp: map['noktp'].toString(),
      blacklist: map['blacklist'].toString(),
      idkota: map['idkota'],
      namakota: map['nama_kota'].toString(),
      token: map['token'].toString(),
      email: map['email'].toString(),
      nohp: map['no_hp'].toString(),
    );
  }
  Map<String, dynamic> toJson(){
    return{
      "nama_customer": namacustomer,
      "alamat": alamat,
      "noktp": noktp,
      "blacklist": blacklist.toString(),
      "idkota": idkota,
      "token": token
    };
  }

  @override
  String toString(){
    return 'Customer{idkota: $idkota, nama_customer: $namacustomer, alamat: $alamat, noktp: $noktp, token: $token, blacklist: $blacklist}';
  }

}

List<Customers> customerFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<Customers>.from(data.map((item) => Customers.fromJson(item)));
}

String customerToJson(Customers data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}