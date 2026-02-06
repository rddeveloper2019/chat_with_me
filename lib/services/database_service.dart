import 'package:cloud_firestore/cloud_firestore.dart';

const USERS_COLLECTION = 'users';
const CHATS_COLLECTION = 'chats';
const MESSAGES_COLLECTION = 'messages';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseService();
}
