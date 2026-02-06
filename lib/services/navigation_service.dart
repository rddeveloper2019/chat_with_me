import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void removeAndNavigateToRoute(String route) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      route,
      (Route<dynamic> route) => false,
    );
  }

  void navigateToRoute(String route) {
    navigatorKey.currentState?.pushNamed(route);
  }

  void navigateToPage(Widget page) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void goBack() {
    navigatorKey.currentState?.pop();
  }
}
