import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/jenisproduk/jenisproduk.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/OrderPage/Order.Input2.dart';
import 'package:horang/utils/constant_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProdukDashboard extends StatefulWidget {
  @override
  _ProdukDashboard createState() => _ProdukDashboard();
}

class _ProdukDashboard extends State<ProdukDashboard> {
  SharedPreferences sp;
  ApiService _apiService = ApiService();
  bool isSuccess = false;
  var access_token,
      refresh_token,
      idcustomer,
      email,
      nama_customer,
      nama,
      gambar;

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
      future: _apiService.listJenisProduk(access_token),
      builder:
          (BuildContext context, AsyncSnapshot<List<JenisProduk>> snapshot) {
        print("hmm : ${snapshot.connectionState}");
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Center(
            child: Text(
                "2Something wrong with message: ${snapshot.error.toString()}"),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          List<JenisProduk> profiles = snapshot.data;
          return _buildlistview(profiles);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildlistview(List<JenisProduk> dataIndex) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      // height: MediaQuery.of(context).size.height * 0.35,
      height: 100,
      margin: EdgeInsets.only(left: 16, right: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          JenisProduk jenisProduk = dataIndex[index];
          return GestureDetector(
              onTap: () {
                if (idcustomer == "0") {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Anda Harus Melengkapi profile untuk melakukan transaksi!'),
                    duration: Duration(seconds: 10),
                  ));
//                        Navigator.pop(context, false);
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return FormInputOrder(
                      jenisProduk: jenisProduk,
                    );
                  }));
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: EdgeInsets.all(8),
                height: 64,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: mFillColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: mBorderColor, width: 1),
                ),
                child: Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                jenisProduk.kapasitas,
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: mTitleColor),
                              ),
                              Text(
                                jenisProduk.nama_kota,
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                    color: mSubtitleColor),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width * 0.3,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(jenisProduk.gambar))),
                            )
                          ],
                        )
                      ],
                    )),
              ));
        },
      ),
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

  // AccountValidation(BuildContext context) {
  //   Widget okButton = FlatButton(
  //     child: Text("OK"),
  //     onPressed: () {
  //       print("ini produk dashboard");
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => LoginPage()));
  //     },
  //   );
  //   AlertDialog alert = AlertDialog(
  //     title: Text("Lengkapi Profile anda"),
  //     content: Text("Anda harus melengkapi akun sebelum melakukan transaksi!"),
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
