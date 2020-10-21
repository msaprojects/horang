import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:horang/api/models/log/listlog.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_tile/timeline_tile.dart';

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
  var access_token, refresh_token, idcustomer, idtransaksi_detail1;

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
    idtransaksi_detail1 = widget.iddetail_orders;
    super.initState();
    cekToken();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
          future: _apiService.listloggs(access_token, idtransaksi_detail1),
          // builder: (),
          builder:
              (BuildContext context, AsyncSnapshot<List<LogList>> snapshot) {
            print('MASUK KANG $access_token');
            print('detOrder $idtransaksi_detail1');
            if (snapshot.hasError) {
              print('MASUK KANG1');
              return Center(
                child: Text(
                    "Something wrong with message ${snapshot.error.toString()}"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              print('MASUK KANG3');
              List<LogList> logs1 = snapshot.data;
              print(snapshot.data);
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
          "List Log",
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
                  return TimelineTile(
                    axis: TimelineAxis.vertical,
                    alignment: TimelineAlign.manual,
                    lineXY: 0.1,
                    isFirst: index == 0,
                    isLast: index == dataIndex.length - 1,
                    indicatorStyle: IndicatorStyle(
                      width: 40,
                      height: 40,
                      color: Colors.red,
                      padding: EdgeInsets.only(left: 5),
                      indicator: _IndicatorExample(
                        number: '${index + 1}',
                      ),
                      drawGap: true,
                    ),
                    beforeLineStyle: LineStyle(
                      color: Colors.black.withOpacity(0.2),
                    ),
                    endChild: Padding(
                      padding: EdgeInsets.all(25),
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.only(left: 10, top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(log2.timestamp, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                              Text(log2.status)
                            ],
                          ),
                        )
                      ),
                      ),
                  );
                },
              )),
            ),
          ))
        ],
      ),
    );
  }
}

class _IndicatorExample extends StatelessWidget {
  const _IndicatorExample({Key key, this.number}) : super(key: key);

  final String number;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.fromBorderSide(
          BorderSide(
            color: Colors.black.withOpacity(0.2),
            width: 4,
          ),
        ),
      ),
      child: Center(
        child: Text(
          number,
          style: const TextStyle(fontSize: 20, color: Colors.redAccent),
        ),
      ),
    );
  }
}
