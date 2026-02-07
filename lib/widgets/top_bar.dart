import 'package:chat_with_me/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopBar extends StatelessWidget {
  final int index;
  const TopBar({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    List<AppBar> appBars = [
      AppBar(
        title: Text('Chats', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              auth.logOut();
            },
            icon: Icon(Icons.logout_outlined, color: Colors.white38),
          ),
        ],
      ),
      AppBar(
        title: Text('Users', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              auth.logOut();
            },
            icon: Icon(Icons.logout_outlined, color: Colors.white38),
          ),
        ],
      ),
    ];
    return PreferredSize(
      preferredSize: Size(double.infinity, 60),
      child: appBars[index],
    );
  }
}
