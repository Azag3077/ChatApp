import 'package:chatapp/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models.dart';

final chatsProvider =
    StreamProvider<List<Chat>>((ref) => FirebaseService.getChats());

final messagesProvider = StateProvider<List<Message>>((ref) {
  return List.empty();
});
