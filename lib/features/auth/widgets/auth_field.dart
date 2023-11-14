import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  const AuthField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.icon,
    this.isPasswordField = false,
  });

  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool isPasswordField;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPasswordField ? true : false,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        labelText: labelText,
        suffixIcon: Icon(icon),
      ),
    );
  }
}
