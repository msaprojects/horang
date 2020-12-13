import 'dart:convert';

class Customers{
  int idkota, idcustomer;
  // ignore: non_constant_identifier_names
  String token, nama_customer, alamat, noktp, blacklist, email, no_hp;

  Customers({
    // this.idcustomer,
    // ignore: non_constant_identifier_names
    this.nama_customer,
    this.alamat,
    this.noktp,
    this.blacklist,
    this.idkota,
    this.token,
    this.email,
    this.no_hp
    // this.nama_kota
  });

  factory Customers.fromJson(Map<String, dynamic> map){
    return Customers(
      // idcustomer: map['idcustomer'],
      nama_customer: map['nama_customer'],
      alamat: map['alamat'],
      noktp: map['noktp'],
      blacklist: map['blacklist'].toString(),
      idkota: map['idkota'],
      // nama_kota: map['nama_kota']
      token: map['token'],
      email: map['email'],
      no_hp: map['no_hp'],
    );
  }
  Map<String, dynamic> toJson(){
    return{
      // "idcustomer": idcustomer,
      "nama_customer": nama_customer,
      "alamat": alamat,
      "noktp": noktp,
      "blacklist": blacklist.toString(),
      "idkota": idkota,
      // "nama_kota": nama_kota
      // "email": email,
      // "no_hp": no_hp,
      "token": token
    };
  }

  @override
  String toString(){
    return 'Customer{idkota: $idkota, nama_customer: $nama_customer, alamat: $alamat, noktp: $noktp, token: $token, blacklist: $blacklist}';
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