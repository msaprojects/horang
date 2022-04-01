import 'package:flutter/material.dart';
import 'package:horang/component/StoragePage/StorageActive.List.dart';
import 'package:horang/component/StoragePage/StorageExpired.List.dart';
import 'package:horang/component/StoragePage/StorageNonActive.List.dart';

class StorageHandler extends StatefulWidget {
  late int ? initialIndexz;
  StorageHandler({Key? key,required this.initialIndexz}) : super(key: key);

  @override
  State<StorageHandler> createState() => _StorageHandlerState();
}

class _StorageHandlerState extends State<StorageHandler> with SingleTickerProviderStateMixin {
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        // initialIndex: initialIndexz ?? 0,
        initialIndex: widget.initialIndexz = 0,
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
                Text('Status Pesanan', style: (TextStyle(color: Colors.black))),
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
