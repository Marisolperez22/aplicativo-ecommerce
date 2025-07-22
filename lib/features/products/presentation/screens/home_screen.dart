import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atomic_design_system/widgets/title.dart';
import 'package:atomic_design_system/widgets/home_card.dart';
import 'package:atomic_design_system/atomic_design_system.dart';

import '../../../../core/widgets/grid_view_widget.dart';
import '../providers/providers.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/widgets/screen_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsListProvider);

    return ScreenWidget(
      hasBottomNavigationBar: true,
      appBar: CustomAppBar(
        title: 'Fake Store',
        leftIcon: Icons.search,
        rightIcon: Icons.shopping_bag_outlined,
        rightIconOnPressed: () => context.pushNamed('cart'),
        leftIconOnPressed: () => context.pushNamed('search'),
        appBarColor: const Color.fromARGB(255, 235, 237, 237),
      ),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          if (error is Failure) {
            return Center(child: Text(error.message ?? ''));
          }
          return Center(child: Text('Error: $error'));
        },
        data: (either) {
          return either.fold(
            (failure) => Center(child: Text(failure.message ?? '')),
            (products) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Producto destacado
                HomeCard(
                  productTitle: products[13].title ?? '',
                  description: 'Ahora el 25% de descuento',
                  buttonTitle: 'Comprar ahora',
                  buttonOnPressed:
                      () => context.pushNamed(
                        'product_detail',
                        pathParameters: {'id': products[13].id.toString()},
                      ),
                  imageUrl: products[13].image ?? '',
                ),

                // Título de sección
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextTitle(title: 'Los más vendidos'),
                ),

                // Lista de productos
                GridviewWidget(itemCount: 6, products: products),
              ],
            ),
          );
        },
      ),
    );
  }
}
