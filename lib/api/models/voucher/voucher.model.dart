import 'dart:convert';

class VoucherModel {
  num idvoucher, persentase, min_nominal, nominal_persentase;
  String keterangan, gambar, kode_voucher, expVoucher;

  VoucherModel(
      {this.idvoucher = 0,
        required this.kode_voucher,
        required this.persentase,
        required this.nominal_persentase,
        required this.min_nominal,
        required this.keterangan,
      this.gambar = "",
        required this.expVoucher});

  factory VoucherModel.fromJson(Map<String, dynamic> map) {
    return VoucherModel(
        idvoucher: map["idvoucher"],
        kode_voucher: map["kode_voucher"],
        persentase: map["persentase"],
        nominal_persentase: map["nominal_persentase"],
        min_nominal: map["min_nominal"],
        keterangan: map["keterangan"],
        gambar: map["gambar"],
        expVoucher: map["expired_voucher"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "idvoucher": idvoucher,
      "kode_voucher": kode_voucher,
      "persentase": persentase,
      "nominal_presentase": nominal_persentase,
      "min_nominal": min_nominal,
      "keterangan": keterangan,
      "gambar": gambar,
      "expired_voucher": expVoucher
    };
  }

  @override
  String toString() {
    return 'Voucher{idvoucher: $idvoucher, kode_voucher: $kode_voucher, persentase: $persentase, nominal_presentase: $nominal_persentase, min_nominal: $min_nominal, keterangan: $keterangan, gambar: $gambar, expired_voucher: $expVoucher}';
  }
}

List<VoucherModel> voucherFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<VoucherModel>.from(
      data.map((item) => VoucherModel.fromJson(item)));
}

String voucherToJson(VoucherModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
