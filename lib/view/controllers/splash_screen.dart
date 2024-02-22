import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/chat_lists.dart';
import '../pages/get_started.dart';

mixin SplashScreenController on Widget {
  void _gotoPage(BuildContext context, Widget page) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => page));
  }

  Future<void> initialize(BuildContext context) async {
    SharedPreferences.getInstance().then((prefs) {
      final uid = prefs.getString('uid');

      if (uid == null) {
        _gotoPage(context, const GetStarted());
      } else {
        _gotoPage(context, const ChatList());
      }
    });
  }
}
