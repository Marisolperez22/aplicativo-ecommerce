import 'package:ecommerce/core/errors/failure.dart';
import 'package:ecommerce/features/products/domain/repositories/product_repository.dart';
import 'package:ecommerce/features/products/domain/usecases/get_products_by_category_usecase.dart';
import 'package:fake_store_get_request/data/models/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:either_dart/either.dart';

import 'get_categories_usecase_test.mocks.dart';


@GenerateMocks([ProductRepository])
void main() {
  // 👇 Dummy necesario para evitar MissingDummyValueError
  provideDummy<Either<Failure, List<Product>>>(Right([]));

  late GetProductsByCategoryUsecase useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetProductsByCategoryUsecase(mockRepository);
  });

  group('GetProductsByCategoryUsecase', () {
    const tCategory = 'electronics';
    final tProducts = [
      Product(
        id: 1,
        title: 'Test Product',
        price: 49.99,
        description: 'desc',
        category: 'electronics',
        image: 'https://example.com/product.png',
      ),
    ];

    test('Debería retornar productos cuando category = "Todas"', () async {
      // arrange
      when(mockRepository.getProducts())
          .thenAnswer((_) async => Right(tProducts));

      // act
      final result = await useCase('Todas');

      // assert
      expect(result.isRight, true);
      expect(result.right, tProducts);
      verify(mockRepository.getProducts()).called(1);
      verifyNever(mockRepository.getProductsByCategory(any));
    });

    test('Debería retornar productos cuando category ≠ "Todas"', () async {
      // arrange
      when(mockRepository.getProductsByCategory(tCategory))
          .thenAnswer((_) async => Right(tProducts));

      // act
      final result = await useCase(tCategory);

      // assert
      expect(result.isRight, true);
      expect(result.right, tProducts);
      verify(mockRepository.getProductsByCategory(tCategory)).called(1);
      verifyNever(mockRepository.getProducts());
    });

    test('Debería retornar Failure cuando falla getProducts() con category = "Todas"', () async {
      // arrange
      final failure = ServerFailure(500);
      when(mockRepository.getProducts())
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase('Todas');

      // assert
      expect(result.isLeft, true);
      expect(result.left, failure);
      verify(mockRepository.getProducts()).called(1);
    });

    test('Debería retornar Failure cuando falla getProductsByCategory()', () async {
      // arrange
      final failure = NetworkFailure();
      when(mockRepository.getProductsByCategory(tCategory))
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase(tCategory);

      // assert
      expect(result.isLeft, true);
      expect(result.left, failure);
      verify(mockRepository.getProductsByCategory(tCategory)).called(1);
    });
  });
}
