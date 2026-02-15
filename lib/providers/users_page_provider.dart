import 'package:chat_with_me/models/chat.dart';
import 'package:chat_with_me/models/chat_user.dart';
import 'package:chat_with_me/pages/chat_page.dart';
import 'package:chat_with_me/providers/auth_provider.dart';
import 'package:chat_with_me/services/cloud_storage_service.dart';
import 'package:chat_with_me/services/database_service.dart';
import 'package:chat_with_me/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class UsersPageProvider extends ChangeNotifier {
  final DatabaseService db = GetIt.I<DatabaseService>();
  final CloudStorageService storageService = GetIt.I<CloudStorageService>();
  final NavigationService navigationService = GetIt.I<NavigationService>();

  final AuthProvider auth;

  List<ChatUser> _users = [];

  List<ChatUser> _selectedUsers = [];

  List<ChatUser> get users => _users;
  List<ChatUser> get selectedUsers => _selectedUsers;

  UsersPageProvider({required this.auth}) {
    getUsers();
  }

  Future<void> getUsers([String? name]) async {
    _users.clear();
    print('(**) => name:  ${name}');
    try {
      final data = await db.getUsers(name);
      _users.addAll(
        (data.docs).where((doc) => doc.id != auth.chatUser!.uid).map((doc) {
          final map = doc.data();

          return ChatUser.fromMap({...map, 'uid': doc.id});
        }),
      );
    } catch (e) {
      debugPrint('getUsers error :  ${e.toString()}');
    }
    notifyListeners();
  }

  void updateSelectedUsers(ChatUser user) {
    if (_selectedUsers.contains(user)) {
      _selectedUsers.remove(user);
    } else {
      _selectedUsers.add(user);
    }

    notifyListeners();
  }

  Future<void> createChat() async {
    if (_selectedUsers.isEmpty) {
      return;
    }

    try {
      final membersIds = _selectedUsers.map((u) => u.uid).toList();
      membersIds.add(auth.chatUser!.uid);

      final isGroup = _selectedUsers.length > 1;

      final DocumentReference<Map<String, dynamic>>? documentReference =
          await db.createChat({
            'is_activity': false,
            'is_group': isGroup,
            'members': membersIds,
            'messages': [],
          });

      if (documentReference == null) {
        throw Exception('Failed to create chat document');
      }

      List<ChatUser> members = [];
      for (var uid in membersIds) {
        final snapshot = await db.getUser(uid);
        if (snapshot.exists) {
          final map = snapshot.data()!;
          members.add(ChatUser.fromMap({...map, 'uid': snapshot.id}));
        }
      }

      navigationService.navigateToPage(
        ChatPage(
          chat: Chat(
            uid: documentReference.id,
            currentUserUid: auth.chatUser!.uid,
            isActivity: false,
            isGroup: isGroup,
            messages: [],
            members: members,
          ),
        ),
      );

      _selectedUsers.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('createChat error: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
