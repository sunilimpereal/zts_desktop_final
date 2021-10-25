import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zts_counter_desktop/authentication/login/bloc/validation_mixin.dart';
import 'package:zts_counter_desktop/authentication/login/data/repository/login_repository.dart';

class LoginBloc with ValidationMixin {
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();

  //gettters
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;

  //streams
  Stream<String> get email => _email.stream.transform(validatorEmail);
  Stream<String> get password => _password.stream.transform(validatorPassword);

  Stream<bool> get submitValidForm => Rx.combineLatest2(email, password, (e, n) => true);
  Stream<List<String>> get validateFormStream => Rx.combineLatestList(
        [
          email,
          password,
        ],
      );

  dispose() {
    _email.close();
    _password.close();
  }
}

class LoginProvider extends InheritedWidget {
  final bloc = LoginBloc();
  LoginProvider({Key? key, required Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static LoginBloc? of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<LoginProvider>())!.bloc;
  }
}
