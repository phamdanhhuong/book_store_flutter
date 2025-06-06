import 'package:book_store_mobile/models/order.dart';
import 'package:flutter/material.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    Order order = widget.order;
    List<OrderItem> orderItems = order.items;
    return Scaffold(
      appBar: AppBar(title: Text('Chi tiết đơn hàng')),
      body: orderItems.length == Icons.battery_0_bar
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: orderItems.length,
                    itemBuilder: (context, index) {
                      final orderItem = orderItems[index];
                      return Card(
                        color: Colors.transparent,
                        shadowColor: Colors.transparent,
                        child: ListTile(
                          leading: Image.network(
                            orderItem.book.coverUrl,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(orderItem.book.title),
                          subtitle: Text('Số lượng: ${orderItem.quantity}'),
                          trailing: Text(
                            '${orderItem.quantity * orderItem.book.price} VND',
                          ),
                          onTap: () => {},
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tổng tiền: ${order.total_price} VND",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Phương thức thanh toán: ${order.payment_method == "COD" ? "Thanh toán khi nhận hàng" : "Ví điện tử"}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Địa chỉ giao hàng: ${order.shipping_address}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
