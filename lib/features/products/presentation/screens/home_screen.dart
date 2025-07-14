import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:ecommerce/features/products/presentation/providers/product_notifier.dart';
import 'package:fake_store_get_request/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_notifier.dart';
import '../widgets/product_list_item.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(productNotifierProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Fake Store',
        rightIconOnPressed: () {
          ref.read(authNotifierProvider.notifier).logout();
          context.pushNamed('login');
        },
        leftIcon: Icons.search,
        rightIcon: Icons.logout_rounded,
        leftIconOnPressed: () => context.pushNamed('search'),
      ),
      body: Column(
        children: [
          TextButton(onPressed: (){
            context.pushNamed('catalog');
          }, child: Text('Ver más')),
          
          Expanded(child: _buildBody(homeState)),
        ],
      ),
    );
  }



  Widget _buildBody(ProductState state) {
    if (state is ProductInitial) {
      return const Center(
        child: Text('Presiona refresh para cargar productos'),
      );
    } else if (state is ProductLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ProductError) {
      return Center(child: Text('Error: ${state.message}'));
    } else if (state is ProductsLoaded) {
      return _buildProductList(state.products);
    } else {
      return const Center(child: Text('Estado desconocido'));
    }
  }

  Widget _buildProductList(List<Product> products) {
    return ListView.builder(
      padding: EdgeInsets.all(20.0),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductListItem(product: product);
      },
    );
  }


}
