import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fake_store_get_request/models/product.dart';

import 'product_card.dart';

class ProductListItem extends ConsumerWidget {
  final Product product;

  const ProductListItem({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CardProduct(product: product);
  }
}