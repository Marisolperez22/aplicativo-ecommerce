import 'package:ecommerce/features/products/data/datasources/products_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fake_store_get_request/data/models/cart.dart';
import 'package:fake_store_get_request/data/models/product.dart';

import 'products_datasource_test.mocks.dart';

void main() {
  late MockFakeStoreService mockService;
  late ProductsDatasource datasource;

  setUp(() {
    mockService = MockFakeStoreService();
    datasource = ProductsDatasource(remoteDataSource: mockService);
  });

  group('ProductsDatasource', () {
    test('getProducts debería retornar lista de productos', () async {
      // Arrange
      final products = [Product(id: 1, title: 'Test', price: 10.0)];
      when(mockService.getProducts()).thenAnswer((_) async => products);

      // Act
      final result = await datasource.getProducts();

      // Assert
      expect(result, products);
      verify(mockService.getProducts()).called(1);
    });

    test('getProductDetail debería retornar un producto', () async {
      // Arrange
      final product = Product(id: 1, title: 'Test', price: 10.0);
      when(mockService.getProductDetail(1)).thenAnswer((_) async => product);

      // Act
      final result = await datasource.getProductDetail(1);

      // Assert
      expect(result, product);
      verify(mockService.getProductDetail(1)).called(1);
    });

    test('getCategories debería retornar lista de categorías', () async {
      // Arrange
      final categories = ['electronics', 'clothing'];
      when(mockService.getCategories()).thenAnswer((_) async => categories);

      // Act
      final result = await datasource.getCategories();

      // Assert
      expect(result, categories);
      verify(mockService.getCategories()).called(1);
    });

    test('getProductsByCategory debería retornar lista de productos', () async {
      // Arrange
      final products = [Product(id: 2, title: 'Shirt', price: 20.0)];
      when(
        mockService.getProductsByCategory('clothing'),
      ).thenAnswer((_) async => products);

      // Act
      final result = await datasource.getProductsByCategory('clothing');

      // Assert
      expect(result, products);
      verify(mockService.getProductsByCategory('clothing')).called(1);
    });

    test('getUserCart debería retornar un carrito', () async {
      // Arrange
      final cart = Cart(id: 1, userId: 1, date: '2025-09-22', products: []);
      when(mockService.getUserCart(1)).thenAnswer((_) async => cart);

      // Act
      final result = await datasource.getUserCart(1);

      // Assert
      expect(result, cart);
      verify(mockService.getUserCart(1)).called(1);
    });
  });
}
