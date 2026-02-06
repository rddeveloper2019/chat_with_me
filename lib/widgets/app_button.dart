import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final void Function() onPressed;
  final String name;
  double? width;
  double? height;

  AppButton({
    super.key,
    required this.onPressed,
    required this.name,
    this.width = double.infinity,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        // color: Color.fromRGBO(38, 8, 236, 0.8),
        borderRadius: BorderRadius.circular(12),
        border: BoxBorder.all(width: 1, color: Colors.blue),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(),
        child: Text(name, style: TextStyle(fontSize: 22, color: Colors.white)),
      ),
    );
  }
}
