import 'package:flutter/material.dart';
import 'package:horang/component/StoragePage/StorageActive.List.dart';
import 'package:horang/component/StoragePage/StorageExpired.List.dart';
import 'package:horang/component/StoragePage/StorageNonActive.List.dart';

class StorageHandler extends StatelessWidget {
  final int initialIndex;
  StorageHandler({Key key, this.initialIndex}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
                  text: "Selesai",
                ),
              ],
            ),
            title:
                Text('Order Status', style: (TextStyle(color: Colors.black))),
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
