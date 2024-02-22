import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({
    required this.uid,
    required this.username,
    required this.profileImage,
    required this.friendLists,
    required this.groupLists,
    required this.createdDate,
    required this.lastSeen,
  });
  final String uid;
  final String username;
  final String profileImage;
  final List<String> friendLists;
  final List<String> groupLists;
  final DateTime createdDate;
  final DateTime lastSeen;

  factory User.fromDoc(DocumentSnapshot data) {
    DateTime getTimestamp(String key) =>
        (data.get(key) as Timestamp?)?.toDate() ?? DateTime.now();

    return User(
      uid: data.get('uid'),
      username: data.get('username'),
      profileImage: data.get('profileImage'),
      friendLists: data.get('friendLists').cast<String>().toList(),
      groupLists: data.get('groupLists').cast<String>().toList(),
      createdDate: getTimestamp('createdDate'),
      lastSeen: getTimestamp('lastSeen'),
    );
  }
}
