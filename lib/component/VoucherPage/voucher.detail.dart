import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/voucher/voucher.controller.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VoucherDetail extends StatefulWidget {
  var voucherdet, kode_voucher, nominal, keterangan, gambar;
  VoucherDetail(
      {this.voucherdet,
      this.kode_voucher,
      this.nominal,
      this.keterangan,
      this.gambar});
  @override
  _VoucherDetailState createState() => _VoucherDetailState();
}

class _VoucherDetailState extends State<VoucherDetail> {
  SharedPreferences sp;
  bool _isLoading = false, isSuccess = true;
  var access_token,
      refresh_token,
      idcustomer,
      kode_voucher1,
      nominal1,
      keterangan1,
      gambar1;
  ApiService _apiService = ApiService();

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    idcustomer = sp.getString("idcustomer");

    // //checking jika token kosong maka di arahkan ke menu login jika tidak akan meng-hold token dan refresh token
    if (access_token == null) {
      showAlertDialog(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    } else {
      _apiService.checkingToken(access_token).then((value) => setState(() {
            isSuccess = value;
            // checking jika token expired/tidak berlaku maka akan di ambilkan dari refresh token
            if (!isSuccess) {
              _apiService
                  .refreshToken(refresh_token)
                  .then((value) => setState(() {
                        var newtoken = value;
                        // setting access_token dari refresh_token
                        if (newtoken != "") {
                          sp.setString("access_token", newtoken);
                          access_token = newtoken;
                        } else {
                          showAlertDialog(context);
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
    super.initState();
    kode_voucher1 = widget.kode_voucher;
    nominal1 = widget.nominal;
    keterangan1 = widget.keterangan;
    gambar1 = widget.gambar;
    print("cek gambar {$gambar1}");
    cekToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(gambar1), fit: BoxFit.cover),
                ),
              ),
              Container(
                child: Center(
                  child: Container(
                    height: 140,
                    child: Card(
                      margin: EdgeInsets.all(18),
                      elevation: 7.0,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(kode_voucher1.toString(),
                                style: GoogleFonts.inter(fontSize: 14)),
                            Divider(),
                            Text(nominal1.toString(),
                                style: GoogleFonts.inter(fontSize: 12))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
                child: Container(
                  color: Colors.grey[300],
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: Text("Syarat dan Ketentuan",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child: Text(
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                    style: GoogleFonts.inter(fontSize: 12)),
              )
            ],
          ),
          // Center(
          //   child: Container(
          //     height: 140,
          //     child: Card(
          //       margin: EdgeInsets.all(18),
          //       elevation: 7.0,
          //       child: Center(
          //         child: Text("Text in a Card"),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
      // body: Container(
      //   child: Column(
      //     children: [
      //       Container(
      //         height: 200,
      //         decoration: BoxDecoration(
      //           image: DecorationImage(
      //               image: NetworkImage(gambar1), fit: BoxFit.cover),
      //         ),
      //       ),
      //       SizedBox(height: 20,),
      //       Container(
      //         padding: EdgeInsets.only(top: 200),
      //         height: 100,
      //         child: Card(
      //           color: Colors.red,
      //           borderOnForeground: true,
      //         ),

      //       )
      //     ],
      //   ),
      // ),
    );
    //     child: CustomScrollView(
    //   slivers: [
    //     SliverPersistentHeader(
    //       pinned: true,
    //       floating: true,
    //       delegate: CustomSliverDelegate(
    //         expandedHeight: 120,
    //       ),
    //     ),
    //     SliverFillRemaining(
    //       child: Center(
    //         child: Text(nominal1.toString()),
    //       ),
    //     )
    //   ],
    // )),
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        print("ini konfirmasi log");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Sesi Anda Berakhir!"),
      content: Text(
          "Harap masukkan kembali email beserta nomor handphone untuk mengakses fitur di aplikasi ini."),
      actions: [
        okButton,
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}

// class CustomSliverDelegate extends SliverPersistentHeaderDelegate {
//   final double expandedHeight;
//   final bool hideTitleWhenExpanded;

//   CustomSliverDelegate({
//     @required this.expandedHeight,
//     this.hideTitleWhenExpanded = true,
//   });

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     final appBarSize = expandedHeight - shrinkOffset * 10;
//     final cardTopPosition = expandedHeight / 2 - shrinkOffset;
//     final proportion = 2 - (expandedHeight / appBarSize);
//     final percent = proportion < 0 || proportion > 1 ? 0.0 : proportion;
//     return SizedBox(
//       height: expandedHeight + expandedHeight / 2,
//       child: Stack(
//         children: [
//           SizedBox(
//             height: appBarSize < kToolbarHeight ? kToolbarHeight : appBarSize,
//             child: AppBar(
//               backgroundColor: Colors.green,
//               leading: IconButton(
//                 icon: Icon(Icons.arrow_back),
//                 onPressed: () {},
//               ),
//               elevation: 0.0,
//               title: Opacity(
//                   opacity: hideTitleWhenExpanded ? 1.0 - percent : 1.0,
//                   child: Text("Test")),
//             ),
//           ),
//           Positioned(
//             left: 0.0,
//             right: 0.0,
//             top: cardTopPosition > 0 ? cardTopPosition : 0,
//             bottom: 0.0,
//             child: Opacity(
//               opacity: percent,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 30 * percent),
//                 child: Card(
//                   elevation: 20.0,
//                   child: Center(
//                     child: Text("Header"),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   // TODO: implement maxExtent
//   double get maxExtent => expandedHeight + expandedHeight / 2;

//   @override
//   // TODO: implement minExtent
//   double get minExtent => kToolbarHeight;

//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     // TODO: implement shouldRebuild
//     return true;
//   }
// }
