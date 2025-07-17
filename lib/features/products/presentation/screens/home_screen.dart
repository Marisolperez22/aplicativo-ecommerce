import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fake_store_get_request/models/product.dart';
import 'package:atomic_design_system/atomic_design_system.dart';

import '../widgets/product_list_item.dart';
import '../providers/product_notifier.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(productNotifierProvider);

    final Product productDestacado =
        (homeState is ProductsLoaded) ? homeState.products[13] : Product(id: 0);

    return Scaffold(
      appBar: CustomAppBar(
        appBarColor: const Color.fromARGB(255, 235, 237, 237),
        title: 'Fake Store',
        rightIconOnPressed: () {
          ref.read(authNotifierProvider.notifier).logout();
          context.pushNamed('login');
        },
        leftIcon: Icons.search,
        rightIcon: Icons.logout_rounded,
        leftIconOnPressed: () => context.pushNamed('search'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color.fromARGB(255, 235, 237, 237),
                  const Color.fromARGB(255, 255, 255, 255),
                ],
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Card
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ((homeState is ProductsLoaded)
                                          ? homeState.products[13].title
                                          : '') ??
                                      '',
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Ahora con el 25% de descuento',
                                  style: TextStyle(),
                                ),
                                SizedBox(height: 10),

                                PrimaryButton(
                                  text: 'Comprar ahora',
                                  onPressed: () {
                                    context.pushNamed(
                                      'product_detail',
                                      pathParameters: {
                                        'id': productDestacado.id.toString(),
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Image.network(
                              ((homeState is ProductsLoaded)
                                      ? homeState.products[13].image
                                      : '') ??
                                  '',
                              height: 90,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  Text(
                    'Los más vendidos',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildBody(homeState),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 10,
            right: 10,
            child: BarNavigationBottom(
              onNavItemTap: (index) {
                switch (index) {
                  case 0:
                    context.pushNamed('home');
                    break;
                  case 1:
                    context.pushNamed('cart');
                    break;

                  case 2:
                    context.pushNamed('catalog');
                    break;
                  case 3:
                    ref.read(authNotifierProvider.notifier).logout();
                    context.pushNamed('login');
                    break;
                  default:
                }
              },
            ),
          ),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductListItem(product: product);
        },
      ),
    );
  }
}
