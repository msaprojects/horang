import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/account_page/tambah_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReusableClasses {
  PerhitunganOrder(
    String persentasevoucher,
    String minimumtransaksi,
    bool boolasuransi,
    bool boolvoucher,
    String nominalVoucher,
    String harga,
    String durasi,
    String nominalbaranginput,
    String ceksaldopoint,
    String minimaldeposit,
    String asuransi,
  ) {
    var hasilperhitungan;
    num nominalV = 0;
    num ceksaldoD = 0;

    if (boolasuransi == false) asuransi = "0";
    if (boolvoucher == false) {
      nominalV = 0;
    } else {
      if ((double.parse(durasi) * double.parse(harga)) >=
          double.parse(minimumtransaksi)) {
        if (((double.parse(persentasevoucher) / 100) *
                double.parse(harga) *
                double.parse(durasi)) >=
            double.parse(nominalVoucher)) {
          nominalV = double.parse(nominalVoucher);
        } else {
          nominalV = (double.parse(persentasevoucher) / 100) *
              double.parse(harga) *
              double.parse(durasi);
        }
      } else {
        nominalV = 0;
      }
    }

    if (((double.parse(harga) * double.parse(durasi)) +
            ((double.parse(asuransi) / 100) *
                double.parse(nominalbaranginput)) +
            int.parse(minimaldeposit) * double.parse(harga) -
            nominalV) >=
        double.parse(ceksaldopoint)) {
      ceksaldoD = double.parse(ceksaldopoint);
    } else {
      ceksaldoD = ((double.parse(harga) * double.parse(durasi)) +
          ((double.parse(asuransi) / 100) * double.parse(nominalbaranginput)) +
          int.parse(minimaldeposit) * double.parse(harga) -
          nominalV);
    }

    hasilperhitungan = ((double.parse(harga) * double.parse(durasi)) +
            ((double.parse(asuransi) / 100) *
                double.parse(nominalbaranginput)) +
            int.parse(minimaldeposit) * double.parse(harga) -
            ceksaldoD -
            nominalV)
        .toStringAsFixed(2);

    return hasilperhitungan;
  }

  hitungvoucher(
    String persentasevoucher,
    String minimumtransaksi,
    bool boolvoucher,
    String nominalmaksVoucher,
    String harga,
    String durasi,
  ) {
    num nominalV = 0;

    if (boolvoucher == false) {
      nominalV = 0;
    } else {
      if ((double.parse(durasi) * double.parse(harga)) >=
          double.parse(minimumtransaksi)) {
        if (((double.parse(persentasevoucher) / 100) *
                double.parse(harga) *
                double.parse(durasi)) >=
            double.parse(nominalmaksVoucher)) {
          nominalV = double.parse(nominalmaksVoucher);
        } else {
          nominalV = (double.parse(persentasevoucher) / 100) *
              double.parse(harga) *
              double.parse(durasi);
        }
      } else {
        nominalV = 0;
      }
    }
    return nominalV;
  }

  cekToken(String access_token, refresh_token, idcustomer, email, nama_customer,
      BuildContext context) async {
    ApiService _apiService;
    var newtoken = "";
    bool isSuccess = false;
    SharedPreferences sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    idcustomer = sp.getString("idcustomer");
    email = sp.getString("email");
    nama_customer = sp.getString("nama_customer");
    //checking jika token kosong maka di arahkan ke menu login jika tidak akan meng-hold token dan refresh token
    if (idcustomer.toString() == '0') {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Peringatan'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Data profile anda belum lengkap.'),
                    Text('Harap melengkapi data anda terlebih dahulu !'),
                  ],
                ),
              ),
              actions: <Widget>[
                Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text("Lengkapi"),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    TambahProfile()),
                            (Route<dynamic> route) => false);
                      },
                    ),
                    FlatButton(
                      child: Text("Batalkan"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            );
          });
    }
    if (access_token == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    } else {
      _apiService
          .checkingToken(access_token)
          .then((value) => isSuccess = value);
      //checking jika token expired/tidak berlaku maka akan di ambilkan dari refresh token
      if (!isSuccess) {
        _apiService
            .refreshToken(refresh_token)
            .then((value) => newtoken = value);
        //setting access_token dari refresh_token
        if (newtoken != "") {
          sp.setString("access_token", newtoken);
          access_token = newtoken;
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
              (Route<dynamic> route) => false);
        }
      }
    }
  }

  getSaldo(String access_token) async {
    final response = await http.get(ApiService().urlceksaldo,
        headers: {"Authorization": "BEARER ${access_token}"});
    var saldo = json.decode(response.body);
    return saldo;
    // return saldo;
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        print("ini konfirmasi order detail");
        Navigator.pushReplacement(
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

  sk() async {
    ApiService _apiService = ApiService();
    print('///xxx///');
    print(await http.read('https://server.horang.id/adminmaster/sk.txt'));
  }
}
