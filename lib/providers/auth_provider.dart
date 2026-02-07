import 'package:chat_with_me/models/chat_user.dart';
import 'package:chat_with_me/services/database_service.dart';
import 'package:chat_with_me/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AuthProvider extends ChangeNotifier {
  late FirebaseAuth _auth;
  late NavigationService _navigationService;
  late DatabaseService _databaseService;
  late ChatUser chatUser;
  AuthProvider() {
    _auth = FirebaseAuth.instance;
    _navigationService = GetIt.I<NavigationService>();
    _databaseService = GetIt.I<DatabaseService>();
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _databaseService.updateUserLastSeenTime(user.uid);
        _databaseService.getUser(user.uid).then((snapshot) {
          if (snapshot.exists) {
            final userDataMap = snapshot.data()!;
            chatUser = ChatUser.fromMap({'uid': user.uid, ...userDataMap});
            _navigationService.removeAndNavigateToRoute('/home');
          }
        });
      } else {
        _navigationService.removeAndNavigateToRoute('/login');
      }
    });
  }

  Future<void> loginUsingEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException:  ${e.toString()}");
    } catch (e) {
      print("AuthProviderException:  ${e.toString()}");
    }
  }
}
