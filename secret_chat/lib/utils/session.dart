import 'dart:convert';
//import 'dart:html' as html;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Session {
  final Key = "SESSION";
  final _storage = FlutterSecureStorage();

  set(String token, int expiresIn) async {
    final data = {
      "token": token,
      "expiresIn": expiresIn,
      "createdAt": DateTime.now().toString()
    };
    await _storage.write(key: Key, value: jsonEncode(data));
  }

  get() async {
    final result = await _storage.read(key: Key);
    if (result != null) {
      return jsonDecode(result);
    }
    return null;
  }

  clearSession() async {
    await _storage.deleteAll();
  }
}
