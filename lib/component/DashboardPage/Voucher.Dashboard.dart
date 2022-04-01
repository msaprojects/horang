import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/voucher/voucher.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/VoucherPage/voucher.detail.dart';
import 'package:horang/component/DashboardPage/home_page.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/constant_style.dart';
import 'package:horang/utils/reusable.class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VoucherDashboard extends StatefulWidget {
  @override
  _VoucherDashboard createState() => _VoucherDashboard();
}

class _VoucherDashboard extends State<VoucherDashboard> {
  int _current = 0;
  Widget currentScreen = HomePage();
  late SharedPreferences sp;
  ApiService _apiService = ApiService();
  bool isSuccess = false;
  var sk,
      access_token,
      refresh_token,
      idcustomer,
      email,
      nama_customer,
      nama,
      pin;

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
    return FutureBuilder(
      future: _apiService.listVoucher(access_token),
      builder:
          (BuildContext context, AsyncSnapshot<List<VoucherModel>?> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Center(
            child: Text("4wrong with message: ${snapshot.error.toString()}"),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          List<VoucherModel> voucher = snapshot.data!;
          if (voucher.isNotEmpty) {
            return _listPromo(voucher);
          } else {
            return Container(
              margin: EdgeInsets.only(bottom: 20),
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Card(
                child: GestureDetector(
                  onTap: () {},
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: Colors.orange,
                        size: 18,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Anda Belum Ada Transaksi...",
                        style: GoogleFonts.lato(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
                ),
              ),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _listPromo(List<VoucherModel> dataIndex) {
    if (idcustomer == "0") {
      nama = email;
    } else {
      nama = nama_customer;
    }

    return Column(
      children: <Widget>[
        Container(
          child: Text(
            "Promo",
            style: mTitleStyle,
          ),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(bottom: 10),
        ),
        Container(
          alignment: Alignment.centerLeft,
          // margin: EdgeInsets.only(left: 16, right: 16),
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: Swiper(
            // pagination: new SwiperPagination(),
            pagination: new SwiperPagination(
              alignment: Alignment.bottomCenter,
              builder: new DotSwiperPaginationBuilder(
                  color: Colors.grey, activeColor: Colors.red),
            ),
            control: new SwiperControl(color: Color(0xff38547C)),
            loop: false,
            autoplay: true,
            layout: SwiperLayout.DEFAULT,
            itemBuilder: (BuildContext context, index) {
              VoucherModel voucher = dataIndex[index];
              return Container(
                child: Container(
                  child: GestureDetector(
                    onTap: () {
                      print('HEY YU $sk');
                      _apiService
                          .ambildataSyaratKetentuan(sk)
                          .then((value) => setState(() {
                                sk = value.toString();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VoucherDetail(
                                            sk: sk,
                                            nominal: voucher.min_nominal,
                                            gambar: voucher.gambar,
                                            keterangan: voucher.keterangan,
                                            kode_voucher:
                                                voucher.kode_voucher)));
                              }));
                    },
                  ),
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                        image: NetworkImage(voucher.gambar), fit: BoxFit.cover),
                  ),
                ),
              );
            },
            itemCount: dataIndex.length,
          ),
        ),
      ],
    );
  }
}
