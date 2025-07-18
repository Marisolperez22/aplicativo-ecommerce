import 'package:fake_store_get_request/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_products_by_category_usecase.dart';

class ProductsByCategoryNotifier
    extends StateNotifier<AsyncValue<List<Product>>> {
  final GetProductsByCategoryUsecase _getProductsByCategory;

  ProductsByCategoryNotifier(this._getProductsByCategory)
    : super(const AsyncValue.loading()) {
    loadProducts('Todas');
  }

  Future<void> loadProducts(String category) async {
    state = const AsyncValue.loading();
    final result = await _getProductsByCategory(category);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (products) => AsyncValue.data(products),
    );
  }
}

