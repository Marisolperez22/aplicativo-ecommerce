import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce/core/widgets/search_app_bar.dart';
import 'package:fake_store_get_request/models/product.dart';

import '../../../../core/widgets/gridview_widget.dart';
import '../../../../core/widgets/screen_widget.dart';
import '../providers/product_notifier.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productNotifierProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    // Filtrar productos
    List<Product> filteredProducts = [];
    if (productState is ProductsLoaded && searchQuery.isNotEmpty) {
      filteredProducts =
          productState.products.where((product) {
            return (product.title ?? '').toLowerCase().contains(
              searchQuery.toLowerCase(),
            );
          }).toList();
    }

    return ScreenWidget(
      appBar: SearchAppBar(
        onChanged:
            (value) => ref.read(searchQueryProvider.notifier).state = value,
      ),
      body: _buildBody(
        productState,
        filteredProducts,
        searchQuery,
        screenWidth,
      ),
    );
  }

  Widget _buildBody(
    ProductState state,
    List<Product> filteredProducts,
    String searchQuery,
    double screenWidth,
  ) {
    if (state is ProductInitial || state is ProductLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ProductError) {
      return Center(child: Text(state.message));
    } else if (state is ProductsLoaded) {
      if (filteredProducts.isEmpty && searchQuery.isNotEmpty) {
        return _buildNoResultsState(searchQuery, screenWidth);
      }

      return GridviewWidget(
        itemCount: filteredProducts.length,
        products: filteredProducts,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildNoResultsState(String query, double screenWidth) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: screenWidth > 600 ? 80 : 60,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          Text(
            'No encontramos resultados para:',
            style: TextStyle(
              fontSize: screenWidth > 600 ? 20 : 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '"$query"',
            style: TextStyle(
              fontSize: screenWidth > 600 ? 18 : 16,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Intenta con otros términos de búsqueda',
            style: TextStyle(
              fontSize: screenWidth > 600 ? 16 : 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
