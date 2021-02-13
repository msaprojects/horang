import 'dart:convert';
import 'package:commons/commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/jenisproduk/jenisproduk.model.dart';
import 'package:horang/api/models/voucher/voucher.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/PaymentPage/Pembayaran.Input.dart';
import 'package:horang/utils/reusable.class.dart';
import 'package:indonesia/indonesia.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormInputOrder extends StatefulWidget {
  JenisProduk jenisProduk;
  var tglawal12, tglakhir12, tglawalforklift, jamawal, jamakhir;
  FormInputOrder(
      {this.jenisProduk,
      this.tglawal12,
      this.tglakhir12,
      this.tglawalforklift,
      this.jamawal,
      this.jamakhir});

  @override
  _FormDetailOrder createState() => _FormDetailOrder();
}

class _FormDetailOrder extends State<FormInputOrder> {
  //DEKLARASI VARIABEL
  bool isLoading = false,
      boolasuransi = true,
      boolvoucher = false,
      tekanvoucher = false,
      isSuccess = false,
      flagasuransi = true,
      flagvoucher = false,
      fieldnominalbarang,
      fieldketeranganbarang = false;
  var kapasitas,
      alamat,
      keterangan,
      produkimage,
      jamawal1,
      jamakhir1,
      tglawalforklift1,
      valueawal,
      valueakhir,
      hasilperhitungan,
      email_asuransi,
      getVoucher = "Pilih Voucher",
      tglAwal,
      tglAkhir,
      total_asuransi,
      totalhariharga,
      ceksaldo = 0,
      kondisisaldo,
      hargaxminimalsewadeposit,
      saldodepositkurangnominaldeposit,
      vkodevoucher = "",
      access_token,
      refresh_token,
      hitungsemua,
      gambarvoucher,
      vsatuan_sewa = "",
      namasetting = "",
      nilaisetting = "",
      namasetting1 = "",
      nilaisetting1 = "",
      namasetting2 = "",
      nilaisetting2 = "";
  num vdurasi_sewa,
      idjenis_produk,
      idcustomer,
      idasuransi,
      idlokasi,
      vminimumtransaksi = 0,
      harga_sewa,
      vpersentasevoucher = 0,
      vmaksimalpotongan = 0,
      minimaldeposit = 0,
      nomasuransi = 0,
      idvoucher = 0,
      totaldeposit = 0, potonganvoucher =0;
  DateTime dtAwal, dtAkhir;
  //END DEKLARASI VARIABEL
  //CALLING REFFERENCE
  SharedPreferences sp;
  ApiService _apiService = ApiService();
  TextStyle valueTglAwal = TextStyle(fontSize: 16.0);
  TextStyle valueTglAkhir = TextStyle(fontSize: 16.0);
  TextEditingController _keteranganbarang = TextEditingController();
  TextEditingController _nominalbarang = TextEditingController();
  //END CALLING REFFERENCE
  //DATE TIME PICKER FORMAT
  int diffInDays(tglAwal, tglAkhir) {
    return ((tglAkhir.difference(tglAwal) -
                    Duration(hours: tglAwal.hour) +
                    Duration(hours: tglAkhir.hour))
                .inHours /
            24)
        .round();
  }

  int diffInTime(tglAwal, tglAkhir) {
    return ((Duration(hours: tglAkhir.hour) - Duration(hours: tglAwal.hour))
            .inHours)
        .round();
  }

  //END DATE TIME PICKER FORMAT
  //ADDON
  getAsuransi() async {
    final response = await http.get(ApiService().urlasuransi,
        headers: {"Authorization": "BEARER ${access_token}"});
    nomasuransi = json.decode(response.body)[0]['nilai'];
    email_asuransi = json.decode(response.body)[0]['email_asuransi'];
    idasuransi = json.decode(response.body)[0]['idasuransi'];
    return;
  }

  void hitungsemuaFunction() async {
    setState(() {
      hitungsemua = ReusableClasses().PerhitunganOrder(
          vpersentasevoucher.toString(),
          vminimumtransaksi.toString(),
          flagasuransi,
          flagvoucher,
          vmaksimalpotongan.toString(),
          harga_sewa.toString(),
          vdurasi_sewa.toString(),
          _nominalbarang.text.toString(),
          totaldeposit.toString(),
          minimaldeposit.toString(),
          nomasuransi.toString());
    });
  }

  cleartextinputnominal() {
    _nominalbarang.clear();
    _keteranganbarang.clear();
  }

  //END ADDON
//INIT STATE
  @override
  void initState() {
    cekToken();
    getSaldo();
    // getSetting(access_token, idlokasi);
    tekanvoucher = !tekanvoucher;
    if (_nominalbarang.text == "") _nominalbarang.text = "0";
    idjenis_produk = widget.jenisProduk.idjenis_produk;
    kapasitas = widget.jenisProduk.kapasitas.toString();
    harga_sewa = widget.jenisProduk.harga;
    alamat = widget.jenisProduk.nama_lokasi;
    keterangan = widget.jenisProduk.keterangan;
    idlokasi = widget.jenisProduk.idlokasi;
    produkimage = widget.jenisProduk.gambar;
    if (widget.jenisProduk.kapasitas
        .toString()
        .toLowerCase()
        .contains('forklift')) {
      minimaldeposit = 0;
      vsatuan_sewa = " jam )";
      tglawalforklift1 = widget.tglawalforklift.toString();
      jamawal1 = widget.jamawal.toString();
      jamakhir1 = widget.jamakhir.toString();
      valueawal = tglawalforklift1 + " " + jamawal1;
      valueakhir = tglawalforklift1 + " " + jamakhir1;
      vdurasi_sewa =
          diffInTime(DateTime.parse(valueawal), DateTime.parse(valueakhir));
    } else {
      minimaldeposit = 3;
      vsatuan_sewa = " hari )";
      tglAwal = widget.tglawal12.toString();
      tglAkhir = widget.tglakhir12.toString();
      valueawal = tglAwal;
      valueakhir = tglAkhir;
      vdurasi_sewa =
          diffInDays(DateTime.parse(tglAwal), DateTime.parse(tglAkhir));
    }
    totalhariharga = vdurasi_sewa * harga_sewa;
    hargaxminimalsewadeposit = harga_sewa * minimaldeposit;
    if (ceksaldo >= hargaxminimalsewadeposit) {
      totaldeposit = hargaxminimalsewadeposit;
    } else {
      totaldeposit = ceksaldo;
    }
    _nominalbarang.addListener(() {
      setState(() {
        total_asuransi =
            (nomasuransi / 100) * double.parse(_nominalbarang.text.toString());
        hitungsemuaFunction();
      });
    });
    hitungsemuaFunction();
    super.initState();
  }
//END INITSTATE

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Lengkapi Data Sewa",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 150,
                    decoration: new BoxDecoration(
                        image: new DecorationImage(
                      // image: ExactAssetImage('assets/image/container1.png'),
                      image: NetworkImage(produkimage),
                      fit: BoxFit.fitHeight,
                    )),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 32, top: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: media.size.width - 64 - 48,
                              child: Text(
                                kapasitas,
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(alamat,
                                style: TextStyle(
                                  color: Colors.grey[500],
                                ),
                                overflow: TextOverflow.ellipsis),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Harga : " +
                                  rupiah(harga_sewa.toString(),
                                      separator: '.') +
                                  vsatuan_sewa,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        // IconButton(
                        //   icon: Icon(Icons.navigation),
                        //   onPressed: () {},
                        // )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(
                                    bottom: 8, left: 30, top: 8),
                                child: Text(
                                  "Durasi Sewa ",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(valueawal,
                                        style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("s/d",
                                        style: GoogleFonts.inter(fontSize: 14)),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(valueakhir,
                                        style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(width: 10),
                                    Text(
                                        "( " +
                                            vdurasi_sewa.toString() +
                                            vsatuan_sewa,
                                        style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(
                                    bottom: 8, left: 36, top: 8),
                                child: Text(
                                  "Deskripsi Produk",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  new Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 38),
                              child: Text(keterangan),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(
                                    bottom: 8, left: 36, top: 8),
                                child: Text(
                                  "Jam Operasional",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 38),
                        child: Text(nilaisetting.toString()),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 38),
                        child: Text(namasetting.toString()),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 38),
                        child: Text(nilaisetting1.toString()),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 38),
                        child: Text(namasetting1.toString()),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 38),
                        child: Text(nilaisetting2.toString()),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 38),
                        child: Text(namasetting2.toString()),
                      ),
                    ],
                  ),
                  Divider(),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(
                                    bottom: 3, left: 36, top: 8),
                                child: Text(
                                  "Addon Sewa",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 20, top: 5),
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                      value: boolasuransi,
                                      onChanged: (bool asuransii) {
                                        setState(() {
                                          boolasuransi = asuransii;
                                          if (boolasuransi == true) {
                                            flagasuransi = true;
                                            hitungsemuaFunction();
                                          } else {
                                            flagasuransi = false;
                                            hitungsemuaFunction();
                                          }
                                        });
                                      },
                                    ),
                                    SizedBox(width: 8.0),
                                    Text("Asuransi (" +
                                        nomasuransi.toString() +
                                        "%)"),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {});
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.50,
                                          decoration: new BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: new BorderRadius.only(
                                              topLeft:
                                                  const Radius.circular(25.0),
                                              topRight:
                                                  const Radius.circular(25.0),
                                            ),
                                          ),
                                          child: SafeArea(
                                              child: FutureBuilder(
                                                  future:
                                                      _apiService.listVoucher(
                                                          access_token),
                                                  builder: (context,
                                                      AsyncSnapshot<
                                                              List<
                                                                  VoucherModel>>
                                                          snapshot) {
                                                    if (snapshot.hasError) {
                                                      return Center(
                                                        child: Text(
                                                            "Something wrong with message: ${snapshot.error.toString()}"),
                                                      );
                                                    } else if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    } else if (snapshot
                                                            .connectionState ==
                                                        ConnectionState.done) {
                                                      List<VoucherModel>
                                                          vclist =
                                                          snapshot.data;
                                                      return _buildListvoucher(
                                                          vclist);
                                                    }
                                                  }))));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 30, right: 30, top: 5),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      enabled: false,
                                      hintText: "$getVoucher - "+potonganvoucher.toString(),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 30, right: 30, top: 5),
                                child: TextFormField(
                                  onTap: () {
                                    if (_nominalbarang.text == "0") {
                                      cleartextinputnominal();
                                    }
                                  },
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  decoration: InputDecoration(
                                    labelText: 'Total Nominal Barang',
                                    hintText: 'Masukkan Total Nominal Barang',
                                    border: const OutlineInputBorder(),
                                  ),
                                  controller: _nominalbarang,
                                  inputFormatters: <TextInputFormatter>[
                                    // ignore: deprecated_member_use
                                    WhitelistingTextInputFormatter.digitsOnly,
                                  ],
                                  onChanged: (value) {
                                    bool isFieldValid = value.trim().isNotEmpty;
                                    if (isFieldValid != fieldnominalbarang) {
                                      setState(() =>
                                          fieldnominalbarang = isFieldValid);
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 30, right: 30, top: 5),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Keterangan',
                                    hintText: 'Masukkan Keterangan Barang',
                                    border: const OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 3,
                                  controller: _keteranganbarang,
                                  onChanged: (value) {
                                    bool isFieldValid = value.trim().isNotEmpty;
                                    if (isFieldValid != fieldketeranganbarang) {
                                      setState(() =>
                                          fieldketeranganbarang = isFieldValid);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            // padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: Column(
                    children: [
                      Text("Total Pembayaran",
                          style: GoogleFonts.lato(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 3,
                      ),
                      Text(rupiah(hitungsemua),
                          style: GoogleFonts.lato(
                              fontSize: 20, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  alignment: Alignment.center,
                  width: 130,
                  height: 100,
                  // margin: EdgeInsets.only(top: 3),
                  child: OutlineButton(
                    borderSide: BorderSide(color: Colors.green, width: 2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    color: Colors.green,
                    onPressed: () {
                      hitungsemuaFunction();
                      _nominalbarang.text.toString() == "0" ||
                              _keteranganbarang.text.toString() == "" ||
                              _nominalbarang.text.toString() == "" ||
                              _keteranganbarang.text.toString() == "0" ||
                              _keteranganbarang.text.toString() == "-"
                          ? errorDialog(context,
                              "Nominal Barang Tidak boleh 0 atau kurang, karena nominal barang menentukan nominal klaim garansi jika ada hal yang tidak kita inginkan bersama, pastikan juga keterangan barang sudah terisi.")
                          : setState(() {
                              if (ceksaldo >= hargaxminimalsewadeposit) {
                                saldodepositkurangnominaldeposit = 0;
                                totaldeposit = hargaxminimalsewadeposit;
                                kondisisaldo = "";
                                orderConfirmation(context);
                              } else {
                                saldodepositkurangnominaldeposit =
                                    hargaxminimalsewadeposit - ceksaldo;
                                totaldeposit = ceksaldo;
                                kondisisaldo =
                                    "Saldo Poin anda sekarang ${rupiah(ceksaldo)}, minimal saldo poin sebesar $minimaldeposit ($vsatuan_sewa dari nominal harga sewa sebesar ${rupiah(harga_sewa)} total ${rupiah(hargaxminimalsewadeposit)}, diwajibkan untuk menambah nominal deposit sebesar ${rupiah(saldodepositkurangnominaldeposit)} ?";
                                cekDeposit(context);
                              }
                            });
                    },
                    child: Text(
                      "Lanjutkan Pembayaran",
                      textAlign: TextAlign.center,
                      style: (TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  cekDeposit(BuildContext context) {
    warningDialog(
        context, "Hai, Maaf saldo poin anda tidak mencukupi, $kondisisaldo ",
        title: "Saldo Poin Tidak Mencukupi",
        showNeutralButton: false,
        negativeText: "Batal",
        negativeAction: () {},
        positiveText: "OK", positiveAction: () {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return FormInputPembayaran(
          flagasuransi: flagasuransi,
          flagvoucher: flagvoucher,
          idlokasi: idlokasi,
          idjenis_produk: idjenis_produk,
          idvoucher: idvoucher,
          idasuransi: idasuransi,
          harga_sewa: harga_sewa,
          durasi_sewa: vdurasi_sewa,
          valuesewaawal: valueawal,
          valuesewaakhir: valueakhir,
          kapasitas: kapasitas,
          alamat: alamat,
          keterangan_barang: _keteranganbarang.text.toString(),
          nominal_barang: _nominalbarang.text.toString(),
          nominal_voucher: potonganvoucher,
          minimum_transaksi: vminimumtransaksi,
          persentase_voucher: vpersentasevoucher,
          totalharixharga: totalhariharga.toString(),
          saldopoint: totaldeposit.toString(),
          email_asuransi: email_asuransi.toString(),
          tambahsaldopoint: saldodepositkurangnominaldeposit.toString(),
          persentase_asuransi: nomasuransi.toString(),
          minimalsewahari: minimaldeposit,
        );
      }));
    });
  }

  orderConfirmation(BuildContext context) {
    successDialog(context,
        "Harap periksa kembali pesanan anda, pastikan anda data yang anda masukkan sesuai",
        title: "Konfirmasi Pesanan",
        showNeutralButton: false,
        negativeText: "Periksa Kembali",
        negativeAction: () {},
        positiveText: "Saya Setuju", positiveAction: () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return FormInputPembayaran(
            flagasuransi: flagasuransi,
            flagvoucher: flagvoucher,
            idlokasi: idlokasi,
            idjenis_produk: idjenis_produk,
            idvoucher: idvoucher,
            idasuransi: idasuransi,
            harga_sewa: harga_sewa,
            durasi_sewa: vdurasi_sewa,
            valuesewaawal: valueawal,
            valuesewaakhir: valueakhir,
            kapasitas: kapasitas,
            alamat: alamat,
            keterangan_barang: _keteranganbarang.text.toString(),
            nominal_barang: _nominalbarang.text.toString(),
            nominal_voucher: potonganvoucher,
            minimum_transaksi: vminimumtransaksi,
            persentase_voucher: vpersentasevoucher,
            totalharixharga: totalhariharga.toString(),
            saldopoint: totaldeposit.toString(),
            email_asuransi: email_asuransi.toString(),
            tambahsaldopoint: saldodepositkurangnominaldeposit.toString(),
            persentase_asuransi: nomasuransi.toString(),
            minimalsewahari: minimaldeposit);
      }));
    });
  }

  Widget _buildListvoucher(List<VoucherModel> dataIndex) {
    return Container(
      height: 50,
      margin: EdgeInsets.only(left: 8, right: 8),
      child: ListView.builder(
          itemCount: dataIndex.length,
          itemBuilder: (context, index) {
            VoucherModel voucherlist = dataIndex[index];
            return GestureDetector(
              onTap: () {
                if (idcustomer == "0" || idcustomer == "") {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Anda Harus Melengkapi profile untuk melakukan transaksi!'),
                    duration: Duration(seconds: 5),
                  ));
                } else {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => FormInputOrder()),
                      (route) => false);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: EdgeInsets.all(8),
                height: 120,
                width: MediaQuery.of(context).size.width * 0.5,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (tekanvoucher) {
                        gambarvoucher = voucherlist.gambar;
                        idvoucher = voucherlist.idvoucher;
                        vminimumtransaksi = voucherlist.min_nominal;
                        vkodevoucher = voucherlist.kode_voucher.toString();
                        vpersentasevoucher = voucherlist.persentase;
                        vmaksimalpotongan = voucherlist.nominal_persentase;
                        potonganvoucher = ((double.parse(vpersentasevoucher.toString())/100) * double.parse(totalhariharga.toString()));
                        flagvoucher = true;
                        Navigator.pop(context);
                        hitungsemuaFunction();
                      }
                    });
                  },
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width * 0.25,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(voucherlist.gambar))),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10, top: 10),
                            child: SizedBox(
                              width: 170,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Kode Voucher : " +
                                      voucherlist.kode_voucher.toString()),
                                  Flexible(
                                    child: Text(
                                      "Minimum Transaksi : " +
                                          rupiah(voucherlist.min_nominal.toString()),
                                      maxLines: 2,
                                      overflow: TextOverflow.visible,
                                      softWrap: false,
                                    ),
                                  ),
                                  Text("Nominal Potongan : " +
                                      rupiah(voucherlist.nominal_persentase.toString())),
                                  Flexible(
                                    child: Text("Persentase Potongan : " +
                                        voucherlist.persentase.toString() +
                                        " %",
                                        softWrap: false,
                                        overflow: TextOverflow.visible,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    //checking jika token kosong maka di arahkan ke menu login jika tidak akan meng-hold token dan refresh token
    if (access_token == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    } else {
      _apiService.checkingToken(access_token).then((value) => setState(() {
            isSuccess = value;
            //checking jika token expired/tidak berlaku maka akan di ambilkan dari refresh token
            if (!isSuccess) {
              _apiService
                  .refreshToken(refresh_token)
                  .then((value) => setState(() {
                        var newtoken = value;
                        //setting access_token dari refresh_token
                        if (newtoken != "") {
                          sp.setString("access_token", newtoken);
                          access_token = newtoken;
                        } else {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LoginPage()),
                              (Route<dynamic> route) => false);
                        }
                      }));
            }
          }));
    }
    getAsuransi();
    getSaldo();
    getSetting(access_token, idlokasi);
  }

  getSaldo() async {
    final response = await http.get(ApiService().urlceksaldo,
        headers: {"Authorization": "BEARER ${access_token}"});
    ceksaldo = json.decode(response.body)[0]['saldo'];
    return ceksaldo;
  }

  getSetting(token, idlokasi) async {
    final response = await http.post(ApiService().urlsettingbylokasi,
        headers: {"content-type": "application/json"},
        body: json.encode({"token": token, "idlokasi": idlokasi}));
    namasetting = json.decode(response.body)[0]['kunci'];
    nilaisetting = json.decode(response.body)[0]['nilai'];
    namasetting1 = json.decode(response.body)[1]['kunci'];
    nilaisetting1 = json.decode(response.body)[1]['nilai'];
    namasetting2 = json.decode(response.body)[2]['kunci'];
    nilaisetting2 = json.decode(response.body)[2]['nilai'];
  }
}

class CurrencyFormat extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    double value = double.parse(newValue.text);
    final money = NumberFormat("#.###.###,00", "id");
    // final money = NumberFormat.currency(locale: 'id',symbol: 'Rp. ', decimalDigits: 0);
    String newText = money.format(value);

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}
