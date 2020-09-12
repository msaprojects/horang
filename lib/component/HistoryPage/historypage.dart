import 'package:flutter/material.dart';
import 'package:horang/api/models/history/history.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:indonesia/indonesia.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  SharedPreferences sp;
  ApiService _apiService = ApiService();
  bool isSuccess = false;
  var access_token,
      refresh_token,
      nama_customer,
      no_order,
      total_harga,
      jumlah_sewa,
      idcustomer;

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    idcustomer = sp.getString("idcustomer");
    nama_customer = sp.getString("nama_customer");
    no_order = sp.getString("no_order");
    total_harga = sp.getString("total_harga");
    jumlah_sewa = sp.getString("jumlah_sewa");
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
    super.initState();
    cekToken();
  }

  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: FutureBuilder(
        future: _apiService.listHistory(access_token),
        builder: (BuildContext context, AsyncSnapshot<List<history>> snapshot) {
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
            List<history> historyyy = snapshot.data;
            return _buildListView(historyyy);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildListView(List<history> dataIndex) {
    DateTime date = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "History",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 16, right: 16),
            child: TextField(
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300])),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[300],
                  ),
                  suffixIcon: Icon(
                    Icons.filter_list,
                    color: Colors.lightBlue,
                  ),
                  hintText: "Cari Item",
                  focusColor: Colors.blue),
            ),
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            color: Colors.grey[100],
            child: ListView.builder(
              itemBuilder: (context, index) {
                history History = dataIndex[index];
                return Card(
                  // child: Column(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  child: InkWell(
                    onTap: () {
                      if (idcustomer == "0") {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Anda Harus Melengkapi profile untuk melakukan transaksi!'),
                          duration: Duration(seconds: 10),
                        ));
                        Navigator.pop(context, false);
                      } else {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          // return FormInputOrder(
                          //   history: history,
                          // );
                        }));
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(left: 20)),
                            Expanded(
                              child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "No. Order : " + History.no_order,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(padding: EdgeInsets.only(right: 20),
                                    child: Text(
                                      tanggal(date, shortMonth: true),
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.visible,
                                    ),
                                    ),
                                    // Text(
                                    //   tanggal(date, shortMonth: true),
                                    //   style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    // )
                                  ],
                                ),
                                // Text(
                                //   "No. Order : " + History.no_order,
                                //   style: TextStyle(
                                //       fontSize: 16,
                                //       color: Colors.grey[800],
                                //       fontWeight: FontWeight.bold),
                                // ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Customer : " + History.nama_customer,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black45,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      "Sewa : " + History.jumlah_sewa + " Hari",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.fade,
                                    ),
                                    Text(
                                      rupiah(History.total_harga,
                                          separator: ',', trailing: '.00'),
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.fade,
                                    ),
                                  ],
                                ),

                                // Text(
                                //   rupiah(
                                //     History.total_harga,
                                //     separator: ',',
                                //     trailing: '.00'
                                //   ),
                                //   style: TextStyle(
                                //       fontSize: 20,
                                //       color: Colors.green,
                                //       fontWeight: FontWeight.bold),
                                //   overflow: TextOverflow.fade,
                                // ),

                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: dataIndex.length,
            ),
          ))
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

  AccountValidation(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Lengkapi Profile anda"),
      content: Text("Anda harus melengkapi akun sebelum melakukan transaksi!"),
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
