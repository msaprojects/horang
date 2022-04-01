import 'package:intl/intl.dart';

class CurrencyFormat {
  static String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat rupiah = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return rupiah.format(number);
  }
}