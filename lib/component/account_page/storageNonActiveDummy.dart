import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/log/openLog.dart';
import 'package:horang/api/models/mystorage/mystorageModel.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/Key/KonfirmasiLog.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/reusable.class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sksk extends StatefulWidget {
  final TabController tabController1;
  const Sksk({Key key, this.tabController1}) : super(key: key);
  @override
  _StorageNonActive createState() => _StorageNonActive();
}

class _StorageNonActive extends State<Sksk> {
  bool isLoading = false;
  SharedPreferences sp;
  ApiService _apiService = ApiService();
  bool isSuccess = false, _loading = true;
  var access_token,
      refresh_token,
      idcustomer,
      iddetail_trans,
      pin,
      nama,
      nama_customer,
      keterangan,
      noOrder,
      kode_kontainer,
      nama_kota,
      nama_lokasi,
      tanggal_order,
      hari,
      aktif;

  List<MystorageModel> ngeList = <MystorageModel>[];
  List<MystorageModel> ngeList1 = <MystorageModel>[];

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
    // _apiService.listMystorage(access_token).then((value) {
    //   setState(() {
    //     ngeList.addAll(value);
    //     ngeList1 = ngeList;
    //   });
    // });
    // _loading = false;
    super.initState();
    cekToken();
  }

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
                    "Something wrong with message ${snapshot.error.toString()}"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              // List<MystorageModel> profiles =
              //     snapshot.data.where((i) => i.status == "NONAKTIF").toList();
              var profiles = ngeList = snapshot.data
                  .where((element) => element.status == "NONAKTIF")
                  .toList();
              // print('profilezz'+ ngeList1.toString());
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
                          "Oppss..Maaf data kontainer belum aktif kosong.",
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

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(hintText: 'Cari...'),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            print('tes1 $ngeList');
            ngeList1 = ngeList.where((element){
                var posjudul = element.noOrder.toLowerCase();
                print('dapat apa ?? ${posjudul.toLowerCase()} -- $text');
                return posjudul.contains(text);
              }).toList();
            });
            //   var posjudul = element.noOrder.toLowerCase();
            //   return posjudul.contains(text);
            // }).toList();
          // });
        },
      ),
    );
  }

  Widget _buildListview(List<MystorageModel> dataIndex) {
    return Scaffold(
      body: ListView.builder(
        itemCount: ngeList.length + 1,
        itemBuilder: (context, index) {
          print("wkwkwkw $index");
          return index == 0 ? _searchBar() : listItem(index -1);
          // MystorageModel myStorage = ngeList[index];
          // if (!_loading) {
          //   if (ngeList.length > 0){
          //   // return listItem(index);
          //   return index == 0 ? _searchBar() : listItem(index - 1);
          // } else {
          //   return Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }
        },
      ),
    );
  }

  listItem(index) {
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
          _openAlertDialog(
            context,
            ngeList[index].idtransaksi_detail,
            ngeList[index].noOrder.toString(),
            ngeList[index].kode_kontainer.toString(),
            ngeList[index].nama_kota,
            ngeList[index].nama,
            ngeList[index].nama_lokasi.toString(),
            ngeList[index].keterangan,
            ngeList[index].tanggal_order,
            ngeList[index].tanggal_mulai,
            ngeList[index].tanggal_akhir,
            ngeList[index].hari.toString(),
          );
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'No. Order : ',
                              style: GoogleFonts.inter(fontSize: 14),
                            ),
                            Flexible(
                              child: Text(
                                ngeList[index].noOrder.toString(),
                                style: GoogleFonts.inter(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Kode Kontainer : ',
                              style: GoogleFonts.inter(fontSize: 14),
                            ),
                            Text(
                              ngeList[index].kode_kontainer,
                              style: GoogleFonts.inter(fontSize: 14),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Jenis Kontainer : ',
                              style: GoogleFonts.inter(fontSize: 14),
                            ),
                            Text(
                              ngeList[index].nama,
                              style: GoogleFonts.inter(fontSize: 14),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              // 'Lokasi : '+myStorage.idtransaksi_detail.toString(),
                              'Lokasi : ',
                              style: GoogleFonts.inter(fontSize: 14),
                            ),
                            Text(
                              ngeList[index].idtransaksi_detail.toString(),
                              // myStorage.nama_lokasi,
                              style: GoogleFonts.inter(fontSize: 14),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            "Ketuk untuk detail...",
                            style: GoogleFonts.lato(
                                fontSize: 12, fontStyle: FontStyle.italic),
                          ),
                        )
                      ],
                    ),
                    // );
                    //   },
                    // ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

  void _openAlertDialog(
      BuildContext context,
      int idtransaksi_detail,
      String noOrder,
      kode_kontainer,
      nama_kota,
      nama,
      nama_lokasi,
      keterangan,
      tanggal_order,
      tanggal_mulai,
      tanggal_akhir,
      hari) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Container(
              width: 260.0,
              height: 350.0,
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color(0xFFFFFF),
                borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
              ),
              child: new Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              "Detail Pesanan...",
                              style: GoogleFonts.lato(fontSize: 12),
                            ),
                          ),
                          Divider(),
                          SizedBox(
                            height: 10,
                          ),
                          Text("No. Order : " + noOrder.toString(),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Kode Kontainer : " + kode_kontainer.toString(),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Kota : " + nama_kota.toString(),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Jenis : " + nama.toString(),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Nama Lokasi : " + nama_lokasi.toString(),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Keterangan : " + keterangan.toString(),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Lama Order : " + hari.toString() + " Hari",
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Tanggal Order : " + tanggal_order.toString(),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Tanggal Mulai : " + tanggal_mulai.toString(),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Tanggal Akhir : " + tanggal_akhir.toString(),
                              style: GoogleFonts.lato(fontSize: 14)),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              // width: 900,
                              child: Column(
                            children: [
                              Container(
                                width: 900,
                                // height: 40,
                                child: FlatButton(
                                    height: 40,
                                    color: Colors.blue,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.exit_to_app_outlined,
                                            color: Colors.white),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Kembali',
                                          style: GoogleFonts.inter(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          )),
                        ],
                      ),
                    )
                  ]),
            ),
          );
        });
  }

  void _alertOpen(
      BuildContext context,
      int idtransaksi_detail,
      String noorder,
      kode_kontainer,
      nama_kota,
      nama,
      nama_lokasi,
      keterangan,
      tanggal_order,
      tanggal_mulai,
      tanggal_akhir,
      hari) {
    // var ket = _note.text.toString();
    Widget cancelButton = FlatButton(
      child: Text("Batal"),
      onPressed: () => Navigator.pop(context),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Konfirmasi Action" + idtransaksi_detail.toString()),
            content: Text("Apakah anda ingin membuka kontainer ini ?"),
            actions: [
              FlatButton(onPressed: () {}, child: Text("Ya, Setuju")),
              cancelButton
            ],
          );
        });
  }
}
