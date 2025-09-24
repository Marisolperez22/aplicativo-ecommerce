import 'package:either_dart/either.dart';
import 'package:ecommerce/core/errors/failure.dart';
import 'package:ecommerce/features/products/domain/repositories/product_repository.dart';
import 'package:ecommerce/features/products/domain/usecases/get_user_cart_usecase.dart';
import 'package:fake_store_get_request/data/models/cart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_categories_usecase_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  provideDummy<Either<Failure, Cart>>(Right(
    Cart(id: 0, userId: 0, date: '', products: []),
  ));

  late GetUserCartUsecase useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetUserCartUsecase(mockRepository);
  });

  group('GetUserCartUsecase', () {
    const tUserId = 123;

    final tCart = Cart(
      id: 1,
      userId: tUserId,
      date: '2025-09-22',
      products: [
        CartProducts(
          productId: 1,
          quantity: 2,
          
        ),
      ],
    );

    test('Debe retornar Cart cuando repository responde con éxito', () async {
      // arrange
      when(mockRepository.getUserCart(tUserId))
          .thenAnswer((_) async => Right(tCart));

      // act
      final result = await useCase(tUserId);

      // assert
      expect(result.isRight, true);
      expect(result.right, tCart);
      verify(mockRepository.getUserCart(tUserId)).called(1);
    });

    test('Debe retornar Failure cuando repository retorna error', () async {
      // arrange
      final failure = NetworkFailure();
      when(mockRepository.getUserCart(tUserId))
          .thenAnswer((_) async => Left(failure));

      // act
      final result = await useCase(tUserId);

      // assert
      expect(result.isLeft, true);
      expect(result.left, failure);
      verify(mockRepository.getUserCart(tUserId)).called(1);
    });
  });
}
