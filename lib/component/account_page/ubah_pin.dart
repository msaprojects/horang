import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:horang/api/models/pin/pin.model.dart';
import 'package:horang/api/models/pin/tambah.pin.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/reusable.class.dart';
import 'package:shared_preferences/shared_preferences.dart';

// final globalKey = GlobalKey<ScaffoldState>();
var passKey = GlobalKey<FormFieldState>();

class UbahPin extends StatefulWidget {
  Pin_Model ubahPin;
  UbahPin({this.ubahPin});

  @override
  _UbahPinState createState() => _UbahPinState();
}

class _UbahPinState extends State<UbahPin> {
  SharedPreferences sp;
  ApiService _apiService = ApiService();
  bool _isLoading = false,
      isSuccess = true,
      _isFieldPinLama,
      _isFieldPinBaru,
      _isFieldPinBaruRetype;
  var token = "",
      newtoken = "",
      access_token,
      refresh_token,
      idcustomer = "",
      nama_customer,
      pin;

  TextEditingController _controllerPassLama = TextEditingController();
  TextEditingController _controllerPassBaru = TextEditingController();
  TextEditingController _controllerPassBaruRetype = TextEditingController();

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
        showAlertDialog(context);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => WelcomePage()),
            (Route<dynamic> route) => false);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          pin != "0" ? "Ubah Pin" : "Tambah Pin",
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
      body: Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              seleksi(),
              Padding(
                padding: const EdgeInsets.only(top: 9),
                child: ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width,
                  height: 50,
                  child: RaisedButton(
                      child: Text('Simpan'),
                      onPressed: () {
                        setState(() {
                          if (pin == "0") {
                            // print("cek Tambah pin");
                            TambahPin_model pintambah = TambahPin_model(
                                pin: _controllerPassBaru.text.toString(),
                                token: access_token);
                            if (widget.ubahPin == null) {
                              print("cek masuk nggk");
                              if (_controllerPassBaru.text !=
                                  _controllerPassBaruRetype.text) {
                                print("cek masuk nggk1");
                                return warningDialog(context,
                                    "PIN baru dan Retype PIN tidak sama");
                              } else {
                                print("cek masuk nggk2");
                                _apiService.TambahPin(pintambah)
                                    .then((isSuccess) {
                                  setState(() => _isLoading = false);
                                  if (!isSuccess) {
                                    print("cek pin ubah3" + pin);
                                    successDialog(context,
                                        "Tambah pin berhasil disimpan, silahkan tekan 'oke' untuk login ulang aplikasi",
                                        showNeutralButton: false,
                                        positiveText: "Oke",
                                        positiveAction: () {
                                      Keluarr();
                                    });
                                  } else {
                                    print("cek pin ubah4" + pin);
                                    errorDialog(context,
                                        "Data pin gagal ditambah, silahkan dicek ulang");
                                  }
                                });
                              }
                            }
                          } else {
                            Pin_Model pinubah = Pin_Model(
                                pinlama: _controllerPassLama.text.toString(),
                                pinbaru: _controllerPassBaru.text.toString(),
                                token: access_token);
                            if (widget.ubahPin == null) {
                              if (_controllerPassLama.text != pin) {
                                return warningDialog(context,
                                    "PIN lama yang anda masukkan tidak sama. ");
                              } else {
                                if (_controllerPassBaru.text !=
                                    _controllerPassBaruRetype.text) {
                                  return warningDialog(context,
                                      "PIN baru dan Retype PIN tidak sama");
                                } else {
                                  _apiService.UbahPin(pinubah)
                                      .then((isSuccess) {
                                    setState(() => _isLoading = false);
                                    if (isSuccess) {
                                      print("cek pin ubah3" + pin);
                                      successDialog(context,
                                          "Ubah pin berhasil disimpan, silahkan tekan 'oke' untuk login ulang aplikasi",
                                          showNeutralButton: false,
                                          positiveText: "Oke",
                                          positiveAction: () {
                                        Keluarr();
                                      });
                                    } else {
                                      print("cek pin ubah4" + pin);
                                      errorDialog(context,
                                          "Data pin gagal diubah, silahkan dicek ulang");
                                    }
                                  });
                                }
                              }
                            }
                          }
                        });
                      }),
                ),
              )
            ],
          )),
    );
  }

  Widget seleksi() {
    if (pin == "0") {
      return Container(
        child: Column(
          children: [_buildTextFieldPinBaru(), _buildTextFieldPinBaruRetype()],
        ),
      );
    } else {
      return Container(
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
      obscureText: true,
      validator: (confirmation) {
        return confirmation.isEmpty
            ? 'Konfirmasi password harus di isi'
            : validasiEquals(confirmation, _controllerPassBaru.text)
                ? null
                : 'Password tidak sama';
      },
      // validator: (confirmation) {
      //   if (confirmation != passKey.currentState.value) {
      //     return 'Password tidak sama';
      //   } else {
      //     return null;
      //   }
      // },
      onChanged: (value) {
        // Validator:
        // (String value) {
        //   if (_isFieldPinBaruRetype != _isFieldPinBaru) {
        //     _scaffoldState.currentState.showSnackBar(SnackBar(
        //       content: Text('Pin Tidak sesuai'),
        //     ));
        //   }
        // };
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldPinBaru) {
          setState(() => _isFieldPinBaru = isFieldValid);
        } else if (value.length < 4) {
          return 'Password kurang dari 4';
        }
      },
    );
  }

  bool validasiEquals(String currentValue, String cekValue) {
    if (currentValue == cekValue) {
      return true;
    } else {
      return false;
    }
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
