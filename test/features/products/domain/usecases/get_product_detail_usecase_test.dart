import 'package:ecommerce/core/errors/failure.dart';
import 'package:ecommerce/features/products/domain/repositories/product_repository.dart';
import 'package:ecommerce/features/products/domain/usecases/get_product_detail_usecase.dart';
import 'package:fake_store_get_request/data/models/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:either_dart/either.dart';

import 'get_categories_usecase_test.mocks.dart';


@GenerateMocks([ProductRepository])
void main() {
  provideDummy<Either<Failure, Product>>(Right(
    Product(id: 0, title: '', price: 0.0, description: '', category: '', image: ''),
  ));

  late GetProductDetailUseCase useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetProductDetailUseCase(mockRepository);
  });

  group('GetProductDetailUseCase', () {
    const tProductId = 1;

    test('Debería retornar Product cuando repository responde con éxito', () async {
      // arrange
      final product = Product(
        id: tProductId,
        title: 'Test Product',
        price: 99.99,
        description: 'Test description',
        category: 'electronics',
        image: 'https://example.com/product.png',
      );

      when(mockRepository.getProductDetail(tProductId))
          .thenAnswer((_) async => Right(product));

      // act
      final result = await useCase(tProductId);

      // assert
      expect(result.isRight, true);
      expect(result.right, product);
      verify(mockRepository.getProductDetail(tProductId)).called(1);
    });

    test('Debería retornar Failure cuando repository lanza un error', () async {
      // arrange
      final failure = ServerFailure(404);

      when(mockRepository.getProductDetail(tProductId))
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase(tProductId);

      // assert
      expect(result.isLeft, true);
      expect(result.left, failure);
      verify(mockRepository.getProductDetail(tProductId)).called(1);
    });
  });
}
