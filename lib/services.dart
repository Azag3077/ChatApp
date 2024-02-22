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
  // static final _chatsRef = _databaseRef.collection("chats");
  // static final _videosRef = _databaseRef.collection('videos');
  // static final _videoStorageRef = _storageRef.ref('videos');
  // static final _thumbnailStorageRef = _storageRef.ref('thumbnail');

  // static Future<void> checkUserExistence() async {
  //   final uid = await getDeviceUid();
  //
  //   final docSnapshot = await _chatsRef.doc(uid).get();
  //   print(docSnapshot.exists);
  //   print(uid);
  //
  // }

  static Future<User> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid')!;
    final data = await _usersRef.doc(uid).get();
    return User.fromDoc(data);
  }

  static Future<void> createUser(String username, String profileImage) async {
    final uid = await getDeviceUid();
    final docSnapshot = await _usersRef.doc(uid).get();

    if (!docSnapshot.exists) {
      await _usersRef.doc(uid).set({
        'uid': uid,
        'username': username,
        'profileImage': profileImage,
        'friendLists': [],
        'groupLists': [],
        'createdDate': FieldValue.serverTimestamp(),
        'lastSeen': FieldValue.serverTimestamp(),
      });
    }
  }

  static Stream<List<Chat>> getChats() {
    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: true);

    // const id = '80cb81a3298076f9';
    // return _chatsRef.doc(id).snapshots().map((event) {
    //   return Chat.fromDoc(event);
    // });

    // return _chatsRef.orderBy('timestamp').snapshots().map(
    return _usersRef.snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => Chat.fromDoc(doc)).toList());
  }
}
