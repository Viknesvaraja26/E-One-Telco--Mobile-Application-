import 'package:flutter/material.dart';
import 'package:fyp2_system/services/utils.dart';

class emptyprodSc extends StatelessWidget {
  const emptyprodSc({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    Color color = Utils(context).color;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Image.asset(
                'lib/assets/images/no-product-found.png',
              ),
            ),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
