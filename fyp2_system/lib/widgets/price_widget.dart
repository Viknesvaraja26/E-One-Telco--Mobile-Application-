import 'package:flutter/material.dart';
import 'package:fyp2_system/providers/dark_theme_provider.dart';
import 'package:fyp2_system/widgets/accounttext_widget.dart';
import 'package:provider/provider.dart';

class priceWidget extends StatelessWidget {
  const priceWidget(
      {super.key,
      required isDark,
      required this.salePrice,
      required this.price,
      required this.textPrice,
      required this.isOneSale});

  final double salePrice, price;
  final String textPrice;
  final bool isOneSale;

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool _isDark = themeState.getDarkTheme;
    double userPrice = isOneSale ? salePrice : price;

    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(1, 0, 0, 0),
        child: Row(
          children: [
            vTextWidget(
              text:
                  'RM ${(userPrice * int.parse(textPrice)).toStringAsFixed(2)}',
              color: Colors.green,
              textSize: 20,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(
              width: 3,
            ),
            Visibility(
              visible: isOneSale ? true : false,
              child: Text(
                'RM ${(price * int.parse(textPrice)).toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  color: _isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.lineThrough,
                  decorationThickness: 1.65,
                  decorationColor: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
