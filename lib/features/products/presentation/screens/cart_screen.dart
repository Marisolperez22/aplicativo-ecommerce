import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/cart_item.dart';
import '../providers/cart_notifier.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Carrito',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        backgroundColor: const Color.fromARGB(255, 235, 237, 237),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color.fromARGB(255, 235, 237, 237),
                const Color.fromARGB(255, 255, 255, 255),
              ],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SizedBox(
                          width: 50,
                          height: 50,

                          child: FadeInImage.assetNetwork(
                            placeholder:
                                'assets/placeholder.png', // Añade un asset para el placeholder
                            image: item.product.image ?? '',
                            fit: BoxFit.contain,
                            imageErrorBuilder:
                                (context, error, stackTrace) =>
                                    Icon(Icons.error),
                          ),
                        ),
                      ),
                      title: Text(
                        item.product.title ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AtomicSystemColorsFoundation.primaryColor,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${item.product.price?.toStringAsFixed(2)} c/u',
                            style: TextStyle(
                              color: AtomicSystemColorsFoundation.primaryColor,
                            ),
                          ),
                          Text(
                            'Total: \$${(item.totalPrice).toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            
                            icon: Icon(Icons.remove),
                            onPressed:
                                () => ref
                                    .read(cartNotifierProvider.notifier)
                                    .decreaseQuantity(item.product.id),
                          ),
                          Text(item.quantity.toString()),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed:
                                () => ref
                                    .read(cartNotifierProvider.notifier)
                                    .addProduct(item.product),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Subtotal: ',
                                style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 106, 106, 106)),
                                
                              ),
                              Text(
                                '\$${_calculateTotal(cartItems).toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),

                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Envío: ',
                                style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 106, 106, 106)),
                                
                              ),
                              Text(
                                '\$25.00',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),

                              ),
                            ],
                          ),
                            Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total: ',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                
                              ),
                              Text(
                                '\$${(_calculateTotal(cartItems) + 25).toStringAsFixed(2) }',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),

                              ),
                            ],
                          ),
                    
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateTotal(List<CartItem> items) {
    return items.fold(0, (sum, item) => sum + item.totalPrice);
  }
}
