import 'package:fake_store_get_request/data/models/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce/core/errors/failure.dart';
import 'package:ecommerce/core/errors/exceptions.dart';
import 'package:ecommerce/core/utils/utils.dart';

import 'package:ecommerce/features/products/data/models/cart_item.dart';

void main() {
  group('Utils', () {
    test('validateInput retorna error si null o vacío', () {
      expect(Utils.validateInput(null), 'Por favor ingrese un valor');
      expect(Utils.validateInput(''), 'Por favor ingrese un valor');
    });

    test('validateInput retorna null si válido', () {
      expect(Utils.validateInput('algo'), null);
    });

    test('validateEmail cubre todos los casos', () {
      expect(Utils.validateEmail(null), 'Por favor ingrese su correo');
      expect(Utils.validateEmail(''), 'Por favor ingrese su correo');
      expect(Utils.validateEmail('correo@invalido'), 'Ingrese un correo válido');
      expect(Utils.validateEmail('test@mail.com'), null);
    });

    test('calculateCrossAxisCount cubre todos los rangos', () {
      expect(Utils.calculateCrossAxisCount(1300), 6);
      expect(Utils.calculateCrossAxisCount(1000), 5);
      expect(Utils.calculateCrossAxisCount(700), 3);
      expect(Utils.calculateCrossAxisCount(400), 2);
    });

    test('calculateChildAspectRatio cubre todos los rangos', () {
      expect(Utils.calculateChildAspectRatio(1300), 0.65);
      expect(Utils.calculateChildAspectRatio(1000), 0.7);
      expect(Utils.calculateChildAspectRatio(800), 0.75);
    });

    test('handleException cubre todos los tipos', () {
      final timeoutEx = BaseClientException(url: 'url', type: 'TimeoutException');
      final authEx = BaseClientException(url: 'url', type: 'UnAuthorization');
      final badReqEx = BaseClientException(url: 'url', type: 'BadRequest', title: 'title', message: 'msg', codeError: 400);
      final otherEx = BaseClientException(url: 'url', type: 'Other');

      expect(Utils.handleException(timeoutEx).left, isA<TimeOutFailure>());
      expect(Utils.handleException(authEx).left, isA<AuthFailure>());
      expect(Utils.handleException(badReqEx).left, isA<BadRequest>());
      expect(Utils.handleException(otherEx).left, isA<AnotherFailure>());
      expect(Utils.handleException(Exception()).left, isA<AnotherFailure>());
    });

    test('calculateTotal funciona', () {
      final items = [
        CartItem(product: Product(id: 1, title: 'p1', price: 10), quantity: 2),
        CartItem(product: Product(id: 2, title: 'p2', price: 5), quantity: 1),
      ];
      expect(Utils.calculateTotal(items), 25);
      expect(Utils.calculateTotal([]), 0);
    });

    test('formatCategoryName cubre casos', () {
      expect(Utils.formatCategoryName('Todas'), 'Todas');
      expect(Utils.formatCategoryName("men's clothing"), "Men's  Clothing");
      expect(Utils.formatCategoryName('ELECTRONICS'), 'Electronics');
    });

    test('calculateAspectRatio cubre todos los rangos', () {
      expect(Utils.calculateAspectRatio(1900), 0.65);
      expect(Utils.calculateAspectRatio(1500), 0.7);
      expect(Utils.calculateAspectRatio(1200), 0.75);
      expect(Utils.calculateAspectRatio(900), 0.8);
      expect(Utils.calculateAspectRatio(600), 0.85);
    });
  });
}
