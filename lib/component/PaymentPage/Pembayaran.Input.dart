import 'package:flutter/material.dart';
import 'package:horang/api/models/order/order.model.dart';
import 'package:horang/api/models/paymentgateway/paymentgateway.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/OrderPage/KonfirmasiOrder.Detail.dart';
import 'package:indonesia/indonesia.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormInputPembayaran extends StatefulWidget {
//  OrderProduk orderProduk;
//  BodyPembayaran({this.orderProduk});
  bool warna;
  var idlokasi,
      idjenis_produk,
      idcustomer,
      keterangan,
      jumlah_sewa,
      flagasuransi,
      flagvoucher,
      idasuransi,
      nomor_polis,
      tanggal_berakhir_polis,
      idvoucher,
      kapasitas,
      harga,
      alamat,
      tanggal_mulai,
      keterangan_barang,
      nominal_barang,
      total_harga,
      tanggal_akhir;
  FormInputPembayaran(
      {this.idlokasi,
      this.idjenis_produk,
      this.keterangan,
      this.jumlah_sewa,
      this.flagasuransi,
      this.flagvoucher,
      this.idasuransi,
      this.nomor_polis,
      this.tanggal_berakhir_polis,
      this.idvoucher,
      this.kapasitas,
      this.harga,
      this.alamat,
      this.tanggal_mulai,
      this.keterangan_barang,
      this.nominal_barang,
      this.total_harga,
      this.tanggal_akhir});

  @override
  _FormInputPembayaran createState() => _FormInputPembayaran();
}

class _FormInputPembayaran extends State<FormInputPembayaran> {
  ApiService _apiService = ApiService();
  int grup = 1;
  var rgIndex = 1;
  int rgID = 1;
  String rgValue = "OVO";

  SharedPreferences sp;
  bool isSuccess = false;
  int idorder = 0;
  var access_token, refresh_token, email, nama_customer;
  var idlokasi,
      idjenis_produk,
      idcustomer,
      keterangan,
      jumlah_sewa,
      flagasuransi,
      flagvoucher,
      idasuransi,
      nomor_polis,
      tanggal_berakhir_polis,
      idvoucher,
      skapasitas,
      sharga,
      salamat,
      sketerangan_barang,
      snominal_barang,
      stotal_harga,
      stanggal_mulai,
      stanggal_akhir,
      totallharga;

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
//    if(widget.orderProduk !=null){
    idlokasi = widget.idlokasi;
    idjenis_produk = widget.idjenis_produk;
    keterangan = widget.keterangan;
    jumlah_sewa = widget.jumlah_sewa;
    sharga = widget.harga;
    flagvoucher = widget.flagvoucher;
    flagasuransi = widget.flagasuransi;
    idasuransi = widget.idasuransi;
    nomor_polis = widget.nomor_polis;
    tanggal_berakhir_polis = widget.tanggal_berakhir_polis;
    idvoucher = widget.idvoucher;
    skapasitas = widget.kapasitas;
    salamat = widget.alamat;
    stanggal_mulai = widget.tanggal_mulai;
    stanggal_akhir = widget.tanggal_akhir;
    sketerangan_barang = widget.keterangan_barang;
    snominal_barang = widget.nominal_barang;
    stotal_harga = widget.total_harga;
    print("Cek IDJENIS ${idjenis_produk}");
//    }
    cekToken();
  }

  Widget _listPaymentGateway(List<PaymentGateway> dataIndex) {
    return Container(
      height: 200,
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                PaymentGateway payment = dataIndex[index];
                return Card(
                  child: Expanded(
                    child: InkWell(
                      highlightColor: Colors.lightGreen,
                      onTap: () {
                        rgValue = payment.nama_provider;
                        rgID = payment.idpayment_gateway;
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            payment.nama_provider,
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "Biaya Layanan : ",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              Text(
                                "Rp. " + payment.nominal_biaya.toString(),
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: dataIndex.length,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var asuransitxt, vouchertxt;
    if (flagasuransi == 1) {
      asuransitxt = "Ya";
    } else {
      asuransitxt = "Tidak";
    }
    totallharga = double.parse(stotal_harga) +
        50000.00 +
        double.parse(sharga.toString()) -
        double.parse(sharga.toString());
    var media = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rincian Pesanan Anda",
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
                            skapasitas,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: new Text(
                            salamat,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8, left: 36, top: 8),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 50, bottom: 15),
                          child: Row(
                            children: <Widget>[
                              Text("Detail Pesanan",
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 50),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Durasi Sewa :"),
                                  Text("Tanggal Mulai :"),
                                  Text("Tanggal Berakhir :"),
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
                                    jumlah_sewa.toString() + " Hari",
                                  ),
                                  Text(
                                    stanggal_mulai,
                                  ),
                                  Text(
                                    stanggal_akhir,
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
                              padding: const EdgeInsets.only(left: 50),
                              child: Row(
                                children: <Widget>[Text("Nominal Barang :")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Text(
                                rupiah(snominal_barang,
                                    separator: ',', trailing: '.00'),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Divider(
                          height: 16,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 50, bottom: 15),
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
                              padding: const EdgeInsets.only(left: 50),
                              child: Row(
                                children: <Widget>[Text("Harga Sewa :")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Text(
                                rupiah(sharga,
                                    separator: ',', trailing: '.00' + "/hari"),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 50),
                              child: Row(
                                children: <Widget>[Text("Subtotal :")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Text(
                                "+" +
                                    rupiah(stotal_harga,
                                        separator: ',', trailing: '.00'),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 50),
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
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 50),
                              child: Row(
                                children: <Widget>[Text("Nominal Asuransi :")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Text(
                                "+Rp. 50000.00",
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 50),
                              child: Row(
                                children: <Widget>[Text("Deposit :")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Text(
                                "+" +
                                    rupiah(sharga,
                                        separator: ',', trailing: '.00'),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 50),
                              child: Row(
                                children: <Widget>[Text("Deposit Terpakai :")],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 60),
                              child: Text(
                                "-" +
                                    rupiah(sharga,
                                        separator: ',', trailing: '.00'),
                              ),
                            ),
                          ],
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
                              padding: const EdgeInsets.only(left: 50),
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
                                rupiah(totallharga,
                                    separator: ',', trailing: '.00'),
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
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  //FOR LISTVIEW PEMBAYARAN
                  SafeArea(
                    child: FutureBuilder(
                      future: _apiService.listPaymentGateway(access_token),
                      builder: (context,
                          AsyncSnapshot<List<PaymentGateway>> snapshot) {
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
                          List<PaymentGateway> payment = snapshot.data;
                          return _listPaymentGateway(payment);
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                  //END LISTVIEW PEMBAYARAN
                  Container(
                    width: MediaQuery.of(context).size.width / 1,
                    height: 60,
                    padding: EdgeInsets.only(left: 10, right: 10),
                    margin: EdgeInsets.only(top: 3),
                    child: RaisedButton(
                      color: Colors.blue[300],
                      onPressed: () {
                        OrderProduk orderProduk = OrderProduk(
                            token: access_token,
                            idlokasi: idlokasi,
                            idjenis_produk: idjenis_produk,
                            jumlah_sewa: jumlah_sewa,
                            idasuransi: 1,
                            idvoucher: idvoucher,
                            flagasuransi: flagasuransi,
                            flagvoucher: flagvoucher,
                            idpayment_gateway: rgID,
                            flag_selesai: 0,
                            harga: double.parse(sharga.toString()),
                            total_harga: double.parse(totallharga.toString()),
                            deposit_tambah: double.parse(sharga.toString()),
                            deposit_pakai: double.parse(sharga.toString()),
                            keterangan: keterangan.toString(),
                            nomor_polis: nomor_polis,
                            tanggal_berakhir_polis: tanggal_berakhir_polis,
                            tanggal_mulai: stanggal_mulai,
                            tanggal_akhir: stanggal_akhir,
                            nominal_barang: double.parse("0.0"),
                            keterangan_barang: sketerangan_barang,
                            tanggal_order: "DATE(NOW())",
                            nominal_deposit: double.parse(sharga.toString()),
                            keterangan_deposit: "-");
                        print("JSONVAL_:" + orderProduk.toString());
                        _apiService
                            .tambahOrderProduk(orderProduk)
                            .then((idorder) {
                          if (idorder != 0) {
                            print("body " + idorder.toString());
//                            print(orderProduk.toString());
//                            _scaffoldState.currentState.showSnackBar(SnackBar(
//                              content: Text("Berhasil"),
//                            ));
//                          _apiService.getOrderSukses();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => KonfirmasiOrderDetail(
                                        idorder: idorder)));
                          } else {
                            print(orderProduk.toString());
//                            _scaffoldState.currentState.showSnackBar(SnackBar(
//                              content: Text("GAGAL" + orderProduk.toString()),
//                            ));
                          }
                        });
                      },
                      child: Text(
                        "Pembayaran yang anda Pilih ${rgValue}",
                        style: (TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
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
