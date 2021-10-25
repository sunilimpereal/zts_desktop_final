import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:zts_counter_desktop/authentication/login/bloc/login_stream.dart';
import '../main.dart';

class API {
  static Map<String, String>? headers = {
    // 'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${sharedPref.token}',
  };
   static Map<String, String>? postheaders = {
    'Content-Type': 'application/json',
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
      log('respose: ${response.statusCode}');
      log('respose: ${response.body}');
      if(response.statusCode == 401){
        CheckLoginProvider.of(context)?.logout();
      }
      return response;
    } finally {
      //TODO : Dialog box
    }
  }

  static Future<Response> post({
    required String url,
    required Object body, required BuildContext context,
    Map<String, String>? headers,
  }) async {
    try {
      log('url: ${config.API_ROOT + url} ');
      log('body: $body');
      var response =
          await http.post(Uri.parse(config.API_ROOT + url), body: body, headers: headers??postheaders);
      log('respose: ${response.statusCode}');
      log('respose: ${response.body}');

      return response;
    } finally {
      //TODO : Dialog box
    }
  }
}
