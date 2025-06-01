import 'dart:convert';

import 'package:book_store_mobile/config.dart';
import 'package:book_store_mobile/providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class OrderProvider extends ChangeNotifier {
  Future<void> addToCart(BuildContext context, int bookId, int quantity) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    final url = Uri.parse("${AppConfig.baseUrl}/order/add-to-cart");
    final Map<String, dynamic> data = {'bookId': bookId, 'quantity': quantity};
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // gửi dạng json
      },
      body: jsonEncode(data), // encode Map thành JSON string
    );
    print(response.statusCode);
  }
}
