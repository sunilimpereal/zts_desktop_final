import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:zts_counter_desktop/authentication/login/bloc/login_stream.dart';
import 'package:zts_counter_desktop/authentication/login/data/models/login_request_model.dart';
import 'package:zts_counter_desktop/authentication/login/data/models/login_respose_model.dart';

import '../main.dart';

class API {
  static Map<String, String>? headers = {
    // 'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${sharedPref.token}',
  };

  static Future<Response> get({
    required BuildContext context,
    required String url,
  }) async {
    try {
      log('url: ${config.API_ROOT + url} ');
      var response = await http.get(Uri.parse(config.API_ROOT + url), headers: headers);
      log('respose: ${response.body}');
      if(response.statusCode == 401){
        log("message logout");
        CheckLoginProvider.of(context)?.logout();
      }
      return response;
    } finally {
      //TODO : Dialog box
    }
  }

  static Future<Response> post({
    required String url,
    required Object body,
  }) async {
    try {
      log('url: ${config.API_ROOT + url} ');
      log('body: $body');
      var response =
          await http.post(Uri.parse(config.API_ROOT + url), body: body, headers: headers);
      log('respose: ${response.body}');

      return response;
    } finally {
      //TODO : Dialog box
    }
  }
}
