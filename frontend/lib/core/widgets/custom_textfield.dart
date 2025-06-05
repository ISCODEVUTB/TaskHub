import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final Widget? prefixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        border: const OutlineInputBorder(),
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).cardColor,
      ),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
