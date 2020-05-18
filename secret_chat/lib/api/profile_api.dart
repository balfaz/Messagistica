import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../utils/dialogs.dart';
import 'package:flutter/services.dart';
import '../app_config.dart';

class profileAPI {
  Future<dynamic> getuserInfo(BuildContext context, String token) async {
    try {
      final url = "${appConfig.apiHost}/user-info";
      final response = await http.get(url, headers: {"token": token});
      final parsed = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return parsed;
      } else if (response.statusCode == 403) {
        throw PlatformException(code: "403", message: parsed['message']);
      } else if (response.statusCode == 500) {
        throw PlatformException(code: "500", message: parsed['message']);
      }
      throw PlatformException(code: "201", message: "error: /user-info");
    } on PlatformException catch (e) {
      print("error ${e.code}: ${e.message}");
      Dialogs.alert(context, title: "Error", message: e.toString());
      return null;
    }
  }
}
