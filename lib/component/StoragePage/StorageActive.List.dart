import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:horang/api/models/mystorage/mystorageModel.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/OrderPage/KonfirmasiLog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageActive extends StatefulWidget {
  @override
  _StorageActive createState() => _StorageActive();
}

class _StorageActive extends State<StorageActive> {
  bool isLoading = false;
  SharedPreferences sp;
  ApiService _apiService = ApiService();
  bool isSuccess = false;
  var access_token,
      refresh_token,
      idcustomer,
      email,
      nama,
      nama_customer,
      keterangan,
      kode_kontainer,
      nama_kota,
      nama_lokasi,
      tanggal_order,
      hari,
      aktif;
  // final String aktif = "";

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    idcustomer = sp.getString("idcustomer");
    email = sp.getString("email");
    nama_customer = sp.getString("nama_customer");
    // //checking jika token kosong maka di arahkan ke menu login jika tidak akan meng-hold token dan refresh token
    if (access_token == null) {
      showAlertDialog(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    } else {
      _apiService.checkingToken(access_token).then((value) => setState(() {
            isSuccess = value;
            // checking jika token expired/tidak berlaku maka akan di ambilkan dari refresh token
            if (!isSuccess) {
              _apiService
                  .refreshToken(refresh_token)
                  .then((value) => setState(() {
                        var newtoken = value;
                        // setting access_token dari refresh_token
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

// class OnGoing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
          future: _apiService.listMystorage(access_token),
          builder: (BuildContext context,
              AsyncSnapshot<List<MystorageModel>> snapshot) {
            print("coba cek lagi : ${snapshot.connectionState}");
            if (snapshot.hasError) {
              print(snapshot.error.toString());
              return Center(
                child: Text(
                    "9Something wrong with message ${snapshot.error.toString()}"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              List<MystorageModel> profiles =
                  snapshot.data.where((i) => i.aktif == "AKTIF").toList();
              return _buildListview(profiles);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Widget _buildListview(List<MystorageModel> dataIndex) {
    return Scaffold(
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
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16, top: 30),
                color: Colors.grey[100],
                child: (ListView.builder(
                  itemCount: dataIndex == null ? 0 : dataIndex.length,
                  itemBuilder: (BuildContext context, int index) {
                    MystorageModel myStorage = dataIndex[index];
                    print("dataindex $dataIndex");
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 90,
                              height: 90,
                            ),
                            SizedBox(
                              width: 14,
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      myStorage.kode_kontainer,
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      myStorage.nama,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      myStorage.nama_kota,
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                          text: 'Berakhir ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.blue[300],
                                              fontWeight: FontWeight.bold),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: myStorage.hari.toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.blue[300],
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: ' Hari Lagi',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.blue[300],
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ]),
                                    ),
                                    Text(
                                      myStorage.tanggal_order,
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        ButtonTheme(
                                          minWidth: 50,
                                          height: 30,
                                          child: RaisedButton(
                                            onPressed: () {
                                              setState(() => isLoading = true);
                                              if (idcustomer == "0") {
                                                Scaffold.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Anda Harus Melengkapi profile untuk melakukan transaksi!'),
                                                  duration:
                                                      Duration(seconds: 10),
                                                ));
                                              } else {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return KonfirmasiLog(
                                                    kode_kontainer: myStorage
                                                        .kode_kontainer,
                                                    nama_kota:
                                                        myStorage.nama_kota,
                                                    idtransaksi_detail:
                                                        myStorage
                                                            .idtransaksi_detail,
                                                    idtransaksi:
                                                        myStorage.idtransaksi,
                                                    nama: myStorage.nama,
                                                  );
                                                }));
                                              }
                                            },
                                            child: Text("Cek Details..." +
                                                myStorage.idtransaksi_detail
                                                    .toString()),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                // );
                                //   },
                                // ),
                              ),
                            ),
                            // IconButton(
                            //   icon: Icon(Icons.hourglass_empty, color: Colors.green, size: 30,),
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          height: 10,
                        )
                      ],
                    );
                  },
                  // separatorBuilder: (context, index) => Divider(),
                  // itemCount: dataIndex.length,
                )),
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
