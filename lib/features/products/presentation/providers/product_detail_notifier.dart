// import 'package:ecommerce/features/products/domain/repositories/product_repository.dart';
// import 'package:ecommerce/features/products/presentation/providers/product_notifier.dart';
// import 'package:fake_store_get_request/models/product.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// // En tu archivo de providers
// final productDetailNotifierProvider = StateNotifierProvider.family<
//   ProductDetailNotifier, 
//   ProductDetailState, 
//   String
// >((ref, productId) {
//   return ProductDetailNotifier(
//     ref.read(productRepositoryProvider),
//     productId,
//   );
// });

// class ProductDetailNotifier extends StateNotifier<ProductDetailState> {
//   final ProductRepository _repository;
//   final String productId;

//   ProductDetailNotifier(this._repository, this.productId) 
//       : super(ProductDetailLoading()) {
//     loadProduct();
//   }

//   Future<void> loadProduct() async {
//     state = ProductDetailLoading();
//     try {
//       final product = await _repository.getProductDetail(int.parse(productId));
//       state = ProductDetailLoaded(product);
//     } catch (e) {
//       state = ProductDetailError(e.toString());
//     }
//   }
// }

// // Estados para el detalle del producto
// abstract class ProductDetailState {}

// class ProductDetailLoading extends ProductDetailState {}

// class ProductDetailLoaded extends ProductDetailState {
//   final Product product;
//   ProductDetailLoaded(this.product);
// }

// class ProductDetailError extends ProductDetailState {
//   final String message;
//   ProductDetailError(this.message);
// }