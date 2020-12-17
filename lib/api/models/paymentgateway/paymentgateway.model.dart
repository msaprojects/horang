import 'dart:convert';

class PaymentGateway{
  num idpayment_gateway, status;
  String password;
  String nama_provider, token_provider;

  PaymentGateway({
    this.idpayment_gateway =0,
    this.status =0,
    this.nama_provider,
    this.token_provider,
    this.password
  });

  factory PaymentGateway.fromJson(Map<String, dynamic> map){
    return PaymentGateway(
      idpayment_gateway: map["idpayment_gateway"],
      nama_provider: map["nama_provider"],
      token_provider: map["token_provider"],
      status: map["status"],
      password: map["password"]
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "idpayment_gateway": idpayment_gateway,
      "nama_provider": nama_provider,
      "token_provider": token_provider,
      "status": status,
      "password": password
    };
  }

  @override
  String toString() {
    return 'PaymentGateway{idpayment_gateway: $idpayment_gateway, status: $status, password: $password, nama_provider: $nama_provider, token_provider: $token_provider}';
  }
}

List<PaymentGateway> paymentgatewayFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<PaymentGateway>.from(data.map((item) => PaymentGateway.fromJson(item)));
}

String paymentgatewayToJson(PaymentGateway data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}