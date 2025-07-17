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
    final screenWidth = MediaQuery.of(context).size.width;

    // Filtrar productos
    List<Product> filteredProducts = [];
    if (productState is ProductsLoaded && searchQuery.isNotEmpty) {
      filteredProducts = productState.products.where((product) {
        return (product.title ?? '').toLowerCase().contains(
              searchQuery.toLowerCase(),
            );
      }).toList();
    }

    return Scaffold(
      appBar: _buildAppBar(isSearching, ref, screenWidth),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth > 1200 ? 48.0 : 
                    screenWidth > 600 ? 24.0 : 16.0,
          vertical: 16.0,
        ),
        child: _buildBody(productState, filteredProducts, searchQuery, screenWidth),
      ),
    );
  }

  AppBar _buildAppBar(bool isSearching, WidgetRef ref, double screenWidth) {
    return AppBar(
      title: isSearching
          ? SizedBox(
              width: screenWidth > 600 ? screenWidth * 0.7 : screenWidth * 0.6,
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Buscar productos...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    fontSize: screenWidth > 900 ? 18 : 16,
                  ),
                ),
                style: TextStyle(fontSize: screenWidth > 900 ? 18 : 16),
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                },
              ),
            )
          : Text(
              'Búsqueda',
              style: TextStyle(
                fontSize: screenWidth > 900 ? 22 : 18,
              ),
            ),
      actions: [
        if (!isSearching)
          IconButton(
            icon: Icon(Icons.search, 
                size: screenWidth > 900 ? 30 : 24),
            onPressed: () => ref.read(searchProvider.notifier).state = true,
          )
        else
          IconButton(
            icon: Icon(Icons.close, 
                size: screenWidth > 900 ? 30 : 24),
            onPressed: () {
              ref.read(searchProvider.notifier).state = false;
              ref.read(searchQueryProvider.notifier).state = '';
            },
          ),
      ],
    );
  }

  Widget _buildBody(
    ProductState state,
    List<Product> filteredProducts,
    String searchQuery,
    double screenWidth,
  ) {
    final crossAxisCount = _calculateCrossAxisCount(screenWidth);
    final childAspectRatio = _calculateChildAspectRatio(screenWidth);

    if (state is ProductInitial || state is ProductLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ProductError) {
      return Center(child: Text(state.message));
    } else if (state is ProductsLoaded) {
      if (searchQuery.isEmpty) {
        return _buildEmptySearchState(screenWidth);
      }

      if (filteredProducts.isEmpty) {
        return _buildNoResultsState(searchQuery, screenWidth);
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: screenWidth > 1200 ? 12 : 
                          screenWidth > 600 ? 10 : 8,
          mainAxisSpacing: screenWidth > 1200 ? 12 : 
                         screenWidth > 600 ? 10 : 8,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          return ProductListItem(
            product: filteredProducts[index],
          );
        },
      );
    }
    return const SizedBox.shrink();
  }

  // Función para calcular columnas dinámicas
  int _calculateCrossAxisCount(double screenWidth) {
    if (screenWidth > 1800) return 6;   // Pantallas muy grandes
    if (screenWidth > 1400) return 5;   // Monitores grandes
    if (screenWidth > 1100) return 4;   // Laptops grandes
    if (screenWidth > 800) return 3;    // Tablets grandes/laptops pequeñas
    if (screenWidth > 500) return 2;    // Tablets pequeñas
    return 2;                           // Móviles
  }

  // Función para calcular relación de aspecto dinámica
  double _calculateChildAspectRatio(double screenWidth) {
    if (screenWidth > 1800) return 0.6; // Más compacto en pantallas muy grandes
    if (screenWidth > 1400) return 0.65;
    if (screenWidth > 1100) return 0.7;
    if (screenWidth > 800) return 0.75;
    return 0.8;                         // Más alto en móviles
  }

  Widget _buildEmptySearchState(double screenWidth) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: screenWidth > 600 ? 80 : 60,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          Text(
            'Busca productos por nombre',
            style: TextStyle(
              fontSize: screenWidth > 600 ? 22 : 18,
              color: Colors.grey.shade600,
            ),
          ),
          if (screenWidth > 600) ...[
            const SizedBox(height: 10),
            Text(
              'Escribe en el campo de búsqueda arriba',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ],
      ),
    );
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