import 'dart:async';
import 'dart:io';

import 'package:chat_with_me/models/chat_message.dart';
import 'package:chat_with_me/providers/auth_provider.dart';
import 'package:chat_with_me/services/cloud_storage_service.dart';
import 'package:chat_with_me/services/database_service.dart';
import 'package:chat_with_me/services/media_service.dart';
import 'package:chat_with_me/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ChatPageProvider extends ChangeNotifier {
  final DatabaseService db = GetIt.I<DatabaseService>();
  final CloudStorageService storageService = GetIt.I<CloudStorageService>();
  final MediaService mediaService = GetIt.I<MediaService>();
  final NavigationService navigationService = GetIt.I<NavigationService>();

  final AuthProvider auth;
  final ScrollController messagesViewScrollController;

  final String chatId;
  final List<ChatMessage> messages = [];

  StreamSubscription? messagesStream;

  String? _message;

  ChatPageProvider({
    required this.auth,
    required this.messagesViewScrollController,
    required this.chatId,
  }) {
    messagesStream = db.streamMessagesForChat(chatId).listen((
      QuerySnapshot<Map<String, dynamic>> snapshot,
    ) {
      try {
        messages.clear();
        messages.addAll(
          snapshot.docs.map((data) {
            return ChatMessage.fromMap(data.data());
          }),
        );
        print('(**) => messages:  ${messages}');
        notifyListeners();
      } catch (e) {
        debugPrint('messagesStream listen error :  ${e.toString()}');
      }
    });
  }

  String? get message => _message;

  void deleteChat() {
    goBack();
    db.deleteChat(chatId);
  }

  void sendText() {
    if (message != null && message!.isNotEmpty) {
      db.addMessageToChat(
        chatId,
        message: ChatMessage(
          senderId: auth.chatUser.uid,
          type: MessageType.text,
          content: message!,
          sentTime: DateTime.now(),
        ),
      );
    }
  }

  Future<void> sendImage() async {
    try {
      final File? image = await mediaService.pickImageFromLibrary();
      if (image == null) {
        return;
      }

      final imageUrl = await storageService.saveChatImageToStorage(
        uid: auth.chatUser.uid,
        file: image,
      );

      db.addMessageToChat(
        chatId,
        message: ChatMessage(
          senderId: auth.chatUser.uid,
          type: MessageType.image,
          content: imageUrl ?? '',
          sentTime: DateTime.now(),
        ),
      );
    } catch (e) {
      debugPrint('sendImage error :  ${e.toString()}');
    }
  }

  void goBack() => navigationService.goBack();

  @override
  void dispose() {
    messagesStream?.cancel();
    messagesViewScrollController.dispose();
    super.dispose();
  }
}
