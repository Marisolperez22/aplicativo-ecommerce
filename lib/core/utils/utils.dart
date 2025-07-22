import 'package:either_dart/either.dart';
import 'package:ecommerce/core/errors/failure.dart';

import '../../features/products/data/models/cart_item.dart';
import '../errors/exceptions.dart';

class Utils {
  static String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese un valor';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese su correo';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Ingrese un correo válido';
    }
    return null;
  }

  static int calculateCrossAxisCount(double screenWidth) {
    if (screenWidth > 1200) return 6;
    if (screenWidth > 900) return 5;
    if (screenWidth > 600) return 3;
    return 2;
  }

  static double calculateChildAspectRatio(double screenWidth) {
    if (screenWidth > 1200) return 0.65;
    if (screenWidth > 900) return 0.7;
    return 0.75;
  }

  static Either<Failure, T> handleException<T>(dynamic e) {
    if (e is BaseClientException) {
      if (e.type == 'TimeoutException') {
        return const Left(TimeOutFailure());
      }
      if (e.type == 'UnAuthorization') {
        return const Left(AuthFailure());
      }
      if (e.type == 'BadRequest') {
        return Left(
          BadRequest(
            title: e.title,
            message: e.message,
            codeError: e.codeError,
          ),
        );
      }
      return const Left(AnotherFailure());
    } else {
      return const Left(AnotherFailure());
    }
  }

  static  double calculateTotal(List<CartItem> items) {
    return items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  static String formatCategoryName(String category) {
    if (category == 'Todas') return category;

    return category
        .replaceAll("'s", "'s ")
        .split(' ')
        .map(
          (word) =>
              word.isNotEmpty
                  ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                  : '',
        )
        .join(' ');
  }

 static double calculateAspectRatio(double screenWidth) {
    if (screenWidth > 1800) return 0.65;
    if (screenWidth > 1400) return 0.7;
    if (screenWidth > 1100) return 0.75;
    if (screenWidth > 800) return 0.8;
    return 0.85;
  }
}
