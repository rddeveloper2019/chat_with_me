import 'package:flutter/material.dart';

class AppLink extends StatelessWidget {
  final String text;
  final void Function() onClick;
  const AppLink({super.key, required this.text, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Text(text, style: TextStyle(color: Colors.blue)),
    );
  }
}
