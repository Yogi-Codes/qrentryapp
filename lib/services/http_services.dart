import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpServices {
  static const _baseUrl = 'http://192.168.29.10:8080/';
  static Future<Map<String, dynamic>?> askForHerNudes(String path) async {
    Map<String, dynamic>? result;
    await http.get(
      Uri.parse(_baseUrl+path),
      headers: {
        'Content-Type': 'application/json',
        'x_access_token': 'sxyprn'
      }
    ).then((nude) {
      if (nude.body.isNotEmpty) {
        result = jsonDecode(nude.body);
      }
    });
    return result;
  }
  static Future<Map<String, dynamic>?> postYourNudes(
    String path, {Map<String, dynamic>? body}) async {
    Map<String, dynamic>? result;
    print(_baseUrl+path);
    await http.post(
      Uri.parse(_baseUrl+path),
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
        'x_access_token': 'sxyprn'
      }
    ).then((nude) {
        print(nude.body);
      if (nude.body.isNotEmpty) {
        result = jsonDecode(nude.body);
      }
    }).catchError((err) {
      print(err.toString());
    });
    return result;
  }
}