import 'dart:async';

import 'package:chat_with_me/models/chat.dart';
import 'package:chat_with_me/models/chat_message.dart';
import 'package:chat_with_me/models/chat_user.dart';
import 'package:chat_with_me/providers/auth_provider.dart';
import 'package:chat_with_me/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ChatsPageProvider extends ChangeNotifier {
  final AuthProvider auth;
  late DatabaseService db;
  List<Chat>? chats;
  late StreamSubscription _chatsStream;

  ChatsPageProvider({required this.auth}) {
    db = GetIt.I<DatabaseService>();
    getChats();
  }

  Future<void> getChats() async {
    try {
      _chatsStream = db.getChatsForUser(auth.chatUser?.uid ?? " ").listen((
        QuerySnapshot<Map<String, dynamic>> snapshot,
      ) async {
        chats = await Future.wait(
          snapshot.docs.map((document) async {
            final chatData = document.data();
            List<ChatUser> members = [];

            for (var userId in chatData['members'] ?? []) {
              final userSnapshot = await db.getUser(userId);

              final userMap = userSnapshot.data();
              if (userMap != null) {
                userMap['uid'] = userSnapshot.id;
                members.add(ChatUser.fromMap(userMap));
              }
            }

            List<ChatMessage> messages = [];
            final messageSnapshot = await db.getLastMessageForChat(document.id);
            if (messageSnapshot.docs.isNotEmpty) {
              messages.add(
                ChatMessage.fromMap(messageSnapshot.docs.first.data()),
              );
            }

            return Chat(
              uid: document.id,
              currentUserUid: auth.chatUser?.uid ?? " " ?? "",
              isActivity: chatData['is_activity'] as bool,
              isGroup: chatData['is_group'] as bool,
              messages: messages,
              members: members,
            );
          }).toList(),
        );

        notifyListeners();
      });
    } catch (e) {
      debugPrint('getChats error :  ${e.toString()}');
    }
  }

  @override
  void dispose() {
    _chatsStream.cancel();
    super.dispose();
  }
}
