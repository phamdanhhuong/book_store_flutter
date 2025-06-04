import 'dart:convert';

import 'package:book_store_mobile/config.dart';
import 'package:book_store_mobile/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OtpScreen extends StatefulWidget {
  final String email;
  const OtpScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otp = TextEditingController();

  void _verifyOtp() async {
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/auth/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": widget.email, "otp": _otp.text}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Xác thực OTP thành công')));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      ); // Quay lại màn hình đăng nhập hoặc home
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xác thực thất bại: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(242, 0, 250, 154),
      appBar: AppBar(title: const Text('Xác thực OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Nhập mã OTP đã gửi tới email: ${widget.email}'),
            TextField(
              controller: _otp,
              decoration: const InputDecoration(labelText: 'Mã OTP'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _verifyOtp,
              child: const Text('Xác thực'),
            ),
          ],
        ),
      ),
    );
  }
}
