import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainView extends StatelessWidget {
  final Widget body;
  final String? appBarTitle;
  final PreferredSizeWidget? appBar;
  final bool hasBottomNavigationBar;

  const MainView({
    super.key,
    required this.body,
    required this.appBarTitle,
    this.appBar,
    this.hasBottomNavigationBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appBarTitle ?? '')),
      body: body,
      bottomNavigationBar: 
      hasBottomNavigationBar ? BarNavigationBottom(
        onNavItemTap: (index) {
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
              context.pushNamed('logout');
              break;
            default:
          }
        },
      )
      : SizedBox.shrink(),
    );
  }
}
