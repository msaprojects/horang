class ReusableClasses {
  PerhitunganOrder(
    double persentasevoucher,
    double minimumtransaksi,
    bool boolasuransi,
    bool boolvoucher,
    var nominalVoucher,
    var harga,
    var durasi,
    var nominalbaranginput,
    var ceksaldopoint,
    num minimaldeposit,
    num asuransi,
  ) {
    var hasilperhitungan;
    if (boolasuransi == false) asuransi = 0;
    if (boolvoucher == false) {
      hasilperhitungan = ((double.parse(harga) * double.parse(durasi)) +
              ((asuransi / 100) * double.parse(nominalbaranginput)) +
              minimaldeposit * double.parse(harga) -
              double.parse(ceksaldopoint))
          .toStringAsFixed(2);
    } else {
      if ((double.parse(durasi) * double.parse(harga)) >= minimumtransaksi) {
        if ((persentasevoucher * double.parse(harga) * double.parse(durasi)) >=
            double.parse(nominalVoucher)) {
          hasilperhitungan = ((double.parse(harga) * double.parse(durasi)) +
                  ((asuransi / 100) * double.parse(nominalbaranginput)) +
                  minimaldeposit * double.parse(harga) -
                  double.parse(ceksaldopoint) -
                  double.parse(nominalVoucher))
              .toStringAsFixed(2);
        } else {
          hasilperhitungan = ((double.parse(harga) * double.parse(durasi)) +
                  ((asuransi / 100) * double.parse(nominalbaranginput)) +
                  minimaldeposit * double.parse(harga) -
                  double.parse(ceksaldopoint) -
                  (persentasevoucher *
                      double.parse(harga) *
                      double.parse(durasi)))
              .toStringAsFixed(2);
        }
      } else {
        hasilperhitungan = ((double.parse(harga) * double.parse(durasi)) +
                ((asuransi / 100) * double.parse(nominalbaranginput)) +
                minimaldeposit * double.parse(harga) -
                double.parse(ceksaldopoint))
            .toStringAsFixed(2);
      }
    }
    return hasilperhitungan;
  }
}
