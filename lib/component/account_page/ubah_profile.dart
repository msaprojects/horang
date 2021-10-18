import 'dart:convert';
import 'dart:ui';
import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:horang/api/models/customer/customer.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/account_page/account.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/reusable.class.dart';
import 'package:horang/widget/bottom_nav.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class UbahProfile extends StatefulWidget {
  Customers dcustomer;
  UbahProfile({this.dcustomer});

  @override
  _UbahProfileState createState() => _UbahProfileState();
}

class _UbahProfileState extends State<UbahProfile> {
  SharedPreferences sp;
  ApiService _apiService = ApiService();
  List<dynamic> _dataKota = List();
  var token = "",
      newtoken = "",
      access_token,
      refresh_token,
      idcustomer,
      nama_customer,
      _controllerNamaLengkap = TextEditingController(),
      _controllerAlamat = TextEditingController(),
      _controllerNoktp = TextEditingController(),
      _controlleridkota = TextEditingController(),
      _controllerEmail = TextEditingController(),
      _controllerNoHp = TextEditingController();
  bool _isLoading = true,
      _obsecureText = true,
      _fieldNamaLengkap = false,
      _fieldAlamat = false,
      _fieldNoktp = false,
      _fieldEmail = false,
      _fieldNoHp = false,
      _fieldidkota,
      isSuccess = true;
  String _nama, _alamat, _noKtp, _email, _noHp, pin, valKota;
  int _idkota, _idpengguna;

  //COMBOBOX KOTA
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
      getcomboKota();
    }
  }

  @override
  void initState() {
    cekToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Ubah Profile",
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
        body: SafeArea(
          child: FutureBuilder(
            future: _apiService.getCustomer(access_token),
            builder: (context, AsyncSnapshot<List<Customers>> snapshot) {
              print(context);
              if (snapshot.hasError) {
                return Center(
                  child: Text("ada kesalaahan : ${snapshot.error.toString()}"),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                print("maersk ${snapshot.data}");
                List<Customers> customer = snapshot.data;
                return _buildIsifield(customer);
                // _simpan()
              } else {
                return Text("");
              }
            },
          ),
        ));
  }

  Widget _buildIsifield(List<Customers> customer) {
    print("santzz ${customer[0].namakota} ${customer[0].idcustomer}");
    print("ada akses tokennya $access_token");
    // if(valKota == null) valKota==customer[0].idkota;
    print("valkotanya ada kah $valKota");
    idcustomer = customer[0].idcustomer;
    return Container(
        child: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          children: <Widget>[
            SizedBox(height: 15),
            SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  _buildTextFieldNoKtp(customer[0].noktp),
                  SizedBox(height: 10),
                  _buildTextFieldNoHp(customer[0].nohp),
                  SizedBox(height: 10),
                  _buildTextFieldEmail(customer[0].email),
                  SizedBox(height: 10),
                  _buildTextFieldNamaLengkap(customer[0].namacustomer),
                  SizedBox(height: 10),
                  _buildTextFieldAlamat(customer[0].alamat),
                  SizedBox(height: 10),
                  Container(
                    // padding: EdgeInsets.all(0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _buildKomboKota(customer[0].namakota.toString(),
                            customer[0].idkota.toString()),
                        // Text("kamu memilih kota $valKota"),
                      ],
                    ),
                  ),
                  // _simpan()
                  Container(
                    width: 500,
                    height: 50,
                    child: FlatButton(
                      color: Colors.blue,
                      child: Text(
                        widget.dcustomer == null
                            ? "Simpan".toUpperCase()
                            : "Update Data".toUpperCase(),
                        // "Simpan",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        _controllerAlamat.text == ""
                            ? infoDialog(context,
                                'Pastikan kolom alamat tidak boleh kosong !')
                            : successDialog(context,
                                "Apakah Data yang anda masukkan sudah sesuai? ${_controllerAlamat.text} -- $_fieldAlamat",
                                showNeutralButton: false,
                                title: "Konfirmasi Perubahan Data",
                                positiveText: "Sudah Benar",
                                positiveAction: () {
                                String alamat =
                                    _controllerAlamat.text.toString();
                                setState(() {
                                  alamat.isEmpty
                                      ? _fieldAlamat = true
                                      : _fieldAlamat = false;
                                });
                                setState(() => _isLoading = true);
                                Customers customer1 = Customers(
                                  namacustomer:
                                      _controllerNamaLengkap.text.toString(),
                                  noktp: _controllerNoktp.text.toString(),
                                  alamat: _controllerAlamat.text.toString(),
                                  blacklist: "0",
                                  token: access_token,
                                  idkota: int.parse(valKota),
                                );
                                print('MASUK ${customer1}');
                                _apiService.UpdateCustomer(customer1)
                                    .then((isSuccess) {
                                  setState(() => _isLoading = true);
                                  if (isSuccess) {
                                    successDialog(context,
                                        "Data profile berhasil disimpan",
                                        showNeutralButton: false,
                                        positiveText: "Ok", positiveAction: () {
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) => Home(
                                                    initIndexHome: 0,
                                                  )),
                                          (route) => false);
                                    });
                                  } else {
                                    errorDialog(
                                        context,
                                        "Data profile gagal disimpan, " +
                                            _apiService.responseCode.mMessage);
                                  }
                                });
                              },
                                negativeText: "Cek Lagi",
                                negativeAction: () {});
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildTextFieldNoKtp(String val) {
    // print("noktp"+val);
    _controllerNoktp.text = val;
    return TextFormField(
      controller: _controllerNoktp,
      // initialValue: "1",
      style: TextStyle(color: Colors.grey),
      enabled: false,
      enableInteractiveSelection: false,
      readOnly: true,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "No KTP",
        labelText: "No KTP",
        errorText: _fieldNoktp ? "No Ktp Harus Diiisi" : null,
      ),

      onChanged: (val) {
        bool isFieldValid = val.trim().isNotEmpty;
        if (isFieldValid != _fieldNoktp) {
          _fieldNoktp = isFieldValid;
        }
      },
    );
  }

  Widget _buildTextFieldNoHp(String val) {
    _controllerNoHp.text = val;
    return TextFormField(
      controller: _controllerNoHp,
      style: TextStyle(color: Colors.grey),
      enabled: false,
      enableInteractiveSelection: false,
      readOnly: true,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "No. Hp",
        border: OutlineInputBorder(),
        errorText: _fieldNoHp ? "No. Hp Harus Diiisi" : null,
      ),
    );
  }

  Widget _buildTextFieldEmail(String val) {
    _controllerEmail.text = val;
    return TextFormField(
      controller: _controllerEmail,
      style: TextStyle(color: Colors.grey),
      enabled: false,
      enableInteractiveSelection: false,
      readOnly: true,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Email",
        border: OutlineInputBorder(),
        errorText: _fieldEmail ? "Nama Email Harus Diiisi" : null,
      ),
    );
  }

  Widget _buildTextFieldNamaLengkap(String val) {
    _controllerNamaLengkap.text = val;
    return TextFormField(
      controller: _controllerNamaLengkap,
      style: TextStyle(color: Colors.grey),
      enabled: false,
      enableInteractiveSelection: false,
      readOnly: true,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        // hintText: val,
        labelText: "Masukkan nama lengkap",
        border: OutlineInputBorder(),
        errorText: _fieldNamaLengkap ? "Nama Lengkap Harus Diiisi" : null,
      ),
    );
  }

  Widget _buildTextFieldAlamat(String val) {
    _controllerAlamat.text = val;
    return TextFormField(
      controller: _controllerAlamat,
      // initialValue: val,
      keyboardType: TextInputType.multiline,
      maxLines: 2,
      decoration: InputDecoration(
        hintText: 'Masukkan Alamat',
        labelText: "Masukkan Alamat",
        border: OutlineInputBorder(),
        errorText: _fieldAlamat == null ? "Alamat Harus Diiisi" : null,
      ),
    );
  }

  Widget _buildKomboKota(String kotaaaa, String idkotaa) {
    print("buildkombokota : $_dataKota");
    // _controlleridkota.text = kotaaaa;
    valKota = idkotaa;
    return DropdownButtonFormField(
      dropdownColor: Colors.white,
      hint: Text(kotaaaa),
      value: valKota,
      items: _dataKota.map((item) {
        return DropdownMenuItem(
          child: Text("${item['nama_kota']}"),
          value: item['idkota'].toString(),
        );
      }).toList(),
      onChanged: (value) {
        valKota = value.toString();
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
      content: Text("Peringatan"),
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

// void displayDialog(BuildContext context, String title, String text) =>
  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );
}
