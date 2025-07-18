import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';

class ProductCardImage extends StatelessWidget {
  final String productImage;
  final String productTitle;
  final String productPrice;
  final String productRating;

  const ProductCardImage({
    super.key,
    required this.productImage,
    required this.productTitle,
    required this.productPrice,
    required this.productRating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagen
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(productImage, fit: BoxFit.contain),
              ),
            ),
            // Texto
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                productTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AtomicSystemColorsFoundation.primaryColor.withAlpha(
                    150,
                  ),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ),
            // Fila con precio e icono
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  productPrice,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      productRating,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
