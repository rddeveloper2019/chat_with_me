// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  final String uid;
  final String name;
  final String email;
  final String imageUrl;
  final Timestamp lastActiveDate;

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
      'last_active': lastActiveDate, // Firestore принимает Timestamp напрямую
    };
  }

  String lastDayActive() {
    final dateTime = lastActiveDate.toDate();
    return "${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}";
  }

  bool wasRecentlyActive() {
    final now = DateTime.now();
    final activeDateTime = lastActiveDate.toDate();
    return now.difference(activeDateTime).inHours < 1;
  }

  factory ChatUser.fromMap(Map<String, dynamic> map) {
    final lastActiveRaw = map['last_active'];

    Timestamp parseLastActive(dynamic value) {
      if (value == null) return Timestamp.now();
      if (value is Timestamp) return value;
      if (value is int) return Timestamp.fromMillisecondsSinceEpoch(value);
      if (value is double)
        return Timestamp.fromMillisecondsSinceEpoch(value.toInt());
      if (value is DateTime) return Timestamp.fromDate(value);
      return Timestamp.now(); // fallback
    }

    return ChatUser(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      imageUrl: map['image'] ?? '',
      lastActiveDate: parseLastActive(lastActiveRaw),
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
