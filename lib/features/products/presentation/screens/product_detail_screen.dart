import 'package:ecommerce/features/products/presentation/providers/product_detail_notifier.dart';
import 'package:fake_store_get_request/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productDetailNotifierProvider(productId));

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Producto')),
      body: _buildBody(productState),
    );
  }

  Widget _buildBody(ProductDetailState state) {
    if (state is ProductDetailLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ProductDetailError) {
      return Center(child: Text(state.message));
    } else if (state is ProductDetailLoaded) {
      return _buildProductDetail(state.product);
    } else {
      return const Center(child: Text('Estado desconocido'));
    }
  }

  Widget _buildProductDetail(Product product) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del producto
          Center(
            child: Image.network(
              product.image ?? '',
              height: 300,
              errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 100),
            ),
          ),
          const SizedBox(height: 16),
          
          // Título y precio
          Text(
            product.title ?? 'Sin título',
          ),
          const SizedBox(height: 8),
          Text(
            '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
           
          ),
          const SizedBox(height: 16),
          
       
          
          // Descripción
          Text(
            'Descripción:',
          ),
          const SizedBox(height: 8),
          Text(product.description ?? 'Sin descripción disponible'),
        ],
      ),
    );
  }
}