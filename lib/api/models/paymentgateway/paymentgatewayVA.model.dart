import 'dart:convert';

class PaymentGatewayVirtualAccount{
  String name, code;

  PaymentGatewayVirtualAccount({
    required this.name,
    required this.code
  });

  factory PaymentGatewayVirtualAccount.fromJson(Map<String, dynamic> map){
    return PaymentGatewayVirtualAccount(
      name: map["name"],
      code: map["code"],
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "name": name,
      "code": code
    };
  }

  @override
  String toString() {
    return 'PaymentGateway{name: $name, code: $code}';
  }
}

List<PaymentGatewayVirtualAccount> paymentgatewayVAFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<PaymentGatewayVirtualAccount>.from(data.map((item) => PaymentGatewayVirtualAccount.fromJson(item)));
}

String paymentgatewayToJson(PaymentGatewayVirtualAccount data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}