import 'package:flutter/material.dart';

class LoginText extends StatelessWidget {
  // final controller;
  final String hint;
  final bool obscureText;
  final IconData icon;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final String? Function(String? value)? validator;
  final Widget? suffixIcon;

  LoginText({
    super.key,
    //  required this.controller,
    required this.hint,
    required this.obscureText,
    required this.icon,
    required this.keyboardType,
    required this.textInputAction,
    required this.controller,
    required this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        //  controller: controller,
        obscureText: obscureText,
        controller: controller,
        validator: validator,
        textInputAction: textInputAction, style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            suffixIcon: suffixIcon,
            prefixIcon: Icon(
              icon,
              color: Colors.white70,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11.0),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.7)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11.0),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.7)),
            ),
            fillColor: Colors.white.withOpacity(0.3),
            filled: true,
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7))),
      ),
    );
  }
}
