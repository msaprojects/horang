import 'package:flutter/material.dart';

class SyaratDanKetentuan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Syarat dan Ketentuan",
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
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Center(
                child: Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Syarat dan ketentuan HORANG",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ],
                    )),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Syarat dan ketentuan yang ditetapkan dibawah ini mengatur pemakaian layanan yang ditawarkan oleh PT. Indah Horang Pintar.",
                    textAlign: TextAlign.justify
                  ),
                  Text(
                    "Selamat datang diaplikasi HORANG!",
                    style: (TextStyle(fontWeight: FontWeight.bold)), textAlign: TextAlign.right,
                  ),                  
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
