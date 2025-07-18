import 'package:fake_store_get_request/models/product.dart';
import 'package:flutter/material.dart';

import '../../features/products/presentation/widgets/product_card.dart';
import '../utils/utils.dart';

class GridviewWidget extends StatelessWidget {
  final int? itemCount;
  final List<Product> products;

  const GridviewWidget({super.key, this.itemCount, required this.products});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Utils.calculateCrossAxisCount(screenWidth),
        crossAxisSpacing:
            screenWidth > 1200
                ? 12
                : screenWidth > 600
                ? 10
                : 8,
        mainAxisSpacing:
            screenWidth > 1200
                ? 12
                : screenWidth > 600
                ? 10
                : 8,
        childAspectRatio: Utils.calculateChildAspectRatio(screenWidth),
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return CardProduct(product: products[index]);
      },
    );
  }
}
