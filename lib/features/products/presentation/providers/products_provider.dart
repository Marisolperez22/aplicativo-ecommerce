import 'providers.dart';
import 'package:either_dart/either.dart';
import '../../../../core/errors/failure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'package:fake_store_get_request/models/product.dart';

final productsProvider =
    FutureProvider.autoDispose<Either<Failure, List<Product>>>((ref) {
      final useCase = ref.read(getProductsUseCaseProvider);
      return useCase();
    });

// Provider para el caso de uso
final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  return GetProductsUseCase(ref.read(productRepositoryProvider));
});
