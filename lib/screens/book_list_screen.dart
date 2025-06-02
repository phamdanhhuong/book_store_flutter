import 'package:book_store_mobile/providers/auth_provider.dart';
import 'package:book_store_mobile/providers/book_provider.dart';
import 'package:book_store_mobile/screens/book_detail_screen.dart';
import 'package:book_store_mobile/screens/filter_screen.dart';
import 'package:book_store_mobile/widgets/category_carousel.dart';
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
    final authProvider = Provider.of<AuthProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(242, 0, 250, 154),
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Tìm kiếm sách...',
            hintStyle: TextStyle(color: Colors.black),
            border: InputBorder.none,
            icon: Icon(Icons.search, color: Colors.black),
          ),
          style: TextStyle(color: Colors.black),
          onSubmitted: (query) {
            // Xử lý khi người dùng nhập text tìm kiếm
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FilterScreen(keyword: query),
              ),
            );
            // Bạn có thể gọi hàm lọc danh sách theo query ở đây
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(242, 0, 250, 154),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(
                      authProvider.user?.avatarUrl ??
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAd5avdba8EiOZH8lmV3XshrXx7dKRZvhx-A&s',
                    ),
                  ),
                  accountName: Text(authProvider.user?.fullname ?? 'Khách'),
                  accountEmail: Text(authProvider.user?.email ?? ''),
                );
              },
            ),
            if (!authProvider.isAuthenticated)
              ListTile(
                title: const Text('Đăng nhập'),
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
            if (authProvider.isAuthenticated)
              ListTile(
                title: const Text('Đăng xuất'),
                onTap: () {
                  authProvider.logout();
                },
              ),
            if (authProvider.isAuthenticated)
              ListTile(
                title: const Text('Giỏ hàng'),
                onTap: () {
                  Navigator.pushNamed(context, '/cart');
                },
              ),
            if (authProvider.isAuthenticated)
              ListTile(
                title: const Text('Đơn hàng'),
                onTap: () {
                  Navigator.pushNamed(context, '/order');
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
                    const SizedBox(height: 20),
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
