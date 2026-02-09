import 'package:chat_with_me/models/chat_message.dart';
import 'package:chat_with_me/models/chat_user.dart';

class Chat {
  final String uid;
  final String currentUserUid;
  final bool isActivity;
  final bool isGroup;
  List<ChatMessage> messages;
  final List<ChatUser> members;
  late final List<ChatUser> _recipients;

  Chat({
    required this.uid,
    required this.currentUserUid,
    required this.isActivity,
    required this.isGroup,
    required this.messages,
    required this.members,
  }) {
    _recipients = members
        .where((member) => member.uid != currentUserUid)
        .toList();
  }

  List<ChatUser> get recipients {
    return _recipients;
  }

  String get title {
    return !isGroup
        ? _recipients.first.name
        : _recipients.map((user) => user.name).join(", ");
  }

  String get imageUrl {
    return !isGroup
        ? _recipients.first.imageUrl
        : "https://img.freepik.com/premium-vector/colorful-chat-logo-template-creative-chat-logo-design-vector_639795-2774.jpg";
  }

  @override
  String toString() {
    return 'Chat{uid=$uid, currentUserUid=$currentUserUid, isActivity=$isActivity, isGroup=$isGroup, messages=$messages, members=$members, _recipients=$_recipients}';
  }
}
