import 'package:book_store_mobile/providers/book_provider.dart';
import 'package:book_store_mobile/screens/book_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatefulWidget {
  final String keyword;
  const FilterScreen({super.key, required this.keyword});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final bookProvider = Provider.of<BookProvider>(context, listen: false);
      await bookProvider.fetchBooksByKeyword(widget.keyword);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context, listen: true);
    final books = bookProvider.booksFiltered;
    return Scaffold(
      appBar: AppBar(
        title: Text('Result for ${widget.keyword}'),
        backgroundColor: const Color.fromARGB(242, 0, 250, 154),
      ),
      body: books.isEmpty
          ? const Center(child: Text('Không tìm thấy kết quả'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Card(
                  color: Colors.transparent,
                  shadowColor: Colors.transparent,
                  child: ListTile(
                    leading: Image.network(
                      book.coverUrl,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(book.title),
                    subtitle: Text('${book.author}\n${book.price} VND'),
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailScreen(book: book),
                        ),
                      ),
                    },
                  ),
                );
              },
            ),
    );
  }
}
