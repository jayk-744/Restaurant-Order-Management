import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../cart/cart_screen.dart';
import '../cart/controllers/cart_provider.dart';
import '../cart/models/cart_item_model.dart';
import '../settings/settings_screen.dart';
import 'controllers/menu_provider.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // var _menuProvider;
  @override
  void initState() {
    context.read<MenuProvider>().loadMenuData();
    super.initState();
    // _menuProvider = context.read<MenuProvider>();
    // _menuProvider?.loadMenuData();
  }

  @override
  Widget build(BuildContext context) {
    final menuProv = Provider.of<MenuProvider>(context);
    final cart = context.read<CartProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => CartPage()));
                },
              ),
              Consumer<CartProvider>(
                builder: (context, value, child) {
                  return value.items.isNotEmpty
                      ? Positioned(
                          right: 6,
                          top: 6,
                          child: CircleAvatar(
                            radius: 8,
                            backgroundColor: Colors.red,
                            child: Text(
                              '${value.items.length}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : const Offstage();
                },
                // child:
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingsPage()));
            },
          ),
        ],
      ),
      body: menuProv.categories.isNotEmpty
          ? ListView.separated(
              itemCount: menuProv.categories.length,
              separatorBuilder: (context, index) => const Offstage(),
              itemBuilder: (context, index) {
                final cat = menuProv.categories[index];
                return ExpansionTile(
                  childrenPadding: EdgeInsets.zero,
                  title: Text(
                    cat.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  children: [
                    ...cat.items.map((it) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          spacing: 10,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                it.imageUrl,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  it.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(it.description),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('₹${it.price.toStringAsFixed(0)}'),
                                const SizedBox(height: 6),
                                Consumer<CartProvider>(
                                  builder: (context, value, child) {
                                    CartItem? cartItem;
                                    final index = value.items.indexWhere(
                                      (cartItem) => cartItem.item.id == it.id,
                                    );
                                    if (index != -1) {
                                      cartItem = value.items[index];
                                    }
                                    return index != -1
                                        ? Container(
                                            width: 120,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              border: Border.all(),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.remove_circle_outline,
                                                  ),
                                                  onPressed: () =>
                                                      cart.changeQty(
                                                        cartItem!.item.id,
                                                        cartItem.qty - 1,
                                                      ),
                                                ),
                                                Text(
                                                  '${cartItem!.qty}',
                                                  textAlign: TextAlign.center,
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.add_circle_outline,
                                                  ),
                                                  onPressed: () =>
                                                      cart.changeQty(
                                                        cartItem!.item.id,
                                                        cartItem.qty + 1,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : ElevatedButton.icon(
                                            icon: Icon(Icons.add),
                                            onPressed: () {
                                              cart.add(it);
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Added ${it.name}',
                                                  ),
                                                ),
                                              );
                                            },
                                            label: const Text('Add'),
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadiusGeometry.circular(
                                                      10,
                                                    ),
                                              ),
                                            ),
                                          );
                                  },
                                  // child:,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );

                      // ListTile(
                      //   leading: Image.network(
                      //     it.imageUrl,
                      //     width: 64,
                      //     height: 64,
                      //     fit: BoxFit.cover,
                      //   ),
                      //   title: Text(it.name),
                      //   subtitle: Text(it.description),
                      //   trailing: Column(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       Text('₹${it.price.toStringAsFixed(0)}'),
                      //       const SizedBox(height: 6),
                      //       ElevatedButton(
                      //         onPressed: () {
                      //           cart.add(it);
                      //           ScaffoldMessenger.of(context).showSnackBar(
                      //             SnackBar(content: Text('Added ${it.name}')),
                      //           );
                      //         },
                      //         child: const Text('Add'),
                      //       ),
                      //     ],
                      //   ),
                      // );
                    }),
                  ],
                );
              },
            )
          : Center(child: Text('No Items Found!')),
    );
  }
}
