import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:horang/api/models/customer/customer.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class UbahProfile extends StatefulWidget {
  Customer customer;
  UbahProfile({this.customer});

  @override
  _UbahProfileState createState() => _UbahProfileState();
}

class _UbahProfileState extends State<UbahProfile> {
  SharedPreferences sp;
  ApiService _apiService = ApiService();
  var token = "", newtoken = "", access_token, refresh_token, idcustomer;
  bool _isLoading = true, _obsecureText = true;
  String _nama,
      _alamat,
      _noKtp,
      urlcomboKota = "http://server.horang.id:9992/api/kota/",
      // urlcomboKota = "http://192.168.6.113:9992/api/kota/",
      valKota;
  bool _fieldNamaLengkap = false,
      _fieldAlamat = false,
      _fieldNoktp = false,
      // _blacklist = true,
      _fieldidkota,
      isSuccess = true;
  int _idkota, _idpengguna;
  TextEditingController _controllerNamaLengkap;
  TextEditingController _controllerAlamat;
  TextEditingController _controllerNoktp;
  TextEditingController _controlleridkota;

  // String kota_id;
  // List<String> kota = ["Surabaya", "Solo", "Gresik"];
  //COMBOBOX KOTA
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
            builder: (context, AsyncSnapshot<List<Customer>> snapshot) {
              print(context);
              if (snapshot.hasError) {
                return Center(
                  child: Text("ada kesalaahan : ${snapshot.error.toString()}"),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                // print(snapshot.data);
                List<Customer> customer = snapshot.data;
                return _buildIsifield(customer);
                // _simpan()
              } else {
                return Text("");
              }
            },
          ),
        ));
  }

  Widget _buildIsifield(List<Customer> customer) {
    // print(customer[0].idkota);
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
                  _buildTextFieldNamaLengkap(customer[0].nama_customer),
                  SizedBox(height: 10),
                  _buildTextFieldAlamat(customer[0].alamat),
                  SizedBox(height: 10),
                  Container(
                    // padding: EdgeInsets.all(0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _buildKomboKota(customer[0].idkota.toString()),
                        // Text("kamu memilih kota $valKota"),
                      ],
                    ),
                  ),
                  _simpan()
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

  Widget _simpan() {
    return SingleChildScrollView(
      child: Container(
        width: 500,
        height: 50,
        child: FlatButton(
          color: Colors.blue,
          child: Text(
            widget.customer == null
                ? "Simpan".toUpperCase()
                : "Update Data".toUpperCase(),
            // "Simpan",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          onPressed: () async {
            //print("kay");
            String noktp = _controllerNoktp.text.toString();
            //print("noktp :$noktp");
            String namalengkap = _controllerNamaLengkap.text.toString();
            String alamat = _controllerAlamat.text.toString();
            setState(() {
              noktp.isEmpty ? _fieldNoktp = true : _fieldNoktp = false;
              namalengkap.isEmpty
                  ? _fieldNamaLengkap = true
                  : _fieldNamaLengkap = false;
              alamat.isEmpty ? _fieldAlamat = true : _fieldAlamat = false;
            });
            print("----" + _fieldNamaLengkap.toString());
//             if (!_fieldNoktp || !_fieldNamaLengkap || !_fieldAlamat) {
////                _scaffoldState.currentState.showSnackBar(SnackBar(
////                  content: Text("Harap isi Semua Kolom"),
////                ));
//                _simpan();
//               return;
//             }
            setState(() => _isLoading = true);
            print("cek kota " + valKota.toString());
            Customer customer = Customer(
idcustomer: idcustomer,
              nama_customer: _controllerNamaLengkap.text.toString(),
              alamat: _controllerAlamat.text.toString(),
              noktp: _controllerNoktp.text.toString(),
              blacklist: "0",
              token: access_token,
              idkota: int.parse(valKota),
            );
            print('MASUK ${customer}');
            _apiService.UpdateCustomer(customer).then((isSuccess) {
              setState(() => _isLoading = true);
              if (isSuccess) {
                print("sukse");
                // return showAlertDialog(context);
              } else {
                Text("Data gagal disimpan, ${_apiService}");
              }
            });
            // if (widget.customer == null) {
            //   _apiService
            //       .createCustomer(customer)
            //       .then((isSuccess) {
            //     print("cek: $_apiService");
            //     setState(() => _isLoading = true);
            //     if (isSuccess) {
            //       print("cek sukses");
            //       return showAlertDialog(context);
            //     } else {
            //       Text("Data Gagal Disimpan!, ${_apiService}");

            //     }
            //   });
            // } else {
            //   customer.idcustomer = widget.customer.idcustomer;
            //   _apiService.UpdateCustomer(customer)
            //       .then((isSuccess) {
            //     setState(() => _isLoading = true);
            //     if (isSuccess) {
            //       Navigator.pop(
            //           _scaffoldState.currentState.context);
            //     } else {
            //       _scaffoldState.currentState.showSnackBar(SnackBar(
            //         content: Text("Update data gagal"),
            //       ));
            //     }
            //   });
            // }
          },
        ),
      ),
    );
  }

  Widget _buildTextFieldNoKtp(String val) {
    // print("noktp"+val);
    _controllerNoktp = TextEditingController(text: val);
    return TextFormField(
      controller: _controllerNoktp,
      // initialValue: "1",
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "No KTP",
        labelText: "No KTP",
        errorText: _fieldNoktp ? "No Ktp Harus Diiisi" : null,
      ),

      // onChanged: (val) {
      //   bool isFieldValid = val.trim().isNotEmpty;
      //   if (isFieldValid != _fieldNoktp) {
      //     setState(() => _fieldNoktp = isFieldValid);
      //   }
      // },
    );
  }

  Widget _buildTextFieldNamaLengkap(String val) {
    _controllerNamaLengkap = TextEditingController(text: val);
    return TextFormField(
      controller: _controllerNamaLengkap,
      // initialValue: val,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        // hintText: val,
        labelText: "Masukkan nama lengkap",
        border: OutlineInputBorder(),
        errorText: _fieldNamaLengkap ? "Nama Lengkap Harus Diiisi" : null,
      ),
      // onChanged: (value) {
      //   bool isFieldValid = value.trim().isNotEmpty;
      //   _fieldNamaLengkap = isFieldValid;
      //   // print("----"+_fieldNamaLengkap.toString());
      // },
    );
  }

  Widget _buildTextFieldAlamat(String val) {
    _controllerAlamat = TextEditingController(text: val);
    return TextFormField(
      controller: _controllerAlamat,
      // initialValue: val,
      keyboardType: TextInputType.multiline,
      maxLines: 2,
      decoration: InputDecoration(
        hintText: val,
        labelText: "Masukkan Alamat",
        border: OutlineInputBorder(),
        errorText: _fieldAlamat ? "Alamat Harus Diiisi" : null,
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _fieldAlamat) {
          setState(() => _fieldAlamat = isFieldValid);
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

  // Widget _buildComboKota() {
  //   return DropDownField(
  //     onValueChanged: (dynamic value) {
  //       _valKota = value;
  //     },
  //     value: kota_id,
  //     required: true,
  //     hintText: 'Pilih Kota Anda',
  //     labelText: 'Kota',
  //     items: kota,
  //   );
  // }

  // Widget _buildComboKota() {
  // return DropdownButton(
  //   hint: Text("Pilih Kota"),
  //   value: valKota,
  //   items: _dataKota.map((item){
  //     return DropdownMenuItem(
  //       child: Text(item['nama_kota']),
  //       value: item['nama_kota'],
  //     );
  //   }).toList(),
  //   onChanged: (value){
  //     setState(() {
  //       valKota = value;
  //     });
  //   },
  // );
  // Text(
  //   "Kamu memilih kota $valKota",
  //   style: TextStyle(
  //     color: Colors.black,
  //     fontSize: 20,
  //     fontWeight: FontWeight.bold
  //   ),
  // );
  // }

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
