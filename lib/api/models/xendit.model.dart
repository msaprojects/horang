import 'dart:convert';

class xenditmodel{
  String balance;

  factory xenditmodel.fromJson(Map<String, dynamic> map){
    return xenditmodel(
        balance: map["balance"]
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "balance": balance
    };
  }

  xenditmodel({
    this.balance
  });

  @override
  String toString(){
    return 'xenditModel{balance: $balance}';
  }

}

List<xenditmodel> xenditFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<xenditmodel>.from(data.map((item) => xenditmodel.fromJson(item)));
}

String xenditToJson(xenditmodel data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}