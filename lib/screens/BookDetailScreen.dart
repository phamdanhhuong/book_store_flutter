import 'package:book_store_mobile/models/book.dart';
import 'package:flutter/material.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;
  const BookDetailScreen({super.key, required this.book});
  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final ButtonStyle cartButton = ElevatedButton.styleFrom(
    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
    backgroundColor: const Color.fromARGB(246, 235, 104, 28),
    minimumSize: Size(80, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );
  final ButtonStyle buyButton = ElevatedButton.styleFrom(
    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
    backgroundColor: const Color.fromARGB(246, 47, 97, 235),
    minimumSize: Size(80, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );
  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        backgroundColor: const Color.fromARGB(242, 0, 250, 154),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.network(book.coverUrl, height: 200)),
            const SizedBox(height: 20),
            Text(
              book.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Tác giả: ${book.author}"),
            const SizedBox(height: 10),
            Text(
              "Giá: ${book.price} VND",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(244, 245, 0, 0),
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 15,
              children: [
                ElevatedButton.icon(
                  onPressed: () => {},
                  label: Text(
                    "Thêm vào giỏ hàng",
                    style: const TextStyle(fontSize: 15),
                  ),
                  style: cartButton,
                  icon: const Icon(Icons.shopping_cart),
                ),
                ElevatedButton.icon(
                  onPressed: () => {},
                  label: Text("Mua ngay", style: const TextStyle(fontSize: 15)),
                  style: buyButton,
                  icon: const Icon(Icons.credit_card),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text("Mô tả:"),
            Text(book.summary ?? "Không có mô tả"),
          ],
        ),
      ),
    );
  }
}
