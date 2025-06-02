import 'package:book_store_mobile/models/book.dart';

class Order {
  final int id;
  final int total_price;
  final String status;
  final DateTime created_at;
  final List<OrderItem> items;
  final String shipping_address;
  final String payment_method;

  Order({
    required this.id,
    required this.total_price,
    required this.status,
    required this.created_at,
    required this.items,
    required this.shipping_address,
    required this.payment_method,
  });
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      total_price: json['total_price'],
      status: json['status'],
      created_at: DateTime.parse(json['created_at']),
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      shipping_address: json['shipping_address'],
      payment_method: json['payment_method'],
    );
  }
}

class OrderItem {
  final int id;
  final Book book;
  final int quantity;
  final int price;

  OrderItem({
    required this.id,
    required this.book,
    required this.quantity,
    required this.price,
  });
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      book: Book.fromJson(json['book']),
      quantity: json['quantity'],
      price: json['price'],
    );
  }
}
