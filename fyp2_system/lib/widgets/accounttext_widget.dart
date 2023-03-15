import 'package:flutter/material.dart';

// ignore: must_be_immutable
class vTextWidget extends StatelessWidget {
  vTextWidget({
    super.key,
    required this.text,
    required this.color,
    required this.textSize,
    required this.fontWeight,
    this.isTitle = false,
    this.maxLines = 10,
    this.letterSpacing,
  });

  final String text;
  final Color color;
  final double textSize;
  final FontWeight fontWeight;
  final double? letterSpacing;
  bool isTitle = false;
  int maxLines = 10;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      style: TextStyle(
        overflow: TextOverflow.ellipsis,
        color: color,
        fontSize: textSize,
        fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
