import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horang/api/models/pengguna/cek.loginuuid.model.dart';
import 'package:horang/api/models/token/token.model.dart';
import 'package:horang/api/utils/apiService.dart';
import 'package:horang/component/LoginPage/Login.Validation.dart';
import 'package:horang/component/account_page/pinauth.dart';
import 'package:horang/component/RegistrationPage/Registrasi.Input.dart';
import 'package:horang/component/account_page/reset.dart';
import 'package:horang/utils/deviceinfo.dart';
import 'package:new_version/new_version.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'background_welcome_page.dart';
// import 'package:get_version/get_version.dart';
import 'package:http/http.dart' as http;

class BodyWelcomePage extends StatefulWidget {
  @override
  _BodyWelcomePageState createState() => _BodyWelcomePageState();
}

class _BodyWelcomePageState extends State<BodyWelcomePage> {
  String? pin = "";
  String? access_token = "", ipPublic;
  bool _showbutton = false;
  // String _projectVersion = '';
  // String _platformVersion = 'Unknown';
  // String _projectCode = '';
  // String _projectAppID = '';
  // String _projectName = '';
  String _uuid = '';
  String? devID;
  late SharedPreferences sp;
  ApiService _apiService = new ApiService();
  late String email = "", nama = "", status;
  // var email = _apiService().emailuuid.email;

  PackageInfo packageInfo =  PackageInfo(
    appName: 'unknown', 
    packageName: 'unknown', 
    version: 'unknown', 
    buildNumber: 'unknown');
  
  Future<void> _initpackageInfo() async{
    final info = await PackageInfo.fromPlatform();
    setState(() {
      packageInfo = info;
    });
  }

  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};
    try {
      if (kIsWeb) {
        deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        if (Platform.isAndroid) {
          deviceData =
              _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        } else if (Platform.isIOS) {
          deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        } else if (Platform.isLinux) {
          deviceData = _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo);
        } else if (Platform.isMacOS) {
          deviceData = _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo);
        } else if (Platform.isWindows) {
          deviceData =
              _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo);
        }
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

   Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'version': data.version,
      'id': data.id,
      'idLike': data.idLike,
      'versionCodename': data.versionCodename,
      'versionId': data.versionId,
      'prettyName': data.prettyName,
      'buildId': data.buildId,
      'variant': data.variant,
      'variantId': data.variantId,
      'machineId': data.machineId,
    };
  }

  Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'browserName': describeEnum(data.browserName),
      'appCodeName': data.appCodeName,
      'appName': data.appName,
      'appVersion': data.appVersion,
      'deviceMemory': data.deviceMemory,
      'language': data.language,
      'languages': data.languages,
      'platform': data.platform,
      'product': data.product,
      'productSub': data.productSub,
      'userAgent': data.userAgent,
      'vendor': data.vendor,
      'vendorSub': data.vendorSub,
      'hardwareConcurrency': data.hardwareConcurrency,
      'maxTouchPoints': data.maxTouchPoints,
    };
  }

  Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return <String, dynamic>{
      'computerName': data.computerName,
      'hostName': data.hostName,
      'arch': data.arch,
      'model': data.model,
      'kernelVersion': data.kernelVersion,
      'osRelease': data.osRelease,
      'activeCPUs': data.activeCPUs,
      'memorySize': data.memorySize,
      'cpuFrequency': data.cpuFrequency,
      'systemGUID': data.systemGUID,
    };
  }

  Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return <String, dynamic>{
      'numberOfCores': data.numberOfCores,
      'computerName': data.computerName,
      'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
    };
  }


  // initPlatformState() async {
  //   String platformVersion;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     platformVersion = await GetVersion.platformVersion;
  //   } on PlatformException {
  //     platformVersion = 'Failed to get platform version.';
  //   }

  //   String projectVersion;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     projectVersion = await GetVersion.projectVersion;
  //   } on PlatformException {
  //     projectVersion = 'Failed to get project version.';
  //   }

  //   String projectCode;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     projectCode = await GetVersion.projectCode;
  //   } on PlatformException {
  //     projectCode = 'Failed to get build number.';
  //   }

  //   String projectAppID;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     projectAppID = await GetVersion.appID;
  //   } on PlatformException {
  //     projectAppID = 'Failed to get app ID.';
  //   }

  //   String projectName;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     projectName = await GetVersion.appName;
  //   } on PlatformException {
  //     projectName = 'Failed to get app name.';
  //   }

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;

  //   setState(() {
  //     _projectVersion = projectVersion;
  //     _platformVersion = platformVersion;
  //     _projectCode = projectCode;
  //     _projectAppID = projectAppID;
  //     _projectName = projectName;
  //   });
  // }

  Future<void> initdeviceInfo() async{
    String? depiceID;
    try {
      depiceID = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      depiceID = 'Failed to get deviceId.';
    }
    if (!mounted) return;

    setState(() {
      devID = depiceID;
      print("deviceId->$depiceID");
    });
  }

  cekToken() async {
    sp = await SharedPreferences.getInstance();
    access_token = sp.getString("access_token");
    pin = sp.getString("pin");
    print("pinnya adalah $pin + $access_token");
    //checking jika token kosong maka di arahkan ke menu login jika tidak akan meng-hold token dan refresh token
    if (access_token == null) {
      return checkingUUID();
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => WelcomePage()));
      // return false;
      // } else if (pin == '0' && access_token != null) {
      //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> UbahPin()));
    } else {
      if (Platform.isIOS) {
        new Future.delayed(
            const Duration(seconds: 3),
            () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Pinauth())));
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => LoginPage(),
        //     ));
      } else if (Platform.isAndroid && access_token != "") {
        if (access_token != "") {
          // loadingScreen(context,
          //     duration: Duration(seconds: 3), loadingType: LoadingType.SCALING);
          new Future.delayed(
              const Duration(seconds: 3),
              () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Pinauth())));
          initPlatformState();
        }
      }
    }
  }

  @override
  void initState() {
    _initpackageInfo();
    initdeviceInfo();
    initPlatformState();
    NewVersion(
      androidId: 'com.cvdtc.horang',
      iOSId: 'com.cvdtc.horang',
      // context: context,
    ).showAlertIfNecessary(context: context);
    print('$access_token tokennyaadalah');
    cekToken();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("object11 $access_token");
    // Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Container(
                height: 120,
                // width: 70,
                child: Image.asset(
                  "assets/image/logogudang.png",
                  alignment: Alignment.center,
                  fit: BoxFit.fill,
                ),
              ),
              
              Text("Version" +packageInfo.version),
              // Text('Version $_projectVersion'),
              // Text("IP PUBKUC $ipPublic"),
              SizedBox(
                height: 10,
              ),
              Text("Hei, Selamat Datang !",
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.black87)),
              SizedBox(
                height: 8,
              ),
              Text("Registrasi sekarang untuk memulai aplikasi",
                  style: GoogleFonts.lato(fontSize: 14, color: Colors.black45)),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.5,
                child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.blue[900],
                    child: Text("Registrasi",
                        style: GoogleFonts.lato(fontSize: 14)),
                    shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegistrasiPage()));
                    }),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.8,
                child: OutlineButton(
                    child: Text("Sudah memiliki akun ? Login sekarang",
                        style: GoogleFonts.lato(fontSize: 14)),
                    borderSide: BorderSide(color: Colors.deepPurple[900]!),
                    shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    onPressed: () {
                      // gettingUUID();
                      // checkingUUID();
                      print('UUID : ' + _uuid + email);
                      print('Email : ' + email);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage(
                                  cekUUID: _uuid, email: email, nama: nama)));
                    }),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Tidak menerima email Registrasi ? ",
                      style: GoogleFonts.lato(),
                    ),
                    GestureDetector(
                        onTap: () {},
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Reset(
                                          tipe: "ResendEmail", resendemail: '', resetpass: '', resetpin: '',
                                        )));
                          },
                          child: Text(
                            "Kirim email ulang",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                color: Colors.blue[900]),
                          ),
                        ))
                  ]),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
              ),
              access_token != ''
                  ? CircularProgressIndicator(
                      backgroundColor: Colors.blueAccent,
                      valueColor: AlwaysStoppedAnimation(Colors.red),
                      strokeWidth: 10,
                    )
                  : Visibility(
                      child: Text(''),
                      visible: false,
                    ),
            ],
          ),
        ),

        // SpinKitCircle(
        //   color: Colors.blue,
        //   duration: const Duration(milliseconds: 1200),
        // ),
      ),
    );
  }

  checkingUUID() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      GetDeviceID().getDeviceID(context).then((cekuuids) {
        _uuid = cekuuids!;
        CekLoginUUID uuid = CekLoginUUID(uuid: _uuid, status: '', email: '');
        _apiService.cekLoginUUID(uuid).then((value) => setState(() {
              print("HEM : " + value);
              if (value == "") {
                email = "";
              } else {
                email = value.split(":")[0].toString();
                nama = value.split(":")[1].toString();
                status = value.split(":")[2].toString();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage(
                            cekUUID: _uuid, email: email, nama: nama, status1: status,)));
              }
            }));
      });
    });
  }
}
