import 'dart:convert';
import 'package:horang/api/models/customer/customer.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class TambahProfile extends StatefulWidget {
  @override
  _TambahProfileState createState() => _TambahProfileState();
}

class _TambahProfileState extends State<TambahProfile> {
  SharedPreferences sp;
  bool _isLoading = false;
  ApiService _apiService = ApiService();
  var token = "", newtoken = "", access_token, refresh_token, idcustomer = "";
  bool _isFieldNamaLengkap;
  bool _isFieldAlamat;
  bool _isFieldNoKtp, isSuccess = true;
  String _nama,
      _alamat,
      _noKtp,
      urlcomboKota = "http://server.horang.id:9992/api/kota/",
      valKota;

  TextEditingController _controllerNamaLengkap = TextEditingController();
  TextEditingController _controllerAlamat = TextEditingController();
  TextEditingController _controllerNoKtp = TextEditingController();
  TextEditingController _controlleridkota;

  List<dynamic> _dataKota = List();
  void getcomboKota() async {
    final response = await http.get(urlcomboKota,
        headers: {"Authorization": "BEARER ${access_token}"});
    var listdata = json.decode(response.body);
    setState(() {
      _dataKota = listdata;
    });
  }

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    _nama = sp.getString("nama_customer");
    _alamat = sp.getString("alamat");
    _noKtp = sp.getString("noktp");
    valKota.toString();
    idcustomer = sp.getString("idcustomer");
    //checking jika token kosong maka di arahkan ke menu login jika tidak akan meng-hold token dan refresh token
    if (access_token == null) {
      showAlertDialog(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => true);
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
                              (Route<dynamic> route) => true);
                        }
                      }));
            }
          }));
      getcomboKota();
    }
  }

  @override
  void initState() {
    super.initState();
    cekToken();
  }

  @override
  Widget build(BuildContext context) {

    void Keluarr() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      cekToken();
      await preferences.clear();
      if (preferences.getString("access_token") == null) {
        print("SharePref berhasil di hapus");
      }
    }

    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Masukkan data diri anda",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildTextFieldName(),
                _buildTextFieldKtp(),
                _buildTextFieldAlamat(),
                Container(
                  // padding: EdgeInsets.all(0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _buildKomboKota(valKota.toString()),
                      Text("kamu memilih kota $valKota"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RaisedButton(
                    child: Text(
                      "Simpan",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_isFieldNamaLengkap == null ||
                          _isFieldAlamat == null ||
                          _isFieldNoKtp == null ||
                          !_isFieldNamaLengkap ||
                          !_isFieldAlamat ||
                          !_isFieldNoKtp) {
                        _scaffoldState.currentState.showSnackBar(
                          SnackBar(
                            content: Text("Kolom Tidak Boleh Kosong"),
                          ),
                        );
                        return;
                      }
                      setState(() => _isLoading = true);
                      Customer customer = Customer(
                        nama_customer: _controllerNamaLengkap.text.toString(),
                        noktp: _controllerNoKtp.text.toString(),
                        alamat: _controllerAlamat.text.toString(),
                        token: access_token,
                        blacklist: "0",
                        idkota: int.parse(valKota),
                      );
                      _apiService.TambahCustomer(customer).then((isSuccess) {
                        setState(() => _isLoading = false);
                        if (isSuccess) {
                          Keluarr();
                        } else {
                          _scaffoldState.currentState.showSnackBar(SnackBar(
                            content: Text("Data Gagal Disimpan"),
                          ));
                        }
                      });
                    },
                    color: Colors.orange[600],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldName() {
    return TextField(
      controller: _controllerNamaLengkap,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Nama Lengkap",
        errorText: _isFieldNamaLengkap == null || _isFieldNamaLengkap
            ? null
            : "Full name is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldNamaLengkap) {
          setState(() => _isFieldNamaLengkap = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldKtp() {
    return TextField(
      controller: _controllerNoKtp,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "No. Ktp",
        errorText: _isFieldNoKtp == null || _isFieldNoKtp
            ? null
            : "Full name is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldNoKtp) {
          setState(() => _isFieldNoKtp = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldAlamat() {
    return TextField(
      controller: _controllerAlamat,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Alamat",
        errorText: _isFieldAlamat == null || _isFieldAlamat
            ? null
            : "Alamat harus diisi",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldAlamat) {
          setState(() => _isFieldAlamat = isFieldValid);
        }
      },
    );
  }

  Widget _buildKomboKota(String kotaaaa) {
    // List<dynamic> _dataKota = List();
    print("buildkombokota : $_dataKota");
    _controlleridkota = TextEditingController(text: kotaaaa);
    return DropdownButtonFormField(
      hint: Text("Pilih Kota"),
      value: valKota,
      items: _dataKota.map((item) {
        return DropdownMenuItem(
          // child: Text(item['nama_kota']),
          child: Text("${item['nama_kota']}"),
          value: item['idkota'].toString(),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          valKota = value.toString();
          print("damn" + value.toString());
        });
      },
    );
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {},
    );

    AlertDialog alert = AlertDialog(
      title: Text("Data Berhasil Disimpan"),
      content: Text("dalskdlasd"),
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
