import 'package:chat_with_me/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return IconButton(
      onPressed: () {
        auth.logOut();
      },
      icon: Icon(Icons.logout_outlined, color: Colors.white38),
    );
  }
}
