import 'package:flutter/material.dart';

class AppPage extends PageRouteBuilder {
  final Widget page;

  AppPage({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      );
}
