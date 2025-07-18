import 'package:flutter/material.dart';

class TextTitle extends StatelessWidget {
  final String title;

  const TextTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    return Text(
      title,
      style: TextStyle(
        fontSize: isLargeScreen ? 20 : 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
