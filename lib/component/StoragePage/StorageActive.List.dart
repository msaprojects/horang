import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/mystorage/mystorageModel.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/Key/KonfirmasiLog.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/reusable.class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageActive1 extends StatefulWidget {
  final TabController tabController2;

  StorageActive1({this.tabController2});
  @override
  _StorageActive createState() => _StorageActive();
}

class _StorageActive extends State<StorageActive1>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  SharedPreferences sp;
  ApiService _apiService = ApiService();
  bool isSuccess = false;
  var access_token,
      refresh_token,
      idcustomer,
      nama,
      nama_customer,
      keterangan,
      idtransaksi,
      idtransaksi_detail,
      kode_kontainer,
      noOrder,
      nama_kota,
      nama_lokasi,
      tanggal_order,
      hari,
      aktif,
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

// class OnGoing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
          future: _apiService.listMystorage(access_token),
          builder: (BuildContext context,
              AsyncSnapshot<List<MystorageModel>> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                    "9Something wrong with message ${snapshot.error.toString()}"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              List<MystorageModel> profiles =
                  snapshot.data.where((i) => i.status == "AKTIF").toList();
              if (profiles.isNotEmpty) {
                return _buildListview(profiles);
              } else {
                return Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/image/datanotfound.png"),
                        Text(
                          "Oppss..Maaf data order berjalan kosong.",
                          style: GoogleFonts.inter(color: Colors.grey),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Widget _buildListview(List<MystorageModel> dataIndex) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16, top: 30),
                color: Colors.grey[100],
                child: (ListView.builder(
                  itemCount: dataIndex == null ? 0 : dataIndex.length,
                  itemBuilder: (BuildContext context, int index) {
                    MystorageModel myStorage = dataIndex[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() => isLoading = true);
                        if (idcustomer == "0") {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Anda Harus Melengkapi profile untuk melakukan transaksi!'),
                            duration: Duration(seconds: 10),
                          ));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => KonfirmasiLog(
                                    kode_kontainer: myStorage.kode_kontainer,
                                    nama_kota: myStorage.nama_kota,
                                    noOrder: myStorage.noOrder,
                                    // idtransaksi_detail: ,
                                    idtransaksi_detail:
                                        myStorage.idtransaksi_detail,
                                    idtransaksi: myStorage.idtransaksi,
                                    nama: myStorage.nama,
                                    tglmulai: myStorage.tanggal_mulai,
                                    tglakhir: myStorage.tanggal_akhir,
                                    tglorder: myStorage.tanggal_order,
                                    keterangan: myStorage.keterangan,
                                    flag_selesai: myStorage.flag_selesai,
                                    selesai: myStorage.selesai,
                                  )));
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Card(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'No. Orderz : ',
                                              style: GoogleFonts.inter(
                                                  fontSize: 14),
                                            ),
                                            Flexible(
                                              child: Text(
                                                myStorage.noOrder.toString(),
                                                style: GoogleFonts.inter(
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Kode Kontainer : ',
                                              style: GoogleFonts.inter(
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              myStorage.kode_kontainer,
                                              style: GoogleFonts.inter(
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Jenis Kontainer : ',
                                              style: GoogleFonts.inter(
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              myStorage.nama,
                                              style: GoogleFonts.inter(
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              // 'Lokasi : '+myStorage.idtransaksi_detail.toString(),
                                              'Lokasi : ',
                                              style: GoogleFonts.inter(
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              myStorage.nama_lokasi,
                                              style: GoogleFonts.inter(
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Text(
                                            "Ketuk untuk detail...",
                                            style: GoogleFonts.lato(
                                                fontSize: 12,
                                                fontStyle: FontStyle.italic),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.push(
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

  AccountValidation(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Lengkapi Profile anda"),
      content: Text("Anda harus melengkapi akun sebelum melakukan transaksi!"),
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
