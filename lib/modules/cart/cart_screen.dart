import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ordermanagement/core/app_preferences.dart';
import 'package:ordermanagement/modules/cart/models/cart_item_model.dart';
import 'package:provider/provider.dart';

import '../order/order_confirmation_screen.dart';
import 'controllers/cart_provider.dart';

class CartPage extends StatelessWidget {
  String _currency(double v) => '₹${v.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: cart.items.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, idx) {
                      final c = cart.items[idx];
                      return ListTile(
                        leading: Image.network(
                          c.item.imageUrl,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        ),
                        title: Text(c.item.name),
                        subtitle: Text(
                          '${_currency(c.item.price)} • Qty: ${c.qty}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () =>
                                  cart.changeQty(c.item.id, c.qty - 1),
                            ),
                            Text('${c.qty}'),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () =>
                                  cart.changeQty(c.item.id, c.qty + 1),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => cart.remove(c.item.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal'),
                          Text(_currency(cart.subtotal)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tax (5%)'),
                          Text(_currency(cart.tax)),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _currency(cart.total),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          // Place order ->
                          final kotId = _generateOrderId();
                          final eta = _estimatePrepTime(cart.items);
                          Navigator.of(context)
                              .pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => OrderConfirmationPage(
                                    kotId: kotId,
                                    items: cart.items,
                                    subtotal: cart.subtotal,
                                    tax: cart.tax,
                                    total: cart.total,
                                    etaMinutes: eta,
                                  ),
                                ),
                              )
                              .whenComplete(() {
                                cart.clear();
                                AppPreferences.clearCartData();
                              });
                          // cart.clear();
                        },
                        child: const Text('Place Order'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  String _generateOrderId() {
    final rnd = Random();
    final num = 1000 + rnd.nextInt(9000);
    return '$num';
  }

  int _estimatePrepTime(List<CartItem> items) {
    //  base 10 minutes + 2 minutes per item quantity
    var totalQty = items.fold(0, (s, e) => s + e.qty);
    return 10 + totalQty * 2;
  }
}
