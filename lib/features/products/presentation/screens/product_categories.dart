import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atomic_design_system/widgets/empty.dart';
import 'package:ecommerce/core/widgets/screen_widget.dart';
import 'package:atomic_design_system/widgets/error_icon.dart';
import 'package:atomic_design_system/widgets/category_title.dart';
import 'package:atomic_design_system/atoms/appbars/generic_app_bar.dart';
import 'package:atomic_design_system/widgets/categories_filter_chip.dart';

import '../providers/providers.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/grid_view_widget.dart';

class ProductCategories extends ConsumerWidget {
  const ProductCategories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final productsAsync = ref.watch(productsByCategoryProvider);

    final isLargeScreen = MediaQuery.of(context).size.width > 600;
    final padding = isLargeScreen ? 16.0 : 10.0;
    final fontSize = isLargeScreen ? 17.0 : 15.0;

    return ScreenWidget(
      hasSingleChilScroll: false,
      hasBottomNavigationBar: true,
      appBar: GenericAppBar(title: 'Categorías'),
      body: Column(
        children: [
          /// Categories Filter Chips
          SizedBox(
            height: isLargeScreen ? 90 : 50,
            child: categoriesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error:
                  (error, stack) => Center(
                    child: Text(
                      'Error: $error',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              data: (categories) {
                final allCategories = ['Todas', ...categories];
                return ListView.separated(
                  itemCount: allCategories.length,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  separatorBuilder:
                      (context, index) =>
                          SizedBox(width: isLargeScreen ? 16 : 12),
                  itemBuilder: (context, index) {
                    final category = allCategories[index];
                    final isSelected = category == selectedCategory;

                    return CategoriesFilterChip(
                      category: category,
                      fontSize: fontSize,
                      isSelected: isSelected,
                      isLargeScreen: isLargeScreen,
                      categoryName: Utils.formatCategoryName(category),
                      onSelected: (selected) {
                        ref.read(selectedCategoryProvider.notifier).state =
                            category;
                        ref
                            .read(productsByCategoryProvider.notifier)
                            .loadProducts(category);
                      },
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          CategoryTitle(
            categories:
                selectedCategory == 'Todas'
                    ? 'Todas las categorías'
                    : Utils.formatCategoryName(selectedCategory ?? 'Todas'),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: productsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => ErrorIcon(error: error.toString()),
              data: (products) {
                if (products.isEmpty) {
                  return Empty();
                }
                return GridviewWidget(
                  itemCount: products.length,
                  products: products,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
