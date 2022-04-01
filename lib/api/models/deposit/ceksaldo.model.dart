import 'dart:convert';

class CekSaldoModel {
  num saldo;

  CekSaldoModel({required this.saldo});

  factory CekSaldoModel.fromJson(Map<String, dynamic> map){
    return CekSaldoModel(
      saldo: map['saldo']
    );
  }
  Map<String, dynamic> toJson(){
    return{
      "saldo": saldo
    };
  }

  @override
  String toString() {
    return 'CekSaldoModel{saldo: $saldo}';
  }
}

List<CekSaldoModel> ceksaldoFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<CekSaldoModel>.from(data.map((item) => CekSaldoModel.fromJson(item)));
}

String ceksaldoToJson(CekSaldoModel data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}