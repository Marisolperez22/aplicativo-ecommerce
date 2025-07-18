import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final String rate;

  const RatingWidget({super.key, required this.rate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 16),
        const SizedBox(width: 4),
        Text(
          rate,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}
