import 'package:flutter/material.dart';
import 'package:horang/utils/constant_color.dart';

class AccountChecker extends StatelessWidget {
  final bool login;
  final Function press;
  const AccountChecker({
    Key key,
    this.login = true,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Belum Punya Akun ?" : "Sudah Punya Akun ?",
          style: TextStyle(color: primaryColor, fontSize: 14),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? " Registrasi" : " Login",
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
