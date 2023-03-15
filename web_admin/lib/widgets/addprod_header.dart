import 'package:flutter/material.dart';
import 'package:web_admin/responsive.dart';

class addproductsHeader extends StatelessWidget {
  const addproductsHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (Responsive.isDesktop(context))
          Padding(
            padding: const EdgeInsets.all(11.0),
            child: Text("Upload New Products",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                )),
          ),
      ],
    );
  }
}
