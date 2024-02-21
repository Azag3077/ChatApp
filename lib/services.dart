import 'package:chatapp/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';

import 'models.dart';

class FirebaseService {
  static final _databaseRef = FirebaseFirestore.instance;
  // static final _storageRef = FirebaseStorage.instance;
  static final _chatsRef = _databaseRef.collection("chats");
  // static final _videosRef = _databaseRef.collection('videos');
  // static final _videoStorageRef = _storageRef.ref('videos');
  // static final _thumbnailStorageRef = _storageRef.ref('thumbnail');

  static Future<void> checkUserExistence() async {
    final uid = await getDeviceUid();
    final docSnapshot = await _chatsRef.doc(uid).get();

    if (!docSnapshot.exists) {
      _chatsRef.doc(uid).set({
        'id': uid,
        'username': 'Azag',
        'profileImage': 'profileImage',
        'friendLists': [],
        'groupLists': [],
        'joinedDate': FieldValue.serverTimestamp(),
        'lastSeenDate': FieldValue.serverTimestamp(),
      });
    }
  }

  static Future<void> createUser() async {
    final uid = await getDeviceUid();
    final docSnapshot = await _chatsRef.doc(uid).get();

    if (!docSnapshot.exists) {
      _chatsRef.doc(uid).collection('azag').add({
        'azag': 'video.file.size',
        'createdDate': FieldValue.serverTimestamp(),
        'updatedDate': FieldValue.serverTimestamp(),
      });
    }
  }

  static Stream<List<Chat>> getChats() {
    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: true);

    return _chatsRef.orderBy('timestamp').snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => Chat.fromDoc(doc)).toList());
  }
}
