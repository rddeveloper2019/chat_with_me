import 'package:chat_with_me/models/chat_user.dart';
import 'package:chat_with_me/providers/auth_provider.dart';
import 'package:chat_with_me/services/cloud_storage_service.dart';
import 'package:chat_with_me/services/database_service.dart';
import 'package:chat_with_me/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class UsersPageProvider extends ChangeNotifier {
  final DatabaseService db = GetIt.I<DatabaseService>();
  final CloudStorageService storageService = GetIt.I<CloudStorageService>();
  final NavigationService navigationService = GetIt.I<NavigationService>();

  final AuthProvider auth;

  // ignore: prefer_final_fields
  List<ChatUser> _users = [];
  // ignore: prefer_final_fields
  List<ChatUser> _selectedUsers = [];

  List<ChatUser> get users => _users;
  List<ChatUser> get selectedUsers => _selectedUsers;

  UsersPageProvider({required this.auth}) {
    getUsers();
  }

  Future<void> getUsers([String? name]) async {
    try {
      final data = await db.getUsers(name);
      _users.clear();
      _users.addAll(
        (data.docs).map((doc) {
          final map = doc.data();

          return ChatUser.fromMap({...map, 'uid': doc.id});
        }),
      );
    } catch (e) {
      debugPrint('getUsers error :  ${e.toString()}');
    } finally {
      notifyListeners();
    }
  }

  void updatesSelectedUsers(ChatUser user) {
    if (_selectedUsers.contains(user)) {
      _selectedUsers.remove(user);
    } else {
      _selectedUsers.add(user);
    }

    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
