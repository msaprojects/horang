import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:horang/component/LogPage/log_aktifitas.dart';

class LogHandler extends StatelessWidget {
  final int initialIndex;
  LogHandler({Key key, this.initialIndex}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        initialIndex: initialIndex ?? 0,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              unselectedLabelColor: Colors.redAccent,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.redAccent),
              tabs: [
                Tab(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.050,
                    width: MediaQuery.of(context).size.height * 0.150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.redAccent, width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Apps"),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                     height: MediaQuery.of(context).size.height * 0.050,
                    width: MediaQuery.of(context).size.height * 0.150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.redAccent, width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Promo"),
                    ),
                  ),
                ),
              ],
            ),
            title:
                Text('Log Aktifitas Aplikasi', style: (TextStyle(color: Colors.black))),
            elevation: 0,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            backgroundColor: Colors.white,
          ),
          body: TabBarView(
            children: [
             LogAktifitasNotif(),
             LogAktifitasNotif()
            
            ],
          ),
        ),
      ),
    );
  }
}
