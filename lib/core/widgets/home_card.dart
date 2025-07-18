import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final String imageUrl;
  final String description;
  final String buttonTitle;
  final String productTitle;
  final dynamic Function()? buttonOnPressed;

  const HomeCard({
    super.key,
    this.buttonOnPressed,
    required this.imageUrl,
    required this.buttonTitle,
    required this.description,
    required this.productTitle,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    return Card(
      elevation: 2,
      color: Colors.white,
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
                    productTitle,
                    style: TextStyle(
                      fontSize: isLargeScreen ? 20 : 16,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: isLargeScreen ? 16 : 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: isLargeScreen ? 180 : 140,
                    child: PrimaryButton(
                      text: buttonTitle,
                      onPressed: buttonOnPressed,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: isLargeScreen ? 2 : 1,
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/placeholder.png',
                image: imageUrl,
                height: isLargeScreen ? 140 : 100,
                fit: BoxFit.contain,
                imageErrorBuilder:
                    (context, error, stackTrace) =>
                        _buildImagePlaceholder(isLargeScreen),
                placeholderErrorBuilder:
                    (context, error, stackTrace) =>
                        _buildImagePlaceholder(isLargeScreen),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(bool isLargeScreen) {
    return Container(
      height: isLargeScreen ? 140 : 100,
      color: Colors.grey.shade200,
      child: Center(child: Icon(Icons.image, color: Colors.grey.shade400)),
    );
  }
}
