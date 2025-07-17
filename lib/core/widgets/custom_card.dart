import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String productTitle;
  final String message;
  final dynamic Function()? onPressed;
  final String buttonTitle;
  final String productImage;
  
  const CustomCard({super.key, required this.productTitle, required this.message, this.onPressed, required this.buttonTitle, required this.productImage});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                   productTitle,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(message, style: TextStyle()),
                  SizedBox(height: 10),

                  PrimaryButton(
                    text: buttonTitle,
                    onPressed: onPressed,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child:
                 FadeInImage.assetNetwork(
                        placeholder:
                            'assets/placeholder.png', 
                        image: productImage,
                        height: 90,
                        fit: BoxFit.contain,
                        imageErrorBuilder:
                            (context, error, stackTrace) =>
                                _buildImagePlaceholder(),
                        placeholderErrorBuilder:
                            (context, error, stackTrace) =>
                                _buildImagePlaceholder(),
                        fadeInDuration: const Duration(milliseconds: 300),
                      )
            ),
          ],
        ),
      ),
    );
  }
    Widget _buildImagePlaceholder() {
    return Container(
      height: 90,
      color: Colors.grey.shade200,
      child: Center(child: Icon(Icons.image, color: Colors.grey.shade400)),
    );
  }
}
