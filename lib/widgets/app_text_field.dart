import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final void Function(String? value) onSave;
  final String regex;
  final String hintText;
  final bool obscureText;
  final String? Function(String? value)? validator;

  const AppTextField({
    super.key,
    required this.onSave,
    required this.regex,
    required this.hintText,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      onSaved: onSave,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      validator: (String? value) {
        if (!RegExp(regex).hasMatch(value ?? "")) {
          return 'Enter a valid value';
        }
        return validator != null ? validator!(value) : null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white54),
        errorStyle: TextStyle(
          color: const Color.fromARGB(255, 252, 2, 2),
          fontSize: 12,
        ),
        fillColor: Color.fromRGBO(30, 29, 37, 1),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color.fromARGB(255, 173, 59, 59)),
        ),
      ),
    );
  }
}
