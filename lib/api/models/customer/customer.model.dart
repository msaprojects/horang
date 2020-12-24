import 'dart:convert';

class Customers{
  num idkota, idcustomer;
  String token, namacustomer, alamat, noktp, blacklist, email, nohp, namakota;

  Customers({
    this.namacustomer,
    this.alamat,
    this.noktp,
    this.blacklist,
    this.idkota,
    this.token,
    this.email,
    this.nohp,
    this.namakota
  });

  factory Customers.fromJson(Map<String, dynamic> map){
    return Customers(
      namacustomer: map['nama_customer'],
      alamat: map['alamat'],
      noktp: map['noktp'],
      blacklist: map['blacklist'].toString(),
      idkota: map['idkota'],
      namakota: map['nama_kota'],
      token: map['token'],
      email: map['email'],
      nohp: map['no_hp'],
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