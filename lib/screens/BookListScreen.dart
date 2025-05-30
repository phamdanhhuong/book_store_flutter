import 'package:book_store_mobile/providers/BookProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookListScreen extends StatelessWidget {
  const BookListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Book Store')),
      body: bookProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: bookProvider.books.length,
              itemBuilder: (context, index) {
                final book = bookProvider.books[index];
                return ListTile(
                  leading: Image.network(
                    book.coverUrl,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(book.title),
                  subtitle: Text(
                    book.author + "\n" + book.price.toString() + "VND",
                  ),
                  onTap: () {
                    // Điều hướng đến màn hình chi tiết nếu muốn
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => bookProvider.fetchBooks(),
        child: const Icon(Icons.download),
      ),
    );
  }
}
