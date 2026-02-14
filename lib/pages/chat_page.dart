import 'package:chat_with_me/models/chat.dart';
import 'package:chat_with_me/providers/auth_provider.dart';
import 'package:chat_with_me/providers/chat_page_provider.dart';
import 'package:chat_with_me/widgets/messages_list_tile.dart';
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
    final auth = Provider.of<AuthProvider>(context);

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
            Expanded(
              child: chatPageProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : chatPageProvider.messages.isEmpty
                  ? const Center(
                      child: Text(
                        'Be first to say Hi!',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      reverse: true,
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                      ),
                      itemCount: chatPageProvider.messages.length,
                      itemBuilder: (context, index) {
                        final message = chatPageProvider.messages[index];
                        final sender = chat.members
                            .where((m) => m.uid == message.senderId)
                            .first;
                        final isOwn = message.senderId == auth.chatUser.uid;

                        return MessagesListTile(
                          message: message,
                          isOwn: isOwn,
                          sender: sender,
                        );
                      },
                    ),
            ),

            ChatInput(),
          ],
        ),
      ),
    );
  }
}

class ChatInput extends StatelessWidget {
  const ChatInput({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(
      text: context.read<ChatPageProvider>().message,
    );
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
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
            onTap: () {},
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
