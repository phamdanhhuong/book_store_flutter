import 'package:book_store_mobile/models/order.dart';
import 'package:book_store_mobile/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      orderProvider.fecthOrder(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    List<Order> orders = orderProvider.orders;
    return Scaffold(
      appBar: AppBar(title: Text('Đơn hàng')),
      body: orders.length == Icons.battery_0_bar
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  color: Colors.transparent,
                  shadowColor: Colors.transparent,
                  child: ListTile(
                    leading: Image.network(
                      order.items[0].book.coverUrl,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(order.items[0].book.title),
                    trailing: Text('${order.total_price} VND'),
                    onTap: () => {},
                  ),
                );
              },
            ),
    );
  }
}
