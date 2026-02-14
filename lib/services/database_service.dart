import 'package:chat_with_me/models/chat.dart';
import 'package:chat_with_me/models/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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
      debugPrint('updateUserLastSeenTime error :  ${e.toString()}');
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
      debugPrint('createUser error :  ${e.toString()}');
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatsForUser(String uid) {
    return _db
        .collection(CHATS_COLLECTION)
        .where('members', arrayContains: uid)
        .snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLastMessageForChat(
    String chatId,
  ) {
    return _db
        .collection(CHATS_COLLECTION)
        .doc(chatId)
        .collection(MESSAGES_COLLECTION)
        .orderBy("sent_time", descending: true)
        .limit(1)
        .get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamMessagesForChat(
    String chatId,
  ) {
    return _db
        .collection(CHATS_COLLECTION)
        .doc(chatId)
        .collection(MESSAGES_COLLECTION)
        .orderBy('sent_time"', descending: false)
        .snapshots();
  }

  Future<void> deleteChat(String chatId) async {
    try {
      await _db.collection(CHATS_COLLECTION).doc(chatId).delete();
    } catch (e) {
      debugPrint('deleteChat error :  ${e.toString()}');
    }
  }

  Future<void> addMessageChat(
    String chatId, {
    required ChatMessage message,
  }) async {
    try {
      await _db
          .collection(CHATS_COLLECTION)
          .doc(chatId)
          .collection(MESSAGES_COLLECTION)
          .add(message.toMap());
    } catch (e) {
      debugPrint('addMessageChat error :  ${e.toString()}');
    }
  }

  Future<void> updateChatData(
    String chatId, {
    required Map<String, dynamic> data,
  }) async {
    try {
      await _db.collection(CHATS_COLLECTION).doc(chatId).update(data);
    } catch (e) {
      debugPrint('updateChatData error :  ${e.toString()}');
    }
  }
}
