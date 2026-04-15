import 'package:chat_with_me/models/chat.dart';
import 'package:chat_with_me/widgets/chat_input.dart';
import 'package:chat_with_me/providers/auth_provider.dart';
import 'package:chat_with_me/providers/chat_page_provider.dart';
import 'package:chat_with_me/widgets/messages_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get_it/get_it.dart';
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
            keyboardVisibilityController:
                GetIt.I<KeyboardVisibilityController>(),
          ),
        ),
      ],
      child: ChatPageView(
        chat: widget.chat,
        scrollController: scrollController,
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
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

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Hero(
                tag: chat.uid,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(chat.imageUrl),
                ),
              ),
              const SizedBox(width: 10),
              Text(chat.title),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () => context.read<ChatPageProvider>().deleteChat(),
              icon: const Icon(Icons.delete, color: Colors.white38),
            ),
          ],
        ),

        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    if (chatPageProvider.isLoading)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (chatPageProvider.messages.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text(
                            'Be first to say Hi!',
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final message = chatPageProvider.messages.reversed
                              .toList()[index];
                          final sender = chat.members.firstWhere(
                            (m) => m.uid == message.senderId,
                          );
                          final isOwn = message.senderId == auth.chatUser?.uid;

                          return MessagesListTile(
                            message: message,
                            isOwn: isOwn,
                            sender: sender,
                          );
                        }, childCount: chatPageProvider.messages.length),
                      ),
                  ],
                ),
              ),

              Padding(padding: const EdgeInsets.all(8.0), child: ChatInput()),
            ],
          ),
        ),
      ),
    );
  }
}
