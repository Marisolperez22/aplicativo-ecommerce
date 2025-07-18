import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce/core/widgets/title.dart';
import 'package:ecommerce/core/widgets/home_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fake_store_get_request/models/product.dart';
import 'package:atomic_design_system/atomic_design_system.dart';

import '../../../../core/widgets/gridview_widget.dart';
import '../../../../core/widgets/screen_widget.dart';
import '../providers/product_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(productNotifierProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final Product featuredProduct =
        (homeState is ProductsLoaded) ? homeState.products[13] : Product(id: 0);

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Producto destacado
          HomeCard(
            productTitle:
                (homeState is ProductsLoaded)
                    ? featuredProduct.title ?? ''
                    : '',
            description: 'Ahora el 25% de descuento',
            buttonTitle: 'Comprar ahora',
            buttonOnPressed:
                () => context.pushNamed(
                  'product_detail',
                  pathParameters: {'id': featuredProduct.id.toString()},
                ),
            imageUrl: featuredProduct.image ?? '',
          ),

          // Título de sección
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextTitle(title: 'Los más vendidos'),
          ),

          // Lista de productos
          _buildBody(homeState, screenWidth),
        ],
      ),
    );
  }

  Widget _buildBody(ProductState state, double screenWidth) {
    if (state is ProductLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ProductError) {
      return Center(child: Text('Error: ${state.message}'));
    } else if (state is ProductsLoaded) {
      return _buildProductList(state.products, screenWidth);
    } else {
      return const Center(child: Text('Estado desconocido'));
    }
  }

  Widget _buildProductList(List<Product> products, double screenWidth) {
    return GridviewWidget(
      itemCount: 6,
      products: products,
    );
  }
}
