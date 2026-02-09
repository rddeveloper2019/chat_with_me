import 'package:chat_with_me/models/chat.dart';
import 'package:chat_with_me/models/chat_message.dart';
import 'package:chat_with_me/providers/auth_provider.dart';
import 'package:chat_with_me/providers/chats_page_provider.dart';
import 'package:chat_with_me/widgets/chat_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatsList extends StatelessWidget {
  const ChatsList({super.key, required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final chats = Provider.of<ChatsPageProvider>(context).chats ?? [];
    final auth = Provider.of<AuthProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: height * 0.02,
      ),
      height: height * 0.98,
      width: width * 0.97,
      child: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final Chat chat = chats[index];

          return ChatListTile(
            title: chat.title,
            subtitle: chat.messages.first.type != MessageType.text
                ? 'Media Attachment'
                : chat.messages.first.content,
            isActive: chats[index].members.any(
              (m) => m.wasRecentlyActive() && auth.chatUser.uid != m.uid,
            ),
            isActivity: chat.isActivity,
            imageUrl: chat.imageUrl,
            height: height * 0.10,
          );
        },
      ),
    );
  }
}
