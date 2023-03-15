import 'package:flutter/material.dart';

class But_Tiles extends StatelessWidget {
  final String imagePath;
  const But_Tiles({
    super.key,
    required this.imagePath,
    required AssetImage image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200],
      ),
      child: Image.asset(
        imagePath,
        height: 40,
      ),
    );
  }
}
