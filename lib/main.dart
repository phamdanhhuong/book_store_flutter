import 'package:book_store_mobile/providers/auth_provider.dart';
import 'package:book_store_mobile/providers/book_provider.dart';
import 'package:book_store_mobile/providers/order_provider.dart';
import 'package:book_store_mobile/screens/book_list_screen.dart';
import 'package:book_store_mobile/screens/cart_screen.dart';
import 'package:book_store_mobile/screens/filter_screen.dart';
import 'package:book_store_mobile/screens/login_screen.dart';
import 'package:book_store_mobile/screens/order_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<StatefulWidget> createState() => _MainAppState();
}

class _MainAppState extends State<StatefulWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.loadTokenFromLocalStorage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book store',
      initialRoute: '/',
      routes: {
        '/': (context) => const BookListScreen(),
        '/login': (context) => const LoginScreen(),
        '/cart': (context) => const CartScreen(),
        '/order': (context) => const OrderScreen(),
      },
    );
  }
}
