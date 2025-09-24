import 'package:ecommerce/features/products/presentation/providers/products_by_category.dart';
import 'package:fake_store_get_request/data/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ecommerce/features/products/domain/usecases/get_products_by_category_usecase.dart';
import 'package:ecommerce/core/errors/failure.dart';

import 'products_by_category_test.mocks.dart';

@GenerateMocks([GetProductsByCategoryUsecase])
void main() {
  late MockGetProductsByCategoryUsecase mockUsecase;
  late ProviderContainer container;

  setUpAll(() {
    // Solución al MissingDummyValueError
    provideDummy<Either<Failure, List<Product>>>(
      const Left(NetworkFailure()),
    );
  });

  setUp(() {
    mockUsecase = MockGetProductsByCategoryUsecase();
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  test('Debe iniciar con AsyncLoading', () {
    when(mockUsecase('Todas'))
        .thenAnswer((_) async => Right([Product(id: 1, description: 'Test', price: 10.0)]));

    final notifier = ProductsByCategoryNotifier(mockUsecase);

    expect(notifier.debugState, const AsyncValue<List<Product>>.loading());
  });

  test('Debe devolver productos en caso de éxito', () async {
    final products = [Product(id: 1, description: 'Test', price: 10.0)];

    when(mockUsecase('Todas')).thenAnswer((_) async => Right(products));

    final notifier = ProductsByCategoryNotifier(mockUsecase);
    await notifier.loadProducts('Todas');

    expect(notifier.debugState.value, products);
  });

  test('Debe devolver fallo en caso de error', () async {
    const failure = ServerFailure(500);

    when(mockUsecase('Todas')).thenAnswer((_) async => const Left(failure));

    final notifier = ProductsByCategoryNotifier(mockUsecase);
    await notifier.loadProducts('Todas');

    expect(notifier.debugState.hasError, true);
    expect(notifier.debugState.error, failure);
  });
}
