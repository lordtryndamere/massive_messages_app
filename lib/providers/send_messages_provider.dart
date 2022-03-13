import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class SendMessagesProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey();
  String message = '';
  dynamic file;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isvalidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
