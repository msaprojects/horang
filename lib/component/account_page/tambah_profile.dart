import 'dart:convert';
import 'package:commons/commons.dart';
import 'package:horang/api/models/customer/customer.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/screen/welcome_page.dart';
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
  String nama_customer, valKota, pin;

  TextEditingController _controllerNamaLengkap = TextEditingController();
  TextEditingController _controllerAlamat = TextEditingController();
  TextEditingController _controllerNoKtp = TextEditingController();
  TextEditingController _controlleridkota;

  List<dynamic> _dataKota = List();
  void getcomboKota() async {
    final response = await http.get(_apiService.urlkota,
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
    idcustomer = sp.getString("idcustomer");
    nama_customer = sp.getString("nama_customer");
    pin = sp.getString("pin");
    //checking jika token kosong maka di arahkan ke menu login jika tidak akan meng-hold token dan refresh token
    if (access_token == null) {
      showAlertDialog(context);
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
                          showAlertDialog(context);
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      WelcomePage()),
                              (Route<dynamic> route) => false);
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
        backgroundColor: Colors.transparent,
        title: Text(
          "Tambah Profile",
          // "Edit Profil",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Padding(
              // padding: EdgeInsets.all(16.0),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildTextFieldName(),
                  SizedBox(height: 10),
                  _buildTextFieldKtp(),
                  SizedBox(height: 10),
                  _buildTextFieldAlamat(),
                  SizedBox(height: 10),
                  Container(
                    // padding: EdgeInsets.all(0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _buildKomboKota(valKota.toString()),
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        width: 500,
                        height: 50,
                        child: FlatButton(
                          child: Text(
                            "Simpan",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            setState(() {
                              if (_isFieldNamaLengkap == null ||
                                  _isFieldAlamat == null ||
                                  _isFieldNoKtp == null ||
                                  !_isFieldNamaLengkap ||
                                  !_isFieldAlamat ||
                                  !_isFieldNoKtp) {
                                warningDialog(
                                    context, "Pastikan Semua Kolom Terisi");
                                return;
                              } else {
                                warningDialog(context,
                                    "Pastikan data yang anda masukkan sesuai dengan data asli, data anda tidak dapat di ubah",
                                    showNeutralButton: false,
                                    negativeText: "Periksa Kembali",
                                    negativeAction: () {},
                                    positiveText: "OK", positiveAction: () {
                                  setState(() => _isLoading = true);
                                  Customers data = Customers(
                                    namacustomer:
                                        _controllerNamaLengkap.text.toString(),
                                    noktp: _controllerNoKtp.text.toString(),
                                    alamat: _controllerAlamat.text.toString(),
                                    token: access_token,
                                    blacklist: "0",
                                    idkota: int.parse(valKota),
                                  );
                                  print("Tambah Customer : " + data.toString());
                                  _apiService.TambahCustomer(data)
                                      .then((isSuccess) {
                                    setState(() => _isLoading = false);
                                    if (isSuccess) {
                                      _controllerNamaLengkap.clear();
                                      _controllerNoKtp.clear();
                                      _controllerAlamat.clear();
                                      successDialog(context,
                                          "Profil anda berhasil disimpan",
                                          showNeutralButton: false,
                                          positiveText: "OK",
                                          positiveAction: () {
                                        Keluarr();
                                      });
                                      // Keluarr();
                                    } else {
                                      errorDialog(context,
                                          "${_apiService.responseCode.mMessage}");
                                    }
                                  });
                                });
                              }
                            });
                          },
                          color: Colors.blue,
                        ),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldName() {
    return TextFormField(
      controller: _controllerNamaLengkap,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
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
    return TextFormField(
      controller: _controllerNoKtp,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
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
    return TextFormField(
      controller: _controllerAlamat,
      keyboardType: TextInputType.text,
      maxLines: 2,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
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
    _controlleridkota = TextEditingController(text: kotaaaa);
    return DropdownButtonFormField(
      hint: Text("Pilih Kota"),
      value: valKota,
      items: _dataKota.map((item) {
        return DropdownMenuItem(
          child: Text("${item['nama_kota']}"),
          value: item['idkota'].toString(),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          valKota = value.toString();
        });
      },
    );
  }

  Future showAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Sesi Anda Berakhir!"),
            content: Text(
                "Harap masukkan kembali email beserta nomor handphone untuk mengakses fitur di aplikasi ini."),
            actions: [
              FlatButton(
                  color: Colors.red,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Ok"))
            ],
          );
        });
  }
}
