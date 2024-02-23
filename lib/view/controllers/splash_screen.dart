import 'package:chatapp/services.dart';
import 'package:flutter/material.dart';

import '../pages/chat_lists.dart';
import '../pages/get_started.dart';

mixin SplashScreenController on Widget {
  void _gotoPage(BuildContext context, Widget page) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => page));
  }

  Future<void> initialize(BuildContext context) async {
    FirebaseService.checkUserExistence().then((isExist) {
      if (isExist) {
        _gotoPage(context, const ChatList());
      } else {
        _gotoPage(context, const GetStarted());
      }
    });
  }
}
