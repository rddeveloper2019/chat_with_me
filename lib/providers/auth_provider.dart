import 'package:chat_with_me/services/database_service.dart';
import 'package:chat_with_me/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AuthProvider extends ChangeNotifier {
  late FirebaseAuth _auth;
  late NavigationService _navigationService;
  late DatabaseService _databaseService;

  AuthProvider() {
    _auth = FirebaseAuth.instance;
    _navigationService = GetIt.I<NavigationService>();
    _databaseService = GetIt.I<DatabaseService>();
  }
}
