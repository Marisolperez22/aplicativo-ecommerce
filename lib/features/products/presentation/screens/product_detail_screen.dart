import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce/core/widgets/screen_widget.dart';
import 'package:atomic_design_system/widgets/generic_app_bar.dart';
import 'package:atomic_design_system/widgets/product_detail_card.dart';

import '../../../../core/errors/failure.dart';
import '../providers/cart_notifier.dart';
import '../providers/providers.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(
      productDetailProvider(int.tryParse(productId) ?? 0),
    );

    return ScreenWidget(
      appBar: GenericAppBar(title: 'Detalle del producto'),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          if (error is Failure) {
            return Center(child: Text(error.message ?? ''));
          }
          return Center(child: Text('Error: $error'));
        },
        data: (either) {
          return either.fold(
            (failure) => Center(child: Text(failure.message ?? '')),
            (product) => ProductDetailCard(
              productImage: product.image ?? '',
              productTitle: product.title ?? 'Sin título',
              productPrice: product.price ?? 0.0,
              productDescription: product.description ?? 'No disponible',
              productRating: product.rating?.rate ?? 0.0,
              onAddToCart: () {
                ref.read(cartNotifierProvider.notifier).addProduct(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.title} añadido al carrito'),
                    duration: Duration(milliseconds: 20),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
