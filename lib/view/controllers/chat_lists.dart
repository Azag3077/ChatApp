import 'package:chatapp/services.dart';
import 'package:chatapp/view/pages/conversation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers.dart';
import '../pages/add_screen.dart';

mixin ChatListController on Widget {
  void _gotoPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  Future<void> getUser(WidgetRef ref) async {
    final user = await FirebaseService.getUser();
    ref.read(userProvider.notifier).update((state) => user);
  }

  void onChatPressed(
      BuildContext context, WidgetRef ref, String id, String chatId) {
    _gotoPage(context, ConversationPage(id, chatId));
  }

  void onAddFriend(BuildContext context) {
    _gotoPage(context, const AddScreen());
  }
}
