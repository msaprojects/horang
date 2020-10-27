import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:horang/api/models/voucher/voucher.controller.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/VoucherPage/voucher.detail.dart';
import 'package:horang/screen/home_page.dart';
import 'package:horang/utils/constant_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VoucherDashboard extends StatefulWidget {
  @override
  _VoucherDashboard createState() => _VoucherDashboard();
}

class _VoucherDashboard extends State<VoucherDashboard> {
  int _current = 0;
  Widget currentScreen = HomePage();

  SharedPreferences sp;
  ApiService _apiService = ApiService();
  bool isSuccess = false;
  var access_token, refresh_token, idcustomer, email, nama_customer, nama;

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    idcustomer = sp.getString("idcustomer");
    email = sp.getString("email");
    nama_customer = sp.getString("nama_customer");
    //checking jika token kosong maka di arahkan ke menu login jika tidak akan meng-hold token dan refresh token
    if (access_token == null) {
      // showAlertDialog(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
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
                          // showAlertDialog(context);
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _apiService.listVoucher(access_token),
      builder: (BuildContext context, AsyncSnapshot<List<Voucher>> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Center(
            child: Text(
                "Something wrong with message: ${snapshot.error.toString()}"),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          List<Voucher> voucher = snapshot.data;
          return _listPromo(voucher);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _listPromo(List<Voucher> dataIndex) {
//    print("Yuhuu.. ${nama_customer}");
    if (idcustomer == "0") {
      nama = email;
    } else {
      nama = nama_customer;
    }

    print(access_token);
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          // margin: EdgeInsets.only(left: 16, right: 16),
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: Swiper(
            autoplay: true,
            layout: SwiperLayout.DEFAULT,
            itemBuilder: (BuildContext context, index) {
              Voucher voucher = dataIndex[index];
              return Container(
                  child: Container(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return VoucherDetail(
                            nominal: voucher.nominal,
                            gambar: voucher.gambar,
                            keterangan: voucher.keterangan,
                          );
                        }));
                      },
                    ),
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                          image: NetworkImage(voucher.gambar),
                          fit: BoxFit.cover),
                    ),
                  ),
                );
            },
            itemCount: dataIndex.length,
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            //Lihat selengkapnya
            Text(
              'Lihat Selengkapnya...',
              style: mMorediscountstyle,
            )
          ],
        )
      ],
    );
  }

  // showAlertDialog(BuildContext context) {
  //   Widget okButton = FlatButton(
  //     child: Text("OK"),
  //     onPressed: () {
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => LoginPage()));
  //     },
  //   );
  //   AlertDialog alert = AlertDialog(
  //     title: Text("Sesi Anda Berakhir!"),
  //     content: Text(
  //         "Harap masukkan kembali email beserta nomor handphone untuk mengakses fitur di aplikasi ini."),
  //     actions: [
  //       okButton,
  //     ],
  //   );
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return alert;
  //       });
  // }
}
