import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/history/history.model.deposit.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/screen/welcome_page.dart';
import 'package:horang/utils/reusable.class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryDeposit extends StatefulWidget {
  const HistoryDeposit({Key key}) : super(key: key);

  @override
  _HistoryDepositState createState() => _HistoryDepositState();
}

class _HistoryDepositState extends State<HistoryDeposit> {
  SharedPreferences sp;
  ApiService _apiService = ApiService();
  bool isSuccess = false;
  var access_token, refresh_token, nama_customer, idcustomer, pin;
  List<HistoryDepositModel> depo = [];
  String query = '', token = '';
  Timer debouncer;

  Text debitorkredit(int dk){
    if(dk == 0){
      return Text('Kredit', style: GoogleFonts.lato(fontSize: 12, color: Colors.red));
    } else {
      return Text('Debit', style: GoogleFonts.lato(fontSize: 12, color: Colors.green));
    }
  }

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
    depo = await _apiService.listHistoryDepo(access_token);
    setState(()=> this.depo = depo);
  }

  @override
  void initState() {
    super.initState();
    cekToken();
  }

  @override
  void dispose() {
    _apiService.client.close();
    debouncer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "History Deposit",
          style: GoogleFonts.lato(color: Colors.black),
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
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: _apiService.listHistoryDepo(access_token),
                builder: (BuildContext context, index) {
                  if (index.connectionState == ConnectionState.waiting) {
                    print('dapet gak1');
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (index.hasData) {
                    print('dapet gak3');
                    return ListView.builder(
                        itemCount: depo.length,
                        itemBuilder: (context, index) {
                          final deposit = depo[index];
                          print('deposit $deposit');
                          return _buildListview(deposit);
                        });
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
                              "Oppss..Maaf Data deposit belum ada",
                              style: GoogleFonts.inter(color: Colors.grey),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    );
                  }
                }),
          )
        ],
      ),
    );
  }

  Widget _buildListview(HistoryDepositModel depositModel) {
    return Container(
      child: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        child: Card(
          child: InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.all(10)),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(depositModel.created,
                                style: GoogleFonts.lato(fontSize: 12)),
                            Text('.',
                                style: GoogleFonts.lato(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                            Container(
                              child: debitorkredit(depositModel.debit),
                            )
                          ],
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(depositModel.noOrder, style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold)),
                                  Text(depositModel.nominal.toString(), style: GoogleFonts.lato(fontSize: 16)),
                                ],
                              ),
                              SizedBox(height: 2,),
                              Text(depositModel.keterangan, style: GoogleFonts.lato(fontSize: 12, color: Colors.black54)),
                              SizedBox(height: 10,),
                            ],
                          ),
                        )
                      ],
                    ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
