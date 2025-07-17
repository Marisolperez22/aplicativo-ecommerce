import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:fake_store_get_request/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/catalog_notifier.dart';
import '../widgets/product_card.dart';

class ProductsCatalog extends ConsumerWidget {
  const ProductsCatalog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Categorías')),
      body: Column(
        children: [
          _buildCategories(catalogState, ref),
          Expanded(child: _buildProducts(catalogState)),
        ],
      ),
    );
  }

  Widget _buildCategories(CatalogState state, WidgetRef ref) {
    if (state is! CatalogLoaded || state.categories.isEmpty) {
      return const SizedBox(
        height: 110,
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      return SizedBox(
        height: 110,
        child: _buildProductCategories(state.categories, ref),
      );
    }
  }

  Widget _buildProductCategories(List<String> categories, WidgetRef ref) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(20.0),
      itemCount: categories.length,
      separatorBuilder: (context, index) {
        return const SizedBox(width: 20);
      },
      itemBuilder: (context, index) {
        final category = categories[index];
        return InkWell(
          onTap: () {
            ref
                .read(catalogRepositoryProvider.notifier)
                .getProductsByCategory(category);
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _formatCategoryName(category),
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProducts(CatalogState state) {
    if (state is CatalogInitial) {
      return const Center(child: Text('Selecciona una categoría'));
    } else if (state is CatalogLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is CatalogError) {
      return Center(child: Text('Error: ${state.message}'));
    } else if (state is CatalogLoaded) {
      return _buildProductList(state.products);
    } else {
      return const Center(child: Text('Estado desconocido'));
    }
  }

  Widget _buildProductList(List<Product> products) {
    if (products.isEmpty) {
      return const Center(child: Text('No hay productos en esta categoría'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return CardProduct(product: product);
      },
    );
  }

  String _formatCategoryName(String category) {
    return category
        .replaceAll("'s", "'s ")
        .split(' ')
        .map(
          (word) =>
              word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '',
        )
        .join(' ');
  }
}
