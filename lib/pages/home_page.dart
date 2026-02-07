import 'package:chat_with_me/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              auth.logOut();
            },
            icon: Icon(Icons.logout_outlined, color: Colors.blueAccent),
          ),
        ],
      ),
      body: SingleChildScrollView(child: Column(children: [Text('Home Page')])),
    );
  }
}
