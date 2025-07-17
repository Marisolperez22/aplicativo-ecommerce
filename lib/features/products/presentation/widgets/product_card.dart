import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:fake_store_get_request/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


class CardProduct extends ConsumerWidget {
  final Product product;

  const CardProduct({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap:
          () => context.pushNamed(
            'product_detail',
            pathParameters: {'id': product.id.toString()},
          ),
      child: Card(
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
                  child: Image.network(
                    product.image ?? '',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Texto
              Padding(
                
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  product.title ?? '',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AtomicSystemColorsFoundation.primaryColor.withAlpha(150)),
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
                    '\$${product.price.toString()}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        (product.rating?.rate ?? 0).toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // InkWell(
              //   onTap: () {
              //     ref.read(cartNotifierProvider.notifier).addProduct(product);
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       SnackBar(
              //         content: Text('${product.title} añadido al carrito'),
              //       ),
              //     );
              //   },

              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: Theme.of(context).primaryColor,
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //     height: 20,
              //     child: Center(
              //       child: Text(
              //         'Agregar',
              //         style: TextStyle(color: Colors.white),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
