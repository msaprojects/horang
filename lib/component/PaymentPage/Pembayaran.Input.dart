import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/paymentgateway/paymentgateway.model.dart';
import 'package:horang/api/models/paymentgateway/paymentgatewayVA.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/PaymentPage/KonfirmPayment.dart';
import 'package:horang/component/ProdukPage/Produk.List.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/format_rupiah.dart';
import 'package:horang/utils/reusable.class.dart';
import 'package:horang/widget/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormInputPembayaran extends StatefulWidget {
  late bool warna, flagasuransi, flagvoucher;
  late var idlokasi,
      idjenis_produk,
      idvoucher,
      idasuransi,
      harga_sewa,
      harga_awal,
      diskonn,
      durasi_sewa,
      valuesewaawal,
      valuesewaakhir,
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
      minimalsewahari,
      cekout,
      cekin,
      lastorder,
      gambarproduk;

  FormInputPembayaran(
      {
        required this.flagasuransi,
        required this.flagvoucher,
      this.idlokasi,
      this.idjenis_produk,
      this.idvoucher,
      this.idasuransi,
      this.harga_sewa,
      this.harga_awal,
      this.diskonn,
      this.durasi_sewa,
      this.valuesewaawal,
      this.valuesewaakhir,
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
      this.minimalsewahari,
      this.cekout,
      this.cekin,
      this.lastorder,
      this.gambarproduk});

  @override
  _FormInputPembayaran createState() => _FormInputPembayaran();
}

class _FormInputPembayaran extends State<FormInputPembayaran> {
  late SharedPreferences sp;
  ApiService _apiService = ApiService();
  int grup = 1, rgID = 1, _currentIndex = 1, rgIndex = 1, idorder = 0;
  bool _sel = false, isEnabled = true, asuransi = false, isSuccess = false;
  late String formatedate, formatedate2, rgValue = "", haurOrDay;
  var access_token,
      refresh_token,
      email,
      nama_customer,
      pflagasuransi,
      pflagvoucher,
      pidlokasi,
      pidjenis_produk,
      pidvoucher,
      pidasuransi,
      pharga_sewa,
      pharga_awal,
      pdiskon,
      pdurasi_sewa,
      pvaluesewaawal,
      pvaluesewaakhir,
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
      totaldeposit,
      hasilperhitungan,
      idcustomer,
      pcekout,
      pcekin,
      plastorder,
      pin,
      labeldiskon,
      labelhargaawal,
      pgambarproduk;

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

  settingJamOperasionalLabel() {
    if (pkapasitas.toString().toLowerCase().contains('forklift')) {
      return Visibility(visible: false, child: Text(""));
    } else {
      return Container(
        padding: const EdgeInsets.only(left: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Jam Operasional : ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text('Check In : '),
                Text(
                  pcekin.toString(),
                ),
              ],
            ),
            Row(
              children: [
                Text('Check Out : '),
                Text(
                  pcekout.toString(),
                ),
              ],
            ),
            Row(
              children: [
                Text('Last Order : '),
                Text(
                  plastorder.toString(),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  settingJamOperasional() {
    if (pkapasitas.toString().toLowerCase().contains('forklift')) {
      return Visibility(visible: false, child: Text(""));
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                pcekin.toString(),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                pcekout.toString(),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                plastorder.toString(),
              ),
            ],
          ),
        ],
      );
    }
  }

  satuanHariatauJam() {
    if (pkapasitas.toString().toLowerCase().contains('forklift')) {
      return haurOrDay = ' Jam';
    } else {
      return haurOrDay = ' Hari';
    }
  }

  Future<bool>? _backPressed() {
     Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Home(
          initIndexHome: 1, callpage: ProdukList(), //UNTUK ROUTING DARI SUATU HALAMAN KE PAGE TERTENTU MELALUI BOTTOMBAR(log trello [03-09-2021] (solved Upd.fadil 7/09/21))
        )),
        (Route<dynamic> route) => false);
  }

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    idcustomer = sp.getString("idcustomer");
    nama_customer = sp.getString("nama_customer");
    pin = sp.getString("pin");
    //checking jika token kosong maka di arahkan ke menu login jika tidak akan meng-hold token dan refresh token
    if (access_token == null) {
      ReusableClasses().showAlertDialog(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => WelcomePage()),
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
                          ReusableClasses().showAlertDialog(context);
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      WelcomePage()),
                              (Route<dynamic> route) => false);
                        }
                      }));
            }
          }));
    }
  }

  @override
  void initState() {
    pflagasuransi = widget.flagasuransi;
    pflagvoucher = widget.flagvoucher;
    pidlokasi = widget.idlokasi;
    pidjenis_produk = widget.idjenis_produk;
    pidvoucher = widget.idvoucher;
    pidasuransi = widget.idasuransi;
    pharga_sewa = widget.harga_sewa;
    pharga_awal = widget.harga_awal;
    pdiskon = widget.diskonn;
    pdurasi_sewa = widget.durasi_sewa;
    pvaluesewaawal = widget.valuesewaawal;
    pvaluesewaakhir = widget.valuesewaakhir;
    pkapasitas = widget.kapasitas;
    palamat = widget.alamat;
    pketerangan_barang = widget.keterangan_barang;
    pnominal_barang = widget.nominal_barang;
    pnominal_voucher = widget.nominal_voucher;
    pminimum_transaksi = widget.minimum_transaksi;
    ppersentase_voucher = widget.persentase_voucher;
    ptotalharixharga = widget.totalharixharga;
    psaldopoint = widget.saldopoint; //as saldo poin terpakai
    pemail_asuransi = widget.email_asuransi;
    ptambahsaldopoint = widget.tambahsaldopoint; //as tambah saldo poin
    ppersentase_asuransi = widget.persentase_asuransi;
    pminimalsewahari = widget.minimalsewahari;
    pcekin = widget.cekin;
    pcekout = widget.cekout;
    plastorder = widget.lastorder;
    pgambarproduk = widget.gambarproduk;
    ptotal_asuransi = ((double.parse(ppersentase_asuransi) / 100) *
        double.parse(pnominal_barang));
    totaldeposit = (int.parse(pminimalsewahari) * int.parse(pharga_awal));
    // pjenisitem = widget.jenisitem;
    print("Flag Asuransi? " +
        pflagasuransi.toString() +
        " ~ " +
        pdiskon.toString() +
        " ~ " +
        pnominal_voucher.toString() +
        " ~ " +
        ptotal_asuransi.toString());
    cekToken();
    hitungsemuaFunction();
    super.initState();
  }

  @override
  void dispose() {
    _apiService.client.close();
    super.dispose();
  }

  void hitungsemuaFunction() async {
    setState(() {
      hitungsemua = ReusableClasses().PerhitunganOrder(
          ppersentase_voucher.toString(),
          pminimum_transaksi.toString(),
          pflagasuransi,
          pflagvoucher,
          pnominal_voucher.toString(),
          pharga_awal.toString(),
          pdurasi_sewa.toString(),
          pnominal_barang.toString(),
          psaldopoint.toString(),
          pminimalsewahari.toString(),
          ppersentase_asuransi.toString(),
          pharga_sewa.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    var asuransitxt, vouchertxt;
    if (pflagasuransi == true) {
      asuransitxt = "Ya";
    } else {
      asuransitxt = "Tidak";
    }
    // var media = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () async {
        bool? result = await _backPressed();
        if(result == null){
          result = false;
        }
        return result;
      },
      child: Scaffold(
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
                            leading: CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.red,
                              backgroundImage: NetworkImage(pgambarproduk),
                            ),
                            title: new Text(
                              "Kapasitas : " + pkapasitas,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: new Text(
                              "Lokasi : " + palamat,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Divider(color: Colors.grey),
                          Container(
                            padding:
                                const EdgeInsets.only(left: 30, bottom: 10),
                            child: Row(
                              children: <Widget>[
                                Text("Detail Pesanan",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(left: 30),
                                child: Column(
                                  children: [
                                    // adaDiskonGak(pdiskon, pharga_awal),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Tgl. Mulai :"),
                                        Text("Tgl. Berakhir :"),
                                        Text("Durasi Sewa :"),
                                        pdiskon != 0
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("Diskon :"),
                                                  Text("Harga Awal :"),
                                                ],
                                              )
                                            : Container()
                                      ],
                                    ),
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
                                    Text(pdurasi_sewa.toString() +
                                        satuanHariatauJam()),
                                    // settingJamOperasional(),
                                    pdiskon != 0
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(pdiskon.toString() + "%"),
                                              Text(
                                                  // rupiah(pharga_awal.toString()),
                                                  // CurrencyFormat.convertToIdr(pharga_awal, 2),
                                                  "$pharga_awal",
                                                  style: TextStyle(
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                            ],
                                          )
                                        : Container()
                                    // valueDiskon(pdiskon.toString(),
                                    // pharga_awal.toString())
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
                                  // rupiah(pharga_sewa,
                                  //     separator: ',',
                                  //     trailing: " /" + satuanHariatauJam()),
                                  // CurrencyFormat.convertToIdr(pharga_sewa+satuanHariatauJam(), 2,),
                                  "$pharga_sewa/${satuanHariatauJam()}",
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold),
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
                                  children: <Widget>[Text("Ket. Barang : ")],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            padding: const EdgeInsets.only(
                                top: 0.0, right: 60, left: 40),
                            child: Text(
                              pketerangan_barang,
                              maxLines: 10,
                              overflow: TextOverflow.visible,
                              textAlign: TextAlign.justify,
                            ),
                            // ],
                          ),
                          Divider(color: Colors.grey),
                          pkapasitas
                                  .toString()
                                  .toLowerCase()
                                  .contains('forklift')
                              ? Container()
                              : settingJamOperasionalLabel(),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(color: Colors.grey),
                          Container(
                            padding:
                                const EdgeInsets.only(left: 30, bottom: 10),
                            child: Row(
                              children: <Widget>[
                                Text("Detail Pembayaran",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
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
                                  // rupiah(ptotalharixharga, separator: ','),
                                  // CurrencyFormat.convertToIdr(ptotalharixharga, 2)
                                  "$ptotalharixharga"
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
                                  // rupiah(totaldeposit, separator: ','),
                                  // CurrencyFormat.convertToIdr(totaldeposit, 2)
                                  "$totaldeposit"
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
                                    Text("Poin Deposit Terpakai : ")
                                  ],
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.only(top: 0.0, right: 60),
                                child: Text(
                                  "-" + "$psaldopoint"
                                  // CurrencyFormat.convertToIdr(psaldopoint, 2)
                                  // rupiah(psaldopoint, separator: ','),
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
                                  "-" + "$pnominal_voucher"
                                  // CurrencyFormat.convertToIdr(pnominal_voucher,2)
                                  // rupiah(pnominal_voucher),
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
                                child: Text(
                                  // rupiah(
                                  //   ptotal_asuransi,
                                  // ),
                                  // CurrencyFormat.convertToIdr(ptotal_asuransi, 2),
                                  "$ptotal_asuransi",
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
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
                                  "$pnominal_barang",
                                  // CurrencyFormat.convertToIdr(pnominal_barang, 2),
                                      // rupiah(pnominal_barang + " )"),
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Divider(color: Colors.grey),
                          SizedBox(
                            height: 15,
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
                                  "$hitungsemua",
                                  // rupiah(hitungsemua),
                                  // CurrencyFormat.convertToIdr(hitungsemua, 2),
                                  style: (TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
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
                                  Card(
                                    child: Container(
                                      child: ExpansionTile(
                                        title: Text(
                                          "Instant Payment : ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SafeArea(
                                                child: FutureBuilder(
                                                    future: _apiService
                                                        .listPaymentGateway(
                                                            access_token),
                                                    // .listPaymentGatewayVA(),
                                                    builder: (context,
                                                        // AsyncSnapshot<List<PaymentGatewayVirtualAccount>>
                                                        AsyncSnapshot<
                                                                List<
                                                                    PaymentGateway>?>
                                                            snapshot) {
                                                      if (snapshot.hasError) {
                                                        print(snapshot.error
                                                            .toString());
                                                        return Center(
                                                          child: Text(
                                                              "Koneksi anda bermasalah harap kembali ke halaman sebelumnya."),
                                                        );
                                                      } else if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      } else if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .done) {
                                                        // List<PaymentGatewayVirtualAccount> payment =
                                                        List<PaymentGateway>
                                                            payment =
                                                            snapshot.data!;
                                                        return _listPaymentGateway(
                                                            payment);
                                                      } else {
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      }
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // padding: EdgeInsets.only(
                                    //   left: 16,
                                    //   right: 16,
                                    // ),
                                    child: Card(
                                      child: Container(
                                        child: ExpansionTile(
                                          title: Text(
                                            "Virtual Account : ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SafeArea(
                                                  child: FutureBuilder(
                                                      future: _apiService
                                                          .listPaymentGatewayVA(),
                                                      // .listPaymentGatewayVA(),
                                                      builder: (context,
                                                          // AsyncSnapshot<List<PaymentGatewayVirtualAccount>>
                                                          AsyncSnapshot<
                                                                  List<
                                                                      PaymentGatewayVirtualAccount>?>
                                                              snapshot) {
                                                        if (snapshot.hasError) {
                                                          print(snapshot.error
                                                              .toString());
                                                          return Center(
                                                            child: Text(
                                                                "Koneksi anda bermasalah harap kembali ke halaman sebelumnya."),
                                                          );
                                                        } else if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        } else if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .done) {
                                                          List<PaymentGatewayVirtualAccount>
                                                              paymentz =
                                                              snapshot.data!;
                                                          print(
                                                              'aqua ${snapshot.data}');
                                                          return _listPaymentGatewayVA(
                                                              paymentz);
                                                        } else {
                                                          return Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        }
                                                      }),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
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
      ),
    );
  }

  Widget _listPaymentGatewayVA(List<PaymentGatewayVirtualAccount> dataIndex) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.30,
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
                PaymentGatewayVirtualAccount pymentgtwyVA = dataIndex[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      _tripModalBottomSheet(context, pymentgtwyVA.code, pymentgtwyVA.name);
                      // _tripModalBottomSheet(context, int.parse(pymentgtwyVA.code),
                      //     pymentgtwyVA.name);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Center(
                            child: Text(pymentgtwyVA.code.toString(),
                                style: GoogleFonts.inter(
                                    fontSize: 15, color: Colors.black87)),
                          ),
                          selected: true,
                          leading: Container(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(pymentgtwyVA.name)),
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
        ],
      ),
    );
  }

  Widget _listPaymentGateway(List<PaymentGateway>? dataIndex) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: ListView.builder(
              itemBuilder: (context, index) {
                // PaymentGatewayVirtualAccount pymentgtwy = dataIndex[index];
                PaymentGateway pymentgtwy = dataIndex![index];
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
                          title: Center(
                            child: Text(pymentgtwy.nama_provider,
                                style: GoogleFonts.inter(
                                    fontSize: 15, color: Colors.black87)),
                          ),
                          selected: true,
                          leading: Container(
                            padding: EdgeInsets.only(left: 20),
                            child: Image(
                              height: 50,
                              width: 50,
                              image: NetworkImage(pymentgtwy.gambar.toString()),
                            ),
                          ),
                          trailing: Icon(Icons.keyboard_arrow_right),
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: dataIndex?.length,
            ),
          )),
        ],
      ),
    );
  }

  void _tripModalBottomSheet(context, var idpayment, String namaprovider) {
    print('debugmasuksini');
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Colors.white,
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
                        Center(
                          child: Text(
                              "Anda akan melakukan pembayaran menggunakan $namaprovider",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                                "Dengan ini Saya menyatakan persetujuan kepada Horang Apps untuk memperoleh dan menggunakan kontainer yang sudah saya pesan sesuai kebijakan yang berlaku",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.inter(
                                    height: 1.5, fontSize: 14))),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RaisedButton(
                                color: Colors.green,
                                child: Text(
                                  "Lanjutkan Pembayaran",
                                  // "Lanjutkan Pembayaran $idpayment",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  // print('heeyyyyy ' + pjenisitem.toString());
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
                                                    totalharixharga:
                                                        ptotalharixharga,
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
                                                        pminimalsewahari,
                                                    harga_awal: pharga_awal,
                                                    namaprovider: namaprovider,
                                                    )));
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
