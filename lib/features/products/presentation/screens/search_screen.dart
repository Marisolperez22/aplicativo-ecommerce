import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:fake_store_get_request/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/product_notifier.dart';
import '../widgets/product_list_item.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(productNotifierProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar productos'),
        leading: BackButton(
          onPressed: () {
            ref.read(searchQueryProvider.notifier).state = '';
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomSearchBar(
              hintText: 'Buscar por título...',
              buttonText: 'Buscar',
              onSearchChanged: (query) {
                ref.read(searchQueryProvider.notifier).state = query;
              },
              onSearchPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
          ),
          Expanded(
            child: _buildSearchResults(homeState, searchQuery),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(ProductState state, String searchQuery) {
    if (state is ProductInitial) {
      return const Center(child: Text('Ingresa un término de búsqueda'));
    } else if (state is ProductLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ProductError) {
      return Center(child: Text('Error: ${state.message}'));
    } else if (state is ProductsLoaded) {
      return _buildProductList(_filterProductsByTitle(state.products, searchQuery));
    } else {
      return const Center(child: Text('Estado desconocido'));
    }
  }

  List<Product> _filterProductsByTitle(List<Product> products, String query) {
    if (query.isEmpty) return [];
    
    return products.where((product) {
      final title = product.title?.toLowerCase() ?? '';
      final searchLower = query.toLowerCase();
      return title.contains(searchLower);
    }).toList();
  }

  Widget _buildProductList(List<Product> products) {
    if (products.isEmpty) {
      return const Center(child: Text('No se encontraron productos'));
    }
    
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductListItem(product: product);
      },
    );
  }
}