import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fake_store_get_request/models/product.dart';

import 'product_notifier.dart';

final productsProvider = FutureProvider<List<Product>>((ref) {
  return ref.read(productRepositoryProvider).getProducts();
});

final selectedCategoryProvider = StateProvider<String?>((ref) => 'Todas');

final productsByCategoryProvider = StateNotifierProvider<ProductsByCategoryNotifier, AsyncValue<List<Product>>>((ref) {
  return ProductsByCategoryNotifier(ref);
});

// Providers separados
final categoriesProvider = FutureProvider<List<String>>((ref) {
  return ref.read(productRepositoryProvider).getCategories();
});

class ProductsByCategoryNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final Ref ref;
  
  ProductsByCategoryNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    state = const AsyncValue.loading();
    try {
      final products = await ref.read(productsProvider.future);
      state = AsyncValue.data(products);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> getProductsByCategory(String category) async {
    if (category == 'Todas') {
      return loadInitialData();
    }
    
    state = const AsyncValue.loading();
    try {
      final products = await ref.read(productRepositoryProvider).getProductsByCategory(category);
      state = AsyncValue.data(products);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}