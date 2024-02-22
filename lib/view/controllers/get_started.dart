import 'package:flutter/material.dart';

import '../pages/create_account.dart';

mixin GetStartedController on Widget {
  void _gotoPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  void onGetStarted(BuildContext context) {
    _gotoPage(context, CreateAccount());
  }
}
