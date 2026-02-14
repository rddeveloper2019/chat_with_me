import 'package:chat_with_me/providers/chat_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatInput extends StatelessWidget {
  const ChatInput({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(
      text: context.read<ChatPageProvider>().message,
    );
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF0088F9), width: 2),
        borderRadius: BorderRadius.circular(25),
        color: const Color(0xFF2A2A2A),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white54,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: const TextStyle(color: Colors.white54),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(
                  left: 8,
                  right: 16,
                  bottom: 12,
                  top: 12,
                ),
              ),
              onChanged: (value) {
                context.read<ChatPageProvider>().message = value;
              },
              onSubmitted: (_) {
                context.read<ChatPageProvider>().sendText();
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<ChatPageProvider>().sendImage();
            },
            child: const Icon(Icons.attach_file, color: Color(0xFF0088F9)),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              context.read<ChatPageProvider>().sendText();
            },
            child: const Icon(Icons.send, color: Color(0xFF0088F9)),
          ),
        ],
      ),
    );
  }
}
