import 'package:mocktail/mocktail.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce/core/errors/exceptions.dart';
import 'package:fake_store_get_request/models/product.dart';
import 'package:ecommerce/features/products/data/datasources/products_datasource.dart';
import 'package:ecommerce/features/products/data/repositories/product_repository_impl.dart';

class MockProductsDatasource extends Mock implements ProductsDatasource {}

void main() {
  late MockProductsDatasource dataSource;
  late ProductRepositoryImpl repository;

  setUp(() {
    dataSource = MockProductsDatasource();
    repository = ProductRepositoryImpl(productsDatasources: dataSource);
  });

  /// Datos de prueba
  final tProducts = [
    Product(
      id: 1,
      title: 'Product 1',
      price: 10.0,
      image: 'image1.jpg',
      category: 'Category 1',
      description: 'Description 1',
      rating: Rating(rate: 4.5, count: 100),
    ),
    Product(
      id: 2,
      title: 'Product 2',
      price: 20.0,
      image: 'image2.jpg',
      category: 'Category 2',
      description: 'Description 2',
      rating: Rating(rate: 3.5, count: 50),
    ),
  ];

  final tProduct = tProducts[0];
  final tCategories = ['electronics', 'jewelery'];

  group('lista de productos', () {
    test('Devuelva la lista de productos', () async {
      /// Arrange
      when(() => dataSource.getProducts()).thenAnswer((_) async => tProducts);

      /// Act
      final result = await repository.getProducts();

      /// Assert
      expect(result, Right(tProducts));
      verify(() => dataSource.getProducts()).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test('Devuelve error cuando la petición falla', () async {
      /// Arrange
      when(
        () => dataSource.getProducts(),
      ).thenThrow(BaseClientException(url: '', type: 'BadRequest'));

      /// Act
      final result = await repository.getProducts();

      /// Assert
      expect(result.isLeft, true);
      verify(() => dataSource.getProducts()).called(1);
    });
  });

  group('obtener detalle del producto', () {
    test('obtener detalle de un producto', () async {
      /// Arrange
      when(
        () => dataSource.getProductDetail(1),
      ).thenAnswer((_) async => tProduct);

      /// Act
      final result = await repository.getProductDetail(1);

      expect(result, Right(tProduct));

      /// Assert
    });

    test('cuando la respuesta devuelve error', () async {
      /// Arrange
      when(
        () => dataSource.getProductDetail(1),
      ).thenThrow(BaseClientException(url: '', type: 'BadRequest'));

      /// Act
      final result = await repository.getProductDetail(1);

      /// Assert
      expect(result.isLeft, true);
    });
  });

  group('Obtener categorias de los productos', () {
    test('obtener lista de categorias', () async {
      /// Arrange
      when(
        () => dataSource.getCategories(),
      ).thenAnswer((_) async => tCategories);

      /// Act
      final result = await repository.getCategories();

      /// Arrange
      expect(result, Right(tCategories));
    });
  });
}
