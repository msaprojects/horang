import 'package:flutter/material.dart';
import 'package:horang/api/models/pin/pin.model.dart';
import 'package:horang/api/models/pin/tambah.pin.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
var passKey = GlobalKey<FormFieldState>();

class UbahPin extends StatefulWidget {
  Pin_Model ubahPin;
  UbahPin({this.ubahPin});

  @override
  _UbahPinState createState() => _UbahPinState();
}

class _UbahPinState extends State<UbahPin> {
  SharedPreferences sp;
  bool _isLoading = false,
      isSuccess = true,
      _isFieldPinLama,
      _isFieldPinBaru,
      _isFieldPinBaruRetype;
  ApiService _apiService = ApiService();
  var token = "",
      newtoken = "",
      access_token,
      refresh_token,
      idcustomer = "",
      pin;
  TextEditingController _controllerPassLama = TextEditingController();
  TextEditingController _controllerPassBaru = TextEditingController();
  TextEditingController _controllerPassBaruRetype = TextEditingController();

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    idcustomer = sp.getString("idcustomer");
    pin = sp.getString("pin");
    print('CEKKKK PIN LAMA $pin');
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
    }
  }

  @override
  void initState() {
    print("cek masuk initstate");
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
        showAlertDialog(context);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
            (Route<dynamic> route) => false);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          pin == "0" ? "Tambah Pin" : "Ubah Pin",
          style: TextStyle(color: Colors.black),
        ),
        // title: Text(
        //   "Ubah Pin",
        //   style: TextStyle(color: Colors.black),
        // ),
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
      body: Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildTextFieldPinLama(),
              _buildTextFieldPinBaru(),
              _buildTextFieldPinBaruRetype(),
              Padding(
                padding: const EdgeInsets.only(top: 9),
                
                child: RaisedButton(
                    child: Text('Simpan'),
                    onPressed: () {
                      setState(() {
                        if (pin == "0") {
                          print("cek Tambah pin");
                          TambahPin_model pintambah = TambahPin_model(
                              pin: _controllerPassBaru.text.toString(),
                              token: access_token);
                          if (widget.ubahPin == null) {
                            _apiService.TambahPin(pintambah).then((isSuccess) {
                              setState(() => _isLoading = false);
                              if (isSuccess) {
                                Keluarr();
                              } else {
                                _scaffoldState.currentState
                                    .showSnackBar(SnackBar(
                                  content: Text("Submit data salah"),
                                ));
                              }
                            });
                          }
                        } else {
                          print("cek pin ubah" + pin);
                          Pin_Model pinubah = Pin_Model(
                              pinlama: _controllerPassLama.text.toString(),
                              pinbaru: _controllerPassBaru.text.toString(),
                              token: access_token);
                          if (widget.ubahPin == null) {
                            _apiService.UbahPin(pinubah).then((isSuccess) {
                              setState(() => _isLoading = false);
                              if (isSuccess) {
                                Navigator.pop(
                                    _scaffoldState.currentState.context);
                              } else {
                                _scaffoldState.currentState
                                    .showSnackBar(SnackBar(
                                  content: Text("Submit data salah"),
                                ));
                              }
                            });
                          }
                        }
                      });
                    }),
              )
            ],
          )),
    );
  }

  void seleksitambahubah() {
    if (pin == null) {
      Container(
        child: Column(
          children: [_buildTextFieldPinBaru(), _buildTextFieldPinBaruRetype()],
        ),
      );
    } else {
      Container(
        child: Column(
          children: [
            _buildTextFieldPinLama(),
            _buildTextFieldPinBaru(),
            _buildTextFieldPinBaruRetype()
          ],
        ),
      );
    }
  }

  Widget _buildTextFieldPinLama() {
    return TextFormField(
      maxLength: 4,
      controller: _controllerPassLama,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: "Pin Lama",
        errorText: _isFieldPinLama == null || _isFieldPinLama
            ? null
            : "Pin lama harus di isi",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldPinLama) {
          setState(() => _isFieldPinLama = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldPinBaru() {
    return TextFormField(
      maxLength: 4,
      controller: _controllerPassBaru,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: "Pin Baru",
        errorText: _isFieldPinBaru == null || _isFieldPinBaru
            ? null
            : "Pin baru harus di isi",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldPinBaru) {
          setState(() => _isFieldPinBaru = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldPinBaruRetype() {
    return TextFormField(
      maxLength: 4,
      controller: _controllerPassBaruRetype,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: "Retype Pin Baru",
        errorText: _isFieldPinBaru == null || _isFieldPinBaru
            ? null
            : "Retype Pin baru harus di isi",
      ),
      // obscureText: true,
      validator: (confirmation) {
        if (confirmation != passKey.currentState.value) {
          return 'Password tidak sama';
        } else {
          return null;
        }
      },
      onChanged: (value) {
        Validator:
        (String value) {
          if (_isFieldPinBaruRetype != _isFieldPinBaru) {
            _scaffoldState.currentState.showSnackBar(SnackBar(
              content: Text('Pin Tidak sesuai'),
            ));
          }
        };
        // bool isFieldValid = value.trim().isNotEmpty;
        // if (isFieldValid != _isFieldPinBaru) {
        //   setState(() => _isFieldPinBaru = isFieldValid);
        // }
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
      content: Text("Bisa disimpan !!"),
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
