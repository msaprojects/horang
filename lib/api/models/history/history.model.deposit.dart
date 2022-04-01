import 'dart:convert';

class HistoryDepositModel {
  String keterangan;
  num nominal;
  int debit;
  String created, noOrder;

  HistoryDepositModel(
      {required this.keterangan,
        required this.debit,
        required this.nominal,
        required this.created,
        required this.noOrder});

  factory HistoryDepositModel.fromJson(Map<String, dynamic> map) {
    return HistoryDepositModel(
      keterangan: map['keterangan'].toString(),
      debit: map['debit'],
      nominal: map['nominal'],
      created: map['created'].toString(),
      noOrder: map['no_order'].toString()
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "keterangan": keterangan,
      "debit": debit,
      "nominal": nominal,
      "created": created,
      "no_order": noOrder
    };
  }

  @override
  String toString() {
    return 'HistoryDeposit{keterangan: $keterangan, debit: $debit, nominal: $nominal, created: $created, no_order: $noOrder}';
  }
}

List<HistoryDepositModel> historyFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<HistoryDepositModel>.from(
      data.map((item) => HistoryDepositModel.fromJson(item)));
}

String historyToJson(HistoryDepositModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
