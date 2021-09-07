import 'dart:convert';
import 'package:commons/commons.dart';
import 'package:flutter/foundation.dart';
import 'package:horang/api/models/asuransi/asuransi.model.dart';
import 'package:horang/api/models/customer/customer.model.dart';
import 'package:horang/api/models/forgot/forgot.password.dart';
import 'package:horang/api/models/history/history.model.dart';
import 'package:horang/api/models/history/history.model.deposit.dart';
import 'package:horang/api/models/jenisproduk/jenisproduk.model.dart';
import 'package:horang/api/models/log/Log.Aktifitas.Model.dart';
import 'package:horang/api/models/log/Log.dart';
import 'package:horang/api/models/log/generateKode.model.dart';
import 'package:horang/api/models/log/listlog.model.dart';
import 'package:horang/api/models/log/openLog.dart';
import 'package:horang/api/models/log/selesaiLog.dart';
import 'package:horang/api/models/mystorage/mystorageModel.dart';
import 'package:horang/api/models/order/order.model.dart';
import 'package:horang/api/models/order/order.sukses.model.dart';
import 'package:horang/api/models/paymentgateway/paymentgateway.model.dart';
import 'package:horang/api/models/paymentgateway/paymentgatewayVA.model.dart';
import 'package:horang/api/models/pengguna/cek.loginuuid.model.dart';
import 'package:horang/api/models/pengguna/pengguna.model.dart';
import 'package:horang/api/models/pin/cek.pin.model.dart';
import 'package:horang/api/models/pin/edit.password.model.dart';
import 'package:horang/api/models/pin/pin.model.dart';
import 'package:horang/api/models/pin/tambah.pin.model.dart';
import 'package:horang/api/models/produk/produk.model.dart';
import 'package:horang/api/models/responsecode/responcode.model.dart';
import 'package:horang/api/models/token/token.model.dart';
import 'package:horang/api/models/voucher/voucher.model.dart';
import 'package:horang/api/models/xendit.model.dart';
import 'package:http/http.dart' show Client;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//CODE STRUCTURE
// - LIST
// - TAMBAH
// - UBAH

class ApiService {
  // final String baseUrl = "http://192.168.1.213:9992/api/"; //LOCAL
  final String baseUrl = "http://dev.horang.id:9992/api/"; //DEVELOPMENT
  // final String baseUrl = "https://server.horang.id:9993/api/"; //SERVER
  final String baseUrlVA =
      "https://api.xendit.co/available_virtual_account_banks/";
  final String UrlFTP = "https://dev.horang.id/adminmaster/sk.txt";
  Client client = Client();
  // ResponseCode responseCode;
  ResponseCodeCustom responseCode;
  CekLoginUUID emailuuid;
  OrderSukses orderSukses = OrderSukses();
  List<Customers> _data = [];
  List<Customers> get datacus => _data;

  //URL MAKER
  String urlasuransi,
      urlceksaldo,
      urllokasi,
      urlgetcustomer,
      urlsettingbylokasi,
      urlkota;
  ApiService() {
    urlasuransi = baseUrl + "asuransiaktif";
    urlceksaldo = baseUrl + "ceksaldo";
    urllokasi = baseUrl + "lokasi";
    urlgetcustomer = baseUrl + "customer";
    urlsettingbylokasi = baseUrl + "lokasisetting";
    urlkota = baseUrl + "kota";
  }

  /////////////////////// LIST /////////////////////////

  Future<List<xenditmodel>> xenditUrl() async {
    String username =
        'xnd_development_ZWfcdXVZYxzEwOyg3wdZV7IH1sKkJV0aQYL36aNROitLlLcGoXVUGXBqhFbKF';
    String password = '';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final response = await client.get("https://api.xendit.co/balance",
        headers: {
          "content-type": "application/json",
          "Authorization": basicAuth
        });
  }

  //LOAD JENIS PRODUK
  Future<List<JenisProduk>> listJenisProduk(String token) async {
    final response = await client.get("$baseUrl/jenisprodukdanproduk",
        headers: {"Authorization": "BEARER ${token}"});
    if (response.statusCode == 200) {
      return jenisprodukFromJson(response.body);
    } else {
      return null;
    }
  }

  //LIST PRODUK
  Future<List<JenisProduk>> listProduk(PostProdukModel data) async {
    final response = await client.post(
      "$baseUrl/jenisprodukavailable",
      headers: {"content-type": "application/json"},
      body: PostProdukModelToJson(data),
    );
    print('respondotbody ${response.body}');
    if (response.statusCode == 200) {
      return jenisprodukFromJson(response.body);
    } else {
      return null;
    }
  }

  //LOAD DETAIL ORDER
  Future<List<OrderSukses>> listOrderSukses(String token, int idorder) async {
    final response = await client.get("$baseUrl/orderdet/$idorder",
        headers: {"Authorization": "BEARER ${token}"});
    if (response.statusCode == 200) {
      return ordersuksesFromJson(response.body);
    } else {
      return null;
    }
  }

  //LOAD VOUCHER
  Future<List<VoucherModel>> listVoucher(String token) async {
    final response = await client
        .get("$baseUrl/voucher", headers: {"Authorization": "BEARER ${token}"});
    // .get("$baseUrl/voucher", headers: {"Authorization": "BEARER ${token}"});
    if (response.statusCode == 200) {
      return voucherFromJson(response.body);
    } else {
      return null;
    }
  }

  //LOAD MYSTORAGE

  Future<List<MystorageModel>> listMystorageNonActive(
      String token, var query) async {
    final response = await client.get("$baseUrl/mystorage",
        headers: {"Authorization": "BEARER ${token}"});
    print("token dari apiservice non aktif" + response.body + "$token");
    if (response.statusCode == 200) {
      List storage = json.decode(response.body);

      return storage
          .map((json) => MystorageModel.fromJson(json))
          .where((storage) {
            final noOrderLower = storage.noOrder.toLowerCase();
            final kodeKontainerLower = storage.kode_kontainer.toLowerCase();
            final jenisKontainer = storage.nama.toLowerCase();
            final lokasi = storage.nama_lokasi.toLowerCase();
            final searchLower = query.toLowerCase();

            return noOrderLower.contains(searchLower) ||
                kodeKontainerLower.contains(searchLower) ||
                jenisKontainer.contains(searchLower) ||
                lokasi.contains(searchLower);
          })
          .where((element) => element.status == "NONAKTIF")
          .toList();
    } else {
      throw Exception('gagal');
    }
  }

  Future<List<MystorageModel>> listMystorageActive(
      String token, var query) async {
    final response = await client.get("$baseUrl/mystorage",
        headers: {"Authorization": "BEARER ${token}"});
    print("token dari apiservice active" + response.body + "$token");
    if (response.statusCode == 200) {
      List storage = json.decode(response.body);
      return storage
          .map((json) => MystorageModel.fromJson(json))
          .where((storage) {
            final noOrderLower = storage.noOrder.toLowerCase();
            final kodeKontainerLower = storage.kode_kontainer.toLowerCase();
            final jenisKontainer = storage.nama.toLowerCase();
            final lokasi = storage.nama_lokasi.toLowerCase();
            final searchLower = query.toLowerCase();
            return noOrderLower.contains(searchLower) ||
                kodeKontainerLower.contains(searchLower) ||
                jenisKontainer.contains(searchLower) ||
                lokasi.contains(searchLower);
          })
          .where((element) => element.status == "AKTIF")
          .toList();
    } else {
      throw Exception('gagal');
    }
  }

  // Future<List<MystorageModel>> listMystorageExpiredBuilder(
  //     String token, var query) async {
  //   final response = await client.get("$baseUrl/mystorage",
  //       headers: {"Authorization": "BEARER ${token}"});
  //   print("masuklistbuilder??");
  //   if (response.statusCode == 200) {
  //     List storage = json.decode(response.body);
  //     return storage
  //         .map((json) => MystorageModel.fromJson(json))
  //         .where((storage) {
  //           final noOrderLower = storage.noOrder.toLowerCase();
  //           final kodeKontainerLower = storage.kode_kontainer.toLowerCase();
  //           final jenisKontainer = storage.nama.toLowerCase();
  //           final lokasi = storage.nama_lokasi.toLowerCase();
  //           final searchLower = query.toLowerCase();
  //           return noOrderLower.contains(searchLower) ||
  //               kodeKontainerLower.contains(searchLower) ||
  //               jenisKontainer.contains(searchLower) ||
  //               lokasi.contains(searchLower);
  //         })
  //         .where((element) => element.status == "EXPIRED")
  //         .toList();
  //   } else {
  //     throw Exception('gagal');
  //   }
  // }

  Future<List<MystorageModel>> listMystorageExpired(
      String token, var query) async {
    final response = await client.get("$baseUrl/mystorage",
        headers: {"Authorization": "BEARER ${token}"});
    print("masuklist??");
    if (response.statusCode == 200) {
      List storage = json.decode(response.body);
      return storage
          .map((json) => MystorageModel.fromJson(json))
          .where((storage) {
            final noOrderLower = storage.noOrder.toLowerCase();
            final kodeKontainerLower = storage.kode_kontainer.toLowerCase();
            final jenisKontainer = storage.nama.toLowerCase();
            final lokasi = storage.nama_lokasi.toLowerCase();
            final searchLower = query.toLowerCase();

            return noOrderLower.contains(searchLower) ||
                kodeKontainerLower.contains(searchLower) ||
                jenisKontainer.contains(searchLower) ||
                lokasi.contains(searchLower);
          })
          .where((element) => element.status == "EXPIRED")
          .toList();
    } else {
      throw Exception('gagal');
    }
  }

  Future<List<MystorageModel>> listMystorage(String token) async {
    final response = await client.get("$baseUrl/mystorage",
        headers: {"Authorization": "BEARER ${token}"});
    if (response.statusCode == 200) {
      return mystorageFromJson(response.body);
      // return compute(response.body);
    } else {
      return null;
    }
  }

  //LOAD PAYMENT GATEWAY
  Future<List<PaymentGateway>> listPaymentGateway(String token) async {
    final response = await client.get("$baseUrl/paymentgateway",
        headers: {"Authorization": "BEARER ${token}"});
    if (response.statusCode == 200) {
      return paymentgatewayFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<List<PaymentGatewayVirtualAccount>> listPaymentGatewayVA() async {
    String username =
        'xnd_development_ZWfcdXVZYxzEwOyg3wdZV7IH1sKkJV0aQYL36aNROitLlLcGoXVUGXBqhFbKF';
    String password = '';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final response = await client.get("$baseUrlVA", headers: {
      "content-type": "application/json",
      "Authorization": basicAuth
    });
    print("aman ?" + response.body);
    if (response.statusCode == 200) {
      return paymentgatewayVAFromJson(response.body);
    } else {
      return null;
    }
  }

  //LOAD DETAIL CUSTOMER
  Future<List<Customers>> getCustomer(access_token) async {
    final response = await client.get("$baseUrl/customer",
        headers: {"Authorization": "BEARER ${access_token}"});
    if (response.statusCode == 200) {
      return customerFromJson(response.body);
    } else {
      return null;
    }
  }

  //LOAD HISTORY LIST
  // Future<List<HistoryModel>> listHistoryDashboard(String token) async {
  Future<List<MystorageModel>> listHistoryDashboard(String token) async {
    final response = await client.get("$baseUrl/mystorage",
        headers: {"Authorization": "BEARER ${token}"});
    // print(response.statusCode.toString()+" - TOKEN HISTORY : "+token);
    if (response.statusCode == 200) {
      return mystorageFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<List<HistoryModel>> listHistory(String token, var query) async {
    final response = await client
        .get("$baseUrl/histori", headers: {"Authorization": "BEARER ${token}"});
    print("token dari apiservice" + response.body + "$token");
    if (response.statusCode == 200) {
      List storage = json.decode(response.body);
      return storage
          .map((json) => HistoryModel.fromJson(json))
          .where((storage) {
        final noOrderLower = storage.no_order.toLowerCase();
        final noKontainerLower = storage.kode_kontainer.toLowerCase();
        final noBayarLower = storage.kode_refrensi.toLowerCase();
        final searchLower = query.toLowerCase();

        return noKontainerLower.contains(searchLower) ||
            noBayarLower.contains(searchLower) ||
            noOrderLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception('gagal');
    }
  }

  //LOAD LIST HISTORY DEPOSIT
  Future<List<HistoryDepositModel>> listHistoryDepo(String access_token) async {
    final response = await client.get("$baseUrl/historideposit",
        headers: {"Authorization": "BEARER ${access_token}"});
    if (response.statusCode == 200) {
      return historyFromJson(response.body);
    } else {
      return null;
    }
  }

  //LOAD ASURANSI LIST
  Future<List<AsuransiModel>> listAsuransi(String token) async {
    final response = await client.get("$baseUrl/asuransi",
        headers: {"Authorization": "BEARER ${token}"});
    print('INI LIST ASURANSI' + response.body);
    if (response.statusCode == 200) {
      return asuransiFromJson(response.body);
    } else {
      return null;
    }
  }

  ///////////////////// END LIST //////////////////////

  ////////////////////// TAMBAH ////////////////////////

  //REGISTRASI
  Future<bool> signup(PenggunaModel data) async {
    final response = await client.post(
      "$baseUrl/registrasi",
      headers: {"content-type": "application/json"},
      body: penggunaToJson(data),
    );
    Map message = jsonDecode(response.body);
    responseCode = ResponseCodeCustom.fromJson(message);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

//  LOGIN
  Future<bool> loginIn(PenggunaModel data) async {
    var response = await client.post(
      "$baseUrl/login",
      headers: {"content-type": "application/json"},
      body: penggunaToJson(data),
    );
    Map test = jsonDecode(response.body);
    var token = Token.fromJson(test);
    Map message = jsonDecode(response.body);
    responseCode = ResponseCodeCustom.fromJson(message);
    print('Value Login ' + test.toString());
    if (response.statusCode == 200) {
//      Share Preference
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString("access_token", "${token.access_token}");
      sp.setString("refresh_token", "${token.refresh_token}");
      sp.setString("idcustomer", "${token.idcustomer}");
      sp.setString("nama_customer", "${token.nama_customer}");
      sp.setString("pin", "${token.pin}");
      return true;
    } else {
      return false;
    }
  }

  // CEK LOGIN UUID

  // Future<List<CekLoginUUID>> cekLoginUUID(CekLoginUUID uuid) async {
  Future<String> cekLoginUUID(CekLoginUUID uuid) async {
    final response = await client.post(
      "$baseUrl/cekuuid",
      headers: {"content-type": "application/json"},
      body: cekLoginUUIDCodeToJson(uuid),
    );
    if (response.statusCode == 200) {
//      print(response.body + " - UUID SAMA - " + response.statusCode.toString());
      print("YUHUU : " + response.body);
      return response.body;
    } else {
      return "";
    }
  }

//  ORDER PRODUK
  Future<int> tambahOrderProduk(OrderProduk data) async {
    final response = await client.post(
      "$baseUrl/order",
      headers: {"content-type": "application/json"},
      body: orderprodukToJson(data),
    );
    print("helloworld" +
        response.statusCode.toString() +
        " ~ " +
        response.body.toString());
    if (response.statusCode == 200) {
      return int.parse(response.body.split(" : ")[1]);
    } else if (response.statusCode == 204) {
      return -1;
    } else {
      return 0;
    }
  }

  //Tambah Customer
  Future<bool> TambahCustomer(Customers data) async {
    final response = await client.post(
      "$baseUrl/customer",
      headers: {"Content-type": "application/json"},
      body: customerToJson(data),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  ////////////////////// END TAMBAH ////////////////////

  //////////////////////// UBAH ////////////////////////

//  UBAH CUSTOMER
  Future<bool> UpdateCustomer(Customers data) async {
    final response = await client.post(
      "$baseUrl/ucustomer",
      headers: {"Content-type": "application/json"},
      body: customerToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  ////////////////////// PIN ///////////////////////

  Future<bool> TambahPin(TambahPin_model data) async {
    final response = await client.post(
      "$baseUrl/ipin",
      headers: {"Content-type": "application/json"},
      body: TambahPinToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> UbahPin(Pin_Model data) async {
    final response = await client.post(
      "$baseUrl/upin",
      headers: {"Content-type": "application/json"},
      body: PinToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> CekPin(Pin_Model_Cek data) async {
    final response = await client.post(
      "$baseUrl/pin",
      headers: {"Content-type": "application/json"},
      body: PinCekToJson(data),
    );
    print("cek pinnya" + response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> UbahPassword(Password data) async {
    final response = await client.post(
      "$baseUrl/upassword",
      headers: {"Content-type": "application/json"},
      body: PasswordToJson(data),
    );
    // Map message = jsonDecode(response.statusCode.toString());
    // responseCode = ResponseCodeCustom.fromJson(message);
    // print("responsss" + response.statusCode.toString());
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> OpenLog(LogOpen data) async {
    final response = await client.post(
      "$baseUrl/open",
      headers: {"Content-type": "application/json"},
      body: LogOpenToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // Future<bool> generateCode(GenerateCode data) async {
  //   // Future<GenerateCode> generateKodeForklift(String token) async {
  //   final response = await client.post("$baseUrl/generateforklift",
  //       headers: {"Content-type": "application/json"},
  //       body: generateCodeToJson(data));
  //   print('dollars' + response.body);

  //   if (response.statusCode == 200) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  Future<List<GenerateCode>> generateCode(
      String access_token, idtransaksi_det) async {
    final response = await client.post(
      "$baseUrl/generateforklift",
      headers: {"content-type": "application/json"},
      body: jsonEncode({
        "token": "${access_token}",
        "idtransaksi_detail": "${idtransaksi_det}"
      }),
    );
    print('isoGAK ${response.body}');
    if (response.statusCode == 200) {
      return generateCodeFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<bool> SelesaiLog(selesaiLog data) async {
    final response = await client.post(
      "$baseUrl/selesai",
      headers: {"Content-type": "application/json"},
      body: selesaiLogToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> Log_(Logs data) async {
    final response = await client.post(
      "$baseUrl/log",
      headers: {"Content-type": "application/json"},
      body: LogsToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // Future<List<logAktifitasNotif>> logAktifitasNotif_(String token) async {
  Future<List> logAktifitasNotif_(String token) async {
    final response = await client.post(
      "$baseUrl/logaktifitas",
      headers: {"Content-type": "application/json"},
      body: jsonEncode({"token": "${token}"}),
    );
    print("responnya ?" + response.body);
    if (response.statusCode == 200) {
      return logaktifitasnotifToList(response.body);
    } else {
      return null;
    }
  }

  Future<List<LogList>> listloggs(String token, idtransaksi_detail) async {
    final response = await client.post(
      "$baseUrl/log",
      headers: {"content-type": "application/json"},
      body: jsonEncode(
          {"token": "${token}", "idtransaksi_detail": "${idtransaksi_detail}"}),
    );
    if (response.statusCode == 200) {
      return LoglistFromJson(response.body);
    } else {
      return null;
    }
  }

  ///////////////////// FORGET ///////////////////////
  Future<bool> ForgetPass(Forgot_Password data) async {
    final response = await client.post(
      "$baseUrl/forgotpassword",
      headers: {"Content-type": "application/json"},
      body: ForgotPassToJson(data),
    );
    Map message = jsonDecode(response.body);
    responseCode = ResponseCodeCustom.fromJson(message);

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> ForgetPin(Forgot_Password data) async {
    final response = await client.post(
      "$baseUrl/forgotpin",
      headers: {"Content-type": "application/json"},
      body: ForgotPassToJson(data),
    );
    Map message = jsonDecode(response.body);
    responseCode = ResponseCodeCustom.fromJson(message);

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> ResendEmail(Forgot_Password data) async {
    final response = await client.post(
      "$baseUrl/resendemailaktivasi",
      headers: {"Content-type": "application/json"},
      body: ForgotPassToJson(data),
    );
    Map message = jsonDecode(response.body);
    responseCode = ResponseCodeCustom.fromJson(message);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> LostDevice(Forgot_Password data) async {
    final response = await client.post(
      "$baseUrl/lostdevice",
      headers: {"Content-type": "application/json"},
      body: ForgotPassToJson(data),
    );
    Map message = jsonDecode(response.body);
    responseCode = ResponseCodeCustom.fromJson(message);
    print(response.body);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  /////////////////////// END PASSWORD ///////////////////////

  ////////////////////// END UBAH /////////////////////

  ////////////////////// UTILS ///////////////////////

//  CHECKING TOKEN
  Future<bool> checkingToken(String token) async {
    final response = await client.get("$baseUrl/ceklogin",
        headers: {"Authorization": "BEARER ${token}"});
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

//  GET AND CHECKING REFRESH TOKEN
  Future<String> refreshToken(String token) async {
    final response = await client.post(
      "$baseUrl/newtoken",
      headers: {"content-type": "application/json"},
      body: jsonEncode({"token": "${token}"}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['access_token'];
    } else {
      return "";
    }
  }

  Future<String> ambildataSyaratKetentuan(sk) async {
    http.Response response = await http
        .get(Uri.encodeFull('https://dev.horang.id/adminmaster/sk.txt'));
    // .get(Uri.encodeFull('http://server.horang.id/adminmaster/sk.txt'));
    // var response = await client.get('https://dev.horang.id/adminmaster/sk.txt');
    print("mmzzzrr" + response.statusCode.toString() + "+++" + response.body);
    sk = response.body;
    if (response.statusCode == 200) {
      return sk;
    } else {
      return throw Exception('gagal');
    }
  }

  Future<String> ambildataSyaratKetentuanAplikasi(sk) async {
    http.Response response = await http.get(
        Uri.encodeFull('https://dev.horang.id/adminmaster/skaplikasi.txt'));
    // .get(
    //     Uri.encodeFull('http://server.horang.id/adminmaster/skaplikasi.txt'));
    print("mmzzzrr" + response.statusCode.toString() + "+++" + response.body);
    sk = response.body;
    if (response.statusCode == 200) {
      return sk;
    } else {
      return throw Exception('gagal');
    }
  }

  Future<bool> logout(String token) async {
    final response = await client.delete("$baseUrl/logout",
        headers: {"Authorization": "BEARER ${token}"});
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  ////////////////////// UTILS ///////////////////////

}
