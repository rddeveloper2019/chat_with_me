import 'package:chat_with_me/models/chat.dart';
import 'package:chat_with_me/models/chat_message.dart';
import 'package:chat_with_me/providers/auth_provider.dart';
import 'package:chat_with_me/providers/chat_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;
  const ChatPage({super.key, required this.chat});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GlobalKey messageFormKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final messagesViewController = ScrollController();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatPageProvider>(
          create: (context) => ChatPageProvider(
            auth: context.read<AuthProvider>(),
            messagesViewScrollController: messagesViewController,
            chatId: widget.chat.uid,
          ),
        ),
      ],
      child: ChatPageView(
        chat: widget.chat,
        scrollController: scrollController,
      ),
    );
  }
}

class ChatPageView extends StatelessWidget {
  final Chat chat;
  final ScrollController scrollController;

  const ChatPageView({
    super.key,
    required this.chat,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final chatPageProvider = context.watch<ChatPageProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(chat.imageUrl)),
            const SizedBox(width: 10),
            Text(chat.title),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete, color: Colors.white38),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Список сообщений (прокручиваемый)
            Expanded(
              child: Center(
                child: chatPageProvider.isLoading
                    ? const CircularProgressIndicator()
                    : chatPageProvider.messages.isEmpty
                    ? const Text(
                        'Be first to say Hi!',
                        style: TextStyle(color: Colors.white),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: chatPageProvider.messages.length,
                        itemBuilder: (context, index) {
                          return MessagesListTile(
                            message: chatPageProvider.messages[index],
                          );
                        },
                      ),
              ),
            ),
            // Поле ввода (всегда внизу)
            Container(
              padding: const EdgeInsets.all(8),
              color: const Color(0xFF1A1A1A),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesListTile extends StatelessWidget {
  final ChatMessage message;
  const MessagesListTile({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(message.content, style: const TextStyle(color: Colors.white)),
    );
  }
}
