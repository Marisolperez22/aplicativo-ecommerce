import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../../../../core/widgets/screen_widget.dart';
import '../../../../core/widgets/search_app_bar.dart';
import '../../../../core/widgets/gridview_widget.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsListProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return ScreenWidget(
      appBar: SearchAppBar(
        onChanged:
            (value) => ref.read(searchQueryProvider.notifier).state = value,
      ),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => Center(child: Text('Error: ${error.toString()}')),
        data: (productsEither) {
          return productsEither.fold(
            (failure) => Center(child: Text('Error: ${failure.message}')),
            (products) {
              final filteredProducts =
                  searchQuery.isEmpty
                      ? products
                      : products.where((product) {
                        return (product.title ?? '').toLowerCase().contains(
                          searchQuery.toLowerCase(),
                        );
                      }).toList();

              if (searchQuery.isNotEmpty && filteredProducts.isEmpty) {
                return _buildNoResultsState(searchQuery, screenWidth);
              }

              return GridviewWidget(
                itemCount: filteredProducts.length,
                products: filteredProducts,
              );
            },
          );
        },
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

final searchQueryProvider = StateProvider<String>((ref) => '');
