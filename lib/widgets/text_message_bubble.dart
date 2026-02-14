import 'package:flutter/material.dart';

class TextMessageBubble extends StatelessWidget {
  const TextMessageBubble({
    super.key,
    required this.text,
    required this.isOwn,
    required this.sendDate,
  });

  final String text;
  final bool isOwn;
  final String sendDate;

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = isOwn
        ? [Color.fromRGBO(0, 136, 249, 1), Color.fromRGBO(0, 82, 218, 1)]
        : [Color.fromRGBO(51, 49, 68, 1), Color.fromRGBO(51, 59, 68, 1)];

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
            Text(text, style: const TextStyle(color: Colors.white)),
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
                  GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.delete, size: 15, color: Colors.white54),
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
