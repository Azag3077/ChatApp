import 'package:chatapp/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_storage/firebase_storage.dart';

import 'models/models.dart';
import 'models/user.dart';

class FirebaseService {
  static final _databaseRef = FirebaseFirestore.instance;
  // static final _storageRef = FirebaseStorage.instance;
  static final _usersRef = _databaseRef.collection("users");
  static final _chatsRef = _databaseRef.collection("chats");
  // static final _chatsRef = _databaseRef.collection("chats");
  // static final _videosRef = _databaseRef.collection('videos');
  // static final _videoStorageRef = _storageRef.ref('videos');
  // static final _thumbnailStorageRef = _storageRef.ref('thumbnail');

  static Future<bool> checkUserExistence() async {
    final uid = await getDeviceUid();

    final docSnapshot = await _usersRef.doc(uid).get();
    return docSnapshot.exists;
  }

  static Future<User> getUser([String? id]) async {
    final prefs = await SharedPreferences.getInstance();
    final uid = id ?? prefs.getString('uid')!;
    final data = await _usersRef.doc(uid).get();
    return User.fromDoc(data);
  }

  static Stream<User> getChatDetailsStream([String? id]) async* {
    final prefs = await SharedPreferences.getInstance();
    final uid = id ?? prefs.getString('uid')!;

    await for (var snapshot in _usersRef.doc(uid).snapshots()) {
      yield User.fromDoc(snapshot);
    }
  }

  static Stream<List<Message>> getChatMessagesStream([String? id]) {
    return _chatsRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Message.fromDoc(doc)).toList());
  }

  static Future<void> addMessage(String chatId, Message message) async {
    await _chatsRef.doc(chatId).update(message.toJson());
  }

  static Stream<List<User>> getUsers() {
    return _usersRef.snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => User.fromDoc(doc)).toList());
  }

  static Future<void> addUser(
      String currentUserId, String uid, bool shouldAdd) async {
    if (!shouldAdd) {
      await _usersRef.doc(currentUserId).update({
        'friendLists.$uid': FieldValue.delete(),
      });
      return;
    }

    // Check if friend as user as a friend
    final friendData = await _usersRef.doc(uid).get();
    final friendLists = friendData.get('friendLists') as Map<String, dynamic>;

    late final String chatId;

    if (friendLists.keys.contains(currentUserId)) {
      // Friend to be added already has current user as friend
      chatId = friendLists[currentUserId]['chatId'];
    } else {
      // Create chatroom for both users and notify the other user
      _chatsRef.doc();

      final docRef = await _chatsRef.add({
        'createdDate': FieldValue.serverTimestamp(),
        'updatedDate': FieldValue.serverTimestamp(),
      });
      chatId = docRef.id;

      await _usersRef.doc(uid).update({
        'friendLists.$currentUserId.chatId': chatId,
      });
    }

    await _usersRef.doc(currentUserId).update({
      'friendLists.$uid.chatId': chatId,
    });

    // await _usersRef.doc(currentUserId).update({
    //   'friendLists.userId': uid,
    //   'friendLists.chatId': FieldValue.serverTimestamp(),
    //   'friendLists.timestamp': FieldValue.serverTimestamp(),
    // });
    // await _usersRef.doc(currentUserId).update({
    //   'friendLists': FieldValue.arrayUnion(['uid']),
    // });

    print('object');
  }

  static Future<void> createUser(String username, String profileImage) async {
    final uid = await getDeviceUid();
    final docSnapshot = await _usersRef.doc(uid).get();

    if (!docSnapshot.exists) {
      await _usersRef.doc(uid).set({
        'uid': uid,
        'username': username,
        'profileImage': profileImage,
        'isOnline': true,
        'friendLists': {},
        'groupLists': {},
        'createdDate': FieldValue.serverTimestamp(),
        'lastSeen': FieldValue.serverTimestamp(),
      });
    }
  }

  static Stream<List<Chat>> getChats() {
    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: true);

    return _usersRef.snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => Chat.fromDoc(doc)).toList());
  }
}

// Future<void> updateMapInFirestore() async {
//   try {
//     // Retrieve the document
//     DocumentReference docRef =
//     FirebaseFirestore.instance.collection('your_collection').doc('s');
//
//     DocumentSnapshot docSnapshot = await docRef.get();
//
//     if (docSnapshot.exists) {
//       // Get the existing map or create a new one if it doesn't exist
//       Map<String, dynamic> existingMap = docSnapshot.data()?['your_map_key'] ?? {};
//
//       // Add or update values in the map
//       existingMap['new_key'] = 'new_value';
//       existingMap['another_key'] = 'another_value';
//
//       // Update the document with the modified map
//       await docRef.update({
//         'your_map_key': existingMap,
//       });
//
//       print('Map in Firestore updated successfully');
//     } else {
//       print('Document does not exist');
//     }
//   } catch (error) {
//     print('Error updating map in Firestore: $error');
//   }
// }
