import 'package:flutter/material.dart';
import 'package:web_admin/consts/constants.dart';
import 'package:web_admin/responsive.dart';

class productsHeader extends StatelessWidget {
  const productsHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (Responsive.isDesktop(context))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Products",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                )),
          ),
        if (Responsive.isDesktop(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search",
              fillColor: Theme.of(context).cardColor,
              filled: true,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              suffixIcon: InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(defaultPadding * 0.75),
                  margin: const EdgeInsets.symmetric(
                      horizontal: defaultPadding / 2),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Icon(
                    Icons.search,
                    size: 25,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
