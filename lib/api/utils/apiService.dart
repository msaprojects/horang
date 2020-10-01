import 'dart:convert';
import 'package:horang/api/models/asuransi/asuransi.model.dart';
import 'package:horang/api/models/customer/customer.model.dart';
import 'package:horang/api/models/forgot/forgot.password.dart';
import 'package:horang/api/models/history/history.model.dart';
import 'package:horang/api/models/jenisproduk/jenisproduk.model.dart';
import 'package:horang/api/models/log/Log.dart';
import 'package:horang/api/models/log/listlog.model.dart';
import 'package:horang/api/models/log/openLog.dart';
import 'package:horang/api/models/log/selesaiLog.dart';
import 'package:horang/api/models/mystorage/mystorageModel.dart';
import 'package:horang/api/models/order/order.model.dart';
import 'package:horang/api/models/order/order.sukses.model.dart';
import 'package:horang/api/models/paymentgateway/paymentgateway.model.dart';
import 'package:horang/api/models/pengguna/pengguna.model.dart';
import 'package:horang/api/models/pin/cek.pin.model.dart';
import 'package:horang/api/models/pin/edit.password.model.dart';
import 'package:horang/api/models/pin/pin.model.dart';
import 'package:horang/api/models/pin/tambah.pin.model.dart';
import 'package:horang/api/models/responsecode/responcode.model.dart';
import 'package:horang/api/models/token/token.model.dart';
import 'package:horang/api/models/voucher/voucher.controller.dart';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';

//CODE STRUCTURE
// - LIST
// - TAMBAH
// - UBAH

class ApiService {
  // final String baseUrl = "http://192.168.1.243:9992/api/";
  // final String baseUrl = "http://104.199.147.100:9992/api/";
  final String baseUrl = "http://server.horang.id:9992/api/";
  Client client = Client();
  ResponseCode responseCode;
  OrderSukses orderSukses = OrderSukses();
  var vall;

  /////////////////////// LIST /////////////////////////

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
  Future<List<Voucher>> listVoucher(String token) async {
    final response = await client
        .get("$baseUrl/voucher", headers: {"Authorization": "BEARER ${token}"});
    if (response.statusCode == 200) {
      return voucherFromJson(response.body);
    } else {
      return null;
    }
  }

  //LOAD MYSTORAGE
  Future<List<MystorageModel>> listMystorage(String token) async {
    final response = await client.get("$baseUrl/mystorage",
        headers: {"Authorization": "BEARER ${token}"});
    if (response.statusCode == 200) {
      return mystorageFromJson(response.body);
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

  //LOAD DETAIL CUSTOMER
  Future<List<Customer>> getCustomer(access_token) async {
    final response = await client.get("$baseUrl/customer",
        headers: {"Authorization": "BEARER ${access_token}"});
    if (response.statusCode == 200) {
      return customerFromJson(response.body);
    } else {
      return null;
    }
  }

  //LOAD HISTORY LIST
  Future<List<history>> listHistory(String token) async {
    final response = await client
        .get("$baseUrl/histori", headers: {"Authorization": "BEARER ${token}"});
    if (response.statusCode == 200) {
      return HistoryFromJson(response.body);
    } else {
      return null;
    }
  }

  //LOAD ASURANSI LIST
  Future<List<AsuransiModel>> listAsuransi(String token) async {
    final response = await client.get("$baseUrl/asuransi",
        headers: {"Authorization": "BEARER ${token}"});
    if (response.statusCode == 200) {
      return asuransiFromJson(response.body);
    } else {
      return null;
    }
  }

  ///////////////////// END LIST //////////////////////

  ////////////////////// TAMBAH ////////////////////////

  //REGISTRASI
  Future<bool> signup(Pengguna data) async {
    final response = await client.post(
      "$baseUrl/registrasi",
      headers: {"content-type": "application/json"},
      body: penggunaToJson(data),
    );
    Map message = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(message);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

//  LOGIN
  Future<bool> loginIn(Pengguna data) async {
    var response = await client.post(
      "$baseUrl/login",
      headers: {"content-type": "application/json"},
      body: penggunaToJson(data),
    );
    Map test = jsonDecode(response.body);
    var token = Token.fromJson(test);
    Map message = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(message);
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

//  ORDER PRODUK
  Future<int> tambahOrderProduk(OrderProduk data) async {
    final response = await client.post(
      "$baseUrl/order",
      headers: {"content-type": "application/json"},
      body: orderprodukToJson(data),
    );
    if (response.statusCode == 200) {
      return int.parse(response.body.split(" : ")[1]);
    } else {
      return 0;
    }
  }

  //Tambah Customer
  Future<bool> TambahCustomer(Customer data) async {
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
  Future<bool> UpdateCustomer(Customer data) async {
    final response = await client.post(
      "$baseUrl/ecustomer",
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
      "$baseUrl/epin",
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
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> UbahPassword(Password data) async {
    final response = await client.post(
      "$baseUrl/epassword",
      headers: {"Content-type": "application/json"},
      body: PasswordToJson(data),
    );
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

  Future<List<LogList>> listloggs(String token, iddetail_order) async {
   final response = await client.post(
      "$baseUrl/log",
      headers: {"content-type": "application/json"},
      body: jsonEncode({"token": "${token}", "iddetail_order":"${iddetail_order}"}),
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
    if (response.statusCode == 200) {
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
    if (response.statusCode == 200) {
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
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }


  //////////////////////////////////////////////

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

  ////////////////////// UTILS ///////////////////////

}
