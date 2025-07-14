import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fake_store_get_request/models/product.dart';

import '../../domain/repositories/product_repository.dart';
import '../../data/repositories/product_repository_impl.dart';
import 'product_notifier.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl();
});

final productsNotifierProvider =
    StateNotifierProvider<ProductNotifier, ProductState>((ref) {
      return ProductNotifier(ref.read(productRepositoryProvider));
    });


final catalogRepositoryProvider =
    StateNotifierProvider<CatalogNotifier, CatalogState>((ref) {
      return CatalogNotifier(ref.read(productRepositoryProvider));
    });

class CatalogNotifier extends StateNotifier<CatalogState> {
  final ProductRepository _productRepository;

  CatalogNotifier(this._productRepository) : super(CatalogInitial()) {
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await getCategories();
  }

  Future<void> getCategories() async {
    try {
      final categories = await _productRepository.getCategories();

      if (state is CatalogLoaded) {
        final currentProducts = (state as CatalogLoaded).products;
        state = CatalogLoaded(currentProducts, categories);
      } else {
        state = CatalogLoaded([], categories);
      }
    } catch (e) {
      if (state is CatalogLoaded) {
        state = CatalogError('Error loading categories: $e');
      }
    }
  }

  Future<void> getProductsByCategory(String category) async {
    // Preservar las categorías actuales
    final currentCategories =
        state is CatalogLoaded ? (state as CatalogLoaded).categories : [''];

    state = CatalogLoading();

    try {
      final products = await _productRepository.getProductsByCategory(category);
      state = CatalogLoaded(products, currentCategories); // Mantener categorías
    } catch (e) {
      if (state is CatalogLoaded) {
        state = CatalogLoaded([], currentCategories);
      }
      state = CatalogError(e.toString());
    }
  }
}

@immutable
abstract class CatalogState {}

class CatalogInitial extends CatalogState {}

class CatalogLoading extends CatalogState {}

class CatalogLoaded extends CatalogState {
  final List<Product> products;
  final List<String> categories;
  CatalogLoaded(this.products, [this.categories = const []]);
}

class CatalogError extends CatalogState {
  final String message;
  CatalogError(this.message);
}
