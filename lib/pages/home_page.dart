import 'package:chat_with_me/pages/chats_page.dart';
import 'package:chat_with_me/widgets/logout_button.dart';
import 'package:chat_with_me/widgets/users_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTabIdx = 0;

  List<({String title, Widget widget})> tabs = [
    (title: 'Chats', widget: ChatsPage()),
    (title: 'Users', widget: UsersPage()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tabs[currentTabIdx].title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [LogoutButton()],
      ),
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
      body: tabs[currentTabIdx]
          .widget, //SingleChildScrollView(child: Column(children: [Text('Home Page')])),
    );
  }
}
