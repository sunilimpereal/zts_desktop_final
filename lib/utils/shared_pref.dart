import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? _sharedPref;
  init() async {
    if (_sharedPref == null) {
      _sharedPref = await  SharedPreferences.getInstance();
    }
  }

  //gettter
  bool get loggedIn => _sharedPref!.getBool('loggedIn') ?? false;
  String get loginId => _sharedPref!.getString('loginId') ?? "";
  String? get token => _sharedPref!.getString('authToken');



  ///Set as logged in
  setLoggedIn() {
    _sharedPref!.setBool('loggedIn', true);
  }

  /// Set as logged out
  setLoggedOut() {
    _sharedPref!.setBool('loggedIn', false);
    // _sharedPref!.remove('authToken');
  }

  /// Set uuid for the user
  setLoginId({required String loginId}) {
    _sharedPref!.setString('loginId', loginId);
  }

  ///set Auth token for the app
  setAuthToken({required String token}) {
    _sharedPref!.setString('authToken', token);
  }

}

final sharedPrefs = SharedPref();
