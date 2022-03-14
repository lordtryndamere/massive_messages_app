import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey();
  final storage = const FlutterSecureStorage();
  String email = '';
  String password = '';
  late Map<String?, dynamic> user;
  final String _baseUrl = 'localhost:8080';
  bool _isLoading = false;
  bool showError = false;
  bool isAuth = false;
  String errorMessage = '';
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future login({required String email, required String password}) async {
    final url = Uri.http(_baseUrl, '/v1/users/login');
    final token = await storage.read(key: 'AccessToken');
    final response = await http.post(url,
        headers: {
          'X-MSM-Access-Token': token!,
          'Content-Type': 'application/json'
        },
        body: json.encode({'email': email, 'password': password}));

    final Map<String?, dynamic> result = json.decode(response.body);
    if (result['code'] == 100) {
      await storage.write(key: 'AuthToken', value: result['data']['authToken']);
      isAuth = true;
      await storage.write(
          key: 'user', value: json.encode(result['data']['user']));
      user = result['data']['user'];
    }
    receiveMessage(result);
    return result;
  }

  void receiveMessage(message) async {
    if (message['code'] != 100) {
      showError = true;
      errorMessage = message['message'];
      await Future.delayed(const Duration(seconds: 5));
      showError = false;
      errorMessage = '';
    }
  }

  bool isvalidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void resetForm() {
    return formKey.currentState?.reset();
  }
}
