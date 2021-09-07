import 'dart:convert';
import 'package:commons/commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/voucher/voucher.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/PaymentPage/Pembayaran.Input.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/reusable.class.dart';
import 'package:indonesia/indonesia.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormInputOrder extends StatefulWidget {
  num idlokasi,
      idjenis_produk,
      harga,
      avail,
      diskon,
      harganett,
      min_sewa,
      min_deposit;
  var tanggaljamawal,
      tanggaljamakhir,
      kapasitas,
      keterangan,
      gambar,
      nama_kota,
      nama_lokasi;
  FormInputOrder(
      {this.tanggaljamawal,
      this.tanggaljamakhir,
      this.idlokasi,
      this.idjenis_produk,
      this.harga,
      this.avail,
      this.diskon,
      this.harganett,
      this.min_sewa,
      this.kapasitas,
      this.keterangan,
      this.gambar,
      this.nama_kota,
      this.nama_lokasi,
      this.min_deposit});

  @override
  _FormDetailOrder createState() => _FormDetailOrder();
}

class _FormDetailOrder extends State<FormInputOrder> {
  //DEKLARASI VARIABEL
  bool isLoading = false,
      boolasuransi = true,
      boolsk = false,
      boolvoucher = false,
      tekanvoucher = false,
      isSuccess = false,
      flagasuransi = true,
      flagvoucher = false,
      fieldnominalbarang,
      fieldketeranganbarang = false,
      boolkontainer = true;
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
      jamcheckout = "",
      jamcheckin = "",
      jamlastorder = "",
      idcustomer,
      pin,
      nama_customer,
      sk
      // jenisitem1
      ;

  num vdurasi_sewa,
      idjenis_produk,
      idasuransi,
      idlokasi,
      vminimumtransaksi = 0,
      harga_sewa,
      vpersentasevoucher = 0,
      vmaksimalpotongan = 0,
      minimaldeposit = 0,
      nomasuransi = 0,
      idvoucher = 0,
      totaldeposit = 0,
      potonganvoucher = 0,
      diskon,
      harga_awal,
      min_sewa = 0,
      min_deposit = 0;
  DateTime dtAwal, dtAkhir;
  int ssk;

  // var _controller = ScrollController();
  // var _isVisible = false;

  final scrollController = ScrollController();
  var buttonVisible = false.obs;

  _FormDetailOrder() {
    scrollController.addListener(() {
      if (!buttonVisible.value)
        buttonVisible.value = scrollController.position.atEdge;
    });
  }

  //END DEKLARASI VARIABEL
  //CALLING REFFERENCE
  SharedPreferences sp;
  ApiService _apiService = ApiService();
  TextStyle valueTglAwal = TextStyle(fontSize: 16.0);
  TextStyle valueTglAkhir = TextStyle(fontSize: 16.0);
  TextEditingController _keteranganbarang = TextEditingController();
  final TextEditingController _nominalbarang = TextEditingController();
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
        // .inMinutes)
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

  Future<String> _ambildataSK() async {
    http.Response response = await http
        .get(Uri.encodeFull('https://dev.horang.id/adminmaster/sk.txt'));
    // .get(Uri.encodeFull('https://server.horang.id/adminmaster/skorder.txt'));
    return sk = response.body;
  }

  void hitungsemuaFunction() async {
    setState(() {
      hitungsemua = ReusableClasses().PerhitunganOrder(
        vpersentasevoucher.toString(),
        vminimumtransaksi.toString(),
        flagasuransi,
        flagvoucher,
        vmaksimalpotongan.toString(),
        harga_awal.toString(),
        vdurasi_sewa.toString(),
        _nominalbarang.text.toString(),
        totaldeposit.toString(),
        minimaldeposit.toString(),
        nomasuransi.toString(),
        harga_sewa.toString(),
      );
    });
  }

  cleartextinputnominal() {
    _nominalbarang.clear();
    _keteranganbarang.clear();
  }

  adaDiskonGakOrderInput() {
    if (diskon != 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rupiah(harga_sewa.toString(), separator: '.') + " /" + vsatuan_sewa,
            style: TextStyle(
                fontSize: 18,
                color: Colors.red[600],
                fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Text(
                rupiah(harga_awal.toString(), separator: '.'),
                // jenisProduk.harga.toString(),
                style: GoogleFonts.inter(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.lineThrough),
                overflow: TextOverflow.fade,
              ),
              Text(' ($diskon%)',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ))
            ],
          ),
        ],
      );
    } else {
      return Text(
        rupiah(harga_sewa.toString(), separator: '.') + " /" + vsatuan_sewa,
        style: TextStyle(
            fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold),
      );
    }
  }

  settingJamOperasional() {
    if (kapasitas.toLowerCase().contains('forklift')) {
      return Visibility(
          child: Text(
        '',
        style: TextStyle(fontSize: 0),
      ));
    } else {
      return Column(
        children: [
          // Divider(),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding:
                            const EdgeInsets.only(bottom: 8, left: 36, top: 8),
                        child: Text(
                          "Jam Operasional",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 38),
                child: Text("Jam Check In     "),
              ),
              Text(" : "),
              Container(
                padding: const EdgeInsets.only(left: 38),
                child: Text(jamcheckin.toString()),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 38),
                child: Text("Jam Check Out  "),
              ),
              Text(" : "),
              Container(
                padding: const EdgeInsets.only(left: 38),
                child: Text(jamcheckout.toString()),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            height: 20,
            thickness: 10,
            // indent: 20,
            // endIndent: 20,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     Container(
          //       padding: const EdgeInsets.only(left: 38),
          //       child: Text("Jam Close Order".toString()),
          //     ),
          //     Text(" : "),
          //     Container(
          //       padding: const EdgeInsets.only(left: 38),
          //       child: Text(jamlastorder.toString()),
          //     ),
          //   ],
          // ),
        ],
      );
    }
  }

  //END ADDON

//INIT STATE
  @override
  void initState() {
    cekToken();
    print("VALUE ORDER? : " +
        widget.tanggaljamawal +
        " ~ " +
        widget.tanggaljamakhir +
        " ~ " +
        widget.idlokasi.toString() +
        " ~ " +
        widget.idjenis_produk.toString() +
        " ~ " +
        widget.harga.toString() +
        " ~ " +
        widget.avail.toString() +
        " ~ " +
        widget.diskon.toString() +
        " ~ " +
        widget.harganett.toString() +
        " ~ " +
        widget.min_sewa.toString() +
        " ~ " +
        widget.kapasitas.toString() +
        " ~ " +
        widget.keterangan +
        " ~ " +
        widget.gambar +
        " ~ " +
        widget.nama_kota +
        " ~ " +
        widget.nama_lokasi);
    // getSetting(access_token, idlokasi);
    tekanvoucher = !tekanvoucher;
    if (_nominalbarang.text == "") _nominalbarang.text = "0";
    idjenis_produk = widget.idjenis_produk;
    kapasitas = widget.kapasitas.toString();
    alamat = widget.nama_lokasi;
    keterangan = widget.keterangan;
    idlokasi = widget.idlokasi;
    produkimage = widget.gambar;
    diskon = widget.diskon;
    harga_awal = widget.harga;
    valueawal = widget.tanggaljamawal;
    valueakhir = widget.tanggaljamakhir;
    min_sewa = widget.min_sewa;
    minimaldeposit = widget.min_deposit;
    if (diskon != 0) {
      harga_sewa = widget.harganett;
    } else {
      harga_sewa = widget.harga;
    }

    if (kapasitas.toLowerCase().contains('forklift')) {
      boolkontainer = false;
      flagasuransi = false;
      boolasuransi = false;
      boolsk = false;
      vsatuan_sewa = "jam ";
      vdurasi_sewa =
          diffInTime(DateTime.parse(valueawal), DateTime.parse(valueakhir));
    } else {
      flagasuransi = true;
      boolkontainer = true;
      boolsk = false;
      vsatuan_sewa = "hari ";
      vdurasi_sewa =
          diffInDays(DateTime.parse(valueawal), DateTime.parse(valueakhir));
    }
    print('flagasuransine? $flagasuransi');
    totalhariharga = vdurasi_sewa * harga_sewa;
    hargaxminimalsewadeposit = harga_awal * minimaldeposit;
    if (ceksaldo >= hargaxminimalsewadeposit) {
      totaldeposit = hargaxminimalsewadeposit;
    } else {
      totaldeposit = ceksaldo;
    }
    print("Harga sewa x hari?" + totalhariharga.toString());
    if (flagasuransi == true) {
      _nominalbarang.addListener(() {
        setState(() {
          total_asuransi = (nomasuransi / 100) *
              double.parse(_nominalbarang.text.toString());
          hitungsemuaFunction();
        });
      });
    }

    hitungsemuaFunction();

    super.initState();
  }
//END INITSTATE

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: GestureDetector(
          child: Text(
            "Checkout",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              reverse: true,
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
                              height: 10,
                            ),
                            adaDiskonGakOrderInput()
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
                    height: 12,
                  ),
                  // Divider(
                  //   height: 20,
                  //   thickness: 2,
                  // indent: 20,
                  // endIndent: 20,
                  // ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
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
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 38, right: 38),
                              child: Text(keterangan),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    height: 20,
                    thickness: 10,
                    color: Colors.grey[300],
                    // indent: 20,
                    // endIndent: 20,
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(
                                    bottom: 8, left: 36, top: 8),
                                child: Text(
                                  "Durasi Sewa ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 38),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(valueawal,
                                        style: GoogleFonts.inter(fontSize: 14)),
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
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 38, top: 5),
                                child: Row(
                                  children: [
                                    Text(
                                        "( " +
                                            vdurasi_sewa.toString() +
                                            " " +
                                            vsatuan_sewa +
                                            ")",
                                        style: GoogleFonts.inter(fontSize: 14)),
                                    Text(
                                        "+(Deposit " +
                                            minimaldeposit.toString() +
                                            " " +
                                            vsatuan_sewa +
                                            ")",
                                        style: GoogleFonts.inter(fontSize: 14)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // Divider(
                  //   height: 20,
                  //   thickness: 2,
                  // indent: 20,
                  // endIndent: 20,
                  // ),
                  settingJamOperasional(),
                  // Divider(),

                  SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {});
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => Container(
                              height: MediaQuery.of(context).size.height * 0.50,
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(25.0),
                                  topRight: const Radius.circular(25.0),
                                ),
                              ),
                              child: SafeArea(
                                  child: FutureBuilder(
                                      future:
                                          _apiService.listVoucher(access_token),
                                      builder: (context,
                                          AsyncSnapshot<List<VoucherModel>>
                                              snapshot) {
                                        if (snapshot.hasError) {
                                          return Center(
                                            child: Text(
                                                "Something wrong with message: ${snapshot.error.toString()}"),
                                          );
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          List<VoucherModel> vclist =
                                              snapshot.data;
                                          return _buildListvoucher(vclist);
                                        }
                                      }))));
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.only(left: 30, right: 30, top: 5),
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.wallet_giftcard_outlined,
                              color: Colors.blue),
                          enabled: false,
                          hintText: potonganvoucher.toString() == "0"
                              ? getVoucher
                              : "Potongan : " +
                                  rupiah(potonganvoucher.toString()),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    height: 20,
                    thickness: 10,
                    // indent: 20,
                    // endIndent: 20,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Container(
                              //   padding: const EdgeInsets.only(
                              //       bottom: 3, left: 36, top: 8),
                              //   child: Text(
                              //     "Addon Sewa",
                              //     style: TextStyle(
                              //       fontWeight: FontWeight.bold,
                              //     ),
                              //   ),
                              // ),
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 20, top: 0),
                                child: kapasitas
                                        .toLowerCase()
                                        .contains('kontainer')
                                    ? Row(
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
                                                print("Flag? " +
                                                    flagasuransi.toString());
                                              });
                                            },
                                          ),
                                          SizedBox(width: 8.0),
                                          Text("Asuransi (" +
                                              nomasuransi.toString() +
                                              "%)"),
                                        ],
                                      )
                                    : Text(
                                        '',
                                        style: TextStyle(fontSize: 0),
                                      ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              // boolkontainer == true
                              boolkontainer == false
                                  ? Text("")
                                  : Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 30, right: 30, top: 5),
                                          child: TextFormField(
                                            scrollPadding:
                                                MediaQuery.of(context)
                                                    .viewInsets,
                                            onTap: () {
                                              if (_nominalbarang.text == "0") {
                                                cleartextinputnominal();
                                              }
                                            },
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    decimal: true),
                                            decoration: InputDecoration(
                                              labelText: 'Total Nominal Barang',
                                              hintText:
                                                  'Masukkan Total Nominal Barang',
                                              border:
                                                  const OutlineInputBorder(),
                                            ),
                                            controller: _nominalbarang,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              // ignore: deprecated_member_use
                                              WhitelistingTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            onChanged: (value) {
                                              bool isFieldValid =
                                                  value.trim().isNotEmpty;
                                              if (isFieldValid !=
                                                  fieldnominalbarang) {
                                                setState(() =>
                                                    fieldnominalbarang =
                                                        isFieldValid);
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
                                              hintText:
                                                  'Masukkan Keterangan Barang',
                                              border:
                                                  const OutlineInputBorder(),
                                            ),
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: 3,
                                            controller: _keteranganbarang,
                                            onChanged: (value) {
                                              bool isFieldValid =
                                                  value.trim().isNotEmpty;
                                              if (isFieldValid !=
                                                  fieldketeranganbarang) {
                                                setState(() =>
                                                    fieldketeranganbarang =
                                                        isFieldValid);
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                              SizedBox(width: 0.0),
                              Row(
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.only(left: 20, top: 5),
                                    child: Row(
                                      children: <Widget>[
                                        Checkbox(
                                          value: boolsk,
                                          onChanged: (bool syaratketentuan) {
                                            setState(() {
                                              boolsk = syaratketentuan;
                                              if (boolsk == true) {
                                                ssk = 1;
                                                buttonVisible.value = false;
                                                showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder:
                                                        (context) =>
                                                            WillPopScope(
                                                              onWillPop:
                                                                  () async =>
                                                                      false,
                                                              child:
                                                                  AlertDialog(
                                                                title: Text(
                                                                    'Syarat dan Ketentuan'),
                                                                content:
                                                                    SingleChildScrollView(
                                                                  controller:
                                                                      scrollController,
                                                                  child: Text(
                                                                      '$sk'),
                                                                ),
                                                                actions: [
                                                                  Obx(() =>
                                                                      Visibility(
                                                                          visible: buttonVisible
                                                                              .value,
                                                                          child:
                                                                              ElevatedButton(
                                                                            child:
                                                                                Text("Setuju"),
                                                                            onPressed:
                                                                                () {
                                                                              ssk = 1;
                                                                              Navigator.pop(context);
                                                                              print('$boolsk');
                                                                            },
                                                                          )))
                                                                ],
                                                              ),
                                                            ));
                                                print("ssk $ssk");
                                              } else {
                                                ssk = 0;
                                                print("ssk1 $ssk");
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsets.only(left: 20, top: 5),
                                    child: Text(
                                      "(*) Syarat dan Ketentuan berlaku",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                          fontStyle: FontStyle.italic,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ],
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
                  // width: 130,
                  width: MediaQuery.of(context).size.width / 3,
                  height: 100,
                  // margin: EdgeInsets.only(top: 3),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blueAccent)),
                    onPressed: () {
                      LanjutkanPembayaranClick();
                    },
                    child: Text(
                      "Lanjutkan Pembayaran",
                      textAlign: TextAlign.center,
                      style: (TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white)),
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
    warningDialog(context,
        "Hai, Maaf saldo poin anda sebesar ${ceksaldo} tidak mencukupi untuk biaya deposit, $kondisisaldo ",
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
            harga_awal: harga_awal,
            diskonn: diskon,
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
            cekout: jamcheckout,
            cekin: jamcheckin,
            lastorder: jamlastorder,
            gambarproduk: produkimage);
      }));
    });
  }

  orderConfirmation(BuildContext context) {
    infoDialog(context,
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
            harga_awal: harga_awal,
            diskonn: diskon,
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
            cekout: jamcheckout,
            cekin: jamcheckin,
            lastorder: jamlastorder,
            gambarproduk: produkimage);
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
                        flagvoucher = true;
                        potonganvoucher = ReusableClasses().hitungvoucher(
                            vpersentasevoucher.toString(),
                            vminimumtransaksi.toString(),
                            flagvoucher,
                            vmaksimalpotongan.toString(),
                            harga_sewa.toString(),
                            vdurasi_sewa.toString());
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
                            height: 500,
                            child: SizedBox(
                              width: 170,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Kode : " +
                                      voucherlist.kode_voucher.toString()),
                                  Text(
                                    "Min. Transaksi : " +
                                        rupiah(
                                            voucherlist.min_nominal.toString()),
                                    overflow: TextOverflow.clip,
                                    softWrap: false,
                                  ),
                                  Text("Potongan : " +
                                      rupiah(voucherlist.nominal_persentase
                                          .toString())),
                                  Text(
                                    "Potongan (%) : " +
                                        voucherlist.persentase.toString() +
                                        " %",
                                    softWrap: false,
                                    overflow: TextOverflow.visible,
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
    idcustomer = sp.getString("idcustomer");
    nama_customer = sp.getString("nama_customer");
    pin = sp.getString("pin");
    print("Order: " + access_token);
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
    getAsuransi();
    getSaldo();
    getSetting(access_token, idlokasi);
    _ambildataSK();
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
    jamcheckout = json.decode(response.body)[0]['nilai'];
    jamcheckin = json.decode(response.body)[1]['nilai'];
    jamlastorder = json.decode(response.body)[2]['nilai'];
  }

  LanjutkanPembayaranClick() {
    hitungsemuaFunction();
    if (boolkontainer == true) {
      if (_nominalbarang.text.toString() == "0" ||
          _nominalbarang.text.toString() == "") {
        errorDialog(context,
            "Nominal Barang Tidak boleh 0 atau kurang, karena nominal barang menentukan nominal klaim garansi jika ada hal yang tidak kita inginkan bersama.");
      } else {
        if (_keteranganbarang.text.toString() == "" ||
            _keteranganbarang.text.toString() == "0" ||
            _keteranganbarang.text.toString() == "-") {
          errorDialog(context,
              "Keterangan barang tidak boleh kosong, atau di isi 0 ataupun -");
        } else {
          if (boolsk == false) {
            warningDialog(context,
                'Mohon untuk menyetujui syarat dan ketentuan yang berlaku terlebih dahulu.',
                title: "Perhatian");
          } else {
            setState(() {
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
                    "untuk melanjutkan transaksi minimum saldo point ${minimaldeposit} ${vsatuan_sewa} dari harga normal sebesar ${rupiah(harga_awal)} total ${rupiah(hargaxminimalsewadeposit)}, setuju untuk menambah poin deposit sebesar ${rupiah(saldodepositkurangnominaldeposit)}?";
                cekDeposit(context);
              }
            });
          }
        }
      }
    } else {
      if (boolsk == false) {
        warningDialog(context,
            'Baca dan accept syarat dan ketentuan yang berlaku terlebih dahulu !');
      } else {
        setState(() {
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
                "untuk melanjutkan transaksi minimum saldo point ${minimaldeposit} ${vsatuan_sewa} dari harga normal sebesar ${rupiah(harga_awal)} total ${rupiah(hargaxminimalsewadeposit)}, setuju untuk menambah poin deposit sebesar ${rupiah(saldodepositkurangnominaldeposit)}?";
            cekDeposit(context);
          }
        });
      }
    }
  }
}
