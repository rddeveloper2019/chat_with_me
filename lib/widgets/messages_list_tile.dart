import 'package:chat_with_me/models/chat_message.dart';
import 'package:chat_with_me/models/chat_user.dart';
import 'package:flutter/material.dart';

class MessagesListTile extends StatelessWidget {
  final ChatMessage message;
  final bool isOwn;
  final ChatUser sender;
  const MessagesListTile({
    super.key,
    required this.message,
    required this.isOwn,
    required this.sender,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.8,
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isOwn
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isOwn)
            CircleAvatar(
              backgroundImage: NetworkImage(sender.imageUrl),
              maxRadius: 20,
            ),
          SizedBox(width: 20),
          message.type == MessageType.text
              ? Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey,
                    ),
                    child: Text(
                      message.content +
                          'feferfer ferferfer ferferferfer ferferferfer ferferf erferf erferf erferf erfer ferf erf erf er ferf erfer f erf e',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : Expanded(child: Container(color: Colors.red)),
        ],
      ),
    );
  }
}
