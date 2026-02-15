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
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get_it/get_it.dart';

class ChatPageProvider extends ChangeNotifier {
  final DatabaseService db = GetIt.I<DatabaseService>();
  final CloudStorageService storageService = GetIt.I<CloudStorageService>();
  final MediaService mediaService = GetIt.I<MediaService>();
  final NavigationService navigationService = GetIt.I<NavigationService>();
  final KeyboardVisibilityController keyboardVisibilityController;

  final AuthProvider auth;
  final ScrollController messagesViewScrollController;
  final String chatId;

  late StreamSubscription<bool> keyboardSubscription;

  List<ChatMessage> messages = [];

  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;
  String? _message;

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;
  String? get message => _message;

  set message(String? value) {
    _message = value;
  }

  StreamSubscription? messagesStream;

  ChatPageProvider({
    required this.auth,
    required this.messagesViewScrollController,
    required this.chatId,
    required this.keyboardVisibilityController,
  }) {
    _loadMessages();

    messagesStream = db.streamMessagesForChat(chatId).listen((
      QuerySnapshot<Map<String, dynamic>> snapshot,
    ) {
      try {
        messages.clear();
        messages.addAll(
          snapshot.docs.map((data) {
            return ChatMessage.fromMap({...data.data(), 'id': data.id});
          }),
        );
      } catch (e) {
        debugPrint('messagesStream listen error :  ${e.toString()}');
      } finally {
        notifyListeners();
      }
    });

    keyboardSubscription = keyboardVisibilityController.onChange.listen((
      isOpen,
    ) {
      db.updateChatData(chatId, data: {'is_activity': isOpen});
    });
  }

  Future<void> _loadMessages() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = null;

    try {
      final snapshot = await db.getAllChatMessages(chatId);

      if (snapshot.docs.isEmpty) {
        debugPrint('ℹ️ Чат $chatId пустой (нет сообщений)');
      }

      messages = snapshot.docs
          .map((doc) => ChatMessage.fromMap(doc.data()))
          .toList();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (messagesViewScrollController.hasClients) {
          messagesViewScrollController.jumpTo(
            messagesViewScrollController.position.maxScrollExtent,
          );
        }
      });
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
      db.updateChatData(chatId, data: {'is_activity': false});
      debugPrint('❌ Ошибка загрузки сообщений: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> retryLoad() => _loadMessages();

  void goBack() => navigationService.goBack();

  void deleteChat() {
    goBack();
    db.deleteChat(chatId);
  }

  void sendText() async {
    if (message != null && message!.isNotEmpty) {
      db.addMessageToChat(
        chatId,
        message: ChatMessage(
          senderId: auth.chatUser?.uid ?? "",
          type: MessageType.text,
          content: message!,
          sentTime: Timestamp.now(),
        ),
      );
      message = '';
      notifyListeners();
    }
  }

  void deleteMessage(String messageId) async {
    await db.deleteMessage(chatId, messageId: messageId);
  }

  Future<void> sendImage() async {
    try {
      final File? image = await mediaService.pickImageFromLibrary();
      if (image == null) {
        return;
      }

      final imageUrl = await storageService.saveChatImageToStorage(
        uid: auth.chatUser?.uid ?? " ",
        file: image,
      );

      db.addMessageToChat(
        chatId,
        message: ChatMessage(
          senderId: auth.chatUser?.uid ?? " ",
          type: MessageType.image,
          content: imageUrl ?? '',
          sentTime: Timestamp.fromDate(DateTime.now()),
        ),
      );
    } catch (e) {
      debugPrint('sendImage error :  ${e.toString()}');
    }
  }

  @override
  void dispose() {
    messagesStream?.cancel();
    messagesViewScrollController.dispose();
    super.dispose();
  }
}
