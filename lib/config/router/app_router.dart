import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/screens/login_page.dart';
import '../../features/auth/presentation/screens/register_page.dart';
import '../../features/products/presentation/screens/cart_screen.dart';
import '../../features/auth/presentation/providers/auth_notifier.dart';
import '../../features/products/presentation/screens/home_screen.dart';
import '../../features/products/presentation/screens/search_screen.dart';
import '../../features/products/presentation/screens/support_screen.dart';
import '../../features/products/presentation/screens/product_categories.dart';
import '../../features/products/presentation/screens/product_detail_screen.dart';

final _routerAuthNotifier = Provider((ref) {
  final auth = ref.watch(authNotifierProvider.notifier);
  return _RouterAuthNotifier(auth);
});

class _RouterAuthNotifier extends ChangeNotifier {
  final AuthNotifier _authNotifier;
  AuthState? _previousState;

  _RouterAuthNotifier(this._authNotifier) {
    _authNotifier.addListener((state) {
      if (state != _previousState) {
        _previousState = state;
        notifyListeners();
      }
    });
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(_routerAuthNotifier);
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/products/:id',
        name: 'product_detail',
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return ProductDetailScreen(productId: productId);
        },
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/catalog',
        name: 'catalog',
        builder: (context, state) => const ProductCategories(),
      ),
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),

      GoRoute(
        path: '/support',
        name: 'support',
        builder: (context, state) => const SupportScreen(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      if (authState is AuthAuthenticated && state.uri.path == '/login') {
        return '/home';
      }

      if (authState is! AuthAuthenticated && state.uri.path == '/home') {
        return '/login';
      }

      return null;
    },
    refreshListenable: authNotifier,
  );
});
