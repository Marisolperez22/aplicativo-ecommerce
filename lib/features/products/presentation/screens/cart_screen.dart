import 'package:atomic_design_system/widgets/cart_custom_tile.dart';
import 'package:atomic_design_system/widgets/cart_total.dart';
import 'package:atomic_design_system/widgets/generic_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/screen_widget.dart';
import '../providers/cart_notifier.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartNotifierProvider);

    return ScreenWidget(
      hasSingleChilScroll: false,
      appBar: GenericAppBar(title: 'Carrito'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return CartCustomTile(
                  imageUrl: item.product.image ?? '',
                  title: item.product.title ?? '',
                  price: item.product.price?.toStringAsFixed(2) ?? '0.00',
                  totalPrice: item.totalPrice.toStringAsFixed(2),
                  quantity: item.quantity.toString(),
                  onDecrease:
                      () => ref
                          .read(cartNotifierProvider.notifier)
                          .decreaseQuantity(item.product.id),
                  onIncrease:
                      () => ref
                          .read(cartNotifierProvider.notifier)
                          .addProduct(item.product),
                );
              },
            ),
          ),
          CartTotal(
            subtotal: Utils.calculateTotal(cartItems).toStringAsFixed(2),
            total: (Utils.calculateTotal(cartItems) + 25).toStringAsFixed(2),
          ),
        ],
      ),
    );
  }
}
