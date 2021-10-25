import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zts_counter_desktop/authentication/login/bloc/login_stream.dart';
import 'package:zts_counter_desktop/authentication/login/data/models/login_request_model.dart';
import 'package:zts_counter_desktop/authentication/login/data/models/login_respose_model.dart';
import 'package:zts_counter_desktop/main.dart';
import 'package:zts_counter_desktop/repository/repositry.dart';
import 'package:zts_counter_desktop/utils/shared_pref.dart';

class LoginRepository {
  Future<bool> login(
      {required BuildContext context, required String email, required String password}) async {
    try {
          Map<String, String>? postheaders = {
    'Accept': 'application/json',
    'Authorization': 'Bearer ${sharedPref.token}',
  };
      LoginRequest loginRequest = LoginRequest(email: email, password: password);
      final response = await API.post(url: 'login/', body: loginRequest.toJson(), context: context,headers: postheaders);
      if (response.statusCode == 200) {
        LoginResponse loginResponse = loginResponseFromJson(response.body);
        sharedPrefs.setUserDetails(
          loginId: loginResponse.loginId.toString(),
          userEmail: email,
          organizationName: loginResponse.organizationName,
          organizationLogo: loginResponse.organizationLogo,
        );
        sharedPref.setLoggedIn();
        sharedPref.setAuthToken(token: loginResponse.token);
        CheckLoginProvider.of(context)?.login();

        return true;
      } else {
        log('filaed 2');
        return false;
      }
    } catch (e) {
      log('filaed 3 $e');
      return false;
    }
  }
}
