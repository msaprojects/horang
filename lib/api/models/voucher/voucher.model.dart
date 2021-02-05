import 'dart:convert';

class VoucherModel {
  num idvoucher, persentase, minNominal, nomPresentase;
  String keterangan, gambar, kode_voucher, expVoucher;

  VoucherModel(
      {this.idvoucher = 0,
      this.kode_voucher,
      this.persentase = 0,
      this.nomPresentase,
      this.minNominal = 0,
      this.keterangan,
      this.gambar = "",
      this.expVoucher});

  factory VoucherModel.fromJson(Map<String, dynamic> map) {
    return VoucherModel(
        idvoucher: map["idvoucher"],
        kode_voucher: map["kode_voucher"],
        persentase: map["persentase"],
        nomPresentase: map["nominal_persentase"],
        minNominal: map["min_nominal"],
        keterangan: map["keterangan"],
        gambar: map["gambar"],
        expVoucher: map["expired_voucher"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "idvoucher": idvoucher,
      "kode_voucher": kode_voucher,
      "persentase": persentase,
      "nominal_presentase": nomPresentase,
      "min_nominal": minNominal,
      "keterangan": keterangan,
      "gambar": gambar,
      "expired_voucher": expVoucher
    };
  }

  @override
  String toString() {
    return 'Voucher{idvoucher: $idvoucher, kode_voucher: $kode_voucher, persentase: $persentase, nominal_presentase: $nomPresentase, min_nominal: $minNominal, keterangan: $keterangan, gambar: $gambar, expired_voucher: $expVoucher}';
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
