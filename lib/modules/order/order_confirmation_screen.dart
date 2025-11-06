import 'package:flutter/material.dart';

import '../cart/models/cart_item_model.dart';

class OrderConfirmationPage extends StatelessWidget {
  final String kotId;
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double total;
  final int etaMinutes;

  const OrderConfirmationPage({
    Key? key,
    required this.kotId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.etaMinutes,
  }) : super(key: key);

  String _currency(double v) => '₹${v.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Confirmation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order: $kotId',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Estimated preparation time: $etaMinutes minutes'),
            const SizedBox(height: 12),
            const Text(
              'Summary:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(items[index].item.name),
                    trailing: Text(
                      '${items[index].qty} x ₹${items[index].item.price.toStringAsFixed(0)}',
                    ),
                  );
                },
                // children: items
                //     .map(
                //       (c) => ListTile(
                //         title: Text(c.item.name),
                //         trailing: Text(
                //           '${c.qty} x ₹${c.item.price.toStringAsFixed(0)}',
                //         ),
                //       ),
                //     )
                //     .toList(),
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text('Subtotal'), Text(_currency(subtotal))],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text('Tax (5%)'), Text(_currency(tax))],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  _currency(total),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
