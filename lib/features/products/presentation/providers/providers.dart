import 'products_by_category.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fake_store_get_request/models/product.dart';

import '../../../../core/errors/failure.dart';
import '../../data/datasources/products_datasource.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/get_user_cart_usecase.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/usecases/get_product_detail_usecase.dart';
import '../../domain/usecases/get_products_by_category_usecase.dart';

// Datasources
final productsDatasourceProvider = Provider<IProductsDatasource>((ref) {
  return ProductsDatasource();
});

// Repositories
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(
    productsDatasources: ref.read(productsDatasourceProvider),
  );
});

// Use Cases
final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  return GetProductsUseCase(ref.read(productRepositoryProvider));
});

final getCategoriesUseCaseProvider = Provider<GetCategoriesUseCase>((ref) {
  return GetCategoriesUseCase(ref.read(productRepositoryProvider));
});

final getProductDetailUseCaseProvider = Provider<GetProductDetailUseCase>((
  ref,
) {
  return GetProductDetailUseCase(ref.read(productRepositoryProvider));
});

final getProductsByCategoryUsecaseProvider =
    Provider<GetProductsByCategoryUsecase>((ref) {
      return GetProductsByCategoryUsecase(ref.read(productRepositoryProvider));
    });

final getUserCartUsecaseProvider = Provider<GetUserCartUsecase>((ref) {
  return GetUserCartUsecase(ref.read(productRepositoryProvider));
});

final productsListProvider =
    FutureProvider.autoDispose<Either<Failure, List<Product>>>((ref) async {
      final getProducts = ref.read(getProductsUseCaseProvider);
      return await getProducts();
    });

final productDetailProvider = FutureProvider.autoDispose
    .family<Either<Failure, Product>, int>((ref, productId) async {
      final getProductDetail = ref.read(getProductDetailUseCaseProvider);
      return await getProductDetail(productId);
    });

final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final getCategories = ref.read(getCategoriesUseCaseProvider);
  final result = await getCategories();
  return result.fold((failure) => throw failure, (categories) => categories);
});

final productsBycategoryProvider = FutureProvider.autoDispose
    .family<Either<Failure, List<Product>>, String>((ref, category) async {
      final getProductsByCategory = ref.read(
        getProductsByCategoryUsecaseProvider,
      );
      return await getProductsByCategory(category);
    });

final selectedCategoryProvider = StateProvider<String?>((ref) => 'Todas');

final productsByCategoryProvider = StateNotifierProvider<
  ProductsByCategoryNotifier,
  AsyncValue<List<Product>>
>((ref) {
  final useCase = ref.read(getProductsByCategoryUsecaseProvider);
  return ProductsByCategoryNotifier(useCase);
});

final searchQueryProvider = StateProvider<String>((ref) => '');
