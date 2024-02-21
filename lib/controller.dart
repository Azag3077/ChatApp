import 'package:chatapp/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/chat_lists.dart';
import 'pages/conversation.dart';

mixin Controller on Widget {
  Future<void> initialize(BuildContext context) async {
    FirebaseService.checkUserExistence();
    Future.delayed(const Duration(seconds: 2)).then(
      (value) => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const ChatList())),
    );
  }

  void onChatPressed(BuildContext context, WidgetRef ref) {
    FirebaseService.checkUserExistence();
    // _gotoPage(context, const ConversationPage());
  }

  void _gotoPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
