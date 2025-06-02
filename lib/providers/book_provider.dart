import 'dart:convert';

import 'package:book_store_mobile/config.dart';
import 'package:book_store_mobile/models/book.dart';
import 'package:book_store_mobile/models/category.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookProvider extends ChangeNotifier {
  List<Book> _books = [];
  List<Book> _booksFiltered = [];
  List<Category> _categories = [];
  bool _isLoading = false;
  bool _isLoadingCategories = false;
  double _currentPos = 0;

  List<Book> get books => _books;
  List<Book> get booksFiltered => _booksFiltered;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  bool get isLoadingCategories => _isLoadingCategories;
  double get currentPos => _currentPos;
  set currentPos(double value) => _currentPos = value;

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

  Future<void> fetchBooksByCategory() async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse("${AppConfig.baseUrl}/book/categories");
    final Map<String, dynamic> data = {'categoryId': _currentPos.toInt()};
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // gửi dạng json
      },
      body: jsonEncode(data), // encode Map thành JSON string
    );

    if (response.statusCode == 201) {
      final List<dynamic> jsonData = json.decode(response.body);
      _books = jsonData.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load books");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    _isLoadingCategories = true;
    notifyListeners();

    final url = Uri.parse("${AppConfig.baseUrl}/book/categories");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      _categories = jsonData.map((json) => Category.fromJson(json)).toList();
      _categories = [
        new Category(
          id: 0,
          name: "Tất cả",
          cover_url:
              "https://cdn.vectorstock.com/i/1000x1000/98/09/all-word-on-white-background-vector-42349809.webp",
        ),
        ..._categories,
      ];
    } else {
      throw Exception("Failed to load categories");
    }

    _isLoadingCategories = false;
    notifyListeners();
  }

  Future<void> fetchBooksByKeyword(String keyword) async {
    final url = Uri.parse(
      '${AppConfig.baseUrl}/book/filter'
      '?title=$keyword', //&author=$keyword&publisher=$keyword
    );

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json', // gửi dạng json
      }, // encode Map thành JSON string
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      _booksFiltered = jsonData.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load books");
    }
    notifyListeners();
  }
}
