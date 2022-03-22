import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:zts_counter_desktop/authentication/login/bloc/login_bloc.dart';
import 'package:zts_counter_desktop/authentication/login/data/repository/login_repository.dart';
import 'package:zts_counter_desktop/authentication/login/widgets/button.dart';
import 'package:zts_counter_desktop/authentication/login/widgets/text_field.dart';
import 'package:zts_counter_desktop/dashboard/settings/screens/settings_login_screen.dart';
import 'package:zts_counter_desktop/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  bool loginFailFlag = false;
  ontap() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    LoginBloc? loginBloc = LoginProvider.of(context);
    return WinScaffold(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/background-login.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: logincard(loginBloc),
              ),
            ),
            Positioned(
                bottom: 20,
                right: 20,
                child: Material(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => SettingsLoginScrteen()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.settings,
                            size: 24,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Settings',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
            Positioned(
                bottom: 20,
                left: 20,
                child: Material(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => SettingsLoginScrteen()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          // Icon(
                          //   Icons.settings,
                          //   size: 24,
                          // ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'v 1.3.0.p',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget logincard(LoginBloc? loginBloc) {
    return Container(
      height: 550,
      width: 400,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(
            16,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(
            height: 30,
          ),
          Container(
            height: 100,
            width: 300,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/logo.png'),
            )),
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            children: [
              ZTSTextField(
                width: 300,
                controller: emailController,
                focusNode: emailFocus,
                icon: Icons.email,
                labelText: 'Email',
                onChanged: loginBloc!.changeEmail,
                onfocus: emailFocus.hasFocus,
                onTap: ontap,
                stream: loginBloc.email,
                heading: 'Email',
              ),
              ZTSTextField(
                width: 300,
                controller: passwordController,
                focusNode: passwordFocus,
                icon: Icons.email,
                labelText: 'Password',
                onChanged: loginBloc.changePassword,
                onfocus: passwordFocus.hasFocus,
                onTap: ontap,
                stream: loginBloc.password,
                obscureText: true,
                heading: 'Password',
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ZTSStreamButton(
                width: 230,
                formValidationStream: loginBloc.validateFormStream,
                submit: () async {
                  sharedPref.isToday();
                  LoginRepository loginRepository = LoginRepository();
                  loginRepository
                      .login(
                    email: emailController.text,
                    password: passwordController.text,
                    context: context,
                  )
                      .then((value) {
                    Future.delayed(const Duration(milliseconds: 200)).then((value1) {
                      if (value) Navigator.pushReplacementNamed(context, '/dashboard');
                      setState(() {
                        loginFailFlag = !value;
                      });
                    });
                  });
                },
                text: 'Login',
                errrorText: 'Login Failed',
                errorFlag: loginFailFlag,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
