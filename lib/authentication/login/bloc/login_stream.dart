import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zts_counter_desktop/main.dart';

class CheckLoginBloc {

  CheckLoginBloc(){
    getLogin();
  }
  final _login = BehaviorSubject<bool>();
  Stream<bool> get loggedInStream => _login.stream.asBroadcastStream();

  getLogin() {
    bool a = sharedPref.loggedIn;
    _login.sink.add(a);
  }

  logout() {
    sharedPref.setLoggedOut();
    bool a =sharedPref.loggedIn;
    _login.sink.add(sharedPref.loggedIn);
  }

   login() {
    sharedPref.setLoggedIn();
    bool a =sharedPref.loggedIn;
    _login.sink.add(sharedPref.loggedIn);
  }

  dispose() {
    _login.close();
  }
}

class CheckLoginProvider extends InheritedWidget {
  final bloc = CheckLoginBloc();
  CheckLoginProvider({Key? key, required Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static CheckLoginBloc? of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CheckLoginProvider>())!.bloc;
  }
}
