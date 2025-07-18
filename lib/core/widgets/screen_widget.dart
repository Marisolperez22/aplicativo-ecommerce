import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:atomic_design_system/atomic_design_system.dart';

class ScreenWidget extends StatelessWidget {
  final Widget body;
  final bool hasBottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final bool hasSingleChilScroll;

  const ScreenWidget({
    super.key,
    this.appBar,
    required this.body,
    this.hasSingleChilScroll = true,
    this.hasBottomNavigationBar = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      appBar: appBar,
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
          ),
          hasSingleChilScroll
          ?
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isLargeScreen ? 48.0 : 24.0,
              vertical: 16,
            ),
            child: body,
          )
          : Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isLargeScreen ? 48.0 : 24.0,
              vertical: 16,
            ),
            child: body,
          ),
          hasBottomNavigationBar
              ? Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: BarNavigationBottom(
                  onNavItemTap: (index) {
                    switch (index) {
                      case 0:
                        context.replaceNamed('home');
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
              )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
