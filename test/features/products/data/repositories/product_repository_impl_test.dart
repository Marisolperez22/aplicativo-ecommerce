import 'package:ecommerce/core/errors/failure.dart';
import 'package:ecommerce/features/products/data/datasources/products_datasource.dart';
import 'package:ecommerce/features/products/data/repositories/product_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fake_store_get_request/data/models/product.dart';
import 'package:fake_store_get_request/data/models/cart.dart';

import 'product_repository_impl_test.mocks.dart';


@GenerateMocks([IProductsDatasource])
void main() {
  late MockIProductsDatasource mockDatasource;
  late ProductRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockIProductsDatasource();
    repository = ProductRepositoryImpl(productsDatasources: mockDatasource);
  });

  group('ProductRepositoryImpl', () {
    test('getProducts debería retornar Right(List<Product>) cuando datasource responde OK', () async {
      final productList = [Product(id: 1, title: 'Test', price: 10.0)];

      when(mockDatasource.getProducts()).thenAnswer((_) async => productList);

      final result = await repository.getProducts();

      expect(result.isRight, true);
      expect(result.right, productList);
      verify(mockDatasource.getProducts()).called(1);
    });

    test('getProducts debería retornar Left(Failure) cuando datasource lanza excepción', () async {
      when(mockDatasource.getProducts()).thenThrow(Exception('Error en API'));

      final result = await repository.getProducts();

      expect(result.isLeft, true);
      expect(result.left, isA<Failure>());
      verify(mockDatasource.getProducts()).called(1);
    });

    test('getProductDetail debería retornar Right(Product)', () async {
      final product = Product(id: 2, title: 'Laptop', price: 1000.0);

      when(mockDatasource.getProductDetail(2)).thenAnswer((_) async => product);

      final result = await repository.getProductDetail(2);

      expect(result.isRight, true);
      expect(result.right, product);
      verify(mockDatasource.getProductDetail(2)).called(1);
    });

    test('getCategories debería retornar Right(List<String>)', () async {
      final categories = ['electronics', 'jewelery'];

      when(mockDatasource.getCategories()).thenAnswer((_) async => categories);

      final result = await repository.getCategories();

      expect(result.isRight, true);
      expect(result.right, categories);
      verify(mockDatasource.getCategories()).called(1);
    });

    test('getProductsByCategory debería retornar Right(List<Product>)', () async {
      final products = [Product(id: 3, title: 'Phone', price: 500.0)];

      when(mockDatasource.getProductsByCategory('electronics'))
          .thenAnswer((_) async => products);

      final result = await repository.getProductsByCategory('electronics');

      expect(result.isRight, true);
      expect(result.right, products);
      verify(mockDatasource.getProductsByCategory('electronics')).called(1);
    });

    test('getUserCart debería retornar Right(Cart)', () async {
      final cart = Cart(id: 1, userId: 1, date: '2025-09-22', products: []);

      when(mockDatasource.getUserCart(1)).thenAnswer((_) async => cart);

      final result = await repository.getUserCart(1);

      expect(result.isRight, true);
      expect(result.right, cart);
      verify(mockDatasource.getUserCart(1)).called(1);
    });
  });
}
