import 'package:commons/commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/mystorage/mystorageModel.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/Key/KonfirmasiLog.dart';
import 'package:horang/utils/constant_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageActive extends StatefulWidget {
  @override
  _StorageActive createState() => _StorageActive();
}

class _StorageActive extends State<StorageActive> {
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
        future: _apiService.listMystorage(access_token),
        builder: (BuildContext context,
            AsyncSnapshot<List<MystorageModel>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "3Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<MystorageModel> profiles = snapshot.data
                .where((element) => element.status == "AKTIF")
                .toList();
            if (profiles.isNotEmpty) {
              return _buildlistview(profiles);
            } else {
              print("gdmntit");
              return Container(
                margin: EdgeInsets.only(bottom: 20),
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Card(
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
              );
            }
          }
        });
  }

  Widget _buildlistview(List<MystorageModel> dataIndex) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      // height: MediaQuery.of(context).size.height * 0.35,
      height: 100,
      margin: EdgeInsets.only(left: 16, right: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dataIndex.length,
        itemBuilder: (context, index) {
          MystorageModel kontainerActive = dataIndex[index];
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
                    return KonfirmasiLog(
                      noOrder: kontainerActive.noOrder,
                      tglakhir: kontainerActive.tanggal_akhir,
                      tglmulai: kontainerActive.tanggal_mulai,
                      tglorder: kontainerActive.tanggal_order,
                      keterangan: kontainerActive.keterangan,
                      kode_kontainer: kontainerActive.kode_kontainer,
                      nama_kota: kontainerActive.nama_kota,
                      idtransaksi_detail: kontainerActive.idtransaksi_detail,
                      nama: kontainerActive.nama,
                      // jenisProduk: jenisProduk,
                    );
                  }));
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: EdgeInsets.all(8),
                height: 64,
                width: MediaQuery.of(context).size.width * 0.5,
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
                                kontainerActive.kode_kontainer,
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: mTitleColor),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Divider(
                                height: 3,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                kontainerActive.nama,
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                    color: mSubtitleColor),
                              ),
                              Text(
                                kontainerActive.nama_kota,
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: mSubtitleColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ));
        },
      ),
    );
  }
}
