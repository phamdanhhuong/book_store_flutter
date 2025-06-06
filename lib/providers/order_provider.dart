import 'dart:convert';

import 'package:book_store_mobile/config.dart';
import 'package:book_store_mobile/models/cart.dart';
import 'package:book_store_mobile/models/order.dart';
import 'package:book_store_mobile/providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class OrderProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<Cart> _carts = [];
  List<Cart> get carts => _carts;
  set carts(List<Cart> value) {
    _carts = value;
    notifyListeners();
  }

  List<Order> _orders = [];
  List<Order> get orders => _orders;
  set orders(List<Order> value) {
    _orders = value;
    notifyListeners();
  }

  Set<int> _selectedCartIds = {};
  Set<int> get selectedCartIds => _selectedCartIds;

  String _paymentMehtod = '';
  String get paymentMehtod => _paymentMehtod;
  set paymentMehtod(String value) {
    _paymentMehtod = value;
  }

  String _address = '';
  String get address => _address;
  set address(String value) {
    _address = value;
  }

  void toggleCartSelection(int cartId) {
    if (_selectedCartIds.contains(cartId)) {
      _selectedCartIds.remove(cartId);
    } else {
      _selectedCartIds.add(cartId);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedCartIds.clear();
    notifyListeners();
  }

  Future<bool> addToCart(BuildContext context, int bookId, int quantity) async {
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
    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }

  Future<bool> fecthCart(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    final url = Uri.parse("${AppConfig.baseUrl}/order/get-cart");
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      _carts = jsonData.map((json) => Cart.fromJson(json)).toList();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> removeFromCart(BuildContext context, int cartId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    final url = Uri.parse("${AppConfig.baseUrl}/order/remove-item/$cartId");
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      await fecthCart(context);
      return true;
    }
    return false;
  }

  Future<bool> fecthOrder(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    final url = Uri.parse("${AppConfig.baseUrl}/order/get-orders");
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      _orders = jsonData.map((json) => Order.fromJson(json)).toList();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> createOrder(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    final data = {
      "itemIds": _selectedCartIds.toList(),
      'payment_method': _paymentMehtod,
      'address': _address,
    };

    final url = Uri.parse("${AppConfig.baseUrl}/order/create-order");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
    print("Status code :${response.statusCode}");
    if (response.statusCode == 201) {
      clearSelection();
      await fecthCart(context);
      await fecthOrder(context);
      notifyListeners();
      return true;
    }
    return false;
  }
}
