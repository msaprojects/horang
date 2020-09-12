import 'dart:convert';

class Customer{
  int idkota, idcustomer;
  String token, nama_customer, alamat, noktp, blacklist;

  Customer({
    // this.idcustomer,
    this.nama_customer,
    this.alamat,
    this.noktp,
    this.blacklist,
    this.idkota = 0,
    this.token
    // this.nama_kota
  });

  factory Customer.fromJson(Map<String, dynamic> map){
    return Customer(
      // idcustomer: map['idcustomer'],
      nama_customer: map['nama_customer'],
      alamat: map['alamat'],
      noktp: map['noktp'],
      blacklist: map['blacklist'].toString(),
      idkota: map['idkota'],
      // nama_kota: map['nama_kota']
      token: map['token'],
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
      "token": token
    };
  }

  @override
  String toString(){
    return 'Customer{idkota: $idkota, nama_customer: $nama_customer, alamat: $alamat, noktp: $noktp, token: $token, blacklist: $blacklist}';
  }

}

List<Customer> customerFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<Customer>.from(data.map((item) => Customer.fromJson(item)));
}

String customerToJson(Customer data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}