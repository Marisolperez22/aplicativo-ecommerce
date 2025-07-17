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
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600; 

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Fake Store',
        leftIcon: Icons.search,
        rightIcon: Icons.shopping_bag_outlined,
        rightIconOnPressed: () => context.pushNamed('cart'),
        leftIconOnPressed: () => context.pushNamed('search'),
        appBarColor: const Color.fromARGB(255, 235, 237, 237),
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
              padding: EdgeInsets.symmetric(
                horizontal: isLargeScreen ? 48.0 : 24.0,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Card de producto destacado
                  _buildFeaturedProductCard(homeState, context, isLargeScreen),
                  
                  const SizedBox(height: 24),
                  
                  // Título de sección
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Los más vendidos',
                      style: TextStyle(
                        fontSize: isLargeScreen ? 20 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Lista de productos
                  _buildBody(homeState, screenWidth),
                ],
              ),
            ),
          ),
          
          // Bottom Navigation Bar
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  selectedItemColor: Theme.of(context).primaryColor,
                  unselectedItemColor: Colors.grey,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Inicio',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.help_center),
                      label: 'Soporte',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.category),
                      label: 'Catálogo',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.logout),
                      label: 'Salir',
                    ),
                  ],
                  onTap: (index) {
                    switch (index) {
                      case 0: context.pushNamed('home'); break;
                      case 1: context.pushNamed('support'); break;
                      case 2: context.pushNamed('catalog'); break;
                      case 3: 
                        ref.read(authNotifierProvider.notifier).logout();
                        context.pushNamed('login');
                        break;
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedProductCard(ProductState state, BuildContext context, bool isLargeScreen) {
    final Product featuredProduct = (state is ProductsLoaded) ? state.products[13] : Product(id: 0);
    
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(isLargeScreen ? 24.0 : 16.0),
        child: Row(
          children: [
            Expanded(
              flex: isLargeScreen ? 3 : 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (state is ProductsLoaded) ? featuredProduct.title ?? '' : '',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 20 : 16,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Ahora con el 25% de descuento',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 16 : 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: isLargeScreen ? 180 : 140,
                    child: PrimaryButton(
                      text: 'Comprar ahora',
                      onPressed: () {
                        context.pushNamed(
                          'product_detail',
                          pathParameters: {'id': featuredProduct.id.toString()},
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: isLargeScreen ? 2 : 1,
              child: (state is ProductsLoaded)
                  ? FadeInImage.assetNetwork(
                      placeholder: 'assets/placeholder.png',
                      image: featuredProduct.image ?? '',
                      height: isLargeScreen ? 140 : 100,
                      fit: BoxFit.contain,
                      imageErrorBuilder: (context, error, stackTrace) => 
                          _buildImagePlaceholder(isLargeScreen),
                      placeholderErrorBuilder: (context, error, stackTrace) => 
                          _buildImagePlaceholder(isLargeScreen),
                    )
                  : _buildImagePlaceholder(isLargeScreen),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(ProductState state, double screenWidth) {
    if (state is ProductInitial) {
      return const Center(child: Text('Presiona refresh para cargar productos'));
    } else if (state is ProductLoading) {
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
    // Calculamos el número de columnas basado en el ancho de la pantalla
    final crossAxisCount = _calculateCrossAxisCount(screenWidth);
    final childAspectRatio = _calculateChildAspectRatio(screenWidth);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: products.length > 6 ? 6 : products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductListItem(product: product);
      },
    );
  }

  int _calculateCrossAxisCount(double screenWidth) {
    if (screenWidth > 1200) return 4; // Desktop grande
    if (screenWidth > 900) return 3; // Desktop pequeño/tablet grande
    if (screenWidth > 600) return 2; // Tablet
    return 2; // Mobile (default)
  }

  double _calculateChildAspectRatio(double screenWidth) {
    if (screenWidth > 1200) return 0.65; // Más anchas en pantallas grandes
    if (screenWidth > 900) return 0.7;
    return 0.75; // Default para mobile/tablet
  }

  Widget _buildImagePlaceholder(bool isLargeScreen) {
    return Container(
      height: isLargeScreen ? 140 : 100,
      color: Colors.grey.shade200,
      child: Center(
        child: Icon(Icons.image, color: Colors.grey.shade400),
      ),
    );
  }
}