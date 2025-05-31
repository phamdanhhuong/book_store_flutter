import 'package:book_store_mobile/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void checkLoginAndNavigate(BuildContext context, VoidCallback onSuccess) {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);

  if (authProvider.isAuthenticated) {
    onSuccess();
  } else {
    Navigator.pushNamed(context, '/login');
  }
}
