import 'package:flutter/material.dart';
import 'package:horang/component/StoragePage/StorageNonActive.List.dart';

import 'StorageActive.List.dart';
import 'StorageExpired.List.dart';

void main() {
  runApp(StorageHandler());
}

class StorageHandler extends StatefulWidget {
  @override
  _StorageHandler createState() => _StorageHandler();
}

class _StorageHandler extends State<StorageHandler>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(
        vsync: this, length: 3); //LENGTH = TOTAL TAB YANG AKAN DIBUAT
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Order Status",
            style: (TextStyle(color: Colors.black)),
          ),
          elevation: 0,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {}),
          backgroundColor: Colors.white,
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.black,
            controller: controller,
            tabs: <Widget>[
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
        ),
        body: TabBarView(
          controller: controller,
          children: <Widget>[
            // OnGoing(),
            StorageNonActive(),
            StorageActive(),
            StorageExpired(),
          ],
        ),
      ),
    );
  }
}
