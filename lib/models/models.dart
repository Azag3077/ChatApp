import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message({
    required this.message,
    required this.timestamp,
    required this.isSender,
  });
  final String message;
  final DateTime timestamp;
  final bool isSender;

  factory Message.fromDoc(DocumentSnapshot data) {
    print(data.data());
    print((data.data() as Map).keys);
    final timestamp =
        (data.get('timestamp') as Timestamp?)?.toDate() ?? DateTime.now();
    return Message(
      message: data.get('message'),
      timestamp: timestamp,
      isSender: data.get('isSender'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'timestamp': timestamp,
      'isSender': isSender,
    };
  }
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
