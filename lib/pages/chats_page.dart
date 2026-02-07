import 'package:chat_with_me/providers/auth_provider.dart';
import 'package:chat_with_me/widgets/chat_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final auth = Provider.of<AuthProvider>(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: height * 0.02,
      ),
      height: height * 0.98,
      width: width * 0.97,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChatListTile(
            title: "Hussain Mustafa",
            subtitle: "hello!",
            isActive: true,
            isActivity: true,
            imageUrl:
                "https://www.headshotpro.com/avatar-results/random-1.webp",
            height: height * 0.10,
          ),
        ],
      ),
    );
  }
}
