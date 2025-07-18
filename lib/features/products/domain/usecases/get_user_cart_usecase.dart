import 'package:either_dart/either.dart';
import 'package:fake_store_get_request/models/cart.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/product_repository.dart';

class GetUserCartUsecase {
  final ProductRepository repository;

  GetUserCartUsecase(this.repository);

  Future<Either<Failure, List<Cart>>> call(int idUser) async {
    return await repository.getUserCart(idUser);
  }
}
