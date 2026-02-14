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
  final List<ChatMessage> messages = [];

  String? _message;

  ChatPageProvider({
    required this.auth,
    required this.messagesViewScrollController,
    required this.chatId,
  }) {}

  String? get message => _message;

  @override
  void dispose() {
    super.dispose();
  }

  void goBack() => navigationService.goBack();
}
