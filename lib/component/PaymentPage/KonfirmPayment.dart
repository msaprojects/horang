import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KonfirmPayment extends StatefulWidget {
  @override
  _KonfirmPaymentState createState() => _KonfirmPaymentState();
}

class _KonfirmPaymentState extends State<KonfirmPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Expanded(
                child: Column(
              children: [
                Text("Masukkan nomor yang terdaftar di OVO",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    hintText: "Ovo",
                    labelText: "Ovo",
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "1. Buka aplikasi OVO dan cek notifikasi untuk menyelesaikan pembayaran",
                  style: GoogleFonts.inter(height: 1.5, fontSize: 14),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "2. Pastikan Anda melakukan pembayaran dalam waktu 30 detik untuk menghindari pembatalan secara otomatis.",
                  style: GoogleFonts.inter(height: 1.5, fontSize: 14),
                ),
              ],
            )),
            FlatButton(
              color: Colors.green,
              child: Text(
                "Bayar Sekarang",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
