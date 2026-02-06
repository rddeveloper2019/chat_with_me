import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final void Function(String? value) onSave;
  final String regex;
  final String hintText;
  final bool obscureText;

  const AppTextField({
    super.key,
    required this.onSave,
    required this.regex,
    required this.hintText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      onSaved: onSave,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      validator: (String? value) {
        return RegExp(regex).hasMatch(value ?? "")
            ? null
            : 'Enter a valid value';
      },
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white54),
        fillColor: Color.fromRGBO(30, 29, 37, 1),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
