import 'package:chatapp/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/chat_lists.dart';
import 'pages/conversation.dart';
import 'pages/create_account.dart';

mixin Controller on Widget {
  Future<void> initialize(BuildContext context) async {
    SharedPreferences.getInstance().then((prefs) {
      final uid = prefs.get('uid');

      if (uid == null) {
        _gotoPage(context, const CreateAccount());
      } else {
        _gotoPage(context, const ConversationPage());
      }
    });

// // Save an integer value to 'counter' key.
//     await prefs.setInt('counter', 10);
// // Save an boolean value to 'repeat' key.
//     await prefs.setBool('repeat', true);
// // Save an double value to 'decimal' key.
//     await prefs.setDouble('decimal', 1.5);
// // Save an String value to 'action' key.
//     await prefs.setString('action', 'Start');
// // Save an list of strings to 'items' key.
//     await prefs.setStringList('items', <String>['Earth', 'Moon', 'Sun']);

    // FirebaseService.checkUserExistence();
    // Future.delayed(const Duration(seconds: 2)).then(
    //   (value) => Navigator.pushReplacement(
    //       context, MaterialPageRoute(builder: (context) => const ChatList())),
    // );
  }

  void onChatPressed(BuildContext context, WidgetRef ref) {
    FirebaseService.checkUserExistence();
  }

  void _gotoPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
