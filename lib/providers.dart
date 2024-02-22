import 'package:chatapp/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/models.dart';
import 'models/user.dart';

final userProvider = StateProvider<User?>((ref) => null);

final usersProvider = StreamProvider<List<User>>((ref) {
  return FirebaseService.getUsers();
  final userId = ref.read(userProvider)?.uid;
  final users = FirebaseService.getUsers();
  return users.map((event) => event.where((e) => e.uid != userId).toList());
});

final userAvatarIconProvider = StateProvider<String?>((ref) => null);

final pageIndexProvider = StateProvider<int>((ref) => 0);

// final chatListProvider = StreamProvider<List<Chat>>((ref) {
//   final user = ref.watch(userProvider);
//   return FirebaseService.getChats();
// });

final chatsProvider =
    StreamProvider<List<Chat>>((ref) => FirebaseService.getChats());

final messagesProvider = StateProvider<List<Message>>((ref) {
  return List.empty();
});
