import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider extends ChangeNotifier {
  final storage = const FlutterSecureStorage();
  dynamic user;
  dynamic authToken;
  UserProvider() {
    getUser();
  }
  void getUser() async {
    if (user != null) return;
    final token = await storage.read(key: 'AuthToken');
    user = await storage.read(key: 'user');
    user = json.decode(user!);
    authToken = token;
    notifyListeners();
  }
}
