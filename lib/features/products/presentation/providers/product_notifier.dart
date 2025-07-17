import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fake_store_get_request/models/product.dart';

import '../../domain/repositories/product_repository.dart';
import '../../data/repositories/product_repository_impl.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl();
});

final searchProvider = StateProvider<bool>((ref) => false);
final searchQueryProvider = StateProvider<String>((ref) => '');

final productNotifierProvider =
    StateNotifierProvider<ProductNotifier, ProductState>((ref) {
      return ProductNotifier(ref.read(productRepositoryProvider));
    });

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductRepository _productRepository;

  ProductNotifier(this._productRepository) : super(ProductInitial()) {
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await getProducts();
    await getCategories();
  }

  Future<void> getProducts() async {
    state = ProductLoading();
    try {
      final List<Product> products = await _productRepository.getProducts();

      state = ProductsLoaded(products);
    } catch (e) {
      state = ProductError(e.toString());
    }
  }

  

  Future<void> getCategories() async {
    try {
      final categories = await _productRepository.getCategories();

      if (state is ProductsLoaded) {
        final currentProducts = (state as ProductsLoaded).products;
        state = ProductsLoaded(currentProducts, categories);
      } else {
        state = ProductsLoaded([], categories);
      }
    } catch (e) {
      if (state is ProductsLoaded) {
        state = ProductError('Error loading categories: $e');
      }
    }
  }

   Future<void> getProductsByCategory(String category) async {
    state = ProductLoading();
    try {
      final products = await _productRepository.getProductsByCategory(category);
      final currentState = state;
      final categories = currentState is ProductsLoaded 
          ? currentState.categories
          : [''];
      state = ProductsLoaded(products, categories);
    } catch (e) {
      state = ProductError(e.toString());
    }
  }


}

@immutable
abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<Product> products;
  final List<String> categories;
  ProductsLoaded(this.products, [this.categories = const []]);
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}
