import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class Dummy1 extends StatefulWidget {
  @override
  _Dummy1State createState() => _Dummy1State();
}

class _Dummy1State extends State<Dummy1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        // margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Icon(Icons.close_rounded),
            ),
            Container(
                child: Center(
              child: Image.asset(
                'assets/image/sikat_min1.gif',
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.contain,
              ),
            )),
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 2.0,
              child: Container(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Total Bayar",
                            style: GoogleFonts.inter(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("Rp. 8.000.000",
                            style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                      ],
                    ),
                    Divider(
                      height: 10,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Icon(Icons.timer),
                              SizedBox(
                                width: 5,
                              ),
                              Text("Menunggu pembayaran",
                                  style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Text("Refresh",
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text("Metode Pembayaran",
                style: GoogleFonts.inter(
                    fontSize: 14, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 15,
            ),
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 2.0,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20, right: 20),
                height: 50,
                child: Text("OVO"),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.warning_rounded, color: Colors.grey,),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Text(
                    "Buka aplikasi OVO anda dan cek pemberitahuan untuk menyelesaikan proses pembayaran. Tolong lakukan dalam 50 detik.",
                    style: GoogleFonts.lato(
                      fontSize: 12, height: 1.5, color: Colors.grey
                    ),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
