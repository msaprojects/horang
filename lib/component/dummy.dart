import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/order/order.sukses.model.dart';

class dummyDesign extends StatefulWidget {
  @override
  _dummyDesignState createState() => _dummyDesignState();
}

class _dummyDesignState extends State<dummyDesign> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 100,
            ),
            Container(
              width: double.infinity,
              // height: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        "ORDER NUMBER: 1109928129819282",
                        style:
                            GoogleFonts.lato(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: ListView.builder(
                itemBuilder: (context, index){
                  
                }),
            ),
            Container(
              height: 10,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/image/paper_gold.png"),
                      fit: BoxFit.fill)),
            )
          ],
        ),
      ),
      // body: Center(
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       Container(
      //         padding: EdgeInsets.only(left: 20, right: 20),
      //         child: ClipPath(
      //             clipper: TicketClipper(),
      //             child: Card(
      //               elevation: 4,
      //               child: Container(
      //                 color: Colors.white,
      //                 width: double.maxFinite,
      //                 height: 400,
      //                 child: Text(
      //                     "On MacOs, installing Android Studio 3.6 or above creates a new path to sdkmanager that is not recognized by flutter. When you get to sdk folder, there is a new cmdline-tools folder and inside it you can find bin folder. But flutter was looking for sdk/tools/bin. Downgrading to Android Studio 3.5.3 solved the problem. Thanks terence. – Alexandre Mucci Mar 4 at 13:40"),
      //               ),
      //             )),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    Path path = Path();

    path.lineTo(0, size.height);
    var radius = 11.0;
    int jumlahreg = (size.width / (radius * 2)).toInt();
    if (jumlahreg % 2 == 0) jumlahreg--;
    path.lineTo((size.width - 2 * radius * jumlahreg) / 2, size.height);
    for (int i = 0; i < jumlahreg; i++)
      if (i % 2 == 0) {
        path.relativeArcToPoint(Offset(2.0 * radius * 1.3, 0),
            radius: Radius.circular(radius), clockwise: true);
      } else {
        path.relativeLineTo(2 * radius * 0.7, 0);
      }
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
    // path.lineTo(size.width, size.height);
    // path.lineTo(size.width, 0.0);

    // path.addOval(Rect.fromCircle(
    //   center: Offset(0.0, size.height / 2), radius: 20.0
    // ));
    // path.addOval(Rect.fromCircle(
    //   center: Offset(size.width, size.height / 2), radius: 20.0
    // ));

    // return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
