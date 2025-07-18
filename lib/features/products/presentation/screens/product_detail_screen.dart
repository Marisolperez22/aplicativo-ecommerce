import 'package:flutter/material.dart';
import 'package:ecommerce/core/widgets/title.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce/core/widgets/screen_widget.dart';
import 'package:fake_store_get_request/models/product.dart';
import 'package:atomic_design_system/atomic_design_system.dart';

import '../../../../core/widgets/generic_app_bar.dart';
import '../../../../core/widgets/rating_widget.dart';
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
            (product) => _buildProductDetail(
              product: product,
              ref: ref,
              context: context,
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductDetail({
    required WidgetRef ref,
    required Product product,
    required BuildContext context,
  }) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.network(
                  product.image ?? '',
                  height: 300,
                  errorBuilder:
                      (_, __, ___) => const Icon(Icons.image, size: 100),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Título y precio
            TextTitle(title: product.title ?? 'Sin título'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$ ${product.price?.toStringAsFixed(2) ?? '0.0'}'),
                RatingWidget(rate: (product.rating?.rate ?? 0).toString()),
              ],
            ),
            const SizedBox(height: 10),

            // Descripción
            TextTitle(title: 'Descripción'),
            const SizedBox(height: 10),

            Text(product.description ?? '', textAlign: TextAlign.justify),
            const SizedBox(height: 20),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                text: 'Agregar al carrito',
                onPressed: () {
                  ref.read(cartNotifierProvider.notifier).addProduct(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.title} añadido al carrito'),
                      duration: Duration(milliseconds: 20),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
