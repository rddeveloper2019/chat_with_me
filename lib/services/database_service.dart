import 'package:cloud_firestore/cloud_firestore.dart';

const USERS_COLLECTION = 'users';
const CHATS_COLLECTION = 'chats';
const MESSAGES_COLLECTION = 'messages';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseService();

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String uid) async {
    return _db.collection(USERS_COLLECTION).doc(uid).get();
  }

  Future<void> updateUserLastSeenTime(String uid) async {
    try {
      await _db.collection(USERS_COLLECTION).doc(uid).update({
        'last_active': DateTime.now().toUtc(),
      });
    } catch (e) {
      print('updateUserLastSeenTime error :  ${e.toString()}');
    }
  }

  Future<void> createUser({
    required String uid,
    required String name,
    required String imageUrl,
    required String email,
  }) async {
    try {
      await _db.collection(USERS_COLLECTION).doc(uid).set({
        'email': email,
        'name': name,
        'image': imageUrl,
        'last_active': DateTime.now().toUtc(),
      });
    } catch (e) {
      print('createUser error :  ${e.toString()}');
    }
  }
}
