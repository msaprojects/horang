import 'dart:convert';
import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:horang/api/models/customer/customer.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/DashboardPage/home_page.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/account_page/account.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/reusable.class.dart';
import 'package:horang/widget/bottom_nav.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/dialog.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class UbahProfile extends StatefulWidget {
  @override
  _UbahProfileState createState() => _UbahProfileState();
}

class _UbahProfileState extends State<UbahProfile> {
  late SharedPreferences sp;
  ApiService _apiService = ApiService();
  var token = "",
      newtoken = "",
      access_token,
      refresh_token,
      idcustomer,
      nama_customer;
  var _controllerNamaLengkap = TextEditingController(),
      _controllerAlamat = TextEditingController(),
      _controllerNoktp = TextEditingController(),
      _controlleridkota = TextEditingController(),
      _controllerEmail = TextEditingController(),
      _controllerNoHp = TextEditingController();
  late bool _isLoading = true,
      _obsecureText = true,
      _fieldNamaLengkap = false,
      _fieldAlamat = false,
      _fieldNoktp = false,
      _fieldEmail = false,
      _fieldNoHp = false,
      _fieldidkota,
      isSuccess = true;
  String? _nama, _alamat, _noKtp, _email, _noHp, pin, valKota;
  late int _idkota, _idpengguna;

  //COMBOBOX KOTA
  List? _dataKota;
  Future<String?> getcomboKota() async {
    var url = Uri.parse(_apiService.baseUrl + 'kota');
    final response = await http
        .get(url, headers: {"Authorization": "BEARER ${access_token}"});
    var listdata = json.decode(response.body);
    setState(() {
      _dataKota = listdata['rows'];
    });
  }

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token")!;
    refresh_token = sp.getString("refresh_token")!;
    idcustomer = sp.getString("idcustomer")!;
    nama_customer = sp.getString("nama_customer")!;
    pin = sp.getString("pin")!;
    //checking jika token kosong maka di arahkan ke menu login jika tidak akan meng-hold token dan refresh token
    if (access_token == "") {
      ReusableClasses().showAlertDialog(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => WelcomePage()),
          (Route<dynamic> route) => false);
    } else {
      _apiService.checkingToken(access_token!).then((value) => setState(() {
            isSuccess = value;
            //checking jika token expired/tidak berlaku maka akan di ambilkan dari refresh token
            if (!isSuccess) {
              _apiService
                  .refreshToken(refresh_token!)
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
    valKota;
    cekToken();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _apiService.client.close();
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
            builder: (context, AsyncSnapshot<List<Customers>?> snapshot) {
              print(context);
              if (snapshot.hasError) {
                return Center(
                  child: Text("ada kesalaahan : ${snapshot.error.toString()}"),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                print("maersk ${snapshot.data}");
                List<Customers> customer = snapshot.data!;
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
    idcustomer = customer[0].idcustomer.toString();
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              children: <Widget>[
                SizedBox(height: 15),
                new Column(
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
                        child: ElevatedButton(
                            child: Text(
                              idcustomer != ""
                                  ? "Update Data".toUpperCase()
                                  : "Simpan Data".toUpperCase(),
                              // "Simpan",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              if (_controllerAlamat.text == "") {
                                Fluttertoast.showToast(
                                    msg:
                                        "Pastikan kolom alamat tidak boleh kosong !",
                                    backgroundColor: Colors.black,
                                    textColor:
                                        Color.fromRGBO(255, 255, 255, 1));
                              } else {
                                AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.INFO,
                                    animType: AnimType.RIGHSLIDE,
                                    headerAnimationLoop: true,
                                    btnCancelOnPress: (){},
                                    title: 'Warning',
                                    desc:
                                        "Apakah Data yang anda masukkan sudah sesuai?",
                                    // +_apiService.responseCode.mMessage,
                                    btnOkOnPress: () {
                                      String alamat =
                                          _controllerAlamat.text.toString();
                                      setState(() {
                                        alamat.isEmpty
                                            ? _fieldAlamat = true
                                            : _fieldAlamat = false;
                                      });
                                      setState(() => _isLoading = true);
                                      Customers customer1 = Customers(
                                        namacustomer: _controllerNamaLengkap
                                            .text
                                            .toString(),
                                        noktp: _controllerNoktp.text.toString(),
                                        alamat:
                                            _controllerAlamat.text.toString(),
                                        blacklist: "0",
                                        token: access_token!,
                                        idkota: int.parse(valKota!),
                                        namakota: '',
                                        nohp: '',
                                        email: '',
                                        idcustomer: idcustomer,
                                      );
                                      print('MASUK ${customer1}');
                                      _apiService.UpdateCustomer(customer1)
                                          .then((isSuccess) {
                                        setState(() => _isLoading = true);
                                        if (isSuccess) {
                                          AwesomeDialog(
                                            context: context,
                                            animType: AnimType.LEFTSLIDE,
                                            headerAnimationLoop: false,
                                            dialogType: DialogType.SUCCES,
                                            showCloseIcon: true,
                                            title: 'Success',
                                            desc:
                                                'Data profile berhasil disimpan',
                                            btnOkOnPress: () {
                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  Home(
                                                                    initIndexHome:
                                                                        0,
                                                                    callpage:
                                                                        HomePage(),
                                                                  )),
                                                      (route) => false);
                                            },
                                            btnOkIcon: Icons.check_circle,
                                          )..show();
                                        } else {
                                          AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.ERROR,
                                              animType: AnimType.RIGHSLIDE,
                                              headerAnimationLoop: true,
                                              title: 'Error',
                                              desc:
                                                  "Data profile gagal disimpan, " ,
                                                  // +_apiService.responseCode.mMessage,
                                              btnOkOnPress: () {},
                                              btnOkIcon: Icons.cancel,
                                              btnOkColor: Colors.red)
                                            ..show();
                                        }
                                      });
                                    },
                                    btnOkText: "Sudah, Lanjutkan",
                                    btnCancelText: "Periksa Lagi",
                                    
                                    btnCancelColor: Colors.red,
                                    btnOkColor: Colors.green)
                                  ..show();
                              }
                            }
                            )),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
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
        errorText: _fieldNoktp ? "No Ktp Harus Diiisi" : "",
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
        errorText: _fieldNoHp ? "No. Hp Harus Diiisi" : "",
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
        errorText: _fieldEmail ? "Nama Email Harus Diiisi" : "",
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
        errorText: _fieldNamaLengkap ? "Nama Lengkap Harus Diiisi" : "",
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
        errorText: _fieldAlamat == "" ? "Alamat Harus Diiisi" : "",
      ),
    );
  }

  Widget _buildKomboKota(String? kotaaaa, String? idkotaa) {
    print("buildkombokota : $_dataKota");
    // _controlleridkota.text = kotaaaa;
    valKota = idkotaa;
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return DropdownButtonFormField(
          dropdownColor: Colors.white,
          hint: Text(kotaaaa!),
          value: valKota,
          items: _dataKota?.map((item) {
            return DropdownMenuItem<String>(
              child: Text("${item['nama_kota'].toString()}"),
              value: item['idkota'].toString(),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              valKota = value.toString();
            });
          },
        );
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
