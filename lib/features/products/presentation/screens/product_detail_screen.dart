import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:ecommerce/features/products/presentation/providers/product_detail_notifier.dart';
import 'package:fake_store_get_request/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/cart_notifier.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productDetailNotifierProvider(productId));

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Producto')),
      body: _buildBody(productState, context, ref),
    );
  }

  Widget _buildBody(
    ProductDetailState state,
    BuildContext context,
    WidgetRef ref,
  ) {
    if (state is ProductDetailLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ProductDetailError) {
      return Center(child: Text(state.message));
    } else if (state is ProductDetailLoaded) {
      return _buildProductDetail(state.product, context, ref);
    } else {
      return const Center(child: Text('Estado desconocido'));
    }
  }

  Widget _buildProductDetail(
    Product product,
    BuildContext context,
    WidgetRef ref,
  ) {
    return Container(
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen del producto
                Row(
                  children: [
                    Expanded(
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
                  ],
                ),
                const SizedBox(height: 16),
            
                // Título y precio
                Text(
                  product.title ?? 'Sin título',
                  style: TextStyle(
                    color: AtomicSystemColorsFoundation.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$ ${product.price?.toStringAsFixed(2) ?? '0.0'}'),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          (product.rating?.rate ?? 0).toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
            
                // Descripción
                Text(
                  'Descripción',
                  style: TextStyle(
                    color: AtomicSystemColorsFoundation.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
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
        ),
      ),
    );
  }
}
