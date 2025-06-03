import 'package:book_store_mobile/providers/order_provider.dart';
import 'package:book_store_mobile/screens/book_detail_screen.dart';
import 'package:book_store_mobile/screens/create_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<StatefulWidget> createState() => _CartScreenState();
}

class _CartScreenState extends State<StatefulWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      await orderProvider.fecthCart(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: true);
    final carts = orderProvider.carts;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
        backgroundColor: const Color.fromARGB(242, 0, 250, 154),
      ),
      body: Column(
        children: [
          Expanded(
            child: carts.isEmpty
                ? const Center(child: Text('Giỏ hàng trống'))
                : ListView.builder(
                    itemCount: carts.length,
                    itemBuilder: (context, index) {
                      final cartItem = carts[index];
                      final isSelected = orderProvider.selectedCartIds.contains(
                        cartItem.id,
                      );
                      return Dismissible(
                        key: Key(
                          cartItem.id.toString(),
                        ), // phải có key duy nhất
                        direction: DismissDirection
                            .endToStart, // chỉ vuốt từ phải sang trái
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          // Optional: hiện dialog xác nhận nếu cần
                          return await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Xác nhận'),
                              content: const Text(
                                'Bạn có chắc chắn muốn xóa không?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: const Text('Không'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: const Text('Có'),
                                ),
                              ],
                            ),
                          );
                        },
                        onDismissed: (direction) {
                          // Gọi Provider hoặc setState để xóa item
                          orderProvider.removeFromCart(context, cartItem.id);
                          // Optional: hiện Snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đã xóa "${cartItem.book.title}"'),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: isSelected,
                                onChanged: (_) {
                                  orderProvider.toggleCartSelection(
                                    cartItem.id,
                                  );
                                },
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  cartItem.book.coverUrl,
                                  width: 40,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.image),
                                ),
                              ),
                            ],
                          ),
                          title: Text(cartItem.book.title),
                          subtitle: Text('Số lượng: ${cartItem.quantity}'),
                          trailing: Text(
                            '${cartItem.book.price * cartItem.quantity}đ',
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BookDetailScreen(book: cartItem.book),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
          if (orderProvider.selectedCartIds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateOrderScreen(),
                    ),
                  );
                },
                child: Text(
                  'Mua (${orderProvider.selectedCartIds.length}) sản phẩm',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
