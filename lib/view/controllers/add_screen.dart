import 'package:chatapp/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin AddScreenController on Widget {
  Future<void> addUser(WidgetRef ref, String currentUserId, String uid, bool shouldAdd) async {
    FirebaseService.addUser(currentUserId, uid, shouldAdd).then((value) {
      // ref
    });
  }
}
