// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType {
  text,
  image,
  unknown;

  @override
  String toString() {
    switch (this) {
      case MessageType.text:
        return 'text';
      case MessageType.image:
        return 'image';
      case MessageType.unknown:
        return 'unknown';
    }
  }

  static MessageType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'text':
        return MessageType.text;
      case 'image':
        return MessageType.image;
      default:
        return MessageType.unknown;
    }
  }
}

class ChatMessage {
  final String senderId;
  final MessageType type;
  final String content;
  final DateTime sentTime;

  ChatMessage({
    required this.senderId,
    required this.type,
    required this.content,
    required this.sentTime,
  });

  @override
  String toString() {
    return 'ChatMessage{senderId=$senderId, type=$type, content=$content, sentTime=$sentTime}';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'type': type.toString(),
      'content': content,
      'sentTime': sentTime.millisecondsSinceEpoch,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      senderId: map['sender_id'] as String,
      type: MessageType.fromString(map['type']),
      content: map['content'] as String,
      sentTime: (map['sent_time'] is Timestamp)
          ? (map['sent_time'] as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(map['sent_time'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) =>
      ChatMessage.fromMap(json.decode(source) as Map<String, dynamic>);
}
