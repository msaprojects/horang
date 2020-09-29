
import 'package:flutter/material.dart';
import 'package:horang/api/models/log/listlog.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListLog extends StatefulWidget {
  @override
  _ListLogState createState() => _ListLogState();
  var iddetail_orders;
  ListLog({this.iddetail_orders});
}

class _ListLogState extends State<ListLog> {
  SharedPreferences sp;
  ApiService _apiService = ApiService();
  bool isSuccess = false;
  var access_token, refresh_token, idcustomer, iddetail_order0;

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    idcustomer = sp.getString("idcustomer");

    // iddetail_order = sp.getString("iddetail_order");
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
    iddetail_order0 = widget.iddetail_orders;
    super.initState();
    cekToken();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
          future: _apiService.listloggs(access_token, iddetail_order0),
          // builder: (),
          builder:
              (BuildContext context, AsyncSnapshot<List<LogList>> snapshot) {
            print('MASUK KANG $access_token');
            print('detOrder $iddetail_order0');
            if (snapshot.hasError) {
              print('MASUK KANG1');
              return Center(
                child: Text(
                    "Something wrong with message ${snapshot.error.toString()}"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              print('MASUK KANG3');
              List<LogList> logs1 = snapshot.data;
              // print("iamcannor ${snapshot.data}");
              return _buildListview(logs1);
            } else {
              print('MASUK KANG4');
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Widget _buildListview(List<LogList> dataIndex) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Log Konfirmasi",
          style: TextStyle(color: Colors.black),
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
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 16, right: 16),
          ),
          Expanded(
              child: Container(
            child: Container(
              padding: EdgeInsets.only(left: 16, right: 16, top: 30),
              color: Colors.grey[100],
              child: (ListView.builder(
                itemCount: dataIndex == null ? 0 : dataIndex.length,
                itemBuilder: (BuildContext context, int index) {
                  LogList log2 = dataIndex[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          // Container(
                          //   width: 90,
                          //   height: 90,
                          // ),
                          // SizedBox(
                          //   width: 14,
                          // ),
                          Expanded(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    log2.timestamp,
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    log2.status,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                },
                // separatorBuilder: (context, index) => Divider(),
                // itemCount: dataIndex.length,
              )),
            ),
          ))
        ],
      ),
    );
  }
}
