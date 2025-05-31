import 'package:book_store_mobile/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<StatefulWidget> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String? _errorMessage;

  void _handleLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final username = _username.text.trim();
    final password = _password.text.trim();

    await authProvider.login(username, password);

    if (authProvider.isAuthenticated) {
      authProvider.saveTokenToLocalStorage();
      Navigator.pushReplacementNamed(context, '/');
    } else {
      setState(() {
        _errorMessage = 'Sai tên đăng nhập hoặc mật khẩu';
      });
    }
  }

  final ButtonStyle loginButton = ElevatedButton.styleFrom(
    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
    backgroundColor: const Color.fromARGB(246, 47, 97, 235),
    minimumSize: Size(150, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );
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
              if (_errorMessage != null)
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              TextField(
                controller: _username,
                decoration: const InputDecoration(labelText: 'Tên đăng nhập'),
              ),
              TextField(
                controller: _password,
                decoration: const InputDecoration(labelText: 'Mật khẩu'),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _handleLogin,
                child: const Text('Đăng nhập'),
                style: loginButton,
              ),
              TextButton(
                onPressed: () => {print("Đăng ký")},
                child: Text("Chưa có tài khoản? Đăng ký ngay!!!"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
