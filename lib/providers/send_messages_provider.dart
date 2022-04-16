import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:io' as i_o;

class SendMessagesProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey();
  final storage = const FlutterSecureStorage();
  String message = '';
  String? file;
  String? image;
  int? positionPhone;
  String? positionEmail;
  final String _baseUrl = 'backend-messages-app.herokuapp.com';
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool showError = false;
  String responseMessage = '';
  bool showText = false;
  bool isAuth = false;
  String errorMessage = '';

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future sendData({
    required String? file,
    required String message,
    required int? positionPhone,
    required String? positionEmail,
  }) async {
    final url = Uri.https(_baseUrl, '/v1/files/massive-messages');
    final token = await storage.read(key: 'AuthToken');
    final bytes = await i_o.File(file!).readAsBytes();
    file = base64.encode(bytes);

    final response = await http.post(url,
        headers: {
          'X-MSM-Auth-Token': token!,
          'Content-Type': 'application/json'
        },
        body: json.encode({
          'file': file,
          'message': message,
          'positionPhone': positionPhone,
          'positionEmail': positionEmail
        }));
    final Map<String?, dynamic> result = json.decode(response.body);
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
    showText = true;
    responseMessage = message['message'];
    await Future.delayed(const Duration(seconds: 5));
    showText = false;
    responseMessage = '';
  }

  bool isvalidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void resetForm() {
    return formKey.currentState?.reset();
  }
}
