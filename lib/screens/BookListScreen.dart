import 'package:book_store_mobile/providers/BookProvider.dart';
import 'package:book_store_mobile/screens/BookDetailScreen.dart';
import 'package:book_store_mobile/widgets/CategoryCarousel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  @override
  void initState() {
    super.initState();

    // Dùng Future.microtask hoặc WidgetsBinding để tránh lỗi context chưa sẵn sàng
    Future.microtask(() {
      final bookProvider = Provider.of<BookProvider>(context, listen: false);
      bookProvider.fetchBooks();
      bookProvider.fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Store'),
        backgroundColor: const Color.fromARGB(242, 0, 250, 154),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(242, 0, 250, 154),
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: -screenWidth * 1.4,
            right: -screenWidth / 2,
            child: Container(
              width: screenWidth * 2,
              height: screenWidth * 2,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(242, 0, 250, 154),
              ),
            ),
          ),
          bookProvider.isLoadingCategories
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    const CategoryCarousel(),
                    bookProvider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: bookProvider.books.length,
                              itemBuilder: (context, index) {
                                final book = bookProvider.books[index];
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
                                    subtitle: Text(
                                      '${book.author}\n${book.price} VND',
                                    ),
                                    onTap: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BookDetailScreen(book: book),
                                        ),
                                      ),
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                  ],
                ),
        ],
      ),
    );
  }
}

// class BookListScreen extends StatelessWidget {
//   const BookListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final bookProvider = Provider.of<BookProvider>(context);
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Book Store'),
//         backgroundColor: Color.fromARGB(242, 0, 250, 154),
//       ),
//       body: Stack(
//         children: [
//           // Hình tròn nền
//           Positioned(
//             top: -screenWidth * 1.4,
//             right: -screenWidth / 2,
//             child: Container(
//               width: screenWidth * 2,
//               height: screenWidth * 2,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Color.fromARGB(242, 0, 250, 154), // Ví dụ màu xanh nhạt
//               ),
//             ),
//           ),

//           bookProvider.isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : Column(children: [const CategoryCarousel()]),
//           // Row(

//           // ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => {
//           bookProvider.fetchBooks(),
//           bookProvider.fetchCategories(),
//         },
//         child: const Icon(Icons.download),
//       ),
//     );
//   }
// }
