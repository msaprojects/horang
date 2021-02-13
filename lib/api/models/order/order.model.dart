import 'dart:convert';

class OrderProduk {
  bool flagasuransi, flagvoucher;
  num idlokasi, idjenis_produk, idvoucher, idasuransi, idpayment_gateway;
  var token,
      harga_sewa,
      durasi_sewa,
      valuesewaawal,
      valuesewaakhir,
      keterangan_barang,
      nominal_barang,
      nominal_voucher,
      minimum_transaksi,
      persentase_voucher,
      total_harga,
      total_asuransi,
      saldopoint, // as saldo poin terpakai
      email_asuransi,
      tambahsaldopoint, // as tambah saldo poin
      persentase_asuransi,
      no_ovo,
      minimalsewahari,
      totaldeposit;

  OrderProduk(
      {this.token,
      this.flagasuransi,
      this.flagvoucher,
      this.idlokasi,
      this.idjenis_produk,
      this.idvoucher,
      this.idasuransi,
      this.idpayment_gateway,
      this.harga_sewa,
      this.durasi_sewa,
      this.valuesewaawal,
      this.valuesewaakhir,
      this.keterangan_barang,
      this.nominal_barang,
      this.nominal_voucher,
      this.minimum_transaksi,
      this.persentase_voucher,
      this.total_harga,
      this.total_asuransi,
      this.saldopoint, // as saldo poin terpakai
      this.email_asuransi,
      this.tambahsaldopoint, // as tambah saldo poin
      this.persentase_asuransi,
      this.no_ovo,
      this.minimalsewahari,
      this.totaldeposit//as nominal minimum deposit
      });

      

}

List<OrderProduk> orderprodukFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<OrderProduk>.from(data.map((item) => OrderProduk.fromJson(item)));
}

String orderprodukToJson(OrderProduk data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
