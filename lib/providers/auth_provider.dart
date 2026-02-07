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
      debugPrint("FirebaseAuthException login:  ${e.toString()}");
    } catch (e) {
      debugPrint("AuthProviderException login:  ${e.toString()}");
    }
  }

  Future<void> logOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint("AuthProviderException logOut:  ${e.toString()}");
    }
  }

  Future<String?> registerUsingEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      return credential.user?.uid;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException register: ${e.toString()}');

      if (e.code == 'network-request-failed') {
        debugPrint(
          '🌐 Сетевая ошибка: проверьте интернет-соединение и разрешение INTERNET в AndroidManifest.xml',
        );
        throw const AuthException(
          message: 'Нет интернета. Проверьте подключение и повторите попытку.',
          code: 'no-internet',
        );
      }

      switch (e.code) {
        case 'email-already-in-use':
          throw const AuthException(
            message: 'Этот email уже зарегистрирован',
            code: 'email-already-in-use',
          );
        case 'invalid-email':
          throw const AuthException(
            message: 'Неверный формат email',
            code: 'invalid-email',
          );
        case 'weak-password':
          throw const AuthException(
            message: 'Пароль слишком простой (минимум 6 символов)',
            code: 'weak-password',
          );
        case 'operation-not-allowed':
          throw const AuthException(
            message: 'Регистрация по email отключена в настройках Firebase',
            code: 'operation-not-allowed',
          );
        default:
          throw AuthException(
            message: e.message ?? 'Неизвестная ошибка аутентификации',
            code: e.code,
          );
      }
    } catch (e) {
      debugPrint('AuthProviderException register: ${e.toString()}');
      rethrow;
    }
  }
}

class AuthException implements Exception {
  final String message;
  final String code;
  const AuthException({required this.message, required this.code});
  @override
  String toString() => 'AuthException[$code]: $message';
}
