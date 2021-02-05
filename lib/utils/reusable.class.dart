import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/account_page/tambah_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReusableClasses {
  PerhitunganOrder(
    num persentasevoucher,
    double minimumtransaksi,
    bool boolasuransi,
    bool boolvoucher,
    var nominalVoucher,
    var harga,
    var durasi,
    var nominalbaranginput,
    var ceksaldopoint,
    num minimaldeposit,
    num asuransi,
  ) {
    var hasilperhitungan;
    if (boolasuransi == false) asuransi = 0;
    if (boolvoucher == false) {
      hasilperhitungan = ((double.parse(harga) * double.parse(durasi)) +
              ((asuransi / 100) * double.parse(nominalbaranginput)) +
              minimaldeposit * double.parse(harga) -
              double.parse(ceksaldopoint))
          .toStringAsFixed(2);
    } else {
      if ((double.parse(durasi) * double.parse(harga)) >= minimumtransaksi) {
        if ((persentasevoucher * double.parse(harga) * double.parse(durasi)) >=
            double.parse(nominalVoucher)) {
          hasilperhitungan = ((double.parse(harga) * double.parse(durasi)) +
                  ((asuransi / 100) * double.parse(nominalbaranginput)) +
                  minimaldeposit * double.parse(harga) -
                  double.parse(ceksaldopoint) -
                  double.parse(nominalVoucher))
              .toStringAsFixed(2);
        } else {
          hasilperhitungan = ((double.parse(harga) * double.parse(durasi)) +
                  ((asuransi / 100) * double.parse(nominalbaranginput)) +
                  minimaldeposit * double.parse(harga) -
                  double.parse(ceksaldopoint) -
                  (persentasevoucher *
                      double.parse(harga) *
                      double.parse(durasi)))
              .toStringAsFixed(2);
        }
      } else {
        hasilperhitungan = ((double.parse(harga) * double.parse(durasi)) +
                ((asuransi / 100) * double.parse(nominalbaranginput)) +
                minimaldeposit * double.parse(harga) -
                double.parse(ceksaldopoint))
            .toStringAsFixed(2);
      }
    }
    return hasilperhitungan;
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
    num saldo = jsonDecode(response.body);
    return saldo;
  }
}
