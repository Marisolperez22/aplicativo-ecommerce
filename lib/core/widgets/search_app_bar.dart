import 'package:flutter/material.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ValueChanged<String> onChanged;

  const SearchAppBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TextField(
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Buscar productos...',
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => onChanged(''),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}