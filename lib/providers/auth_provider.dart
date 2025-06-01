import 'dart:convert';

import 'package:book_store_mobile/config.dart';
import 'package:book_store_mobile/models/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  String? _token;
  User? _user;

  bool get isAuthenticated => _token != null;
  String? get token => _token;
  User? get user => _user;

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['access_token'];
      await fetchUserInfo();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  void logout() async {
    _token = null;
    _user = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwtToken');
    notifyListeners();
  }

  Future<void> fetchUserInfo() async {
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/user/info'),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      _user = User.fromJson(userData);
      notifyListeners();
    } else {
      logout();
      throw Exception('Không thể tải thông tin người dùng');
    }
  }

  Future<void> saveTokenToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwtToken', _token!);
  }

  Future<void> loadTokenFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('jwtToken');
    await fetchUserInfo();
    notifyListeners();
  }
}
