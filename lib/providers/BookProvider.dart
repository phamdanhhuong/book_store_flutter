import 'dart:convert';

import 'package:book_store_mobile/config.dart';
import 'package:book_store_mobile/models/book.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookProvider extends ChangeNotifier {
  List<Book> _books = [];
  bool _isLoading = false;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;

  Future<void> fetchBooks() async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse("${AppConfig.baseUrl}/book/all");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      _books = jsonData.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load books");
    }

    _isLoading = false;
    notifyListeners();
  }
}
