import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atomic_design_system/widgets/no_results.dart';
import 'package:atomic_design_system/widgets/search_app_bar.dart';

import '../providers/providers.dart';
import '../../../../core/widgets/screen_widget.dart';
import '../../../../core/widgets/grid_view_widget.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsListProvider);
    final searchQuery = ref.watch(searchQueryProvider);

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
                return NoResults(query: searchQuery);
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
}
