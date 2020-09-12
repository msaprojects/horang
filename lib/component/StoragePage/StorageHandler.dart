import 'package:flutter/material.dart';

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
        vsync: this, length: 2); //LENGTH = TOTAL TAB YANG AKAN DIBUAT
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
                  icon: new Icon(Icons.all_inclusive, color: Colors.black),
                  text: "Sedang Berjalan"),
              new Tab(
                icon: new Icon(Icons.clear, color: Colors.black),
                text: "Pesanan Expired",
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: controller,
          children: <Widget>[
            // OnGoing(),
            StorageActive(),
            StorageExpired()
          ],
        ),
      ),
    );
  }
}
