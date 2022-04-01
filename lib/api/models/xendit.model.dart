import 'dart:convert';

class Xenditmodel{
  String balance;

  factory Xenditmodel.fromJson(Map<String, dynamic> map){
    return Xenditmodel(
        balance: map["balance"]
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "balance": balance
    };
  }

  Xenditmodel({
    required this.balance
  });

  @override
  String toString(){
    return 'xenditModel{balance: $balance}';
  }

}

List<Xenditmodel> xenditFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<Xenditmodel>.from(data.map((item) => Xenditmodel.fromJson(item)));
}

String xenditToJson(Xenditmodel data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}