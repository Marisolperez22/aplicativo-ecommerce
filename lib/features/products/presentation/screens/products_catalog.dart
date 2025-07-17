import 'package:atomic_design_system/atoms/buttons/primary_button.dart';
import 'package:fake_store_get_request/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/catalog_notifier.dart';
import '../widgets/product_card.dart';

class ProductsCatalog extends ConsumerWidget {
  const ProductsCatalog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final productsAsync = ref.watch(productsByCategoryProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider); // Nuevo provider para categoría seleccionada

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Productos', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Column(
          children: [
            _buildCategories(categoriesAsync, ref, selectedCategory),
            const SizedBox(height: 8),
            _buildCategoryTitle(selectedCategory),
            const SizedBox(height: 8),
            Expanded(child: _buildProducts(productsAsync)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories(
    AsyncValue<List<String>> categoriesAsync,
    WidgetRef ref,
    String? selectedCategory,
  ) {
    return SizedBox(
      height: 80,
      child: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error', style: TextStyle(color: Colors.red))),
        data: (categories) => _buildProductCategories(categories, ref, selectedCategory),
      ),
    );
  }

  Widget _buildProductCategories(List<String> categories, WidgetRef ref, String? selectedCategory) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: categories.length,
      separatorBuilder: (context, index) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = category == selectedCategory;
        
        return ChoiceChip(
          label: Text(
            _formatCategoryName(category),
            style: TextStyle(
              color: isSelected ? Colors.white : Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          selected: isSelected,
          onSelected: (_) {
            ref.read(selectedCategoryProvider.notifier).state = category;
            ref.read(productsByCategoryProvider.notifier).getProductsByCategory(category);
          },
          backgroundColor: Colors.transparent,
          selectedColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected 
                  ? Theme.of(context).primaryColor 
                  : Colors.grey.shade300,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        );
      },
    );
  }

  Widget _buildCategoryTitle(String? selectedCategory) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          selectedCategory != null 
              ? _formatCategoryName(selectedCategory)
              : 'Todos los productos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
      ),
    );
  }

  Widget _buildProducts(AsyncValue<List<Product>> productsAsync) {
    return productsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text('Error al cargar productos', style: TextStyle(fontSize: 18)),
            Text('$error', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
      data: (products) => _buildProductList(products),
    );
  }

  Widget _buildProductList(List<Product> products) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No hay productos en esta categoría',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return CardProduct(product: product);
        },
      ),
    );
  }

  String _formatCategoryName(String category) {
    return category
        .replaceAll("'s", "'s ")
        .split(' ')
        .map(
          (word) => word.isNotEmpty 
              ? word[0].toUpperCase() + word.substring(1).toLowerCase()
              : '',
        )
        .join(' ');
  }
}

// Añade este provider en tu archivo de providers
final selectedCategoryProvider = StateProvider<String?>((ref) => null);