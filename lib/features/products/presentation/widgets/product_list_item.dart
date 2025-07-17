import 'package:atomic_design_system/organisms/product_card.dart';
import 'package:fake_store_get_request/models/product.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductListItem extends StatelessWidget {
  final Product product;

  const ProductListItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => context.pushNamed(
            'product_detail',
            pathParameters: {'id': product.id.toString()},
          ),
      child: ProductCard(
        addToTheCart: () {},
        productName: product.title ?? '',
        price: product.price.toString(),
        rating: '5',
        favoriteOnPressed: () {},
        imageUrl: product.image ?? '',
      ),
    );
  }
}
