import 'dart:convert';

class Voucher{
  int idvoucher;
  num persentase, minNominal,  jumlah_voucher, nomPresentase;
  String keterangan, gambar, kode_voucher, expVoucher;

  Voucher({
    this.idvoucher = 0,
    this.kode_voucher,
    this.jumlah_voucher = 0,
    this.persentase = 0,
    this.nomPresentase,
    this.minNominal = 0,
    this.keterangan,
    this.gambar="",
    this.expVoucher
  });

  factory Voucher.fromJson(Map<String, dynamic> map){
    return Voucher(
      idvoucher: map["idvoucher"],
      kode_voucher: map["kode_voucher"],
      jumlah_voucher: map["jumlah_voucher"],
      persentase: map["persentase"],
      nomPresentase: map["nominal_presentase"],
      minNominal: map["min_nominal"],
      keterangan: map["keterangan"],
      gambar: map["gambar"],
      expVoucher: map["expired_voucher"]
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "idvoucher": idvoucher,
      "kode_voucher": kode_voucher,
      "jumlah_voucher": jumlah_voucher,
      "persentase": persentase,
      "nominal_presentase": nomPresentase,
      "min_nominal": minNominal,
      "keterangan": keterangan,
      "gambar": gambar,
      "expired_voucher": expVoucher
    };
  }

  @override
  String toString(){
    return 'Voucher{idvoucher: $idvoucher, kode_voucher: $kode_voucher, jumlah_voucher: $jumlah_voucher, persentase: $persentase, nominal_presentase: $nomPresentase, min_nominal: $minNominal, keterangan: $keterangan, gambar: $gambar, expired_voucher: $expVoucher}';
  }

}

List<Voucher> voucherFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<Voucher>.from(data.map((item) => Voucher.fromJson(item)));
}

String voucherToJson(Voucher data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}