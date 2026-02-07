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
    // _auth.signOut();
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
      print("FirebaseAuthException login:  ${e.toString()}");
    } catch (e) {
      print("AuthProviderException login:  ${e.toString()}");
    }
  }

  Future<String?> registerUsingEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      return credential.user?.uid;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException register:  ${e.toString()}");

      print('КОД ОШИБКИ: ${e.code}');
      print('СООБЩЕНИЕ: ${e.message}');
      // print('ДОП. ДАННЫЕ: ${e?.additionalData}');

      switch (e.code) {
        case 'invalid-credential':
          print('❗ Проверьте SHA-сертификаты в Firebase Console');
          break;
        case 'email-already-in-use':
          print('📧 Email уже зарегистрирован');
          break;
        case 'weak-password':
          print('🔒 Слабый пароль (минимум 6 символов)');
          break;
      }
    } catch (e) {
      print("AuthProviderException register:  ${e.toString()}");
    }
  }

  Future<void> logOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("AuthProviderException logOut:  ${e.toString()}");
    }
  }
}
