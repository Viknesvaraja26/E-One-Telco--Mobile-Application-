import 'package:flutter/material.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top, left: 25, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '\tHi, Welcome to\n \t\t\t\t\t\t\t\t\t\t One Store Telco🚀',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          /* Container(
            child: IconButton(
              icon: const Icon(IconlyBold.buy),
              iconSize: 28,
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => CartSc()));
              },
            ),
          )*/
        ],
      ),
    );
  }
}
