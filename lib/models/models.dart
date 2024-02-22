import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message({
    required this.message,
    required this.sentTime,
    required this.isSender,
  });
  final String message;
  final DateTime sentTime;
  final bool isSender;
}

enum ChatType {
  group,
  single,
}

class Chat {
  Chat({
    required this.id,
    required this.username,
    required this.profileImage,
    required this.lastMessage,
    required this.type,
    this.messages = const [],
    required this.timestamp,
  });
  final String id;
  final String username;
  final String profileImage;
  final String lastMessage;
  final ChatType type;
  final List<String> messages;
  final DateTime timestamp;

  factory Chat.fromDoc(DocumentSnapshot data) {
    final timestamp =
        (data.get('timestamp') as Timestamp?)?.toDate() ?? DateTime.now();
    return Chat(
      id: data.id,
      username: data.get('username'),
      profileImage: data.get('profileImage'),
      lastMessage: data.get('lastMessage'),
      type: data.get('type'),
      messages: data.get('videos').cast<String>().toList(),
      timestamp: timestamp,
    );
  }
}
