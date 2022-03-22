import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? _sharedPref;
  init() async {
    if (_sharedPref == null) {
      _sharedPref = await SharedPreferences.getInstance();
    }
  }

  //gettter
  bool get loggedIn => _sharedPref!.getBool('loggedIn') ?? false;
  String get loginId => _sharedPref!.getString('loginId') ?? "";
  String get userEmail => _sharedPref!.getString('userEmail') ?? "";
  String get organizationName => _sharedPref!.getString('organizationName') ?? "";
  String get organizationLogo => _sharedPref!.getString('organizationLogo') ?? "";
  String get getPrinter => _sharedPref!.getString('printer') ?? "";
  String get getVehicleNumber => _sharedPref!.getString('vehicleNumber') ?? "";
  String get getbaseUrl => _sharedPref!.getString('baseUrl') ?? 'http://awszts.afroaves.com:8080/';
  String get getTicketCode => _sharedPref!.getString('ticketCode') ?? 'MYS';
  String get getbottleCode => _sharedPref!.getString('bottleCode') ?? 'ABC';
  String get getbottleStart => _sharedPref!.getString('bottleStart') ?? '0';
  String get getbottleEnd => _sharedPref!.getString('bottleEnd') ?? '0';
  String get todayDate =>
      _sharedPref!.getString('todayDate') ??
      "${DateFormat().addPattern("dd-MM-yyyy").format(DateTime.now())}";
  List<String> get bottleQrCodes => _sharedPref!.getStringList("bottle") ?? [];

  String? get token => _sharedPref!.getString('authToken');
//http://awszts.afroaves.com:8080/api/v1/
  ///Set as logged in
  setLoggedIn() {
    _sharedPref!.setBool('loggedIn', true);
  }

  /// Set as logged out
  setLoggedOut() {
    _sharedPref!.setBool('loggedIn', false);
    setAuthToken(token: "");
    // _sharedPref!.remove('authToken');
  }

  isToday() {
    log("date ${sharedPrefs.todayDate}");
    if (sharedPrefs.todayDate ==
        DateFormat().addPattern("dd-MM-yyyy").format(DateTime.now())) {
      return true;
    } else {
        log("date ");
      _sharedPref!.setStringList('bottle', []);
      setTodayDate();
      return true;
    }
  }

  addBottletoList(String qrCode) {
    List<String> list = bottleQrCodes;
    list.add(qrCode);
    _sharedPref?.setStringList('bottle', list);
    log("bottle list:" + bottleQrCodes.toString());
  }

  setTodayDate() {
    _sharedPref!
        .setString('todayDate', '${DateFormat().addPattern("dd-MM-yyyy").format(DateTime.now())}');
    setAuthToken(token: "");
    // _sharedPref!.remove('authToken');
  }

  /// Set uuid for the user
  setUserDetails({
    required String loginId,
    required String userEmail,
    required String organizationName,
    required String organizationLogo,
  }) {
    _sharedPref!.setString('loginId', loginId);
    _sharedPref!.setString('userEmail', userEmail);
    _sharedPref!.setString('organizationName', organizationName);
    _sharedPref!.setString('organizationLogo', organizationLogo);
  }

  ///set Auth token for the app
  setAuthToken({required String token}) {
    _sharedPref!.setString('authToken', token);
  }

  setPrinter({required String printer}) {
    _sharedPref!.setString('printer', printer);
  }

  setVehicleNumber({required String vehicleNumber}) {
    _sharedPref!.setString('vehicleNumber', vehicleNumber);
  }

  setbaseUrl({required String baseUrl}) {
    _sharedPref!.setString('baseUrl', baseUrl);
  }

  setTicketCode({required String baseUrl}) {
    _sharedPref!.setString('ticketCode', baseUrl);
  }

  setBarCode({required String bottleCode, required String start, required String end}) {
    _sharedPref!.setString('bottleCode', bottleCode);
    _sharedPref!.setString('bottleStart', start);
    _sharedPref!.setString('bottleEnd', end);
    _sharedPref!.setStringList('bottle', []);
  }
}

final sharedPrefs = SharedPref();
