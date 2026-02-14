import 'package:chat_with_me/models/chat_message.dart';
import 'package:chat_with_me/models/chat_user.dart';
import 'package:chat_with_me/widgets/image_message_bubble.dart';
import 'package:chat_with_me/widgets/text_message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

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
    return Container(
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
          SizedBox(width: isOwn ? 55 : 15),
          message.type == MessageType.text
              ? TextMessageBubble(
                  text: message.content,
                  isOwn: isOwn,
                  sendDate: timeago.format(
                    message.sentTime.toDate(),
                    locale: 'ru',
                  ),
                  messageId: message.id,
                )
              : ImageMessageBubble(
                  imageUrl: message.content,
                  isOwn: isOwn,
                  sendDate: timeago.format(
                    message.sentTime.toDate(),
                    locale: 'ru',
                  ),
                  messageId: message.id,
                ),
        ],
      ),
    );
  }
}
