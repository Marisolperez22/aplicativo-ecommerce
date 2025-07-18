import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BottomNavigationBar(
        
        type: BottomNavigationBarType.fixed,
        backgroundColor: AtomicSystemColorsFoundation.primaryColor,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_center),
            label: 'Soporte',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Catálogo',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Salir'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              context.pushNamed('home');
              break;
            case 1:
              context.pushNamed('support');
              break;
            case 2:
              context.pushNamed('catalog');
              break;
            case 3:
              // ref.read(authNotifierProvider.notifier).logout();
              context.pushNamed('login');
              break;
          }
        },
      ),
    );
  }
}
