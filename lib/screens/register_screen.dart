import 'dart:convert';

import 'package:book_store_mobile/config.dart';
import 'package:book_store_mobile/screens/verify_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _fullname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone_number = TextEditingController();

  final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
    backgroundColor: const Color.fromARGB(246, 47, 97, 235),
    minimumSize: Size(150, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  void _register() async {
    if (_password.text != _confirmPassword.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Mật khẩu không khớp')));
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username": _username.text,
        "password": _password.text,
        "fullname": _fullname.text,
        "email": _email.text,
        "phone_number": _phone_number.text,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OtpScreen(email: _email.text)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng ký thất bại: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(242, 0, 250, 154),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Center(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    'lib/assets/images/logo.jpg',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              TextField(
                controller: _username,
                decoration: const InputDecoration(labelText: 'Tên đăng nhập'),
              ),
              TextField(
                controller: _password,
                decoration: const InputDecoration(labelText: 'Mật khẩu'),
                obscureText: true,
              ),
              TextField(
                controller: _confirmPassword,
                decoration: const InputDecoration(
                  labelText: 'Xác nhận mật khẩu',
                ),
                obscureText: true,
              ),
              TextField(
                controller: _fullname,
                decoration: const InputDecoration(labelText: 'Họ và tên'),
              ),
              TextField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _phone_number,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Đăng ký'),
                style: buttonStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
