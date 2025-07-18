import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:ecommerce/core/widgets/screen_widget.dart';
import 'package:fake_store_get_request/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/generic_app_bar.dart';
import '../providers/catalog_notifier.dart';
import '../widgets/product_card.dart';

class ProductCategories extends ConsumerWidget {
  const ProductCategories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final productsAsync = ref.watch(productsByCategoryProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return ScreenWidget(
      hasBottomNavigationBar: true,
      hasSingleChilScroll: false,
      appBar: GenericAppBar(title: 'Categorías'),
      body: Column(
        children: [
          _buildCategories(
            categoriesAsync: categoriesAsync,
            ref: ref,
            selectedCategory: selectedCategory,
            screenWidth: screenWidth,
          ),
          const SizedBox(height: 12),
          _buildCategoryTitle(selectedCategory, screenWidth),
          const SizedBox(height: 12),
          Expanded(child: _buildProducts(productsAsync, screenWidth)),
        ],
      ),
      // appBarTitle: 'Catálogo de Productos',
    );
  }

  Widget _buildCategories({
    required WidgetRef ref,
    required String? selectedCategory,
    required AsyncValue<List<String>> categoriesAsync,
    required double screenWidth,
  }) {
    return SizedBox(
      height: screenWidth > 600 ? 90 : 70,
      child: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => Center(
              child: Text('Error: $error', style: TextStyle(color: Colors.red)),
            ),
        data: (categories) {
          final allCategories = ['Todas', ...categories];
          return _buildProductCategories(
            allCategories,
            ref,
            selectedCategory,
            screenWidth,
          );
        },
      ),
    );
  }

  Widget _buildProductCategories(
    List<String> categories,
    WidgetRef ref,
    String? selectedCategory,
    double screenWidth,
  ) {
    final isLargeScreen = screenWidth > 600;
    final padding = isLargeScreen ? 16.0 : 10.0;
    final fontSize = isLargeScreen ? 14.0 : 12.0;

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: padding),
      itemCount: categories.length,
      separatorBuilder:
          (context, index) => SizedBox(width: isLargeScreen ? 16 : 12),
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = category == selectedCategory;

        return FilterChip(
          label: Text(
            _formatCategoryName(category),
            style: TextStyle(
              fontSize: fontSize,
              color:
                  isSelected
                      ? Colors.white
                      : AtomicSystemColorsFoundation.colorButtonPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          selected: isSelected,
          onSelected: (_) {
            ref.read(selectedCategoryProvider.notifier).state = category;
            ref
                .read(productsByCategoryProvider.notifier)
                .getProductsByCategory(category);
          },
          backgroundColor: const Color.fromARGB(255, 255, 208, 198),
          selectedColor: AtomicSystemColorsFoundation.colorButtonPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color:
                  isSelected
                      ? AtomicSystemColorsFoundation.colorButtonPrimary
                      : const Color.fromARGB(255, 255, 208, 198),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isLargeScreen ? 20 : 16,
            vertical: isLargeScreen ? 10 : 8,
          ),
          showCheckmark: false,
        );
      },
    );
  }

  Widget _buildCategoryTitle(String? selectedCategory, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 600 ? 24.0 : 16.0,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          selectedCategory != null
              ? _formatCategoryName(selectedCategory)
              : 'Todos los productos',
          style: TextStyle(
            fontSize: screenWidth > 600 ? 24 : 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
      ),
    );
  }

  Widget _buildProducts(
    AsyncValue<List<Product>> productsAsync,
    double screenWidth,
  ) {
    return productsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: screenWidth > 600 ? 56 : 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar productos',
                  style: TextStyle(fontSize: screenWidth > 600 ? 20 : 18),
                ),
                Text('$error', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
      data: (products) => _buildProductList(products, screenWidth),
    );
  }

  Widget _buildProductList(List<Product> products, double screenWidth) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: screenWidth > 600 ? 56 : 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No hay productos en esta categoría',
              style: TextStyle(
                fontSize: screenWidth > 600 ? 20 : 18,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    final crossAxisCount = _calculateCrossAxisCount(screenWidth);
    final aspectRatio = _calculateAspectRatio(screenWidth);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth > 600 ? 16.0 : 8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: aspectRatio,
          crossAxisSpacing: screenWidth > 600 ? 16 : 12,
          mainAxisSpacing: screenWidth > 600 ? 16 : 12,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return CardProduct(product: product);
        },
      ),
    );
  }

  int _calculateCrossAxisCount(double screenWidth) {
    if (screenWidth > 1800) return 6; // Pantallas muy grandes
    if (screenWidth > 1400) return 5; // Monitores grandes
    if (screenWidth > 1100) return 4; // Laptops grandes
    if (screenWidth > 800) return 3; // Tablets grandes/laptops pequeñas
    if (screenWidth > 500) return 2; // Tablets pequeñas
    return 2; // Móviles
  }

  double _calculateAspectRatio(double screenWidth) {
    if (screenWidth > 1800)
      return 0.65; // Más compacto en pantallas muy grandes
    if (screenWidth > 1400) return 0.7;
    if (screenWidth > 1100) return 0.75;
    if (screenWidth > 800) return 0.8;
    return 0.85; // Más alto en móviles
  }

  String _formatCategoryName(String category) {
    if (category == 'Todas') return category;

    return category
        .replaceAll("'s", "'s ")
        .split(' ')
        .map(
          (word) =>
              word.isNotEmpty
                  ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                  : '',
        )
        .join(' ');
  }
}
