import 'package:flutter/material.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget  {
  final void Function(String)? onChanged;

  const SearchAppBar({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AppBar(
      backgroundColor: const Color.fromARGB(255, 235, 237, 237),
      title: SizedBox(
        width: screenWidth > 600 ? screenWidth * 0.7 : screenWidth * 0.6,
        child: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Buscar productos...',
            border: InputBorder.none,
            hintStyle: TextStyle(fontSize: screenWidth > 900 ? 18 : 16),
          ),
          style: TextStyle(fontSize: screenWidth > 900 ? 18 : 16),
          onChanged: onChanged,
        ),
      ),
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
