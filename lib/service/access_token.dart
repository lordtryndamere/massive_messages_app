import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccessToken extends ChangeNotifier {
  final String _baseUrl = 'localhost:8080';
  final storage = const FlutterSecureStorage();
  AccessToken() {
    getAccessToken();
  }
  Future getAccessToken() async {
    final url = Uri.http(_baseUrl, '/v1/users/generate-access-token');
    final response = await http.get(url);
    final Map<String, dynamic> token = json.decode(response.body);
    if (token['code'] == 100) {
      await storage.write(
          key: 'AccessToken', value: token['data']['accessToken']);
      return token['data']['accessToken'];
    } else {
      return token['message'];
    }
  }
}
