import 'dart:convert';

class Voucher{
  int idvoucher, jumlah_voucher;
  int persentase, nominal;
  String keterangan, gambar, kode_voucher;

  Voucher({
    this.idvoucher = 0,
    this.jumlah_voucher = 0,
    this.persentase = 0,
    this.nominal = 0,
    this.keterangan,
    this.gambar="",
    this.kode_voucher
  });

  factory Voucher.fromJson(Map<String, dynamic> map){
    return Voucher(
      idvoucher: map["idvoucher"],
        jumlah_voucher: map["jumlah_voucher"],
      persentase: map["persentase"],
      nominal: map["nominal"],
      keterangan: map["keterangan"],
      gambar: map["gambar"],
      kode_voucher: map["kode_voucher"]
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "idvoucher": idvoucher,
      "jumlah_voucher": jumlah_voucher,
      "persentase": persentase,
      "nominal": nominal,
      "keterangan": keterangan,
      "gambar": gambar,
      "kode_voucher": kode_voucher
    };
  }

  @override
  String toString(){
    return 'Voucher{idvoucher: $idvoucher, jumlah_voucher: $jumlah_voucher, persentase: $persentase, nominal: $nominal, keterangan: $keterangan, gambar: $gambar, kode_voucher: $kode_voucher}';
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