// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  final String uid;
  final String name;
  final String email;
  final String imageUrl;
  final DateTime lastActiveDate;

  ChatUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.lastActiveDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'image': imageUrl,
      'last_active': lastActiveDate.millisecondsSinceEpoch,
    };
  }

  String lastDayActive() {
    return "${lastActiveDate.day}.${lastActiveDate.month}${lastActiveDate.year}";
  }

  bool wasRecentlyActive() {
    return DateTime.now().difference(lastActiveDate).inHours < 2;
  }

  factory ChatUser.fromMap(Map<String, dynamic> map) {
    return ChatUser(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      imageUrl: map['image'] ?? '',
      lastActiveDate: (map['last_active'] is Timestamp)
          ? (map['last_active'] as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(map['last_active'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatUser.fromJson(String source) =>
      ChatUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatUser{uid=$uid, name=$name, email=$email, imageUrl=$imageUrl, lastActiveDate=$lastActiveDate}';
  }
}
