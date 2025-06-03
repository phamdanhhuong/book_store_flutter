import 'package:book_store_mobile/enum/enum_payment_mehtod.dart';
import 'package:book_store_mobile/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  _CreateOrderScreenState createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: true);
    final selectedItems = orderProvider.carts
        .where((item) => orderProvider.selectedCartIds.contains(item.id))
        .toList();
    late int totalPrice = 0;
    for (var item in selectedItems) {
      totalPrice += item.book.price * item.quantity;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Order'),
        backgroundColor: const Color.fromARGB(242, 0, 250, 154),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: selectedItems.length,
              itemBuilder: (context, index) {
                final item = selectedItems[index];
                return ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          item.book.coverUrl,
                          width: 40,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.image),
                        ),
                      ),
                    ],
                  ),
                  title: Text(item.book.title),
                  subtitle: Text('Số lượng: ${item.quantity}'),
                  trailing: Text('${item.book.price * item.quantity}đ'),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Tổng tiền: $totalPriceđ",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: PaymentMehtod.COD.name,
                  items: [
                    DropdownMenuItem(
                      value: PaymentMehtod.COD.name,
                      child: Text('Thanh toán khi nhận hàng'),
                    ),
                    DropdownMenuItem(
                      value: PaymentMehtod.E_WALLET.name,
                      child: Text('Ví điện tử'),
                    ),
                  ],
                  onChanged: (value) {
                    orderProvider.paymentMehtod = value!;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Phương thức thanh toán',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Địa chỉ giao hàng',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 1,
                  onChanged: (value) {
                    orderProvider.address = value;
                  },
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      bool result = await orderProvider.createOrder(context);
                      if (result) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Thành công"),
                            content: const Text(
                              "Đơn hàng đã được đặt thành công!",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Đóng dialog
                                  Navigator.pop(
                                    context,
                                  ); // Quay về màn hình trước (nếu cần)
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Nếu cần, hiển thị lỗi:
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Thất bại"),
                            content: const Text(
                              "Đặt hàng không thành công. Vui lòng thử lại.",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Đóng"),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Đặt hàng',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
