import 'dart:convert';

class Voucher{
  int idvoucher, jumlah_voucher;
  int persentase, nominal;
  String keterangan, gambar;

  Voucher({
    this.idvoucher = 0,
    this.jumlah_voucher = 0,
    this.persentase = 0,
    this.nominal = 0,
    this.keterangan="",
    this.gambar=""
  });

  factory Voucher.fromJson(Map<String, dynamic> map){
    return Voucher(
      idvoucher: map["idvoucher"],
        jumlah_voucher: map["jumlah_voucher"],
      persentase: map["persentase"],
      nominal: map["nominal"],
      keterangan: map["keterangan"],
      gambar: map["gambar"]
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "idvoucher": idvoucher,
      "jumlah_voucher": jumlah_voucher,
      "persentase": persentase,
      "nominal": nominal,
      "keterangan": keterangan,
      "gambar": gambar
    };
  }

  @override
  String toString(){
    return 'Voucher{idvoucher: $idvoucher, jumlah_voucher: $jumlah_voucher, persentase: $persentase, nominal: $nominal, keterangan: $keterangan, gambar: $gambar}';
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