import 'package:flutter/material.dart';
import 'package:horang/api/models/order/order.sukses.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/widget/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';


final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class KonfirmasiOrderDetail extends StatefulWidget {
  int idorder;
  KonfirmasiOrderDetail({this.idorder});
  @override
  _KonfirmasiOrderDetail createState() => _KonfirmasiOrderDetail();
}

class _KonfirmasiOrderDetail extends State<KonfirmasiOrderDetail> {
  ApiService _apiService = ApiService();
  SharedPreferences sp;
  bool isSuccess = false;
  var access_token, refresh_token, email, nama_customer, idcustomer, idorders = 0;

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    idcustomer = sp.getString("idcustomer");
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
    idorders = widget.idorder;
    cekToken();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: _apiService.listOrderSukses(access_token, idorders),
        builder:
            (BuildContext context, AsyncSnapshot<List<OrderSukses>> snapshot) {
          print("hmm : ${snapshot.connectionState}");
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<OrderSukses> orderstatuss = snapshot.data;
            return _designForm(orderstatuss);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _designForm(List<OrderSukses> dataIndex) {
    OrderSukses orders;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Pesanan Anda",
          style: TextStyle(color: Colors.white),
        ),
        //Blocking Back
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                left: 5,
                right: 5,
              ),
              color: Colors.grey[100],
              child: ListView.builder(
                itemBuilder: (context, index){
                  OrderSukses os = dataIndex[index];
                  print("KOREF"+os.kode_refrensi);
                  return Card(
                    child: new Column(
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: <Widget>[Text("No. Order :", style: TextStyle(fontWeight: FontWeight.bold),)],
                              ),
                            ),
                            Container(
                              padding:
                              const EdgeInsets.only(top: 0.0, right: 20),
                              child: Text(
                                os.no_order, style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: <Widget>[Text("Nomor Kontainer :")],
                              ),
                            ),
                            Container(
                              padding:
                              const EdgeInsets.only(top: 0.0, right: 20),
                              child: Text(
                                os.kode_kontainer, style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: <Widget>[Text("Durasi :")],
                              ),
                            ),
                            Container(
                              padding:
                              const EdgeInsets.only(top: 0.0, right: 20),
                              child: Text(
                                os.jumlah_sewa.toString(), style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: <Widget>[Text("Asuransi :")],
                              ),
                            ),
                            Container(
                              padding:
                              const EdgeInsets.only(top: 0.0, right: 20),
                              child: Text(
                                'Ya, Rp. 50.000',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: <Widget>[Text("Voucher :")],
                              ),
                            ),
                            Container(
                              padding:
                              const EdgeInsets.only(top: 0.0, right: 20),
                              child: Text(
                                'Tidak, Rp. 0',
                              ),
                            ),
                          ],
                        ),Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: <Widget>[Text("Harga Sewa :")],
                              ),
                            ),
                            Container(
                              padding:
                              const EdgeInsets.only(top: 0.0, right: 20),
                              child: Text(
                                os.harga.toString(),
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
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: <Widget>[Text("No. Pembayaran :", style: TextStyle(fontWeight: FontWeight.bold),)],
                              ),
                            ),
                            Container(
                              padding:
                              const EdgeInsets.only(top: 0.0, right: 20),
                              child: Text(
                                os.kode_refrensi,style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: <Widget>[Text("Pembayaran")],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(right: 20),
                              child: Text(
                                os.nama_provider,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: <Widget>[Text("Status Pembayaran")],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(right: 20),
                              child: Text(
                                'Berhasil',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: <Widget>[Text("Total Pembayaran")],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(right: 20),
                              child: Text(
                                os.total_harga.toString(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1,
                          height: 60,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          margin: EdgeInsets.only(top: 3),
                          child: RaisedButton(
                            color: Colors.blue[300],
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home()));
                            },
                            child: Text(
                              "OK",
                              style: (TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  );
                },
                itemCount: dataIndex.length,
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
