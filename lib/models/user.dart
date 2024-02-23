import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChat {
  GroupChat({
    required this.uid,
    required this.name,
    required this.displayPicture,
    required this.members,
    required this.createdDate,
    required this.lastSeen,
  });
  final String uid;
  final String name;
  final String displayPicture;
  final List<String> members;
  final DateTime createdDate;
  final DateTime lastSeen;

  factory GroupChat.fromDoc(DocumentSnapshot data) {
    DateTime getTimestamp(String key) =>
        (data.get(key) as Timestamp?)?.toDate() ?? DateTime.now();

    return GroupChat(
      uid: data.get('uid'),
      name: data.get('name'),
      displayPicture: data.get('displayPicture'),
      members: data.get('members').cast<String>().toList(),
      createdDate: getTimestamp('createdDate'),
      lastSeen: getTimestamp('lastSeen'),
    );
  }
}

class User {
  User({
    required this.uid,
    required this.username,
    required this.profileImage,
    required this.isOnline,
    required this.friendLists,
    required this.groupLists,
    required this.createdDate,
    required this.lastSeen,
  });
  final String uid;
  final String username;
  final String profileImage;
  final bool isOnline;
  final Map<String, dynamic> friendLists;
  final Map<String, dynamic> groupLists;
  final DateTime createdDate;
  final DateTime lastSeen;

  factory User.fromDoc(DocumentSnapshot data) {
    DateTime getTimestamp(String key) =>
        (data.get(key) as Timestamp?)?.toDate() ?? DateTime.now();

    return User(
      uid: data.get('uid'),
      username: data.get('username'),
      profileImage: data.get('profileImage'),
      isOnline: data.get('isOnline'),
      friendLists: data.get('friendLists') as Map<String, dynamic>,
      groupLists: data.get('groupLists') as Map<String, dynamic>,
      createdDate: getTimestamp('createdDate'),
      lastSeen: getTimestamp('lastSeen'),
    );
  }
}
