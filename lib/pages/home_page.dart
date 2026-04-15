import 'package:chat_with_me/pages/chats_page.dart';
import 'package:chat_with_me/widgets/create_chat_button.dart';
import 'package:chat_with_me/widgets/logout_button.dart';
import 'package:chat_with_me/pages/users_page.dart';
import 'package:chat_with_me/widgets/power_save_indicator.dart';
import 'package:chat_with_me/widgets/search_input.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTabIdx = 0;

  List<({Widget body, AppBar appBar})> widgets = [
    (
      body: ChatsPage(),
      appBar: AppBar(
        title: Text('Chats', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [LogoutButton(), PowerSaveIndicator()],
      ),
    ),
    (
      body: UsersPage(),
      appBar: AppBar(
        // title: Text('Users', style: TextStyle(fontWeight: FontWeight.bold)),
        title: SearchInput(),
        centerTitle: false,
        actions: [CreateChatButton(), LogoutButton(), PowerSaveIndicator()],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: widgets[currentTabIdx].appBar,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentTabIdx,
          onTap: (value) {
            setState(() {
              currentTabIdx = value;
            });
          },
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white38,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_sharp),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle_sharp),
              label: 'Users',
            ),
          ],
        ),
        body: widgets[currentTabIdx].body,
      ),
    );
  }
}
