import 'package:ecommerce/features/products/domain/repositories/product_repository.dart';
import 'package:ecommerce/features/products/domain/usecases/get_categories_usecase.dart';
import 'package:ecommerce/core/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:either_dart/either.dart';
import 'package:mockito/mockito.dart';

import 'get_categories_usecase_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  provideDummy<Either<Failure, List<String>>>(Right([]));

  late GetCategoriesUseCase useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetCategoriesUseCase(mockRepository);
  });

  group('GetCategoriesUseCase', () {
    test(
      'Debería retornar lista de categorías cuando repository responde con éxito',
      () async {
        // arrange
        final categories = ["electronics", "jewelery", "men's clothing"];
        when(
          mockRepository.getCategories(),
        ).thenAnswer((_) async => Right(categories));

        // act
        final result = await useCase();

        // assert
        expect(result.isRight, true);
        expect(result.right, categories);
        verify(mockRepository.getCategories()).called(1);
      },
    );

    test('Debería retornar Failure cuando repository lanza un error', () async {
      // arrange
      final failure = ServerFailure(404);
      when(
        mockRepository.getCategories(),
      ).thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase();

      // assert
      expect(result.isLeft, true);
      expect(result.left, failure);
      verify(mockRepository.getCategories()).called(1);
    });
  });
}
