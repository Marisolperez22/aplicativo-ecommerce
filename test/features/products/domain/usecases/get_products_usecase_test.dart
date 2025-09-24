import 'package:either_dart/either.dart';
import 'package:ecommerce/core/errors/failure.dart';
import 'package:ecommerce/features/products/domain/repositories/product_repository.dart';
import 'package:ecommerce/features/products/domain/usecases/get_products_usecase.dart';
import 'package:fake_store_get_request/data/models/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_categories_usecase_test.mocks.dart';



@GenerateMocks([ProductRepository])
void main() {
  // 👇 Dummy para evitar MissingDummyValueError
  provideDummy<Either<Failure, List<Product>>>(Right([]));

  late GetProductsUseCase useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetProductsUseCase(mockRepository);
  });

  group('GetProductsUseCase', () {
    final tProducts = [
      Product(
        id: 1,
        title: 'Test Product',
        price: 19.99,
        description: 'A test product',
        category: 'electronics',
        image: 'https://example.com/product.png',
      ),
    ];

    test('Debe retornar lista de productos cuando repository responde con éxito', () async {
      // arrange
      when(mockRepository.getProducts())
          .thenAnswer((_) async => Right(tProducts));

      // act
      final result = await useCase();

      // assert
      expect(result.isRight, true);
      expect(result.right, tProducts);
      verify(mockRepository.getProducts()).called(1);
    });

    test('Debe retornar Failure cuando repository retorna error', () async {
      // arrange
      final failure = ServerFailure(500);
      when(mockRepository.getProducts())
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase();

      // assert
      expect(result.isLeft, true);
      expect(result.left, failure);
      verify(mockRepository.getProducts()).called(1);
    });
  });
}
