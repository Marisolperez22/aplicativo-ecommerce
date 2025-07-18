import 'package:flutter/material.dart';

class GenericAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const GenericAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: const Color.fromARGB(255, 235, 237, 237),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
