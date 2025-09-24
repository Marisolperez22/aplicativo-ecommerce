import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce/core/errors/failure.dart';

void main() {
  group('Failure', () {
    test('ServerFailure guarda el statusCode', () {
      const failure = ServerFailure(404);
      expect(failure.statusCode, 404);
      expect(failure.title, null);
      expect(failure.message, null);
    });

    test('NetworkFailure se instancia correctamente', () {
      const failure = NetworkFailure();
      expect(failure, isA<Failure>());
    });

    test('TimeOutFailure se instancia correctamente', () {
      const failure = TimeOutFailure();
      expect(failure, isA<Failure>());
    });

    test('AnotherFailure guarda mensaje y codeError', () {
      const failure = AnotherFailure(message: 'Error desconocido', codeError: 500);
      expect(failure.message, 'Error desconocido');
      expect(failure.codeError, 500);
    });

    test('DataNull se instancia correctamente', () {
      const failure = DataNull();
      expect(failure, isA<Failure>());
    });

    test('AuthFailure se instancia correctamente', () {
      const failure = AuthFailure();
      expect(failure, isA<Failure>());
    });

    test('BadRequest guarda title, message y codeError', () {
      const failure = BadRequest(
        title: 'Solicitud incorrecta',
        message: 'Faltan datos',
        codeError: 400,
      );
      expect(failure.title, 'Solicitud incorrecta');
      expect(failure.message, 'Faltan datos');
      expect(failure.codeError, 400);
    });
  });
}
