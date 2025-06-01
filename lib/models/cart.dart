import 'package:book_store_mobile/models/book.dart';

class Cart {
  final int id;
  final Book book;
  final int quantity;
  final DateTime created_at;

  Cart({
    required this.id,
    required this.book,
    required this.quantity,
    required this.created_at,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      book: Book.fromJson(json['book']),
      quantity: json['quantity'],
      created_at: DateTime.parse(json['created_at']),
    );
  }
}
