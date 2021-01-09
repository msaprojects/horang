import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/StoragePage/StorageActive.List.dart';
import 'package:horang/component/StoragePage/StorageExpired.List.dart';
import 'package:horang/component/StoragePage/StorageNonActive.List.dart';
import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   runApp(TabBarDemo());
// }

class StorageHandler extends StatelessWidget {

  final int initialIndex;
  StorageHandler({Key key, this.initialIndex}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    void Keluarr() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      // cekToken();
      await preferences.clear();
      if (preferences.getString("access_token") == null) {
        print("SharePref berhasil di hapus");
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => LoginPage()));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false);
      }
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        initialIndex: initialIndex ?? 0,
        child: Scaffold(
          appBar: AppBar(

            bottom: TabBar(
              labelColor: Colors.black,
              tabs: [
                new Tab(
                    icon: new Icon(Icons.timer, color: Colors.black),
                    text: "Belum Aktif"),
                new Tab(
                  icon: new Icon(Icons.av_timer_sharp, color: Colors.black),
                  text: "Berjalan",
                ),
                new Tab(
                  icon: new Icon(Icons.timer_off_rounded, color: Colors.black),
                  text: "Expired",
                ),
              ],
            ),
            title:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Debug for nusa', style: (TextStyle(color: Colors.black))),
                    IconButton(
                      icon: Icon(Icons.exit_to_app),
                      color: Colors.red, 
                      onPressed: (){
                        infoDialog(
                          context, 
                          "Apakah anda ingin keluar ?",
                          showNeutralButton: false,
                          negativeText: "Tidak",
                          negativeAction: (){},
                          positiveText: "Ya",
                          positiveAction: (){Keluarr();}
                          );
                      })
                  ],
                ),
            elevation: 0,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {}),
            backgroundColor: Colors.white,
          ),
          body: TabBarView(
            children: [
              StorageNonActive1(),
              StorageActive1(),
              StorageExpired1(),
            ],
          ),
        ),
      ),
    );
    
  }
}
