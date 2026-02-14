import 'package:chat_with_me/models/chat_message.dart';
import 'package:chat_with_me/providers/auth_provider.dart';
import 'package:chat_with_me/services/cloud_storage_service.dart';
import 'package:chat_with_me/services/database_service.dart';
import 'package:chat_with_me/services/media_service.dart';
import 'package:chat_with_me/services/navigation_service.dart';
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

  List<ChatMessage> messages = []; // ✅ Исправлено: убран final и ?

  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;

  ChatPageProvider({
    required this.auth,
    required this.messagesViewScrollController,
    required this.chatId,
  }) {
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();

    try {
      final snapshot = await db.getAllChatMessages(chatId);

      if (snapshot.docs.isEmpty) {
        debugPrint('ℹ️ Чат $chatId пустой (нет сообщений)');
      }

      messages = snapshot.docs
          .map((doc) => ChatMessage.fromMap(doc.data()))
          .toList();

      // Автопрокрутка вниз после загрузки
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
      debugPrint('❌ Ошибка загрузки сообщений: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Публичный метод для повторной загрузки при ошибке
  Future<void> retryLoad() => _loadMessages();

  void goBack() => navigationService.goBack();
}
