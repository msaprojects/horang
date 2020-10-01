import 'dart:convert';

class Token{
  int idcustomer, pin;
  String message, access_token, refresh_token, nama_customer;

  Token({
    this.idcustomer = 0,
    this.message,
    this.access_token,
    this.refresh_token,
    this.pin,
    this.nama_customer,
  });

  factory Token.fromJson(Map<String, dynamic> map){
    return Token(
      message: map["message"],
      access_token: map["access_token"],
      refresh_token: map["refresh_token"],
      idcustomer: map["idcustomer"],
      pin: map["pin"],
      nama_customer: map["nama_customer"],
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "message": message,
      "access_token": access_token,
      "refresh_token": refresh_token,
      "idcustomer": idcustomer,
      "pin": pin,
      "pinama_customern": nama_customer,
    };
  }

  @override
  String toString(){
    return 'Token{'
        'message: $message,'
        'access_token: $access_token,'
        'refresh_token: $refresh_token,'
        'idcustomer: $idcustomer,'
        'nama_customer: $nama_customer,'
        'pin: $pin}';
  }

}

List<Token> tokenFromJson(String dataJson){
  final data = json.decode(dataJson);
  return List<Token>.from(data.map((item) => Token.fromJson(item)));
}

String tokenToJson(Token data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

