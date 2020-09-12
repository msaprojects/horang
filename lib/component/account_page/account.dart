import 'package:flutter/material.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/account_page/tambah_profile.dart';
import 'package:horang/component/account_page/ubah_password.dart';
import 'package:horang/component/account_page/ubah_pin.dart';
import 'package:horang/component/account_page/ubah_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  @override
  // ignore: override_on_non_overriding_member
  var objectt;
  // Account({this.objectt});
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  SharedPreferences sp;
  ApiService _apiService = ApiService();
  bool isSuccess = false;
  // ignore: non_constant_identifier_names
  var access_token, refresh_token, idcustomer, email, nama_customer, idpengguna, routing;

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    refresh_token = sp.getString("refresh_token");
    idcustomer = sp.getString("idcustomer");
    nama_customer = sp.getString("nama_customer");
    email = sp.getString("email");
    //checking jika token kosong maka di arahkan ke menu login jika tidak akan meng-hold token dan refresh token
    if (access_token == null) {
      showAlertDialog(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    } else {
      _apiService.checkingToken(access_token).then((value) => setState(() {
            isSuccess = value;
            //checking jika token expired/tidak berlaku maka akan di ambilkan dari refresh token
            if (!isSuccess) {
              _apiService
                  .refreshToken(refresh_token)
                  .then((value) => setState(() {
                        var newtoken = value;
                        //setting access_token dari refresh_token
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
    cekToken();
  }

  @override
  Widget build(BuildContext context) {
    void Keluarr() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      cekToken();
      await preferences.clear();
      if (preferences.getString("access_token") == null) {
        print("SharePref berhasil di hapus");
      }
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Profile",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.transparent,
              ),
              onPressed: () {}),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            ),
            Container(
              child: Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Card(
                  color: Colors.grey[200],
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 50,
                        child: ClipOval(
                          child: Image.asset('assets/image/userpng.png'),
                        ),
                      ),
                      // Text("$nama_customer")
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "$nama_customer",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "$email")
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ),
            
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Lengkapi Profile"),
              trailing: Icon(Icons.keyboard_arrow_right),
              //onTap: () {routing();}),
              onTap:(){
                if(nama_customer == "0"){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TambahProfile()));
                }else{
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UbahProfile()));
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text("Ubah Pin"),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(context,
                    // MaterialPageRoute(builder: (context) => Pin2()));
                    MaterialPageRoute(builder: (context) => UbahPin()));
                // UbahProfile();
              },
            ),

            ListTile(
              leading: Icon(Icons.phonelink_lock),
              title: Text("Ubah Password"),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UbahPass()));
                // UbahProfile();
              },
            ),
            ListTile(
              leading: Icon(Icons.event_note),
              title: Text("Syarat dan Ketentuan"),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.loop),
              title: Text("Logout"),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Keluarr();
              },
            ),
          ],
        ));
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
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
