import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fake_store_get_request/models/product.dart';

import '../../domain/repositories/product_repository.dart';
import 'product_notifier.dart';

// Providers separados
final categoriesProvider = FutureProvider<List<String>>((ref) {
  return ref.read(productRepositoryProvider).getCategories();
});

final productsByCategoryProvider = StateNotifierProvider<ProductsNotifier, AsyncValue<List<Product>>>((ref) {
  return ProductsNotifier(ref.read(productRepositoryProvider));
});

class ProductsNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final ProductRepository _repository;
  
  ProductsNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> getProductsByCategory(String category) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getProductsByCategory(category));
  }
}