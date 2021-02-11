import 'dart:ui';
import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/paymentgateway/paymentgateway.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/PaymentPage/KonfirmPayment.dart';
import 'package:horang/utils/reusable.class.dart';
import 'package:indonesia/indonesia.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormInputPembayaran extends StatefulWidget {
  bool warna;
  var flagasuransi,
      flagvoucher,
      idlokasi,
      idjenis_produk,
      idvoucher,
      idasuransi,
      harga_sewa,
      durasi_sewa,
      valuesewaawal,
      valuesewaakhir,
      tanggal_berakhir_polis,
      nomor_polis,
      kapasitas,
      alamat,
      keterangan_barang,
      nominal_barang,
      nominal_voucher,
      minimum_transaksi,
      persentase_voucher,
      totalharixharga,
      saldopoint,
      email_asuransi,
      tambahsaldopoint,
      persentase_asuransi,
      minimalsewahari;

  FormInputPembayaran(
      {this.flagasuransi,
      this.flagvoucher,
      this.idlokasi,
      this.idjenis_produk,
      this.idvoucher,
      this.idasuransi,
      this.harga_sewa,
      this.durasi_sewa,
      this.valuesewaawal,
      this.valuesewaakhir,
      this.tanggal_berakhir_polis,
      this.nomor_polis,
      this.kapasitas,
      this.alamat,
      this.keterangan_barang,
      this.nominal_barang,
      this.nominal_voucher,
      this.minimum_transaksi,
      this.persentase_voucher,
      this.totalharixharga,
      this.saldopoint,
      this.email_asuransi,
      this.tambahsaldopoint,
      this.persentase_asuransi,
      this.minimalsewahari});

  @override
  _FormInputPembayaran createState() => _FormInputPembayaran();
}

class _FormInputPembayaran extends State<FormInputPembayaran> {
  ApiService _apiService = ApiService();
  int grup = 1;
  var rgIndex = 1;
  int rgID = 1;
  int _currentIndex = 1;
  String rgValue = "";
  bool _sel = false, isEnabled = true;
  bool asuransi = false;
  String formatedate, formatedate2;
  SharedPreferences sp;
  bool isSuccess = false;
  int idorder = 0;
  var access_token, refresh_token, email, nama_customer;
  var pflagasuransi,
      pflagvoucher,
      pidlokasi,
      pidjenis_produk,
      pidvoucher,
      pidasuransi,
      pharga_sewa,
      pdurasi_sewa,
      pvaluesewaawal,
      pvaluesewaakhir,
      ptanggal_berakhir_polis,
      pnomor_polis,
      pkapasitas,
      palamat,
      pketerangan_barang,
      pnominal_barang,
      pnominal_voucher,
      pminimum_transaksi,
      ppersentase_voucher,
      ptotal_asuransi,
      ptotalharixharga,
      psaldopoint,
      pemail_asuransi,
      ptambahsaldopoint,
      ppersentase_asuransi,
      hitungsemua,
      pminimalsewahari,
      totaldeposit;

  var hasilperhitungan;

  enableButton() {
    setState(() {
      isEnabled = true;
    });
  }

  disableButton() {
    setState(() {
      isEnabled = false;
    });
  }

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    email = sp.getString("email");
    nama_customer = sp.getString("nama_customer");
    //checking jika token kosong maka di arahkan ke menu login jika tidak akan meng-hold token dan refresh token
    if (access_token == null) {
      showAlertDialog(context);
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
                          showAlertDialog(context);
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
  }

  @override
  void initState() {
    setState(() {
      pflagasuransi = widget.flagasuransi;
      pflagvoucher = widget.flagvoucher;
      pidlokasi = widget.idlokasi;
      pidjenis_produk = widget.idjenis_produk;
      pidvoucher = widget.idvoucher;
      pidasuransi = widget.idasuransi;
      pharga_sewa = widget.harga_sewa;
      pdurasi_sewa = widget.durasi_sewa;
      pvaluesewaawal = widget.valuesewaawal;
      pvaluesewaakhir = widget.valuesewaakhir;
      ptanggal_berakhir_polis = widget.tanggal_berakhir_polis;
      pnomor_polis = widget.nomor_polis;
      pkapasitas = widget.kapasitas;
      palamat = widget.alamat;
      pketerangan_barang = widget.keterangan_barang;
      pnominal_barang = widget.nominal_barang;
      pnominal_voucher = widget.nominal_voucher;
      pminimum_transaksi = widget.minimum_transaksi;
      ppersentase_voucher = widget.persentase_voucher;
      ptotalharixharga = widget.totalharixharga;
      psaldopoint = widget.saldopoint;
      pemail_asuransi = widget.email_asuransi;
      ptambahsaldopoint = widget.tambahsaldopoint;
      ppersentase_asuransi = widget.persentase_asuransi;
      pminimalsewahari = widget.minimalsewahari;
      ptotal_asuransi = (double.parse(ppersentase_asuransi) / 100) * double.parse(pnominal_barang);
      totaldeposit = (pminimalsewahari * pharga_sewa);
      cekToken();
      hitungsemuaFunction();
    });
    super.initState();
  }

  void hitungsemuaFunction() async {
    setState(() {
      hitungsemua = ReusableClasses().PerhitunganOrder(
          ppersentase_voucher.toString(),
          pminimum_transaksi.toString(),
          pflagvoucher,
          pflagasuransi,
          pnominal_voucher.toString(),
          pharga_sewa.toString(),
          pdurasi_sewa.toString(),
          pnominal_barang.toString(),
          psaldopoint.toString(),
          pminimalsewahari.toString(),
          ppersentase_asuransi.toString());
    });
    print("HITUNG ALL : " +
        ppersentase_voucher.toString() +
        " ~ " +
        pminimum_transaksi.toString() +
        " ~ " +
        pflagvoucher.toString() +
        " ~ " +
        pflagasuransi.toString() +
        " ~ " +
        pnominal_voucher.toString() +
        " ~ " +
        pharga_sewa.toString() +
        " ~ " +
        pdurasi_sewa.toString() +
        " ~ " +
        pnominal_barang.toString() +
        " ~ " +
        psaldopoint.toString() +
        " ~ " +
        pminimalsewahari.toString() +
        " ~ " +
        ppersentase_asuransi.toString()+" ~ "+hitungsemua.toString());
  }

  @override
  Widget build(BuildContext context) {
    var asuransitxt, vouchertxt;
    if (pflagasuransi == 1) {
      asuransitxt = "Ya";
    } else {
      asuransitxt = "Tidak";
    }
    var media = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rincian Data Sewa",
          style: TextStyle(color: Colors.black),
        ),
        //Blocking Back
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    child: new Column(
                      children: <Widget>[
                        new ListTile(
                          leading: Icon(Icons.insert_drive_file),
                          title: new Text(
                            pkapasitas,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: new Flexible(
                              child: Text(
                            palamat,
                            style: TextStyle(color: Colors.black),
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8, left: 36, top: 8),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 30, bottom: 15),
                          child: Row(
                            children: <Widget>[
                              Text("Detail Pesanan ",
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Tanggal Mulai :"),
                                  Text("Tanggal Berakhir :"),
                                  Text("Durasi Sewa :"),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pvaluesewaawal,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(pvaluesewaakhir,
                                      overflow: TextOverflow.ellipsis),
                                  Text(
                                    pdurasi_sewa.toString() + " Hari",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 30),
                              child: Row(
                                children: <Widget>[Text("Harga Sewa :")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Text(
                                rupiah(pharga_sewa,
                                    separator: ',', trailing: " /hari"),
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 30),
                              child: Row(
                                children: <Widget>[Text("Asuransi :")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Text(
                                asuransitxt,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 30),
                              child: Row(
                                children: <Widget>[
                                  Text("Keterangan Barang : ")
                                ],
                              ),
                            ),
                            Flexible(
                                child: Text(
                              pketerangan_barang,
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Divider(
                          height: 16,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 30, bottom: 15),
                          child: Row(
                            children: <Widget>[
                              Text("Detail Pembayaran",
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 30),
                              child: Row(
                                children: <Widget>[Text("Subtotal :")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Text(
                                rupiah(ptotalharixharga, separator: ','),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 30),
                              child: Row(
                                children: <Widget>[Text("Minimum Deposit :")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Text(
                                rupiah(totaldeposit, separator: ','),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 30),
                              child: Row(
                                children: <Widget>[
                                  Text("Point Deposit Anda : ")
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Text(
                                rupiah(psaldopoint, separator: ','),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 30),
                              child: Row(
                                children: <Widget>[Text("Nominal Voucher :")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Text(
                                "-" + rupiah(pnominal_voucher),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 30),
                              child: Row(
                                children: <Widget>[
                                  Text("Nominal Asuransi (" +
                                      ppersentase_asuransi.toString() +
                                      "%) :")
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Flexible(
                                child: Text(
                                  rupiah(
                                    ptotal_asuransi,
                                  ),
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 30),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "( Nominal Barang : " +
                                    rupiah(pnominal_barang + " )"),
                                style: TextStyle(fontStyle: FontStyle.italic),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Divider(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 30),
                              child: Row(
                                children: <Widget>[
                                  Text("Total :",
                                      style: (TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)))
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(right: 60),
                              child: Text(
                                rupiah(hitungsemua),
                                style: (TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: SingleChildScrollView(
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
                                    "Pilih Metode Pembayaran : ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SafeArea(
                                  child: FutureBuilder(
                                      future: _apiService
                                          .listPaymentGateway(access_token),
                                      builder: (context,
                                          AsyncSnapshot<List<PaymentGateway>>
                                              snapshot) {
                                        if (snapshot.hasError) {
                                          print(snapshot.error.toString());
                                          return Center(
                                            child: Text(
                                                "Something wrong with message: ${snapshot.error.toString()}"),
                                          );
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          List<PaymentGateway> payment =
                                              snapshot.data;
                                          return _listPaymentGateway(payment);
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      }),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listPaymentGateway(List<PaymentGateway> dataIndex) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      child: Column(
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: ListView.builder(
              itemBuilder: (context, index) {
                PaymentGateway pymentgtwy = dataIndex[index];
                // print("data index $dataIndex");
                return Card(
                  child: InkWell(
                    onTap: () {
                      _tripModalBottomSheet(
                          context,
                          pymentgtwy.idpayment_gateway,
                          pymentgtwy.nama_provider);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ListTile(
                          selected: true,
                          leading: Text("gambar"),
                          title: Text(
                            pymentgtwy.nama_provider,
                            style: GoogleFonts.inter(
                                fontSize: 15, color: Colors.black26),
                          ),
                          trailing: Icon(Icons.keyboard_arrow_right),
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: dataIndex.length,
            ),
          )),
          // Text("Kamu memilih Pembayaran menggunakan : $rgValue")
        ],
      ),
    );
  }

  void _tripModalBottomSheet(context, int idpayment, String namaprovider) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * 100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text("Konfirmasi",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      Spacer(),
                      IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () {
                            Navigator.of(context).pop();
                          })
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RaisedButton(
                                color: Colors.green,
                                child: Text(
                                  "Lanjutkan Pembayaran $pidvoucher",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  setState(() {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                KonfirmPayment(
                                                    flagasuransi: pflagasuransi,
                                                    flagvoucher: pflagvoucher,
                                                    idlokasi: pidlokasi,
                                                    idjenis_produk:
                                                        pidjenis_produk,
                                                    idvoucher: pidvoucher,
                                                    idasuransi: pidasuransi,
                                                    harga_sewa: pharga_sewa,
                                                    durasi_sewa: pdurasi_sewa,
                                                    valuesewaawal:
                                                        pvaluesewaawal,
                                                    valuesewaakhir:
                                                        pvaluesewaakhir,
                                                    tanggal_berakhir_polis:
                                                        ptanggal_berakhir_polis,
                                                    nomor_polis: pnomor_polis,
                                                    kapasitas: pkapasitas,
                                                    alamat: palamat,
                                                    keterangan_barang:
                                                        pketerangan_barang,
                                                    nominal_barang:
                                                        pnominal_barang,
                                                    nominal_voucher:
                                                        pnominal_voucher,
                                                    minimum_transaksi:
                                                        pminimum_transaksi,
                                                    persentase_voucher:
                                                        ppersentase_voucher,
                                                    total_asuransi:
                                                        ptotal_asuransi,
                                                    totalharixharga:
                                                        ptotalharixharga,
                                                    totaldeposit: ptotaldeposit,
                                                    saldopoint: psaldopoint,
                                                    email_asuransi:
                                                        pemail_asuransi,
                                                    tambahsaldopoint:
                                                        ptambahsaldopoint,
                                                    persentase_asuransi:
                                                        ppersentase_asuransi,
                                                    idpayment_gateway:
                                                        idpayment,
                                                    minimalsewahari:
                                                        pminimalsewahari)));
                                  });
                                })
                          ],
                        ),
                        // _buttonDisable()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        print("ini pembayaran input");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Sesi Anda Berakhir!"),
      content: Text(
          "Harap masukkan kembali email beserta nomor handphone untuk mengakses fitur di aplikasi ini."),
      actions: [
        okButton,
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}
