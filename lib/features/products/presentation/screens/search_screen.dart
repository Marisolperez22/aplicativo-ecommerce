import 'package:fake_store_get_request/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/product_notifier.dart';
import '../widgets/product_list_item.dart';



class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productNotifierProvider);
    final isSearching = ref.watch(searchProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    // Filtrar productos basados en la consulta de búsqueda
    List<Product> filteredProducts = [];
    if (productState is ProductsLoaded) {
      filteredProducts = productState.products.where((product) {
        return (product.title ?? '').toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Buscar productos...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                },
              )
            : Text('Productos'),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              ref.read(searchProvider.notifier).state = !isSearching;
              if (!isSearching) {
                ref.read(searchQueryProvider.notifier).state = '';
              }
            },
          ),
        ],
      ),
      body: _buildBody(productState, filteredProducts, searchQuery),
    );
  }

  Widget _buildBody(ProductState state, List<Product> filteredProducts, String searchQuery) {
    if (state is ProductInitial || state is ProductLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (state is ProductError) {
      return Center(child: Text(state.message));
    } else if (state is ProductsLoaded) {
      if (filteredProducts.isEmpty) {
        return Center(
          child: Text(
            searchQuery.isEmpty ? 'No hay productos disponibles' : 'No se encontraron resultados',
          ),
        );
      }
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return ProductListItem(product: product);
        },
      );
    }
    return SizedBox.shrink();
  }
}