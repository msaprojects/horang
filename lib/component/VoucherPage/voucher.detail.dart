import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/voucher/voucher.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/reusable.class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VoucherDetail extends StatefulWidget {
  var sk, voucherdet, kode_voucher, nominal, keterangan, gambar;
  VoucherDetail(
      {this.sk,
        this.voucherdet,
      this.kode_voucher,
      this.nominal,
      this.keterangan,
      this.gambar});
  @override
  _VoucherDetailState createState() => _VoucherDetailState();
}

class _VoucherDetailState extends State<VoucherDetail> {
  SharedPreferences sp;
  bool _isLoading = false, isSuccess = true;
  var access_token,
      refresh_token,
      idcustomer,
      kode_voucher1,
      nominal1,
      keterangan1,
      gambar1,
      nama_customer,
      pin,
      sk;
  ApiService _apiService = ApiService();

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
    sk = widget.sk;
    kode_voucher1 = widget.kode_voucher;
    nominal1 = widget.nominal;
    keterangan1 = widget.keterangan;
    gambar1 = widget.gambar;
    // print("cek gambar {$gambar1}");
    cekToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Detail Voucher",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(gambar1), fit: BoxFit.cover),
                ),
              ),
              Container(
                child: Center(
                  child: Container(
                    height: 140,
                    child: Card(
                      margin: EdgeInsets.all(18),
                      elevation: 7.0,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Kode Voucher : $kode_voucher1",
                                style: GoogleFonts.inter(fontSize: 14)),
                            Divider(),
                            Text("Nominal Voucher : $nominal1",
                                style: GoogleFonts.inter(fontSize: 12))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
                child: Container(
                  color: Colors.grey[300],
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: Text("Syarat dan Ketentuan",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(keterangan1, style: GoogleFonts.inter(fontSize: 12)),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
