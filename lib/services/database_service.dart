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
        .orderBy("sent_time", descending: false)
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
        .orderBy('sent_time', descending: true)
        .snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllChatMessages(
    String chatId,
  ) {
    return _db
        .collection(CHATS_COLLECTION)
        .doc(chatId)
        .collection(MESSAGES_COLLECTION)
        .orderBy('sent_time', descending: true)
        .get();
  }

  Future<void> deleteChat(String chatId) async {
    try {
      final chatRef = _db.collection(CHATS_COLLECTION).doc(chatId);
      final chatDoc = await chatRef.get();

      if (!chatDoc.exists) return;

      final chatData = chatDoc.data()!;
      final members = List<String>.from(chatData['members'] ?? []);

      final messagesRef = chatRef.collection('messages');
      final messagesSnapshot = await messagesRef.get();

      if (messagesSnapshot.docs.isNotEmpty) {
        final batch = _db.batch();
        for (var doc in messagesSnapshot.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
      }

      for (var uid in members) {
        await _db.collection(USERS_COLLECTION).doc(uid).update({
          'chats': FieldValue.arrayRemove([chatId]),
        });
      }

      await chatRef.delete();

      debugPrint('✅ Chat $chatId deleted completely');
    } catch (e) {
      debugPrint('❌ deleteChat error: ${e.toString()}');
    }
  }

  Future<void> deleteMessage(String chatId, {required String messageId}) async {
    try {
      await _db
          .collection(CHATS_COLLECTION)
          .doc(chatId)
          .collection(MESSAGES_COLLECTION)
          .doc(messageId)
          .delete();
    } catch (e) {
      debugPrint('deleteMessage error :  ${e.toString()}');
    }
  }

  Future<void> addMessageToChat(
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

  Future<QuerySnapshot<Map<String, dynamic>>> getUsers(String? name) {
    return name != null
        ? _db
              .collection(USERS_COLLECTION)
              .where('name', isGreaterThanOrEqualTo: name)
              .where('name', isLessThanOrEqualTo: '${name}z')
              .get()
        : _db.collection(USERS_COLLECTION).get();
  }

  Future<DocumentReference<Map<String, dynamic>>?> createChat(
    Map<String, dynamic> data,
  ) async {
    try {
      return await _db.collection(CHATS_COLLECTION).add(data);
    } catch (e) {
      debugPrint('createChat error :  ${e.toString()}');
    }
  }
}
