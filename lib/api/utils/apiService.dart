import 'dart:convert';
import 'package:horang/api/models/asuransi/asuransi.model.dart';
import 'package:horang/api/models/customer/customer.model.dart';
import 'package:horang/api/models/history/history.model.dart';
import 'package:horang/api/models/jenisproduk/jenisproduk.model.dart';
import 'package:horang/api/models/mystorage/mystorageModel.dart';
import 'package:horang/api/models/order/order.model.dart';
import 'package:horang/api/models/order/order.sukses.model.dart';
import 'package:horang/api/models/paymentgateway/paymentgateway.model.dart';
import 'package:horang/api/models/pengguna/pengguna.model.dart';
import 'package:horang/api/models/pin/edit.password.model.dart';
import 'package:horang/api/models/pin/pin.model.dart';
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
  final String baseUrl = "http://192.168.1.243:9992/api/";
//  final String baseUrl = "http://35.229.217.130:9992/api/";
  Client client = Client();
  ResponseCode responseCode;
  OrderSukses orderSukses = OrderSukses();
  var vall;

  /////////////////////// LIST /////////////////////////

  //LOAD JENIS PRODUK
  Future<List<JenisProduk>> listJenisProduk(String token) async {
    final response = await client.get("$baseUrl/jenisprodukdanproduk",
        headers: {"Authorization": "BEARER ${token}"});
   print(token);
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
    print(response.body);
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
    // print("Hasil"+response.body);
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
     print(" ${response.body}");
    // print("coba cek lagi : ${response.statusCode}");
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
    print(response.body);
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
    // print(response.body);
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
    final response = await client
        .get("$baseUrl/asuransi", headers: {"Authorization": "BEARER ${token}"});
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
    print(response.statusCode);
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
      sp.setString("email", "${token.email}");
      sp.setString("nama_customer", "${token.nama_customer}");
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
    print("Hmm :" + response.body.split(" ")[1]);
    if (response.statusCode == 200) {
//      print(response.body);
      return int.parse(response.body.split(" : ")[1]);
    } else {
      return 0;
    }
  }

  //Tambah Customer
  Future<bool> TambahCustomer(Customer data) async {
    // print("DAtaku"+ data.toString());
    final response = await client.post(
      "$baseUrl/customer",
      headers: {"Content-type": "application/json"},
      body: customerToJson(data),
    );
    print("cusTOjson" + customerToJson(data));
    // print("cekupdatecust :" + response.body);
    print("responstatuskode: " + response.statusCode.toString());
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
    // print("DAtaku"+ data.toString());
    final response = await client.post(
      "$baseUrl/ecustomer",
      headers: {"Content-type": "application/json"},
      body: customerToJson(data),
    );
    print("cusTOjson" + customerToJson(data));
    // print("cekupdatecust :" + response.body);
    print("responstatuskode: " + response.statusCode.toString());
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  ////////////////////// PIN ///////////////////////

  Future<bool> TambahPin(Pin_Model data) async {
    print("cek masuk APISERVICE $PinToJson(data)");
    final response = await client.post(
      "$baseUrl/ipin",
      headers: {"Content-type": "application/json"},
      body: PinToJson(data),
    );
    print("cusTOjson" + PinToJson(data));
    // print("cekupdatecust :" + response.body);
    print("responstatuskode: " + response.statusCode.toString());
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> UbahPin(Pin_Model data) async {
    print("cek masuk APISERVICE $PinToJson(data)");
    final response = await client.post(
      "$baseUrl/epin",
      headers: {"Content-type": "application/json"},
      body: PinToJson(data),
    );
    print("cusTOjson" + PinToJson(data));
    // print("cekupdatecust :" + response.body);
    print("responstatuskode: " + response.statusCode.toString());
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> UbahPassword(Password data) async {
    print("cek masuk APISERVICE $PinToJson(data)");
    final response = await client.post(
      "$baseUrl/epassword",
      headers: {"Content-type": "application/json"},
      body: PasswordToJson(data),
    );
    print("cusTOjson" + PasswordToJson(data));
    // print("cekupdatecust :" + response.body);
    print("responstatuskode: " + response.statusCode.toString());
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
