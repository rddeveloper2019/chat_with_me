import 'package:chat_with_me/providers/chat_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageMessageBubble extends StatelessWidget {
  final String imageUrl;
  final bool isOwn;
  final String sendDate;
  String? messageId;

  ImageMessageBubble({
    super.key,
    required this.imageUrl,
    required this.isOwn,
    required this.sendDate,
    this.messageId,
  });

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = isOwn
        ? [Color.fromRGBO(0, 136, 249, 1), Color.fromRGBO(0, 82, 218, 1)]
        : [Color.fromRGBO(51, 49, 68, 1), Color.fromRGBO(51, 59, 68, 1)];

    final DecorationImage image = DecorationImage(
      image: NetworkImage(imageUrl),
      fit: BoxFit.cover,
    );

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: colors,
            stops: [.3, .7],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: image,
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(sendDate, style: const TextStyle(color: Colors.white54)),
                Spacer(),
                if (isOwn) ...[
                  GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.edit, size: 15, color: Colors.white54),
                  ),
                  SizedBox(width: 10),
                  if (messageId != null)
                    GestureDetector(
                      onTap: () {
                        context.read<ChatPageProvider>().deleteMessage(
                          messageId!,
                        );
                      },
                      child: Icon(
                        Icons.delete,
                        size: 15,
                        color: Colors.white54,
                      ),
                    ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
